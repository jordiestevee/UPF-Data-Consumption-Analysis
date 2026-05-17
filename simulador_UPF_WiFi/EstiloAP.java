package simulador_UPF_WiFi;

import repast.simphony.visualizationOGL2D.DefaultStyleOGL2D;
import java.awt.*;

public class EstiloAP extends DefaultStyleOGL2D {

    @Override
    public Color getColor(Object object) {
        return new Color(255, 80, 0);  // naranja
    }

    @Override
    public String getLabel(Object object) {
        return ((PuntoAcceso) object).getId();
    }

    @Override
    public Color getLabelColor(Object object) {
        return new Color(180, 40, 0);  // marrón oscuro
    }

    @Override
    public Font getLabelFont(Object object) {
        return new Font("Monospaced", Font.BOLD, 20);
    }
}