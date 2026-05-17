package simulador_UPF_WiFi;

public class EdificioCampus {

    private final String codigo;
    private final String nombre;
    private final double ancho;   // unidades del espacio (0-100)
    private final double alto;

    public EdificioCampus(String codigo, String nombre,
                           double ancho, double alto) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.ancho  = ancho;
        this.alto   = alto;
    }

    public String getCodigo() { return codigo; }
    public String getNombre() { return nombre; }
    public double getAncho()  { return ancho; }
    public double getAlto()   { return alto; }
}