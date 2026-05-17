package simulador_UPF_WiFi;

import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class RegistradorWiFi {

    private ContinuousSpace<Object> espacio;
    private Context<Object> context;
    private PrintWriter writer;

    private List<PuntoAcceso> apsCache = new ArrayList<PuntoAcceso>();
    private Map<String, String> sesionesActivas = new HashMap<String, String>();
    private Map<String, String> ultimoAP        = new HashMap<String, String>();

    // ── Modelo RF ────────────────────────────────────────────────────────────
    private static final double RSSI_REF        = -40.0;
    private static final double EXP_PATHLOSS    =   3.0;
    private static final double UMBRAL_DET_DBM  = -85.0;
    private static final double RUIDO_DBM       = -92.0;
    private static final double WALL_PENALTY_DBM=  15.0; // ← estaba faltando

    private DateTimeFormatter formatoFechaHora = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public RegistradorWiFi(Context<Object> context, ContinuousSpace<Object> espacio) {
        this.context = context;
        this.espacio = espacio;
        try {
            writer = new PrintWriter(new FileWriter("Conexiones_WiFi_Campus.csv", false));
            writer.println("Timestamp,SessionID,Username,MAC_Address,AP_Name,AP_Zone,"
                         + "RSSI_dBm,SNR_dB,GT_TipoAgente,GT_ZonaDestino,"
                         + "GT_Distance_m,GT_X,GT_Y");
        } catch (IOException e) {
            System.out.println("Error al crear el CSV: " + e.getMessage());
        }
    }

    @ScheduledMethod(start = 15, interval = 15)
    public void escanearRed() {
        int tick   = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
        int diaAno = tick / 1440;
        int minDia = tick % 1440;

        if (diaAno >= 366) { finalizarArchivo(); return; }

        if (apsCache.isEmpty()) {
            for (Object o : context.getObjects(PuntoAcceso.class))
                apsCache.add((PuntoAcceso) o);
        }

        String tsTxt = LocalDateTime.of(
            LocalDate.ofYearDay(2024, diaAno + 1),
            LocalTime.of(minDia / 60, minDia % 60)
        ).format(formatoFechaHora);

        // ── ESTUDIANTES ───────────────────────────────────────────────────────
        for (Object o : context.getObjects(Estudiante.class)) {
            Estudiante est = (Estudiante) o;
            NdPoint pos = espacio.getLocation(est);
            if (pos == null) continue;

            String username = est.getIdUniversidad() + "@upf.edu";
            String tipoGT   = est.getTipo().name();

            // Ground truth de zona: solo si ha llegado, si no es EnTransito
            String zonaReal = est.isHaLlegado() ? est.getZonaDestino() : null;
            String gtZona   = (zonaReal != null) ? zonaReal : "EnTransito";

            PuntoAcceso mejorAP = null;
            double mejorRssi = -999.0;
            double distanciaAlMejor = 0.0;

            for (PuntoAcceso ap : apsCache) {
                NdPoint posAP = espacio.getLocation(ap);
                if (posAP == null) continue;
                double dx   = pos.getX() - posAP.getX();
                double dy   = pos.getY() - posAP.getY();
                double dist = Math.sqrt(dx*dx + dy*dy);

                if (dist <= ap.getRadioCobertura()) {
                    // ← aquí usamos zonaReal (null si en tránsito = sin penalización)
                    double rssi = calcularRSSI(dist, zonaReal, ap.getZona());
                    if (rssi > mejorRssi) {
                        mejorRssi = rssi;
                        mejorAP = ap;
                        distanciaAlMejor = dist;
                    }
                }
            }

            if (mejorAP != null && mejorRssi >= UMBRAL_DET_DBM) {
                double snr = mejorRssi - RUIDO_DBM;
                for (String mac : est.getDispositivos()) {
                    String prevAP = ultimoAP.get(mac);
                    String sessionID;
                    if (prevAP == null || !prevAP.equals(mejorAP.getId())) {
                        sessionID = UUID.randomUUID().toString().substring(0, 8);
                        sesionesActivas.put(mac, sessionID);
                        ultimoAP.put(mac, mejorAP.getId());
                    } else {
                        sessionID = sesionesActivas.get(mac);
                    }
                    writer.printf(Locale.US,
                        "%s,%s,%s,%s,%s,%s,%.1f,%.1f,%s,%s,%.2f,%.2f,%.2f%n",
                        tsTxt, sessionID, username, mac,
                        mejorAP.getId(), mejorAP.getZona(),
                        mejorRssi, snr,
                        tipoGT, gtZona,
                        distanciaAlMejor, pos.getX(), pos.getY());
                }
            }
        }

        // ── DISPOSITIVOS FIJOS ────────────────────────────────────────────────
        for (Object o : context.getObjects(DispositivoFijo.class)) {
            DispositivoFijo f = (DispositivoFijo) o;
            NdPoint pos = espacio.getLocation(f);
            if (pos == null) continue;

            PuntoAcceso mejorAP = null;
            double mejorRssi = -999.0;
            double distanciaAlMejor = 0.0;

            for (PuntoAcceso ap : apsCache) {
                NdPoint posAP = espacio.getLocation(ap);
                if (posAP == null) continue;
                double dx   = pos.getX() - posAP.getX();
                double dy   = pos.getY() - posAP.getY();
                double dist = Math.sqrt(dx*dx + dy*dy);
                if (dist <= ap.getRadioCobertura()) {
                    // Fijos no se mueven → sin penalización (null)
                    double rssi = calcularRSSI(dist, null, ap.getZona());
                    if (rssi > mejorRssi) {
                        mejorRssi = rssi;
                        mejorAP = ap;
                        distanciaAlMejor = dist;
                    }
                }
            }

            if (mejorAP != null && mejorRssi >= UMBRAL_DET_DBM) {
                String mac = f.getMacAddress();
                String prevAP = ultimoAP.get(mac);
                String sessionID;
                if (prevAP == null || !prevAP.equals(mejorAP.getId())) {
                    sessionID = UUID.randomUUID().toString().substring(0, 8);
                    sesionesActivas.put(mac, sessionID);
                    ultimoAP.put(mac, mejorAP.getId());
                } else {
                    sessionID = sesionesActivas.get(mac);
                }
                double snr = mejorRssi - RUIDO_DBM;
                writer.printf(Locale.US,
                    "%s,%s,equipament.poblenou@upf.edu,%s,%s,%s,%.1f,%.1f,FIJO,FIJO,%.2f,%.2f,%.2f%n",
                    tsTxt, sessionID, mac,
                    mejorAP.getId(), mejorAP.getZona(),
                    mejorRssi, snr,
                    distanciaAlMejor, pos.getX(), pos.getY());
            }
        }

        if (minDia % 60 == 0) writer.flush();
    }

    // zonaDispositivo=null → en tránsito → sin penalización de pared
    private double calcularRSSI(double distM, String zonaDispositivo, String zonaAP) {
        if (distM < 1.0) distM = 1.0;
        double rssi = RSSI_REF - 10.0 * EXP_PATHLOSS * Math.log10(distM);
        if (zonaDispositivo != null && !zonaDispositivo.equals(zonaAP)) {
            rssi -= WALL_PENALTY_DBM;
        }
        return rssi;
    }

    public void finalizarArchivo() {
        if (writer != null) {
            writer.close();
            System.out.println("SIMULACION TERMINADA. CSV guardado.");
        }
        RunEnvironment.getInstance().endRun();
    }
}