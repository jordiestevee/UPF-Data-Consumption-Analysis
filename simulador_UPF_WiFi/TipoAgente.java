package simulador_UPF_WiFi;

/**
 * Perfiles de agente que circulan por el campus UPF.
 * Cada perfil tiene patrones de movimiento, horarios, duracion de estancia
 * y composicion de dispositivos distintos.
 */
public enum TipoAgente {
    GRADO,      // Estudiante de grado - rutina manana, dispositivos basicos
    MASTER,     // Estudiante de master - rutina tarde, mas portatil
    PAS,        // Personal de Administracion - jornada laboral fija
    PROFESOR,   // Profesorado - clases + despacho
    VISITANTE   // Visita/conferencia - estancia breve
}