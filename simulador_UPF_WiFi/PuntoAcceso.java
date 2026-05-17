package simulador_UPF_WiFi;

/**
 * Punto de Acceso WiFi con modelo RSSI log-distance y atenuación por muros.
 *
 * Modelo base:  RSSI = -40 - 30·log10(d)     [log-distance, n=3, ref 1m = -40 dBm]
 * Atenuación:   cada muro/forjado añade WALL_LOSS_DB (típico: 3-5 dB indoor)
 *
 * [NEW] calcularRSSI(dx, dy, userX, userY) aplica penalización automática
 *       cuando el usuario está en la cafetería y el AP está en RocBoronat52,
 *       o viceversa. RegistradorWiFi debe llamar a este método en vez de
 *       calcular la distancia directamente.
 */
public class PuntoAcceso {

    private String id_AP;
    private String zona;
    private double radioCobertura;

    // ── Parámetros del modelo RSSI ────────────────────────────────────────────
    private static final double RSSI_REF_1M    = -40.0;   // dBm a 1 metro
    private static final double PATH_LOSS_EXP  =  3.0;    // n=3: indoor con obstáculos
    private static final double UMBRAL_DETECCION = -85.0; // dBm mínimo para detectar
    private static final double WALL_LOSS_DB   =   4.0;   // dB por muro/forjado

    // ── Zona de la cafetería (para detección de cruce de muro) ───────────────
    // [FIX-CAFE] Coincide con los bounds en Estudiante.java (Y_CAF_MAX=30, Y_R52_MIN=32)
    private static final double Y_LIMITE_CAFETERIA = 31.0; // y < este valor → cafetería
    private static final double X_ZONA_CAFE_MIN    =  8.0;
    private static final double X_ZONA_CAFE_MAX    = 27.0;
    private static final double X_CAF_MIN=8,   X_CAF_MAX=27,  Y_CAF_MIN=18,  Y_CAF_MAX=32;  // CF: APs x[10,25] y[20,30] 
    private static final double X_R52_MIN=8,   X_R52_MAX=27,  Y_R52_MIN=18,  Y_R52_MAX=62; 
    public PuntoAcceso(String id, String zona, double radio) {
        this.id_AP         = id;
        this.zona          = zona;
        this.radioCobertura = radio;
    }

    public String getId()             { return id_AP; }
    public String getZona()           { return zona; }
    public double getRadioCobertura() { return radioCobertura; }
    public double getTamano()         { return radioCobertura; }

    public double calcularRSSI(double distancia, String zonaDelEstudiante) {
        double dist = Math.max(1.0, distancia);
        double rssi = RSSI_REF_1M - 10.0 * PATH_LOSS_EXP * Math.log10(dist);

        // Si la zona del AP y la zona donde cree estar el estudiante son distintas, hay muro
        if (!this.zona.equals(zonaDelEstudiante)) {
            rssi -= 25.0; // Penalización del forjado
        }
        return rssi;
    }

    /**
     * RSSI simple sin corrección de muro (para compatibilidad hacia atrás).
     * Preferir calcularRSSI(apX, apY, userX, userY) cuando se conozcan posiciones.
     */
    public double calcularRSSISimple(double distancia) {
        double dist = Math.max(1.0, distancia);
        return RSSI_REF_1M - 10.0 * PATH_LOSS_EXP * Math.log10(dist);
    }

    public double getUmbralDeteccion() { return UMBRAL_DETECCION; }
}