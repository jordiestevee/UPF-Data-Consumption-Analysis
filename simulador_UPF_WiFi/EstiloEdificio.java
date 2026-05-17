package simulador_UPF_WiFi;

import repast.simphony.visualizationOGL2D.DefaultStyleOGL2D;
import java.awt.*;

public class EstiloEdificio extends DefaultStyleOGL2D {

    private Color getBaseColor(EdificioCampus e) {
        switch (e.getCodigo()) {
            case "50": return new Color(100, 180, 255);
            case "51": return new Color( 80, 200, 120);
            case "52": return new Color(255, 140,  50);
            case "53": return new Color(255, 200,  40);
            case "54": return new Color(180, 120, 220);
            case "PG": return new Color(160, 220, 130);
            case "CF": return new Color(210, 160, 100);
            default:   return new Color(200, 200, 200);
        }
    }

    @Override
    public Color getColor(Object object) {
        Color c = getBaseColor((EdificioCampus) object);
        return new Color(c.getRed(), c.getGreen(), c.getBlue(), 45);
    }

    @Override
    public Color getBorderColor(Object object) {
        Color c = getBaseColor((EdificioCampus) object);
        return new Color(c.getRed(), c.getGreen(), c.getBlue(), 200);
    }

    @Override
    public int getBorderSize(Object object) {
        return 2;
    }

    @Override
    public String getLabel(Object object) {
        EdificioCampus e = (EdificioCampus) object;
        return e.getCodigo() + " · " + e.getNombre();
    }

    @Override
    public Color getLabelColor(Object object) {
        return getBaseColor((EdificioCampus) object).darker();
    }

    @Override
    public Font getLabelFont(Object object) {
        return new Font("SansSerif", Font.BOLD, 25);
    }
}