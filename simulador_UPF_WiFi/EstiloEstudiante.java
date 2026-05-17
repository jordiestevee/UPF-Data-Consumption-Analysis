package simulador_UPF_WiFi;

import repast.simphony.visualizationOGL2D.DefaultStyleOGL2D;
import java.awt.*;

public class EstiloEstudiante extends DefaultStyleOGL2D {

    private Color getColorPorTipo(Estudiante est) {
        switch (est.getTipo()) {
            case GRADO:     return new Color( 50, 120, 200);  // azul
            case MASTER:    return new Color( 60, 180,  80);  // verde
            case PROFESOR:  return new Color(220,  60,  60);  // rojo
            case PAS:       return new Color(200, 140,  30);  // naranja oscuro
            case VISITANTE: return new Color(160,  70, 190);  // púrpura
            default:        return new Color(100, 100, 100);
        }
    }

    @Override
    public Color getColor(Object object) {
        return getColorPorTipo((Estudiante) object);
    }

    @Override
    public Color getBorderColor(Object object) {
        return getColorPorTipo((Estudiante) object).darker();
    }

    @Override
    public int getBorderSize(Object object) {
        return 1;
    }

    @Override
    public String getLabel(Object object) {
        // Primera letra del tipo: G, M, P, A, V
        Estudiante est = (Estudiante) object;
        switch (est.getTipo()) {
            case GRADO:     return "G";
            case MASTER:    return "M";
            case PROFESOR:  return "P";
            case PAS:       return "A";  
            case VISITANTE: return "V";
            default:        return "?";
        }
    }

    @Override
    public Color getLabelColor(Object object) {
        return Color.WHITE;
    }

    @Override
    public Font getLabelFont(Object object) {
        return new Font("SansSerif", Font.BOLD, 7);
    }

    @Override
    public float getLabelXOffset(Object object) {
        return 0.0f;
    }

    @Override
    public float getLabelYOffset(Object object) {
        return 0.0f;
    }
}