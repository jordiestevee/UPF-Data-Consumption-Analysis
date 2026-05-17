package simulador_UPF_WiFi;

import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.NdPoint;
import java.util.ArrayList;

public class Estudiante {

    private String idUniversidad;
    private TipoAgente tipo;
    private ArrayList<String> macDispositivos = new ArrayList<String>();
    private ContinuousSpace<Object> espacio;
    private ControladorCampus controlador;

    private double destinoX, destinoY;
    private double velocidad;
    private int    minutosQuieto    = 0;
    private int    duracionMaxQuieto;
    private boolean saliendo        = false;
    private String zonaDestino      = "Desconocida";
    private boolean haLlegado       = false;

    // ── Zones ────────────────────────────────────────────────────────────────
    private static final double X_FAB_MIN=70, X_FAB_MAX=95, Y_FAB_MIN=15, Y_FAB_MAX=70;
    private static final double X_NAU_MIN=10, X_NAU_MAX=95, Y_NAU_MIN=6,  Y_NAU_MAX=18;
    private static final double X_R52_MIN=5,  X_R52_MAX=30, Y_R52_MIN=15, Y_R52_MAX=70;
    private static final double X_R53_MIN=5,  X_R53_MAX=20, Y_R53_MIN=75, Y_R53_MAX=100;
    private static final double X_T54_MIN=35, X_T54_MAX=95, Y_T54_MIN=70, Y_T54_MAX=100;
    private static final double X_TAN_MIN=15, X_TAN_MAX=85, Y_TAN_MIN=0,  Y_TAN_MAX=8;
    private static final double X_PG_MIN=30,  X_PG_MAX=65,  Y_PG_MIN=25,  Y_PG_MAX=65;
    private static final double X_CAF_MIN=5,  X_CAF_MAX=30, Y_CAF_MIN=15, Y_CAF_MAX=35;
    private static final double X_SAL_MIN=0,  X_SAL_MAX=5,  Y_SAL_MIN=60, Y_SAL_MAX=70;

    public Estudiante(String idUniv, TipoAgente tipus,
                      ContinuousSpace<Object> espacio, ControladorCampus controlador) {
        this.idUniversidad = idUniv;
        this.tipo          = tipus;
        this.espacio       = espacio;
        this.controlador   = controlador;
        switch (tipus) {
            case PAS:       duracionMaxQuieto=240; velocidad=5.0; break;
            case PROFESOR:  duracionMaxQuieto=120; velocidad=5.5; break;
            case MASTER:    duracionMaxQuieto= 90; velocidad=6.0; break;
            case GRADO:     duracionMaxQuieto= 90; velocidad=6.5; break;
            case VISITANTE: duracionMaxQuieto= 30; velocidad=5.0; break;
            default:        duracionMaxQuieto= 90; velocidad=5.5;
        }
        generarDispositivos();
    }

    public String     getZonaDestino()  { return zonaDestino; }
    public boolean    isHaLlegado()     { return haLlegado; }
    public ArrayList<String> getDispositivos() { return macDispositivos; }
    public String     getIdUniversidad(){ return idUniversidad; }
    public TipoAgente getTipo()         { return tipo; }

    private java.util.LinkedList<double[]> rutaWaypoints = new java.util.LinkedList<>();

    // ── irAZona: detecta zona ANTES de moverse ────────────────────────────────
    private void irAZona(double xMin, double xMax, double yMin, double yMax) {
        // Registro ground truth en el momento de la decisión
        if      (xMin==X_CAF_MIN && yMin==Y_CAF_MIN) zonaDestino = "Cafeteria";
        else if (xMin==X_R52_MIN && yMin==Y_R52_MIN) zonaDestino = "RocBoronat52";
        else if (xMin==X_FAB_MIN && yMin==Y_FAB_MIN) zonaDestino = "LaFabrica";
        else if (xMin==X_NAU_MIN && yMin==Y_NAU_MIN) zonaDestino = "LaNau";
        else if (xMin==X_R53_MIN && yMin==Y_R53_MIN) zonaDestino = "RocBoronat";
        else if (xMin==X_T54_MIN && yMin==Y_T54_MIN) zonaDestino = "AreaTallers";
        else if (xMin==X_TAN_MIN && yMin==Y_TAN_MIN) zonaDestino = "Tanger";
        else if (xMin==X_PG_MIN  && yMin==Y_PG_MIN)  zonaDestino = "PlacaGutenberg";
        else if (xMin==X_SAL_MIN && yMin==Y_SAL_MIN) zonaDestino = "Salida";
        else                                           zonaDestino = "Exterior";

        haLlegado = false; // en tránsito hasta llegar

        xMin=Math.max(0,Math.min(xMin,100)); xMax=Math.max(0,Math.min(xMax,100));
        yMin=Math.max(0,Math.min(yMin,100)); yMax=Math.max(0,Math.min(yMax,100));
        double dX = RandomHelper.nextDoubleFromTo(xMin, xMax);
        double dY = RandomHelper.nextDoubleFromTo(yMin, yMax);
        NdPoint pos = espacio.getLocation(this);
        if (pos == null) { destinoX=dX; destinoY=dY; return; }
        int wpO = Waypoints.waypointMasCercano(pos.getX(), pos.getY());
        int wpD = Waypoints.waypointMasCercano(dX, dY);
        int[] cam = Waypoints.caminoMinimo(wpO, wpD);
        rutaWaypoints.clear();
        for (int wp : cam)
            rutaWaypoints.add(new double[]{Waypoints.NODOS[wp][1], Waypoints.NODOS[wp][2]});
        rutaWaypoints.add(new double[]{dX, dY});
        double[] seg = rutaWaypoints.poll();
        destinoX=seg[0]; destinoY=seg[1];
    }

    private void generarDispositivos() {
        double rM,rP,rT,rW;
        switch(tipo) {
            case GRADO:     rM=.90;rP=.75;rT=.08;rW=.05; break;
            case MASTER:    rM=.90;rP=.92;rT=.15;rW=.10; break;
            case PAS:       rM=.95;rP=.40;rT=.05;rW=.02; break;
            case PROFESOR:  rM=.95;rP=.85;rT=.25;rW=.10; break;
            case VISITANTE: rM=.50;rP=.20;rT=.05;rW=.05; break;
            default:        rM=.50;rP=.50;rT=.05;rW=.05;
        }
        if(RandomHelper.nextDoubleFromTo(0,1)<rM) macDispositivos.add(idUniversidad+"_MOVIL");
        if(RandomHelper.nextDoubleFromTo(0,1)<rP) macDispositivos.add(idUniversidad+"_PC");
        if(RandomHelper.nextDoubleFromTo(0,1)<rT) macDispositivos.add(idUniversidad+"_TABLET");
        if(RandomHelper.nextDoubleFromTo(0,1)<rW) macDispositivos.add(idUniversidad+"_WATCH");
    }

    public void marcarSalida() {
        saliendo = true;
        irAZona(X_SAL_MIN, X_SAL_MAX, Y_SAL_MIN, Y_SAL_MAX);
    }
    
    

    private double toleranciaTemp(double t) {
        if (t<=10||t>=35) return 0;
        if (t>=18&&t<=26) return 1;
        return t<18 ? (t-10)/8.0 : (35-t)/9.0;
    }

    private void intentarIrAPlaza() {
        if (controlador.isLloviendo()) { refugioPorLluvia(); return; }
        if (RandomHelper.nextDoubleFromTo(0,1) < toleranciaTemp(controlador.getTemperatura()))
            irAZona(X_PG_MIN,X_PG_MAX,Y_PG_MIN,Y_PG_MAX);
        else
            refugioPorLluvia();
    }

    private void refugioPorLluvia() {
        if (RandomHelper.nextDoubleFromTo(0,1)<.40)
            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
        else
            irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
    }

    // =========================================================================
    // irADestinoAleatorio — amb Tànger integrat per PROFESOR i MASTER
    // =========================================================================
    public void irADestinoAleatorio() {
        double r = RandomHelper.nextDoubleFromTo(0,1);
        String td = controlador.getTipoDiaActual();

        boolean esVacAltre = td.equals("Vacances") || td.equals("Altre");
        boolean esFinde    = td.equals("Dissabte")||td.equals("Diumenge")||td.equals("Festiu");
        boolean esAvalua   = td.equals("Avaluacio");

        // ── VACANCES / ALTRE ─────────────────────────────────────────────────
        if (esVacAltre) {
            switch(tipo) {
                case GRADO:
                    if      (r<.50) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                    else if (r<.70) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                    else if (r<.82) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // TFG DTIC
                    else if (r<.92) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                    else            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                    break;
                case MASTER:
                    if      (r<.40) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                    else if (r<.65) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // recerca DTIC
                    else if (r<.85) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                    else if (r<.95) irAZona(X_T54_MIN,X_T54_MAX,Y_T54_MIN,Y_T54_MAX);
                    else            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                    break;
                case PROFESOR:
                    if      (r<.45) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // despatx DTIC
                    else if (r<.75) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                    else if (r<.90) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                    else            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                    break;
                case PAS:
                    if      (r<.55) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                    else if (r<.80) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                    else if (r<.92) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // gestió DTIC
                    else            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                    break;
                default: // VISITANTE
                    if      (r<.40) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                    else if (r<.65) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                    else            intentarIrAPlaza();
            }
            return;
        }

        // ── FINDE / FESTIU ───────────────────────────────────────────────────
        if (esFinde) {
            if      (r<.55) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
            else if (r<.75) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
            else if (r<.90) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
            else            intentarIrAPlaza();
            return;
        }

        // ── CLASSE / AVALUACIÓ / NO LECTIU ───────────────────────────────────
        switch(tipo) {
            case GRADO:
                if (esAvalua) {
                    if      (r<.40) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                    else if (r<.70) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                    else if (r<.80) irAZona(X_T54_MIN,X_T54_MAX,Y_T54_MIN,Y_T54_MAX);
                    else if (r<.82) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                    else if (r<.84) irAZona(X_NAU_MIN,X_NAU_MAX,Y_NAU_MIN,Y_NAU_MAX);
                    else if (r<.94) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                    else intentarIrAPlaza();
                } else {
                    if      (r<.40) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                    else if (r<.60) irAZona(X_T54_MIN,X_T54_MAX,Y_T54_MIN,Y_T54_MAX);
                    else if (r<.80) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                    else if (r<.81) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                    else if (r<.82) irAZona(X_NAU_MIN,X_NAU_MAX,Y_NAU_MIN,Y_NAU_MAX);
                    else if (r<.92) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                    else            intentarIrAPlaza();
                }
                break;

            case MASTER:
                // LaFab=28%, LaNau=22%, Tallers=15%, Tànger=15%, RocB53=10%, RocB52=6%, Cafe=3%, Plaça=1%
                if      (r<.28) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                else if (r<.35) irAZona(X_NAU_MIN,X_NAU_MAX,Y_NAU_MIN,Y_NAU_MAX);
                else if (r<.55) irAZona(X_T54_MIN,X_T54_MAX,Y_T54_MIN,Y_T54_MAX);
                else if (r<.60) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // ← DTIC
                else if (r<.60) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                else if (r<.90) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                else if (r<.95) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                else            intentarIrAPlaza();
                break;

            case PROFESOR:
                // RocB53=35%, Tànger=20%, LaNau=17%, Tallers=13%, LaFab=9%, RocB52=4%, Cafe=2%
                if      (r<.35) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                else if (r<.55) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // ← DTIC
                else if (r<.72) irAZona(X_NAU_MIN,X_NAU_MAX,Y_NAU_MIN,Y_NAU_MAX);
                else if (r<.85) irAZona(X_T54_MIN,X_T54_MAX,Y_T54_MIN,Y_T54_MAX);
                else if (r<.94) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                else if (r<.98) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                else            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                break;

            case PAS:
                // LaFab=43%, RocB52=24%, RocB53=14%, Tallers=9%, Tànger=5%, Cafe=5%
                if      (r<.43) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                else if (r<.67) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                else if (r<.81) irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
                else if (r<.90) irAZona(X_T54_MIN,X_T54_MAX,Y_T54_MIN,Y_T54_MAX);
                else if (r<.95) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // ← gestió DTIC
                else            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                break;

            case VISITANTE:
                if      (controlador.isLloviendo())
                                irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                else if (r<.10) irAZona(X_NAU_MIN,X_NAU_MAX,Y_NAU_MIN,Y_NAU_MAX);
                else if (r<.30) irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
                else if (r<.45) intentarIrAPlaza();
                else if (r<.65) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // ← jornades DTIC
                else if (r<.90) irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
                else            irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                break;

            default:
                irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
        }
    }

    // =========================================================================
    // decidirDestinoPorHora
    // =========================================================================
    public void decidirDestinoPorHora(int minDia) {
        if (saliendo) return;
        double r = RandomHelper.nextDoubleFromTo(0,1);
        String td = controlador.getTipoDiaActual();

        boolean esVacAltre = td.equals("Vacances")||td.equals("Altre");
        boolean esFinde    = td.equals("Dissabte")||td.equals("Diumenge")||td.equals("Festiu");

        if (esVacAltre || esFinde) {
            if (minDia>=720 && minDia<780) {
                if (r<.50) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                else       irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
            } else {
                irADestinoAleatorio();
            }
            return;
        }

        if (tipo == TipoAgente.PAS) {
            if      (minDia>=630 && minDia<660) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
            else if (minDia>=780 && minDia<870) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
            else if (r<.55)                      irAZona(X_FAB_MIN,X_FAB_MAX,Y_FAB_MIN,Y_FAB_MAX);
            else                                 irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
            return;
        }

        if (tipo == TipoAgente.PROFESOR) {
            if      (minDia>=480 && minDia<570) {
                if (r<.45) irAZona(X_TAN_MIN,X_TAN_MAX,Y_TAN_MIN,Y_TAN_MAX); // despatx DTIC matí
                else       irAZona(X_R53_MIN,X_R53_MAX,Y_R53_MIN,Y_R53_MAX);
            } else if (minDia>=630 && minDia<660) {
                if      (r<20) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                else            irADestinoAleatorio();
            } else if (minDia>=780 && minDia<870) {
                if      (r<.35) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
                else            irADestinoAleatorio();
            } else irADestinoAleatorio();
            return;
        }

        if (tipo == TipoAgente.VISITANTE) {
            if      (minDia>=480 && minDia<570) irAZona(X_NAU_MIN,X_NAU_MAX,Y_NAU_MIN,Y_NAU_MAX);
            else if (minDia>=630 && minDia<900) {
                if (r<.55) irAZona(X_NAU_MIN,X_NAU_MAX,Y_NAU_MIN,Y_NAU_MAX);
                else       irAZona(X_R52_MIN,X_R52_MAX,Y_R52_MIN,Y_R52_MAX);
            } else irADestinoAleatorio();
            return;
        }

        // GRADO / MASTER
        if (minDia>=480 && minDia<=570) {
            if (r<.35) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
            else       irADestinoAleatorio();
        } else if (minDia>=630 && minDia<=660) {
            if (r<.20) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
            else       irADestinoAleatorio();
        } else if (minDia>=780 && minDia<=900) {
            if      (r<.35) irAZona(X_CAF_MIN,X_CAF_MAX,Y_CAF_MIN,Y_CAF_MAX);
            else if (r<.55) intentarIrAPlaza();
            else            irADestinoAleatorio();
        } else {
            irADestinoAleatorio();
        }
    }

    @ScheduledMethod(start=1, interval=1)
    public void caminar() {
        NdPoint miPos = espacio.getLocation(this);
        if (miPos == null) return;
        int tick   = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
        int minDia = tick % 1440;

        if (!saliendo
                && destinoX>=X_PG_MIN && destinoX<=X_PG_MAX
                && destinoY>=Y_PG_MIN && destinoY<=Y_PG_MAX) {
            double temp = controlador.getTemperatura();
            if (controlador.isLloviendo()||temp<=10||temp>=35) {
                refugioPorLluvia(); minutosQuieto=0;
            }
        }

        String td = controlador.getTipoDiaActual();
        boolean teCampana = td.equals("Classe")||td.equals("Avaluacio")
                         || td.equals("La Benvinguda")||td.equals("No lectiu");
        if (!saliendo && teCampana) {
            for (int h=510; h<=1230; h+=120) {
                if (minDia==h) { decidirDestinoPorHora(minDia); minutosQuieto=0; break; }
            }
        }

        double dx=destinoX-miPos.getX(), dy=destinoY-miPos.getY();
        double dist=Math.sqrt(dx*dx+dy*dy);

        if (dist>velocidad) {
            espacio.moveTo(this,
                Math.max(0,Math.min(100,miPos.getX()+(dx/dist)*velocidad)),
                Math.max(0,Math.min(100,miPos.getY()+(dy/dist)*velocidad)));
            minutosQuieto=0;
            haLlegado=false;
        } else {
            if (!rutaWaypoints.isEmpty()) {
                double[] s=rutaWaypoints.poll();
                destinoX=s[0]; destinoY=s[1];
                haLlegado=false;
                return;
            }
            if (saliendo) { controlador.removerEstudiante(this); return; }
            haLlegado=true;
            minutosQuieto++;
            if (minutosQuieto>=duracionMaxQuieto) {
                decidirDestinoPorHora(minDia); minutosQuieto=0;
            }
        }
    }
}