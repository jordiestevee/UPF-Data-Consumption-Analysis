import streamlit as st
import pandas as pd
import joblib

# --- 1. CONFIGURACIÓN INICIAL ---
st.set_page_config(page_title="UPF Smart Campus AI", page_icon="⚡", layout="wide")
st.title("⚡ Plataforma de Inteligencia Energética - UPF Smart Campus")
st.markdown("Desarrollado para el Trabajo de Fin de Grado | **Motor IA: XGBoost & K-Means**")

# Cargar el modelo guardado
@st.cache_resource
def load_model():
    modelo = joblib.load('../AnalysisWithPython/modelo_xgboost_tfg.pkl')
    columnas = joblib.load('../AnalysisWithPython/columnas_entrenamiento.pkl')
    return modelo, columnas

try:
    modelo_xgb, columnas_entrenamiento = load_model()
    modelo_cargado = True
except:
    st.error("⚠️ No se encuentra el archivo 'modelo_xgboost_tfg.pkl'. Asegúrate de que está en la misma carpeta.")
    modelo_cargado = False

# --- 2. NAVEGACIÓN POR PESTAÑAS ---
tab1, tab2, tab3 = st.tabs(["🔮 1. Predictor en Vivo", "📊 2. Perfiles (Clustering)", "💸 3. Análisis Financiero"])

# ==========================================
# PESTAÑA 1: EL GEMELO DIGITAL (XGBOOST)
# ==========================================
with tab1:
    st.header("Predicción de Consumo en Tiempo Real")
    col1, col2 = st.columns([1, 2])
    
    with col1:
        st.subheader("Parámetros del Edificio")
        temp = st.slider("Temperatura Exterior (°C)", 0.0, 40.0, 22.0)
        wifi = st.slider("Conexiones Wi-Fi Activas", 0, 3000, 850)
        hora = st.slider("Hora del Día", 0, 23, 12)
        ocup_aulas = st.slider("Aulas Reservadas (%)", 0.0, 100.0, 60.0)
        lluvia = st.slider("Lluvia (mm)", 0.0, 20.0, 0.0)
        tipo_dia = st.selectbox("Tipo de Día", ['Lectivo', 'Festivo', 'Vacaciones'])
        
    with col2:
        st.subheader("Resultado de la Inteligencia Artificial")
        if modelo_cargado:
            # Preparar datos
            datos_entrada = {col: 0.0 for col in columnas_entrenamiento}
            datos_entrada['Temperatura'] = temp
            datos_entrada['Ocupacion_Simulada'] = wifi
            datos_entrada['Hora_del_Dia'] = hora
            datos_entrada['Lluvia'] = lluvia
            datos_entrada['Ocupacio_Percent'] = ocup_aulas
            
            if tipo_dia == 'Lectivo' and 'tipus_dia_Lectiu' in datos_entrada: datos_entrada['tipus_dia_Lectiu'] = 1.0
            if tipo_dia == 'Festivo' and 'tipus_dia_Festiu' in datos_entrada: datos_entrada['tipus_dia_Festiu'] = 1.0
            
            # Predecir
            df_pred = pd.DataFrame([datos_entrada])
            prediccion = modelo_xgb.predict(df_pred)[0]
            
            # Visualización del resultado
            st.metric(label="Consumo Eléctrico Estimado", value=f"{prediccion:.2f} kWh")
            
            # Alertas lógicas del sistema
            if prediccion > 300:
                st.error("🚨 ALERTA: Consumo crítico detectado. Pico de demanda en la red.")
            elif wifi < 50 and prediccion > 150:
                st.warning("⚠️ AVISO: Posible fuga energética. Alto consumo con el campus vacío.")
            else:
                st.success("✅ Consumo dentro de los parámetros de eficiencia normales.")

# ==========================================
# PESTAÑA 2: CLUSTERING (K-MEANS)
# ==========================================
with tab2:
    st.header("Descubrimiento de Patrones (Aprendizaje No Supervisado)")
    st.markdown("El modelo K-Means ha analizado un año de datos y ha descubierto **4 perfiles de comportamiento** en el campus de forma autónoma:")
    
    colA, colB, colC, colD = st.columns(4)
    colA.info("🔵 **Clúster 1: Modo Ahorro**\n\nBaja ocupación, bajo consumo. (Madrugadas, domingos).")
    colB.success("🟢 **Clúster 2: Rutina Eficiente**\n\nAlta ocupación, consumo moderado. (Días lectivos de primavera/otoño).")
    colC.warning("🟠 **Clúster 3: Estrés Térmico**\n\nOcupación media, pero alto consumo. (Olas de frío o calor).")
    colD.error("🔴 **Clúster 4: Anomalía (Fuga)**\n\nBaja ocupación, pero consumo altísimo. (Sistemas olvidados encendidos).")

# ==========================================
# PESTAÑA 3: IMPACTO FINANCIERO (ROI)
# ==========================================
with tab3:
    st.header("Análisis de Fugas Energéticas (Basado en MIT)")
    st.markdown("Cruzando el clúster de 'Anomalías' con los precios de mercado, obtenemos el coste económico del derroche energético.")
    
    precio_kwh = st.number_input("Precio actual de la energía (€/kWh)", value=0.15, step=0.01)
    
    # Datos simulados basados en tu descubrimiento anterior
    horas_perdidas_anuales = 252 # Ejemplo
    energia_desperdiciada = horas_perdidas_anuales * 180 # Asumiendo 180 kWh de media en la fuga
    coste_total = energia_desperdiciada * precio_kwh
    ahorro_potencial = coste_total * 0.60
    
    st.markdown("---")
    st.subheader("📊 Auditoría Anual del Gemelo Digital")
    st.metric(label="Energía Desperdiciada Anual", value=f"{energia_desperdiciada:,.0f} kWh")
    st.metric(label="Coste Económico de las Fugas", value=f"{coste_total:,.2f} €")
    st.metric(label="Ahorro Potencial (Automatizando apagados)", value=f"{ahorro_potencial:,.2f} €", delta="Dinero recuperable")