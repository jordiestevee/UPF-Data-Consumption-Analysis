package simulador_UPF_WiFi;

public class DispositivoFijo {
    private String idAparato;
    private String macAddress;

    public DispositivoFijo(String idAparato, String macAddress) {
        this.idAparato = idAparato;
        this.macAddress = macAddress;
    }

    public String getIdAparato()  { return idAparato; }
    public String getMacAddress() { return macAddress; }
}