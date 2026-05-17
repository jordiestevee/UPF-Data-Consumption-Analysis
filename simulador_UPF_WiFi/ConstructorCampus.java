package simulador_UPF_WiFi;

import repast.simphony.context.Context;
import repast.simphony.context.space.continuous.ContinuousSpaceFactory;
import repast.simphony.context.space.continuous.ContinuousSpaceFactoryFinder;
import repast.simphony.dataLoader.ContextBuilder;
import repast.simphony.random.RandomHelper;
import repast.simphony.space.continuous.ContinuousSpace;
import repast.simphony.space.continuous.RandomCartesianAdder;

/*
 * Gemelo digital del Campus UPF Poblenou.
 */
public class ConstructorCampus implements ContextBuilder<Object> {

    @Override
    public Context<Object> build(Context<Object> context) {

        context.setId("Simulador_UPF_WiFi");
        RandomHelper.setSeed(42);

        ContinuousSpaceFactory spaceFactory =
                ContinuousSpaceFactoryFinder.createContinuousSpaceFactory(null);
        ContinuousSpace<Object> espacio = spaceFactory.createContinuousSpace(
                "EspacioCampus", context,
                new RandomCartesianAdder<Object>(),
                new repast.simphony.space.continuous.StrictBorders(),
                100, 100);

        // Radios: 12 indoor (con paredes), 14 outdoor
        double R_IN  = 12.0;
        double R_OUT = 14.0;
        double R_CAF = 8.0;

        // ====================================================================
        // EDIFICIO 50 — LA FÀBRICA (CRAI, PIE, Servei Informàtica)
        // ====================================================================
        crearAP(context, espacio, "AP_50_01", "LaFabrica", R_IN, 75, 20);
        crearAP(context, espacio, "AP_50_02", "LaFabrica", R_IN, 90, 29);
        crearAP(context, espacio, "AP_50_03", "LaFabrica", R_IN, 75, 38);
        crearAP(context, espacio, "AP_50_04", "LaFabrica", R_IN, 90, 47);
        crearAP(context, espacio, "AP_50_05", "LaFabrica", R_IN, 75, 56);
        crearAP(context, espacio, "AP_50_06", "LaFabrica", R_IN, 90, 65);

        // ====================================================================
        // EDIFICIO 51 — LA NAU (Aulari, departaments, Sala Nau)
        // ====================================================================
        crearAP(context, espacio, "AP_51_01", "LaNau", R_IN, 15,  12);
        crearAP(context, espacio, "AP_51_03", "LaNau", R_IN, 40,  12);
        crearAP(context, espacio, "AP_51_05", "LaNau", R_IN, 65,  12);
        crearAP(context, espacio, "AP_51_06", "LaNau", R_IN, 90, 12);

        // ====================================================================
        // EDIFICIO 52 — ROC BORONAT BAIX (OMA, Auditori, Aulari PB-P4)
        // ====================================================================
        crearAP(context, espacio, "AP_52_01", "RocBoronat52", R_IN, 25, 20);
        crearAP(context, espacio, "AP_52_02", "RocBoronat52", R_IN, 10, 29);
        crearAP(context, espacio, "AP_52_03", "RocBoronat52", R_IN, 25, 38);
        crearAP(context, espacio, "AP_52_04", "RocBoronat52", R_IN, 10, 47);
        crearAP(context, espacio, "AP_52_05", "RocBoronat52", R_IN, 25, 56);
        crearAP(context, espacio, "AP_52_06", "RocBoronat52", R_IN, 10, 65);
        // ====================================================================
        // EDIFICIO 53 — ROC BORONAT TORRE (Despatxos, Departaments)
        // ====================================================================
        crearAP(context, espacio, "AP_53_01", "RocBoronat", R_IN, 10, 80);
        crearAP(context, espacio, "AP_53_02", "RocBoronat", R_IN, 15, 87.5);
        crearAP(context, espacio, "AP_53_03", "RocBoronat", R_IN, 10, 95);

        // ====================================================================
        // EDIFICIO 54 — ÀREA TALLERS (Labs audiovisuals, cotreball)
        // ====================================================================
        crearAP(context, espacio, "AP_54_01", "AreaTallers", R_IN, 40, 75);
        crearAP(context, espacio, "AP_54_02", "AreaTallers", R_IN, 60, 75);
        crearAP(context, espacio, "AP_54_03", "AreaTallers", R_IN, 80, 75);
        crearAP(context, espacio, "AP_54_04", "AreaTallers", R_IN, 50, 95);
        crearAP(context, espacio, "AP_54_05", "AreaTallers", R_IN, 70, 95);
        crearAP(context, espacio, "AP_54_06", "AreaTallers", R_IN, 90, 95);
        
	     // ====================================================================
	     // EDIFICIO 55 — TÀNGER (DTIC, Labs recerca, despatxos)
	     // ====================================================================
	     crearAP(context, espacio, "AP_55_01", "Tanger", R_IN, 20, 4);
	     crearAP(context, espacio, "AP_55_02", "Tanger", R_IN, 50, 4);
	     crearAP(context, espacio, "AP_55_03", "Tanger", R_IN, 80, 4);


        // ====================================================================
        // PLAÇA GUTENBERG — espai exterior central
        // ====================================================================
        crearAP(context, espacio, "AP_PG_01", "PlacaGutenberg", R_OUT, 40, 60);
        crearAP(context, espacio, "AP_PG_02", "PlacaGutenberg", R_OUT, 60, 60);
        crearAP(context, espacio, "AP_PG_03", "PlacaGutenberg", R_OUT, 40, 30);
        crearAP(context, espacio, "AP_PG_04", "PlacaGutenberg", R_OUT, 60, 30);
        
        // ====================================================================
        // CAFETERIA — planta baixa Roc Boronat (accés des de la Plaça)

        // ====================================================================
        crearAP(context, espacio, "AP_CAFE_01", "Cafeteria", R_CAF, 10, 20); 
        crearAP(context, espacio, "AP_CAFE_02", "Cafeteria", R_CAF, 25, 30); 
        // ====================================================================
        // EDIFICIOS — para visualización (centro del rectángulo)
        // ====================================================================
        Object[][] edificios = {
        	    { "50", "La Fàbrica",      82.5d, 42.5d, 25.0d, 55.0d },
        	    { "51", "La Nau",          52.5d, 12.0d, 85.0d, 12.0d },
        	    { "52", "Roc B. 52",       17.5d, 42.5d, 25.0d, 55.0d },
        	    { "53", "Roc B. 53",       12.5d, 87.5d, 15.0d, 25.0d },
        	    { "54", "Àrea Tallers",    65.0d, 85.0d, 55.0d, 25.0d },
        	    { "55", "Tànger",          50.0d,  4.0d, 65.0d,  8.0d },
        	    { "PG", "Plaça Gutenberg", 50.0d, 45.0d, 30.0d, 35.0d },
        	    { "CF", "Cafeteria",       17.5d, 25.0d, 25.0d, 20.0d },
        	};

        for (Object[] ed : edificios) {
            EdificioCampus edif = new EdificioCampus(
                (String) ed[0], 
                (String) ed[1],
                ((Number) ed[4]).doubleValue(),   
                ((Number) ed[5]).doubleValue()    
            );
            context.add(edif);
            espacio.moveTo(edif, 
                ((Number) ed[2]).doubleValue(),   
                ((Number) ed[3]).doubleValue()    
            );
        }

        // Controlador y registrador
        ControladorCampus controlador = new ControladorCampus(context, espacio);
        context.add(controlador);

        RegistradorWiFi registrador = new RegistradorWiFi(context, espacio);
        context.add(registrador);

        System.out.println("Campus Poblenou: 30 APs en 7 zonas (5 edificios + plaça + cafeteria).");
        System.out.println("  [FIX] AP_52_01 movido a (20,42) — fuera del bounding-box cafeteria.");
        System.out.println("  [FIX] Cafeteria: 3 APs con radio 8 (reducido de 12).");
        return context;
    }

    private void crearAP(Context<Object> ctx, ContinuousSpace<Object> esp,
                          String id, String zona, double radio, double x, double y) {
        PuntoAcceso ap = new PuntoAcceso(id, zona, radio);
        ctx.add(ap);
        esp.moveTo(ap, x, y);
    }
}