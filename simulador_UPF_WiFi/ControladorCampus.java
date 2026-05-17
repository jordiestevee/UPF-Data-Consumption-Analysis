package simulador_UPF_WiFi;

import repast.simphony.context.Context;
import repast.simphony.engine.environment.RunEnvironment;
import repast.simphony.engine.schedule.ScheduledMethod;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.time.LocalDate;

/*
 * Controlador del campus — versión con variabilidad real por tipo de día.
 */
public class ControladorCampus {

    private Context<Object> context;
    private ContinuousSpace<Object> espacio;

    private int contadorAlumnos = 0;
    private ArrayList<Estudiante> estudiantesEnCampus = new ArrayList<Estudiante>();
    private ArrayList<String> calendario = new ArrayList<String>();

    private double[] lluviaHoraria = new double[8784];
    private double[] tempHoraria   = new double[8784];

    private boolean llueveActual = false;
    private double  tempActual   = 20.0;

    // Variabilidad aleatoria diaria (renovada cada día a las 00:00)
    private double variacioAleatoriaDia = 1.0;
    private int    ultimoDiaVariacio    = -1;

    private static final double UMBRAL_LLUVIA_MM = 0.2;

    public ControladorCampus(Context<Object> context, ContinuousSpace<Object> espacio) {
        this.context = context;
        this.espacio = espacio;
        cargarCalendario();
        cargarClima();
        instalarDispositivosFijos();
    }

    public boolean isLloviendo()    { return llueveActual; }
    public double  getTemperatura() { return tempActual; }

    public String getTipoDiaActual() {
        int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
        int dia  = tick / 1440;
        return (dia >= 0 && dia < calendario.size()) ? calendario.get(dia) : "Desconocido";
    }

    public void removerEstudiante(Estudiante est) {
        context.remove(est);
        estudiantesEnCampus.remove(est);
    }

    private void cargarCalendario() {
        try {
            BufferedReader br = new BufferedReader(new FileReader("Calendari-UPF-2024.csv"));
            br.readLine();
            String linea;
            while ((linea = br.readLine()) != null) {
                String[] partes = linea.split(",");
                if (partes.length >= 2)
                    calendario.add(partes[1].replace("\"", "").trim());
            }
            br.close();
            System.out.println("Calendario cargado: " + calendario.size() + " dias.");
        } catch (IOException e) {
            System.out.println("ERROR: No se encontro Calendari-UPF-2024.csv");
        }
    }

    private void cargarClima() {
        try {
            BufferedReader br = new BufferedReader(new FileReader("clima_2024.csv"));
            br.readLine();
            String linea;
            int hora = 0;
            while ((linea = br.readLine()) != null && hora < 8784) {
                String[] partes = linea.split(",");
                if (partes.length >= 9) {
                    try {
                        tempHoraria[hora]   = Double.parseDouble(partes[4]);
                        lluviaHoraria[hora] = Double.parseDouble(partes[8]);
                    } catch (NumberFormatException ex) {
                        tempHoraria[hora]   = 20.0;
                        lluviaHoraria[hora] = 0.0;
                    }
                }
                hora++;
            }
            br.close();
            System.out.println("Clima cargado: " + hora + " horas.");
        } catch (IOException e) {
            System.out.println("ERROR: No se encontro clima_2024.csv");
        }
    }

    private void instalarDispositivosFijos() {
        int n = 0;
        // RocBoronat 52+53: PCs aulas
        for (int i = 0; i < 20; i++) {
            n++;
            DispositivoFijo f = new DispositivoFijo("PC_AULA_52_" + n, "FIJO_MAC_" + n);
            context.add(f);
            espacio.moveTo(f, 8  + RandomHelper.nextDoubleFromTo(0, 15),
                               32 + RandomHelper.nextDoubleFromTo(0, 28));
        }
        // Àrea Tallers: labs
        for (int i = 0; i < 40; i++) {
            n++;
            DispositivoFijo f = new DispositivoFijo("PC_LAB_54_" + n, "FIJO_MAC_" + n);
            context.add(f);
            espacio.moveTo(f, 45 + RandomHelper.nextDoubleFromTo(0, 35),
                               75 + RandomHelper.nextDoubleFromTo(0, 20));
        }
        // La Fàbrica: CRAI
        for (int i = 0; i < 35; i++) {
            n++;
            DispositivoFijo f = new DispositivoFijo("PC_CRAI_50_" + n, "FIJO_MAC_" + n);
            context.add(f);
            espacio.moveTo(f, 78 + RandomHelper.nextDoubleFromTo(0, 12),
                               38 + RandomHelper.nextDoubleFromTo(0, 20));
        }
        // La Nau: investigación
        for (int i = 0; i < 5; i++) {
            n++;
            DispositivoFijo f = new DispositivoFijo("PC_INV_51_" + n, "FIJO_MAC_" + n);
            context.add(f);
            espacio.moveTo(f, 25 + RandomHelper.nextDoubleFromTo(0, 30),
                               6  + RandomHelper.nextDoubleFromTo(0, 10));
        }
        System.out.println("Instalados " + n + " dispositivos fijos.");
    }

    @ScheduledMethod(start = 1, interval = 60)
    public void actualizarClima() {
        int tick = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
        int hora = tick / 60;
        if (hora < 8784) {
            tempActual   = tempHoraria[hora];
            llueveActual = lluviaHoraria[hora] > UMBRAL_LLUVIA_MM;
        }
    }

    @ScheduledMethod(start = 1, interval = 1)
    public void gestionarFlujo() {
        int tick   = (int) RunEnvironment.getInstance().getCurrentSchedule().getTickCount();
        int diaAno = tick / 1440;
        int minDia = tick % 1440;

        if (diaAno >= calendario.size()) return;

        // ── [VAR-1] Renovar variabilidad aleatoria diaria ────────────────────
        if (diaAno != ultimoDiaVariacio) {
            // Log-normal: media=1.0, sigma=0.12 → mayoría entre 0.88 y 1.14
            double u1 = RandomHelper.nextDoubleFromTo(0.001, 1.0);
            double u2 = RandomHelper.nextDoubleFromTo(0.001, 1.0);
            double gauss = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);
            variacioAleatoriaDia = Math.exp(0.12 * gauss);
            variacioAleatoriaDia = Math.max(0.75, Math.min(1.35, variacioAleatoriaDia));
            ultimoDiaVariacio    = diaAno;
        }

        String tipoDia = calendario.get(diaAno);

        // Multiplicadores por tipo de día 
        double multiplicadorDia;
        if      (tipoDia.equals("Classe"))        multiplicadorDia = 1.00;
        else if (tipoDia.equals("La Benvinguda")) multiplicadorDia = 0.7;
        else if (tipoDia.equals("Avaluacio"))     multiplicadorDia = 0.8;
        else if (tipoDia.equals("No lectiu"))     multiplicadorDia = 1.00; 
        else if (tipoDia.equals("Altre"))         multiplicadorDia = 0.60;
        else if (tipoDia.equals("Vacances"))      multiplicadorDia = 0.6;
        else if (tipoDia.equals("Dissabte") ||
                tipoDia.equals("Diumenge") ||
                tipoDia.equals("Festiu"))    multiplicadorDia = 0.30; 
        else                                       multiplicadorDia = 0.3;

        // Primera semana de cuatrimestre: +15%
        boolean esPrimeraSemana = (diaAno >= 7  && diaAno < 14)
                                || (diaAno >= 97 && diaAno < 104)
                                || (diaAno >= 267 && diaAno < 274);
        if (esPrimeraSemana && tipoDia.equals("Classe")) multiplicadorDia *= 1.15;

        // Multiplicador día de la semana
        LocalDate fechaHoy = LocalDate.ofYearDay(2024, diaAno + 1);
        int diaSemana = fechaHoy.getDayOfWeek().getValue();
        double multiplicadorSemanal = 1.0;
        switch (diaSemana) {
            case 1: multiplicadorSemanal = 0.80; break; // Lunes
            case 2: multiplicadorSemanal = 1.20; break; // Martes
            case 3: multiplicadorSemanal = 1.20; break; // Miércoles
            case 4: multiplicadorSemanal = 1.10; break; // Jueves
            case 5: multiplicadorSemanal = 0.75; break; // Viernes
            default: multiplicadorSemanal = 1.00;
        }

        // Multiplicador final = tipo × semana × variabilidad aleatoria diaria
        double multFinal = multiplicadorDia * multiplicadorSemanal * variacioAleatoriaDia;

        // Lambda de entrada según tipo de día
        double lambdaEntrada = calcularLambda(minDia, tipoDia);
        lambdaEntrada *= multFinal;

        // Impacto del clima
        if (llueveActual) {
            lambdaEntrada *= 0.75;
        } else if (!llueveActual && tempActual >= 18.0 && tempActual <= 30.0) {
            lambdaEntrada *= 1.20;
        }

        if (lambdaEntrada > 0) {
            int llegadas = muestraPoisson(lambdaEntrada);
            for (int i = 0; i < llegadas; i++) crearUnEstudiante(minDia, tipoDia);
        }

        // ── Tasa de salida ────────────────────────────────────────────────────
        double porcentajeSalida = calcularPorcentajeSalida(minDia, tipoDia);
        if (diaSemana == 5 && minDia >= 840) porcentajeSalida *= 1.5;  // Viernes
        if (llueveActual)                     porcentajeSalida *= 1.2;

        if (!estudiantesEnCampus.isEmpty()) {
            int salidas = muestraPoisson(estudiantesEnCampus.size() * porcentajeSalida);
            salidas = Math.min(salidas, estudiantesEnCampus.size());
            for (int i = 0; i < salidas; i++) marcarParaSalir();
        }

        if (minDia % 60 == 0) {
            // Contar por tipo de agente
            int nGrado=0, nMaster=0, nProf=0, nPas=0, nVisit=0;
            for (Estudiante e : estudiantesEnCampus) {
                switch(e.getTipo()) {
                    case GRADO:     nGrado++;  break;
                    case MASTER:    nMaster++; break;
                    case PROFESOR:  nProf++;   break;
                    case PAS:       nPas++;    break;
                    case VISITANTE: nVisit++;  break;
                }
            }

            System.out.printf(
                "──────────────────────────────────────────────────────%n" +
                "Día %3d | %02d:00 | %-15s | %.1f°C | %s%n" +
                "  Total: %d personas (var=%.2f)%n" +
                "  G=%-4d M=%-4d P=%-4d A=%-4d V=%-4d%n",
                diaAno,
                minDia / 60,
                tipoDia,
                tempActual,
                llueveActual ? "Lluvia" : "Despejado",
                estudiantesEnCampus.size(),
                variacioAleatoriaDia,
                nGrado, nMaster, nProf, nPas, nVisit
            );
        }
    }

    /**
     *
     * Classe/Avaluacio: pico 8:30-12h fuerte (clases magistrales)
     * No_lectiu:        pico 9-12h moderado (actos institucionales)
     * Vacances/Altre:   perfil plano 8-17h (PAS + investigadores con horario flexible)
     * Finde/Festiu:     perfil mínimo 9-14h (visitas puntuales)
     */
    private double calcularLambda(int minDia, String tipoDia) {
        boolean esLectivo   = tipoDia.equals("Classe") || tipoDia.equals("Avaluacio")
                           || tipoDia.equals("La Benvinguda");
        boolean esNoLectiu  = tipoDia.equals("No lectiu");
        boolean esVacAltre  = tipoDia.equals("Vacances") || tipoDia.equals("Altre");
        boolean esFinde     = tipoDia.equals("Dissabte") || tipoDia.equals("Diumenge")
                           || tipoDia.equals("Festiu");

        if (esLectivo) {
            // Perfil lectivo: entrada fuerte a las 8-9h, segunda ola a las 15h
            if (minDia <= 360)                         return 0.0;
            else if (minDia <= 480)                    return 2.0;   // 6-8h
            else if (minDia <= 510)                    return 9.0;   // 8-8:30h pico
            else if (minDia <= 720)                    return 8.0;   // 8:30-12h
            else if (minDia <= 840)                    return 5.0;   // 12-14h
            else if (minDia <= 870)                    return 8.0;   // 14-14:30h segunda ola
            else if (minDia <= 1020)                   return 5.0;   // 14:30-17h
            else if (minDia <= 1140)                   return 2.5;   // 17-19h
            else if (minDia <= 1320)                   return 0.5;   // 19-22h
            else                                       return 0.0;

        } else if (esNoLectiu) {
            // Perfil no lectiu: pico moderado a las 9-12h (actos, jornades)
            if (minDia <= 420)                         return 0.0;   // <7h
            else if (minDia <= 540)                    return 3.0;   // 7-9h
            else if (minDia <= 720)                    return 5.0;   // 9-12h (pico moderado)
            else if (minDia <= 900)                    return 3.0;   // 12-15h
            else if (minDia <= 1080)                   return 1.5;   // 15-18h
            else if (minDia <= 1200)                   return 0.5;   // 18-20h
            else                                       return 0.0;

        } else if (esVacAltre) {
            // Perfil vacaciones/agosto: perfil plano sin pico fuerte
            // PAS e investigadores tienen horario flexible de verano (8-15h)
            if (minDia <= 420)                         return 0.0;   // <7h
            else if (minDia <= 480)                    return 1.0;   // 7-8h
            else if (minDia <= 900)                    return 2.5;   // 8-15h (estable)
            else if (minDia <= 1020)                   return 1.0;   // 15-17h (salidas)
            else if (minDia <= 1140)                   return 0.3;   // 17-19h (pocos)
            else                                       return 0.0;   // >19h

        } else if (esFinde) {
            if (minDia <= 420)       return 0.0;   // <7h
            else if (minDia <= 600)  return 1.5;   // 7-10h apertura CRAI
            else if (minDia <= 840)  return 3.0;   // 10-14h pico finde 
            else if (minDia <= 1020) return 2.0;   // 14-17h tarde      
            else if (minDia <= 1140) return 0.8;   // 17-19h cierre
            else                     return 0.0;
        }

        return 0.0;
    }

 
    private double calcularPorcentajeSalida(int minDia, String tipoDia) {
        boolean esVacAltre = tipoDia.equals("Vacances") || tipoDia.equals("Altre");
        boolean esFinde    = tipoDia.equals("Dissabte") || tipoDia.equals("Diumenge")
                          || tipoDia.equals("Festiu");

        if (esVacAltre) {
            // En verano la gente se va a partir de las 15h (horario reducido)
            if (minDia <= 540)         return 0.001;
            else if (minDia <= 900)    return 0.003;   // 9-15h estable
            else if (minDia <= 1020)   return 0.020;   // 15-17h salida rápida
            else                       return 0.200;   // >17h cierre

        } else if (esFinde) {
            if (minDia <= 480)       return 0.000;
            else if (minDia <= 840)  return 0.002; // ← era 0.003
            else if (minDia <= 1080) return 0.008;
            else                     return 0.100; // ← era 0.150
            
        } else {
            // Perfil lectivo estándar
            if (minDia <= 360)         return 0.000;
            else if (minDia <= 600)    return 0.001;
            else if (minDia <= 750)    return 0.004;
            else if (minDia <= 870)    return 0.007;
            else if (minDia <= 960)    return 0.005;
            else if (minDia <= 1080)   return 0.004;
            else if (minDia <= 1140)   return 0.005;
            else if (minDia <= 1230)   return 0.010;
            else if (minDia <= 1320)   return 0.020;
            else                       return 0.250;
        }
    }

    private void crearUnEstudiante(int minuto, String tipoDia) {
        contadorAlumnos++;
        TipoAgente tipo = sortearPerfil(minuto, tipoDia);
        Estudiante nuevo = new Estudiante("ID_" + contadorAlumnos, tipo, espacio, this);
        context.add(nuevo);
        estudiantesEnCampus.add(nuevo);
        // Punto de entrada: esquina noroeste del campus
        double x = RandomHelper.nextDoubleFromTo(0, 2);
        double y = RandomHelper.nextDoubleFromTo(60, 70);
        espacio.moveTo(nuevo, x, y);
        nuevo.decidirDestinoPorHora(minuto);
    }

    /**
     
     *
     * Lectivo mañana: 65% GRADO, 10% MASTER, 10% PAS, 10% PROFESOR, 5% VISITANTE
     * Vacances/Altre: 15% GRADO (TFG), 30% MASTER, 25% PAS, 25% PROFESOR, 5% VISITANTE
     * Finde/Festiu:   10% GRADO, 10% MASTER, 30% PAS, 10% PROFESOR, 40% VISITANTE
     */
    private TipoAgente sortearPerfil(int minDia, String tipoDia) {
        double r = RandomHelper.nextDoubleFromTo(0, 1);

        boolean esVacAltre = tipoDia.equals("Vacances") || tipoDia.equals("Altre");
        boolean esFinde    = tipoDia.equals("Dissabte") || tipoDia.equals("Diumenge")
                          || tipoDia.equals("Festiu");

        if (esVacAltre) {
            // En verano: más investigadores (MASTER+PROFESOR) y PAS, menos GRADO
            if (r < 0.15) return TipoAgente.GRADO;
            if (r < 0.45) return TipoAgente.MASTER;
            if (r < 0.70) return TipoAgente.PAS;
            if (r < 0.95) return TipoAgente.PROFESOR;
            return TipoAgente.VISITANTE;

        } else if (esFinde) {
            // Finde: casi todo PAS de guardia + visitantes + algún estudiante
            if (r < 0.15) return TipoAgente.GRADO;
            if (r < 0.30) return TipoAgente.MASTER;
            if (r < 0.55) return TipoAgente.PAS;
            if (r < 0.65) return TipoAgente.PROFESOR;
            return TipoAgente.VISITANTE;

        } else {
            // Día lectivo: perfil habitual con variación mañana/tarde
            if (minDia < 840) {
                if (r < 0.65) return TipoAgente.GRADO;
                if (r < 0.75) return TipoAgente.MASTER;
                if (r < 0.85) return TipoAgente.PAS;
                if (r < 0.95) return TipoAgente.PROFESOR;
                return TipoAgente.VISITANTE;
            } else {
                if (r < 0.45) return TipoAgente.GRADO;
                if (r < 0.80) return TipoAgente.MASTER;
                if (r < 0.85) return TipoAgente.PAS;
                if (r < 0.97) return TipoAgente.PROFESOR;
                return TipoAgente.VISITANTE;
            }
        }
    }

    private void marcarParaSalir() {
        if (estudiantesEnCampus.isEmpty()) return;
        int idx = RandomHelper.nextIntFromTo(0, estudiantesEnCampus.size() - 1);
        estudiantesEnCampus.get(idx).marcarSalida();
    }

    private int muestraPoisson(double lambda) {
        if (lambda <= 0) return 0;
        double L = Math.exp(-lambda);
        int k = 0; double p = 1.0;
        do { k++; p *= RandomHelper.nextDoubleFromTo(0, 1); } while (p > L);
        return k - 1;
    }
}