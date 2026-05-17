package simulador_UPF_WiFi;

public class Waypoints {

    public static final double[][] NODOS = {

        // ─── ENTRADA PRINCIPAL CAMPUS ─────────────────────────────────────────
        {  0,  3.0, 72.5 },  // W0  SPAWN/SALIDA — entre RocB52 (y_max=70) y RocB53 (y_min=75)

        // ─── NODOS CORREDOR IZQUIERDO ─────────────────────────────────────────
        {  1, 20.0, 72.5 },  // W1  corredor izq entrada — alineado con W0
        {  2, 20.0, 55.0 },  // W2  corredor izq — frente RocB52 centro (cy=42.5)
        {  3, 20.0, 35.0 },  // W3  corredor izq — frente Cafetería (cy=25)

        // ─── ENTRADAS EDIFICIOS ───────────────────────────────────────────────
        {  4, 17.5, 72.5 },  // W4  ENTRADA RocB52  (borde sur, y_max=70 ≈ 72)
        {  5, 17.5, 80.0 },  // W5  ENTRADA RocB53  (borde norte, y_min=75 ≈ 80)
        {  6, 30.0, 35.0 },  // W6  ENTRADA Cafetería (borde derecho, x_max=30)
        {  7, 65.0, 42.5 },  // W7  ENTRADA LaFàbrica (borde izq, x_min=70 ≈ 65)
        {  8, 37.5, 72.5 },  // W8  ENTRADA AreaTallers (borde izq, x_min=37)
        {  9, 52.5, 18.0 },  // W9  ENTRADA LaNau (borde sur, y_max=18)
        { 10, 52.5,  8.0 },  // W10 ENTRADA Tànger (borde sur, y_max=8)

        // ─── PLAÇA GUTENBERG (hub central) ────────────────────────────────────
        { 11, 50.0, 45.0 },  // W11 CENTRO PLAÇA (cy=45)

        // ─── NODOS AUXILIARES ─────────────────────────────────────────────────
        { 12, 50.0, 22.0 },  // W12 corredor LaNau↔Plaça (entre LaNau y=18 y Plaça y=27)
        { 13, 50.0, 12.0 },  // W13 corredor LaNau↔Tànger
        { 14, 65.0, 72.5 },  // W14 nodo AreaTallers↔LaFàbrica (entre ambos)
    };

    public static final int[][] ARISTAS = {
        // Entrada campus → corredor izquierdo
        {0, 1},

        // Corredor izquierdo vertical
        {1, 2}, {2, 3},

        // Entradas desde corredor izquierdo
        {1, 4},  // → RocB52 (por el sur)
        {1, 5},  // → RocB53 (por el norte)
        {3, 6},  // → Cafetería

        // Corredor izq → Plaça
        {2, 11}, // centro corredor → Plaça
        {3, 11}, // sur corredor → Plaça (diagonal)

        // Plaça → LaFàbrica
        {11, 7},

        // Plaça → AreaTallers
        {11, 14}, {14, 8},

        // Plaça → LaNau → Tànger
        {11, 12}, {12, 9},  // Plaça → LaNau entrada
        {9, 13},  {13, 10}, // LaNau → Tànger entrada

        // Atajo directo entrada campus → AreaTallers (sin pasar por Plaça)
        {1, 14},
    };

    public static int waypointMasCercano(double x, double y) {
        int mejor = 0;
        double minDist = Double.MAX_VALUE;
        for (int i = 0; i < NODOS.length; i++) {
            double dx = NODOS[i][1] - x;
            double dy = NODOS[i][2] - y;
            double d = Math.sqrt(dx*dx + dy*dy);
            if (d < minDist) { minDist = d; mejor = i; }
        }
        return mejor;
    }

    public static int[] caminoMinimo(int origen, int destino) {
        if (origen == destino) return new int[]{origen};
        int n = NODOS.length;
        int[] padre = new int[n];
        boolean[] visitado = new boolean[n];
        java.util.Arrays.fill(padre, -1);

        java.util.Queue<Integer> cola = new java.util.LinkedList<>();
        cola.add(origen); visitado[origen] = true;

        while (!cola.isEmpty()) {
            int actual = cola.poll();
            if (actual == destino) break;
            for (int[] arista : ARISTAS) {
                int vecino = -1;
                if (arista[0] == actual && !visitado[arista[1]]) vecino = arista[1];
                if (arista[1] == actual && !visitado[arista[0]]) vecino = arista[0];
                if (vecino >= 0) { visitado[vecino] = true; padre[vecino] = actual; cola.add(vecino); }
            }
        }

        java.util.LinkedList<Integer> path = new java.util.LinkedList<>();
        for (int nodo = destino; nodo != -1; nodo = padre[nodo]) path.addFirst(nodo);
        return path.stream().mapToInt(i -> i).toArray();
    }
}