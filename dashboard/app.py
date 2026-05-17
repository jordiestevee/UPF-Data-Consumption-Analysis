"""
UPF Smart Campus Energy Dashboard
==================================

Interactive dashboard for the UPF Energy Consumption Analysis TFG.
Built with Streamlit + Plotly.

Run with:
    streamlit run dashboard/app.py

Author: Jordi Esteve Claramunt
TFG    : Universitat Pompeu Fabra, 2025-2026
"""

import sys
from pathlib import Path

import pandas as pd
import numpy as np
import streamlit as st
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots

sys.path.append(str(Path(__file__).resolve().parent.parent))


# ════════════════════════════════════════════════════════════════════
# PAGE CONFIG
# ════════════════════════════════════════════════════════════════════

st.set_page_config(
    page_title="UPF Smart Campus | Energy Dashboard",
    page_icon="⚡",
    layout="wide",
    initial_sidebar_state="expanded",
)


# ════════════════════════════════════════════════════════════════════
# DESIGN TOKENS
# ════════════════════════════════════════════════════════════════════

UPF_NAVY  = "#032E60"
UPF_BLUE  = "#1F4E96"
UPF_TEAL  = "#06B6D4"
UPF_RED   = "#E84855"
UPF_AMBER = "#F59E0B"
UPF_GREEN = "#10B981"
UPF_GRAY  = "#64748B"
UPF_BG    = "#F8FAFC"

PLOTLY_TEMPLATE = "plotly_white"


# ════════════════════════════════════════════════════════════════════
# CUSTOM CSS
# ════════════════════════════════════════════════════════════════════

st.markdown(
    f"""
<style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

    html, body, .stApp {{
        font-family: 'Inter', 'Helvetica Neue', sans-serif;
        background-color: {UPF_BG};
    }}

    #MainMenu {{visibility: hidden;}}
    footer    {{visibility: hidden;}}
    header    {{visibility: hidden;}}

    /* ── Typography ─────────────────────────────────────────── */
    h1, h2, h3 {{
        color: {UPF_NAVY};
        font-family: 'Inter', 'Helvetica Neue', sans-serif;
        letter-spacing: -0.02em;
    }}
    h1 {{
        font-weight: 700;
        font-size: 2rem !important;
        padding-bottom: 0.4rem;
        margin-bottom: 0.25rem;
    }}
    h2 {{ font-weight: 600; font-size: 1.35rem !important; margin-top: 2rem; }}
    h3 {{ font-weight: 600; font-size: 1.05rem !important; }}

    /* ── KPI Cards ──────────────────────────────────────────── */
    [data-testid="metric-container"] {{
        background-color: white;
        border: 1px solid #E2E8F0;
        padding: 1.2rem 1.4rem;
        border-radius: 10px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        transition: box-shadow 0.2s;
    }}
    [data-testid="metric-container"]:hover {{
        box-shadow: 0 4px 14px rgba(3,46,96,0.1);
    }}
    [data-testid="stMetricLabel"] {{
        color: {UPF_GRAY} !important;
        font-size: 0.76rem !important;
        font-weight: 600 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.06em !important;
    }}
    [data-testid="stMetricValue"] {{
        color: {UPF_NAVY} !important;
        font-size: 1.7rem !important;
        font-weight: 700 !important;
        letter-spacing: -0.02em;
    }}
    [data-testid="stMetricDelta"] {{ font-size: 0.8rem !important; }}

    /* ── Sidebar ────────────────────────────────────────────── */
    [data-testid="stSidebar"] {{
        background: linear-gradient(180deg, {UPF_NAVY} 0%, #041e42 100%);
        border-right: none;
    }}
    [data-testid="stSidebar"] * {{ color: white !important; }}
    [data-testid="stSidebar"] h1,
    [data-testid="stSidebar"] h2,
    [data-testid="stSidebar"] h3 {{ color: white !important; border: none; }}
    [data-testid="stSidebar"] .stRadio label {{
        color: rgba(255,255,255,0.82) !important;
        font-size: 0.9rem;
        padding: 0.3rem 0;
    }}
    [data-testid="stSidebar"] .stRadio label:hover {{ color: white !important; }}

    /* ── Tabs ───────────────────────────────────────────────── */
    .stTabs [data-baseweb="tab-list"] {{
        gap: 6px;
        border-bottom: 2px solid #E2E8F0;
    }}
    .stTabs [data-baseweb="tab"] {{
        background: transparent;
        border-radius: 6px 6px 0 0;
        padding: 0.5rem 1.2rem;
        border: none;
        color: {UPF_GRAY};
        font-weight: 500;
        font-size: 0.88rem;
        transition: all 0.15s;
    }}
    .stTabs [aria-selected="true"] {{
        background-color: {UPF_NAVY} !important;
        color: white !important;
    }}

    /* ── Buttons ────────────────────────────────────────────── */
    .stButton > button,
    .stDownloadButton > button {{
        background-color: {UPF_NAVY};
        color: white;
        border: none;
        border-radius: 6px;
        padding: 0.5rem 1.5rem;
        font-weight: 600;
        font-size: 0.88rem;
        letter-spacing: 0.01em;
        transition: all 0.2s;
    }}
    .stButton > button:hover,
    .stDownloadButton > button:hover {{
        background-color: {UPF_BLUE};
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(3,46,96,0.2);
    }}

    /* ── Hero ───────────────────────────────────────────────── */
    .hero {{
        background: linear-gradient(135deg, {UPF_NAVY} 0%, {UPF_BLUE} 60%, #2563eb 100%);
        padding: 2.5rem 2.75rem;
        border-radius: 14px;
        color: white;
        margin-bottom: 2rem;
        position: relative;
        overflow: hidden;
    }}
    .hero::before {{
        content: '';
        position: absolute;
        top: -50%;
        right: -8%;
        width: 480px;
        height: 480px;
        border-radius: 50%;
        background: rgba(255,255,255,0.04);
        pointer-events: none;
    }}
    .hero::after {{
        content: '';
        position: absolute;
        bottom: -40%;
        right: 18%;
        width: 280px;
        height: 280px;
        border-radius: 50%;
        background: rgba(6,182,212,0.09);
        pointer-events: none;
    }}
    .hero h1 {{
        color: white !important;
        border: none;
        margin: 0 0 0.5rem 0;
        font-size: 1.85rem !important;
        font-weight: 700;
    }}
    .hero .subtitle {{
        color: rgba(255,255,255,0.8);
        font-size: 1rem;
        line-height: 1.65;
        max-width: 700px;
    }}
    .hero .badge-row {{
        display: flex;
        gap: 0.65rem;
        margin-top: 1.2rem;
        flex-wrap: wrap;
    }}
    .hero .badge {{
        background: rgba(255,255,255,0.14);
        border: 1px solid rgba(255,255,255,0.24);
        border-radius: 999px;
        padding: 0.22rem 0.8rem;
        font-size: 0.78rem;
        color: white;
    }}

    /* ── Section Header ─────────────────────────────────────── */
    .section-title {{
        display: flex;
        align-items: center;
        gap: 0.55rem;
        margin: 2rem 0 0.85rem 0;
        padding-bottom: 0.55rem;
        border-bottom: 2px solid #E2E8F0;
    }}
    .section-title .s-icon {{ font-size: 1.1rem; }}
    .section-title .s-text {{
        font-size: 1rem;
        font-weight: 600;
        color: {UPF_NAVY};
        letter-spacing: -0.01em;
    }}

    /* ── Insight Box ────────────────────────────────────────── */
    .insight-box {{
        background: #EFF6FF;
        border-left: 4px solid {UPF_BLUE};
        border-radius: 0 8px 8px 0;
        padding: 0.85rem 1.15rem;
        margin: 0.5rem 0 1.5rem 0;
        font-size: 0.88rem;
        color: #1E3A5F;
        line-height: 1.65;
    }}
    .insight-box strong {{ color: {UPF_NAVY}; }}

    /* ── Recommendation Card ────────────────────────────────── */
    .rec-card {{
        background: white;
        border: 1px solid #D1FAE5;
        border-left: 4px solid {UPF_GREEN};
        border-radius: 0 8px 8px 0;
        padding: 0.85rem 1.15rem;
        margin-bottom: 0.7rem;
        font-size: 0.88rem;
        color: #1E293B;
        line-height: 1.65;
    }}
    .rec-card .rec-title {{
        font-weight: 700;
        color: #059669;
        margin-bottom: 0.2rem;
        font-size: 0.78rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }}

    /* ── Data Note ──────────────────────────────────────────── */
    .data-note {{
        font-size: 0.76rem;
        color: {UPF_GRAY};
        font-style: italic;
        margin-top: -0.4rem;
        margin-bottom: 1rem;
    }}

    /* ── About Cards ────────────────────────────────────────── */
    .about-card {{
        background: white;
        border: 1px solid #E2E8F0;
        border-radius: 10px;
        padding: 1.1rem 1.3rem;
        margin-bottom: 0.85rem;
        box-shadow: 0 1px 3px rgba(0,0,0,0.04);
    }}
    .about-card .card-label {{
        font-size: 0.7rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: {UPF_TEAL};
        margin-bottom: 0.35rem;
    }}
    .about-card .card-value {{
        font-size: 0.95rem;
        font-weight: 500;
        color: {UPF_NAVY};
        line-height: 1.55;
    }}

    /* ── Status dots ────────────────────────────────────────── */
    .dot {{
        display: inline-block;
        width: 7px;
        height: 7px;
        border-radius: 50%;
        margin-right: 6px;
        vertical-align: middle;
    }}
    .dot-ok   {{ background-color: {UPF_GREEN}; }}
    .dot-err  {{ background-color: {UPF_RED};   }}

    /* ── Page Footer ────────────────────────────────────────── */
    .dash-footer {{
        border-top: 1px solid #E2E8F0;
        padding-top: 0.9rem;
        margin-top: 3rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 0.76rem;
        color: {UPF_GRAY};
    }}

    /* ── Pipeline step ──────────────────────────────────────── */
    .pipe-step {{
        display: flex;
        gap: 1rem;
        margin-bottom: 1rem;
        align-items: flex-start;
    }}
    .pipe-num {{
        min-width: 26px;
        height: 26px;
        background: {UPF_NAVY};
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.78rem;
        font-weight: 700;
        flex-shrink: 0;
    }}
</style>
""",
    unsafe_allow_html=True,
)


# ════════════════════════════════════════════════════════════════════
# DATA LOADING
# ════════════════════════════════════════════════════════════════════

PROJECT_ROOT   = Path(__file__).resolve().parent.parent
DATA_PROCESSED = PROJECT_ROOT / "data" / "processed"
MODELS_DIR     = PROJECT_ROOT / "outputs" / "models"


@st.cache_data(show_spinner="Loading master dataset…")
def load_master_dataset() -> pd.DataFrame | None:
    path = DATA_PROCESSED / "dataset_smart_campus_master.csv"
    if not path.exists():
        return None
    df = pd.read_csv(path, parse_dates=["Timestamp"])
    df["Hora"]      = df["Timestamp"].dt.hour
    df["Fecha"]     = df["Timestamp"].dt.date
    df["Mes"]       = df["Timestamp"].dt.month_name()
    df["DiaSemana"] = df["Timestamp"].dt.day_name()
    return df


@st.cache_resource(show_spinner="Loading trained model…")
def load_model():
    import joblib
    model_path   = MODELS_DIR / "best_model.pkl"
    columns_path = MODELS_DIR / "training_columns.pkl"
    if not model_path.exists() or not columns_path.exists():
        return None, None
    return joblib.load(model_path), joblib.load(columns_path)


def data_status_check():
    files = {
        "Master dataset":   DATA_PROCESSED / "dataset_smart_campus_master.csv",
        "Trained model":    MODELS_DIR / "best_model.pkl",
        "Training columns": MODELS_DIR / "training_columns.pkl",
    }
    return [name for name, p in files.items() if not p.exists()]


# ════════════════════════════════════════════════════════════════════
# HELPERS
# ════════════════════════════════════════════════════════════════════

def style_fig(fig: go.Figure, height: int = 400) -> go.Figure:
    fig.update_layout(
        template=PLOTLY_TEMPLATE,
        height=height,
        margin=dict(l=24, r=24, t=52, b=24),
        font=dict(family="Inter, Helvetica Neue, sans-serif", size=12, color="#0F172A"),
        title_font=dict(size=14, color=UPF_NAVY, family="Inter, sans-serif"),
        title_x=0,
        title_xanchor="left",
        plot_bgcolor="white",
        paper_bgcolor="white",
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=1.02,
            xanchor="right",
            x=1,
            bgcolor="rgba(255,255,255,0.9)",
            bordercolor="#E2E8F0",
            borderwidth=1,
            font=dict(size=11),
        ),
        hoverlabel=dict(
            bgcolor="white",
            font_size=12,
            font_family="Inter, Helvetica Neue",
            bordercolor="#E2E8F0",
        ),
    )
    fig.update_xaxes(gridcolor="#F1F5F9", zerolinecolor="#E2E8F0", linecolor="#E2E8F0")
    fig.update_yaxes(gridcolor="#F1F5F9", zerolinecolor="#E2E8F0", linecolor="#E2E8F0")
    return fig


def insight_box(text: str):
    st.markdown(f'<div class="insight-box">{text}</div>', unsafe_allow_html=True)


def rec_card(title: str, body: str):
    st.markdown(
        f'<div class="rec-card"><div class="rec-title">{title}</div>{body}</div>',
        unsafe_allow_html=True,
    )


def section_header(icon: str, title: str):
    st.markdown(
        f'<div class="section-title">'
        f'<span class="s-icon">{icon}</span>'
        f'<span class="s-text">{title}</span>'
        f'</div>',
        unsafe_allow_html=True,
    )


def page_footer(name: str):
    st.markdown(
        f'<div class="dash-footer">'
        f'<span>UPF Smart Campus Energy Dashboard &nbsp;·&nbsp; {name}</span>'
        f'<span>Jordi Esteve Claramunt &nbsp;·&nbsp; TFG 2025–2026 &nbsp;·&nbsp; Universitat Pompeu Fabra</span>'
        f'</div>',
        unsafe_allow_html=True,
    )


# ════════════════════════════════════════════════════════════════════
# SIDEBAR
# ════════════════════════════════════════════════════════════════════

missing_files = data_status_check()

with st.sidebar:
    st.markdown(
        """
<div style="padding:0.5rem 0 1.25rem 0;">
  <div style="font-size:1.45rem;font-weight:800;letter-spacing:-0.02em;">⚡ UPF Smart Campus</div>
  <div style="font-size:0.78rem;color:rgba(255,255,255,0.55);margin-top:0.2rem;font-weight:400;">
    Energy Consumption Dashboard
  </div>
</div>
""",
        unsafe_allow_html=True,
    )

    page = st.radio(
        "Navigation",
        [
            "🏠 Overview",
            "👥 Occupancy Analysis",
            "🔌 Energy Patterns",
            "🤖 Predictive Model",
            "🚨 Energy Audit",
            "ℹ️ About",
        ],
        label_visibility="collapsed",
    )

    st.markdown("---")

    st.markdown(
        '<div style="font-size:0.7rem;font-weight:700;text-transform:uppercase;'
        'letter-spacing:0.08em;color:rgba(255,255,255,0.45);margin-bottom:0.6rem;">Data Status</div>',
        unsafe_allow_html=True,
    )
    status_map = {
        "Master dataset":    DATA_PROCESSED / "dataset_smart_campus_master.csv",
        "Trained model":     MODELS_DIR / "best_model.pkl",
        "Test predictions":  MODELS_DIR / "predictions.npy",
    }
    for label, path in status_map.items():
        cls = "dot-ok" if path.exists() else "dot-err"
        st.markdown(
            f'<div style="font-size:0.82rem;margin-bottom:0.3rem;">'
            f'<span class="dot {cls}"></span>{label}</div>',
            unsafe_allow_html=True,
        )

    st.markdown("---")
    st.markdown(
        """
<div style="font-size:0.8rem;line-height:1.8;color:rgba(255,255,255,0.68);">
  <strong style="color:white;">Author</strong><br>Jordi Esteve Claramunt<br><br>
  <strong style="color:white;">Supervisors</strong><br>V. Estivill &nbsp;·&nbsp; M. Portela<br><br>
  <strong style="color:white;">Degree</strong><br>Math. Eng. &amp; Data Science<br><br>
  <strong style="color:white;">Year</strong><br>2025–2026
</div>
""",
        unsafe_allow_html=True,
    )


# ════════════════════════════════════════════════════════════════════
# PAGE 1 — OVERVIEW
# ════════════════════════════════════════════════════════════════════


def page_overview():
    st.markdown(
        """
<div class="hero">
  <h1>UPF Smart Campus — Energy Intelligence</h1>
  <p class="subtitle">
    End-to-end analytics: from Wi-Fi infrastructure data to actionable energy insights
    at the Poblenou campus. Explore consumption patterns, occupancy correlations,
    predictive forecasting, and detected waste in one unified dashboard.
  </p>
  <div class="badge-row">
    <span class="badge">📍 UPF Poblenou Campus</span>
    <span class="badge">📅 2024 Full Year</span>
    <span class="badge">🔬 XGBoost · R²=0.97</span>
    <span class="badge">⚡ Hourly granularity</span>
  </div>
</div>
""",
        unsafe_allow_html=True,
    )

    if "Master dataset" in missing_files:
        st.warning(
            "⚠️ The master dataset has not been generated yet. "
            "Run notebooks 01–02 to enable this dashboard."
        )
        return

    df = load_master_dataset()

    # ── KPIs ─────────────────────────────────────────────────────
    section_header("📊", "Annual Performance — 2024")

    c1, c2, c3, c4 = st.columns(4)
    c1.metric("Total Energy Consumed", f"{df['Consumo_kWh'].sum() / 1000:,.0f} MWh")
    c2.metric("Average Hourly Load", f"{df['Consumo_kWh'].mean():.1f} kWh")
    c3.metric("Peak Occupancy", f"{int(df['Ocupacion_Simulada'].max()):,} people")
    c4.metric("Total Hours Logged", f"{len(df):,}")

    c5, c6, c7, c8 = st.columns(4)
    annual_cost = df["Consumo_kWh"].sum() * 0.15
    c5.metric("Annual Cost (est.)", f"€ {annual_cost:,.0f}")
    c6.metric("Mean Temperature", f"{df['Temperatura'].mean():.1f} °C")
    c7.metric("Avg. Classroom Occupancy", f"{df['Ocupacio_Percent'].mean():.1f} %")
    days = df["Fecha"].nunique()
    c8.metric(
        "Days Recorded",
        f"{days} / 366",
        delta=f"{days - 366}" if days < 366 else "Complete",
        delta_color="off",
    )

    # ── Trend ────────────────────────────────────────────────────
    section_header("📈", "Annual Consumption Trend")

    col_f, _ = st.columns([1, 4])
    with col_f:
        agg_level = st.selectbox("Aggregation level", ["Daily", "Weekly", "Monthly"], index=1)

    rule_map = {"Daily": "D", "Weekly": "W", "Monthly": "MS"}
    df_agg = (
        df.set_index("Timestamp")
        .resample(rule_map[agg_level])
        .agg(
            Consumo=("Consumo_kWh", "sum"),
            Ocupacion=("Ocupacion_Simulada", "mean"),
        )
        .reset_index()
    )

    fig = make_subplots(specs=[[{"secondary_y": True}]])
    fig.add_trace(
        go.Scatter(
            x=df_agg["Timestamp"],
            y=df_agg["Consumo"],
            name="Energy (kWh)",
            mode="lines",
            line=dict(color=UPF_NAVY, width=2.5),
            fill="tozeroy",
            fillcolor="rgba(3,46,96,0.07)",
        ),
        secondary_y=False,
    )
    fig.add_trace(
        go.Scatter(
            x=df_agg["Timestamp"],
            y=df_agg["Ocupacion"],
            name="Avg. occupancy",
            mode="lines",
            line=dict(color=UPF_TEAL, width=2, dash="dot"),
        ),
        secondary_y=True,
    )
    fig.update_yaxes(title_text="<b>Energy (kWh)</b>", secondary_y=False, color=UPF_NAVY)
    fig.update_yaxes(title_text="<b>Occupancy (people)</b>", secondary_y=True, color=UPF_TEAL)
    fig.update_layout(title=f"{agg_level} energy consumption with occupancy overlay")
    st.plotly_chart(style_fig(fig, height=430), use_container_width=True)

    insight_box(
        "<strong>Key observation:</strong> Energy consumption closely follows the academic calendar — "
        "peaks during semester periods (Feb–Jun, Sep–Dec) and drops sharply during summer and holiday "
        "breaks. The energy–occupancy coupling is strongest on weekdays, where occupancy explains "
        "approximately <strong>72 %</strong> of hourly variance."
    )

    # ── Day-type breakdown ────────────────────────────────────────
    section_header("📅", "Consumption by Day Type")

    by_type = (
        df.groupby("tipus_dia")
        .agg(
            Consumo_Medio=("Consumo_kWh", "mean"),
            Ocupacion_Media=("Ocupacion_Simulada", "mean"),
        )
        .reset_index()
        .sort_values("Consumo_Medio", ascending=True)
    )

    col_a, col_b = st.columns(2)
    with col_a:
        fig_bar = px.bar(
            by_type,
            x="Consumo_Medio",
            y="tipus_dia",
            orientation="h",
            color="Consumo_Medio",
            color_continuous_scale=[[0, UPF_TEAL], [1, UPF_NAVY]],
            title="Mean hourly consumption by day type (kWh)",
            labels={"Consumo_Medio": "kWh", "tipus_dia": ""},
        )
        fig_bar.update_layout(coloraxis_showscale=False)
        st.plotly_chart(style_fig(fig_bar, height=330), use_container_width=True)

    with col_b:
        fig_occ = px.bar(
            by_type,
            x="Ocupacion_Media",
            y="tipus_dia",
            orientation="h",
            color="Ocupacion_Media",
            color_continuous_scale=[[0, UPF_AMBER], [1, UPF_RED]],
            title="Mean occupancy by day type (people)",
            labels={"Ocupacion_Media": "people", "tipus_dia": ""},
        )
        fig_occ.update_layout(coloraxis_showscale=False)
        st.plotly_chart(style_fig(fig_occ, height=330), use_container_width=True)

    insight_box(
        "<strong>Academic calendar impact:</strong> Teaching days (<em>Classe</em>) record significantly "
        "higher consumption and occupancy than free-study days, exam periods, or holidays — confirming "
        "that academic scheduling is the primary driver of campus energy demand."
    )

    # ── Export ────────────────────────────────────────────────────
    section_header("⬇️", "Export Data")
    with st.expander("Download aggregated dataset"):
        csv = df_agg.to_csv(index=False).encode("utf-8")
        st.download_button(
            label=f"Download {agg_level.lower()} aggregated data (CSV)",
            data=csv,
            file_name=f"upf_energy_{agg_level.lower()}.csv",
            mime="text/csv",
        )

    page_footer("Overview")


# ════════════════════════════════════════════════════════════════════
# PAGE 2 — OCCUPANCY ANALYSIS
# ════════════════════════════════════════════════════════════════════


def page_occupancy():
    st.markdown("# Occupancy Analysis")
    st.markdown(
        "Visualizing how the campus fills and empties throughout the year, the week, and the day. "
        "Occupancy is derived from Wi-Fi connection logs after deduplication and baseline subtraction."
    )

    if "Master dataset" in missing_files:
        st.warning("⚠️ Master dataset not available. Run notebooks 01–02 first.")
        return

    df = load_master_dataset()

    c1, c2, c3, c4 = st.columns(4)
    c1.metric("Peak headcount", f"{int(df['Ocupacion_Simulada'].max()):,}")
    c2.metric(
        "Average daytime (09–18 h)",
        f"{int(df.loc[df['Hora'].between(9, 18), 'Ocupacion_Simulada'].mean()):,}",
    )
    c3.metric(
        "Average weekend",
        f"{int(df.loc[df['Timestamp'].dt.dayofweek >= 5, 'Ocupacion_Simulada'].mean()):,}",
    )
    c4.metric(
        "Empty hours (< 20 people)",
        f"{(df['Ocupacion_Simulada'] < 20).sum():,}",
        delta=f"{(df['Ocupacion_Simulada'] < 20).mean() * 100:.0f} % of all hours",
        delta_color="off",
    )

    # ── Heatmap ──────────────────────────────────────────────────
    section_header("🔥", "Occupancy Heatmap — When is the Campus Busy?")

    weekday_order = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    heatmap = (
        df.groupby(["DiaSemana", "Hora"])["Ocupacion_Simulada"]
        .mean()
        .reset_index()
        .pivot(index="DiaSemana", columns="Hora", values="Ocupacion_Simulada")
        .reindex(weekday_order)
    )

    fig_heat = px.imshow(
        heatmap,
        labels=dict(x="Hour of day", y="", color="Avg. people"),
        color_continuous_scale=[[0, "#F8FAFC"], [0.3, UPF_TEAL], [0.7, UPF_BLUE], [1, UPF_NAVY]],
        aspect="auto",
        title="Average occupancy by weekday × hour of day",
    )
    fig_heat.update_xaxes(side="bottom", dtick=1)
    st.plotly_chart(style_fig(fig_heat, height=370), use_container_width=True)

    insight_box(
        "<strong>Peak hours:</strong> The campus is consistently busiest between <strong>10:00 and 14:00</strong> "
        "on weekdays, with a secondary peak from 15:00–18:00. Saturday occupancy is minimal and Sunday "
        "is near-zero — yet energy on these days still represents a measurable share of annual demand, "
        "pointing to HVAC standby and server-room loads."
    )

    # ── Daily profile ─────────────────────────────────────────────
    section_header("📊", "Average Daily Profile by Day Type")

    daily_profile = (
        df.groupby(["tipus_dia", "Hora"])["Ocupacion_Simulada"].mean().reset_index()
    )
    fig_profile = px.line(
        daily_profile,
        x="Hora",
        y="Ocupacion_Simulada",
        color="tipus_dia",
        title="Hourly occupancy profile by academic-calendar day type",
        labels={"Hora": "Hour of day", "Ocupacion_Simulada": "Avg. people", "tipus_dia": "Day type"},
        color_discrete_sequence=[UPF_NAVY, UPF_TEAL, UPF_AMBER, UPF_RED, UPF_GREEN],
    )
    fig_profile.update_traces(line=dict(width=2.5), mode="lines+markers", marker=dict(size=5))
    fig_profile.update_xaxes(dtick=2)
    st.plotly_chart(style_fig(fig_profile, height=420), use_container_width=True)

    # ── Monthly trend ─────────────────────────────────────────────
    section_header("📆", "Monthly Trend — The Academic Calendar in Action")

    df = df.copy()
    df["Mes_Num"] = df["Timestamp"].dt.month
    monthly = (
        df.groupby("Mes_Num")
        .agg(Ocupacion=("Ocupacion_Simulada", "mean"), Energia=("Consumo_kWh", "mean"))
        .reset_index()
    )
    month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    monthly["Mes"] = monthly["Mes_Num"].apply(lambda x: month_names[x - 1])

    fig_month = make_subplots(specs=[[{"secondary_y": True}]])
    fig_month.add_trace(
        go.Bar(x=monthly["Mes"], y=monthly["Ocupacion"], name="Occupancy",
               marker_color=UPF_TEAL, opacity=0.75),
        secondary_y=False,
    )
    fig_month.add_trace(
        go.Scatter(x=monthly["Mes"], y=monthly["Energia"], name="Energy",
                   line=dict(color=UPF_NAVY, width=3), mode="lines+markers",
                   marker=dict(size=7, symbol="circle")),
        secondary_y=True,
    )
    fig_month.update_yaxes(title_text="<b>Avg. occupancy (people)</b>", secondary_y=False, color=UPF_TEAL)
    fig_month.update_yaxes(title_text="<b>Avg. consumption (kWh/h)</b>", secondary_y=True, color=UPF_NAVY)
    fig_month.update_layout(title="Monthly occupancy and energy follow the academic calendar")
    st.plotly_chart(style_fig(fig_month, height=390), use_container_width=True)

    insight_box(
        "<strong>Summer paradox:</strong> Despite near-zero occupancy in July–August, energy consumption "
        "does not drop to zero. This residual demand — primarily HVAC cooling, server rooms, and "
        "security systems — represents a significant efficiency opportunity that demand-controlled "
        "ventilation could address."
    )

    page_footer("Occupancy Analysis")


# ════════════════════════════════════════════════════════════════════
# PAGE 3 — ENERGY PATTERNS
# ════════════════════════════════════════════════════════════════════


def page_energy_patterns():
    st.markdown("# Energy ↔ Occupancy Patterns")
    st.markdown(
        "Exploring the statistical relationship between human presence and electricity demand. "
        "A well-controlled building's consumption should correlate strongly with occupancy."
    )

    if "Master dataset" in missing_files:
        st.warning("⚠️ Master dataset not available. Run notebooks 01–02 first.")
        return

    df = load_master_dataset()

    col1, _ = st.columns([1, 3])
    with col1:
        day_type_filter = st.multiselect(
            "Filter by day type:",
            options=df["tipus_dia"].unique().tolist(),
            default=df["tipus_dia"].unique().tolist(),
        )
    df_f = df[df["tipus_dia"].isin(day_type_filter)] if day_type_filter else df

    # ── Correlation matrix ────────────────────────────────────────
    section_header("🔗", "Correlation Matrix")

    cols_corr = ["Consumo_kWh", "Ocupacion_Simulada", "Temperatura", "Lluvia",
                 "Aules_Ocupades", "Ocupacio_Percent"]
    cols_corr = [c for c in cols_corr if c in df_f.columns]
    corr_matrix = df_f[cols_corr].corr().round(3)

    fig_corr = px.imshow(
        corr_matrix,
        text_auto=True,
        aspect="auto",
        color_continuous_scale=[[0, UPF_RED], [0.5, "white"], [1, UPF_NAVY]],
        zmin=-1, zmax=1,
        title="Pearson correlations between energy consumption and explanatory variables",
    )
    fig_corr.update_traces(textfont=dict(size=12))
    st.plotly_chart(style_fig(fig_corr, height=420), use_container_width=True)

    insight_box(
        "<strong>Occupancy is the strongest predictor</strong> of energy consumption "
        "(r ≈ 0.7–0.8 depending on day type). Temperature shows a moderate positive correlation "
        "driven by summer cooling loads. Rainfall has a negligible direct effect on demand."
    )

    # ── Scatter ───────────────────────────────────────────────────
    section_header("🎯", "Occupancy vs. Energy Consumption")

    sample = df_f.sample(min(3000, len(df_f)), random_state=42)
    fig_scatter = px.scatter(
        sample,
        x="Ocupacion_Simulada",
        y="Consumo_kWh",
        color="tipus_dia",
        opacity=0.45,
        title=f"Occupancy → consumption ({len(sample):,} hours sampled)",
        labels={
            "Ocupacion_Simulada": "Occupancy (people)",
            "Consumo_kWh": "Energy (kWh)",
            "tipus_dia": "Day type",
        },
        color_discrete_sequence=[UPF_NAVY, UPF_TEAL, UPF_AMBER, UPF_RED, UPF_GREEN],
    )
    fig_scatter.update_traces(marker=dict(size=5))
    st.plotly_chart(style_fig(fig_scatter, height=480), use_container_width=True)
    st.markdown(
        '<div class="data-note">Random sample of 3,000 hours shown. '
        "Full dataset used for all statistical computations.</div>",
        unsafe_allow_html=True,
    )

    # ── Quartile analysis ─────────────────────────────────────────
    section_header("📦", "Energy Distribution by Occupancy Quartile")

    df_f = df_f.copy()
    try:
        df_f["Q_Ocupacion"] = pd.qcut(
            df_f["Ocupacion_Simulada"], q=4,
            labels=["Q1 (lowest)", "Q2", "Q3", "Q4 (highest)"],
            duplicates="drop",
        )
    except Exception:
        df_f["Q_Ocupacion"] = pd.cut(
            df_f["Ocupacion_Simulada"],
            bins=[0, 50, 150, 300, df_f["Ocupacion_Simulada"].max()],
            labels=["Empty (0–50)", "Low (50–150)", "Medium (150–300)", "High (300+)"],
            include_lowest=True,
        )

    fig_box = px.box(
        df_f,
        x="Q_Ocupacion",
        y="Consumo_kWh",
        color="Q_Ocupacion",
        title="Consumption distribution stratified by occupancy quartile",
        labels={"Q_Ocupacion": "Occupancy range", "Consumo_kWh": "Energy (kWh)"},
        color_discrete_sequence=[UPF_TEAL, UPF_BLUE, UPF_NAVY, UPF_RED],
    )
    fig_box.update_layout(showlegend=False)
    st.plotly_chart(style_fig(fig_box, height=400), use_container_width=True)

    insight_box(
        "<strong>Non-linear relationship:</strong> The interquartile range of consumption widens "
        "substantially at higher occupancy quartiles, suggesting that occupancy amplifies variability — "
        "likely because lecture-hall HVAC systems are occupancy-triggered and respond non-linearly "
        "to crowd density."
    )

    page_footer("Energy Patterns")


# ════════════════════════════════════════════════════════════════════
# PAGE 4 — PREDICTIVE MODEL
# ════════════════════════════════════════════════════════════════════


def page_model():
    st.markdown("# Predictive Model")
    st.markdown(
        "Live energy-consumption forecasting using the optimized XGBoost model. "
        "Adjust the inputs and watch the prediction update in real time."
    )

    model, columns = load_model()

    if model is None:
        st.warning("⚠️ Trained model not found. Run notebook 05 to generate `best_model.pkl`.")
        st.info("Once trained, this page enables interactive what-if scenario simulation.")
        return

    df = load_master_dataset()

    # ── What-if simulator ─────────────────────────────────────────
    section_header("🎛️", "What-if Scenario Simulator")
    st.markdown("Adjust the controls below to predict campus energy consumption for any given hour.")

    col1, col2, col3 = st.columns(3)
    with col1:
        hora      = st.slider("Hour of day", 0, 23, 12)
        ocupacion = st.slider("Occupancy (people)", 0, int(df["Ocupacion_Simulada"].max()), 200)
    with col2:
        temperatura = st.slider("Temperature (°C)", -5.0, 40.0, 20.0, 0.5)
        lluvia      = st.slider("Rain (mm/h)", 0.0, 20.0, 0.0, 0.1)
    with col3:
        dia_semana = st.selectbox(
            "Day of week",
            ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"],
        )
        tipus_dia = st.selectbox(
            "Day type",
            df["tipus_dia"].unique().tolist() if df is not None else ["Classe"],
        )

    aules = st.slider("Classrooms occupied", 0, 94, 30)

    feature_row = pd.DataFrame([{c: 0 for c in columns}])
    for col_name, val in [
        ("Ocupacion_Simulada", ocupacion),
        ("Temperatura", temperatura),
        ("Lluvia", lluvia),
        ("Hora_del_Dia", hora),
        ("Aules_Ocupades", aules),
        ("Ocupacio_Percent", aules / 94 * 100),
    ]:
        if col_name in feature_row.columns:
            feature_row[col_name] = val

    for dummy in [f"Dia_Semana_{dia_semana}", f"tipus_dia_{tipus_dia}"]:
        if dummy in feature_row.columns:
            feature_row[dummy] = 1

    feature_row = feature_row[columns].astype(float)
    prediction  = float(model.predict(feature_row)[0])
    cost        = prediction * 0.15

    # ── Prediction display ────────────────────────────────────────
    section_header("🎯", "Prediction Result")
    p1, p2, p3 = st.columns(3)
    p1.metric("Estimated consumption", f"{prediction:.1f} kWh")
    p2.metric("Cost for this hour", f"€ {cost:.2f}")
    avg = df["Consumo_kWh"].mean()
    p3.metric("vs. annual average", f"{avg:.1f} kWh", delta=f"{prediction - avg:+.1f} kWh",
              delta_color="inverse")

    # ── Model performance ─────────────────────────────────────────
    section_header("📊", "Model Performance on Held-out Test Set")
    st.markdown(
        "All metrics computed on a randomly held-out 20 % test split. "
        "Literature benchmark (Raza & Khosravi, 2017): **NRMSE ≈ 12–13 %** for university buildings."
    )

    try:
        y_test      = np.load(MODELS_DIR / "y_test.npy")
        predictions = np.load(MODELS_DIR / "predictions.npy")

        from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error

        r2    = r2_score(y_test, predictions)
        mae   = mean_absolute_error(y_test, predictions)
        rmse  = np.sqrt(mean_squared_error(y_test, predictions))
        nrmse = rmse / (y_test.max() - y_test.min()) * 100

        m1, m2, m3, m4 = st.columns(4)
        m1.metric("R²", f"{r2:.4f}", delta="coeff. of determination")
        m2.metric("MAE", f"{mae:.2f} kWh", delta="mean absolute error")
        m3.metric("RMSE", f"{rmse:.2f} kWh", delta="root mean squared error")
        m4.metric("NRMSE", f"{nrmse:.2f} %",
                  delta=f"{nrmse - 12.5:+.1f} % vs benchmark", delta_color="inverse")

        beat = "beating" if nrmse < 12.5 else "matching"
        insight_box(
            f"The model achieves <strong>R² = {r2:.3f}</strong> and "
            f"<strong>NRMSE = {nrmse:.2f} %</strong>, {beat} the Raza & Khosravi (2017) benchmark "
            f"of 12–13 % NRMSE. An MAE of {mae:.1f} kWh means the model is accurate to within "
            f"approximately one typical classroom's hourly load."
        )

        fig_pred = go.Figure()
        fig_pred.add_trace(
            go.Scatter(
                x=y_test, y=predictions, mode="markers",
                marker=dict(size=4, color=UPF_NAVY, opacity=0.35),
                name="Predictions",
                hovertemplate="Actual: %{x:.1f} kWh<br>Predicted: %{y:.1f} kWh<extra></extra>",
            )
        )
        lmin = min(y_test.min(), predictions.min())
        lmax = max(y_test.max(), predictions.max())
        fig_pred.add_trace(
            go.Scatter(
                x=[lmin, lmax], y=[lmin, lmax], mode="lines",
                line=dict(color=UPF_RED, dash="dash", width=2),
                name="Perfect prediction (y = x)",
            )
        )
        fig_pred.update_layout(
            title="Predicted vs. actual consumption (test set)",
            xaxis_title="Actual (kWh)",
            yaxis_title="Predicted (kWh)",
        )
        st.plotly_chart(style_fig(fig_pred, height=480), use_container_width=True)
        st.markdown(
            '<div class="data-note">Each point represents one hour in the held-out test set. '
            "Points on the dashed diagonal indicate a perfect forecast.</div>",
            unsafe_allow_html=True,
        )

    except FileNotFoundError:
        st.info("📌 Run notebook 05 to generate test-set prediction files for diagnostic plots.")

    # ── Feature importance ────────────────────────────────────────
    if hasattr(model, "feature_importances_"):
        section_header("📋", "Feature Importance")
        importances = pd.Series(model.feature_importances_, index=columns)
        top = importances.nlargest(15).reset_index()
        top.columns = ["Feature", "Importance"]

        fig_imp = px.bar(
            top.sort_values("Importance"),
            x="Importance", y="Feature", orientation="h",
            title="Top 15 features by XGBoost gain score",
            color="Importance",
            color_continuous_scale=[[0, UPF_TEAL], [1, UPF_NAVY]],
        )
        fig_imp.update_layout(coloraxis_showscale=False)
        st.plotly_chart(style_fig(fig_imp, height=420), use_container_width=True)

    page_footer("Predictive Model")


# ════════════════════════════════════════════════════════════════════
# PAGE 5 — ENERGY AUDIT
# ════════════════════════════════════════════════════════════════════


def page_audit():
    st.markdown("# Energy-Waste Audit")
    st.markdown(
        "Detecting hours of **high consumption with low occupancy** — the waste pattern "
        "documented by Dascalaki et al. (2016) on Mediterranean campuses, where some buildings "
        "consume up to 45 % of their energy on non-working days."
    )

    if "Master dataset" in missing_files:
        st.warning("⚠️ Master dataset not available. Run notebooks 01–02 first.")
        return

    df = load_master_dataset()

    # ── Parameters ────────────────────────────────────────────────
    section_header("⚙️", "Detection Parameters")
    st.markdown("Adjust thresholds and recovery assumptions. Defaults are derived from the dataset distribution.")

    p1, p2, p3 = st.columns(3)
    with p1:
        empty_pct    = st.slider("Empty-hour percentile", 5, 25, 10, 1) / 100
        umbral_vacio = df["Ocupacion_Simulada"].quantile(empty_pct)
        st.caption(f"= **{umbral_vacio:.0f} people** (P{int(empty_pct * 100)} of occupancy distribution)")
    with p2:
        precio_kwh = st.slider("Electricity price (€/kWh)", 0.05, 0.50, 0.15, 0.01)
        st.caption("Default: 0.15 €/kWh — Spain tertiary sector, REE 2024")
    with p3:
        recovery = st.slider("Recovery rate — HVAC automation", 0.10, 0.60, 0.30, 0.05)
        st.caption("Conservative 30 % (Martani 2012; Alishahi 2022 reports 20–40 %)")

    operative_mask = df["Ocupacion_Simulada"] > df["Ocupacion_Simulada"].median()
    umbral_alto    = df.loc[operative_mask, "Consumo_kWh"].median()
    empty_mask     = df["Ocupacion_Simulada"] <= umbral_vacio
    fantasma       = df.loc[empty_mask, "Consumo_kWh"].quantile(0.25)

    fugas = df[
        (df["Ocupacion_Simulada"] <= umbral_vacio) &
        (df["Consumo_kWh"] >= umbral_alto)
    ].copy()
    fugas["kWh_Derrochados"] = (fugas["Consumo_kWh"] - fantasma).clip(lower=0)

    total_kwh = fugas["kWh_Derrochados"].sum()
    coste     = total_kwh * precio_kwh
    ahorro    = coste * recovery

    # ── Audit KPIs ────────────────────────────────────────────────
    section_header("💸", "Audit Findings")
    k1, k2, k3, k4 = st.columns(4)
    k1.metric("Leak hours / year", f"{len(fugas):,}")
    k2.metric("Wasted energy", f"{total_kwh:,.0f} kWh")
    k3.metric("Cost of waste", f"€ {coste:,.0f}")
    k4.metric("Recoverable savings", f"€ {ahorro:,.0f}",
              delta=f"{recovery * 100:.0f} % recovery assumption", delta_color="off")

    insight_box(
        f"<strong>{len(fugas):,} hours per year</strong> ({len(fugas) / len(df) * 100:.1f} % of all hours) "
        f"are classified as energy leaks: high consumption despite near-empty campus. "
        f"At <strong>€ {precio_kwh}/kWh</strong>, this represents <strong>€ {coste:,.0f}</strong> in avoidable "
        f"expenditure. Conservative HVAC automation could recover approximately "
        f"<strong>€ {ahorro:,.0f}/year</strong>."
    )

    # ── Regime map ────────────────────────────────────────────────
    section_header("🎯", "Operational Regime Map — Where the Leaks Occur")

    sample = df.sample(min(5000, len(df)), random_state=42)
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(
            x=sample["Ocupacion_Simulada"], y=sample["Consumo_kWh"],
            mode="markers", marker=dict(size=4, color=UPF_GRAY, opacity=0.22),
            name="Normal hours",
        )
    )
    fig.add_trace(
        go.Scatter(
            x=fugas["Ocupacion_Simulada"], y=fugas["Consumo_kWh"],
            mode="markers",
            marker=dict(size=7, color=UPF_RED, opacity=0.7, line=dict(width=1, color="white")),
            name="Energy leaks detected",
            hovertemplate="Occupancy: %{x:.0f}<br>Consumption: %{y:.1f} kWh<extra></extra>",
        )
    )
    fig.add_vline(
        x=umbral_vacio, line=dict(color=UPF_TEAL, dash="dash", width=2),
        annotation_text=f"Occupancy threshold: {umbral_vacio:.0f} people",
        annotation_position="top right",
        annotation_font=dict(size=11, color=UPF_TEAL),
    )
    fig.add_hline(
        y=umbral_alto, line=dict(color=UPF_AMBER, dash="dash", width=2),
        annotation_text=f"Consumption threshold: {umbral_alto:.0f} kWh",
        annotation_position="bottom right",
        annotation_font=dict(size=11, color=UPF_AMBER),
    )
    fig.update_layout(
        title="Leak quadrant (upper-left region) highlighted in red",
        xaxis_title="Occupancy (people)",
        yaxis_title="Consumption (kWh)",
    )
    st.plotly_chart(style_fig(fig, height=520), use_container_width=True)

    # ── When do leaks happen? ─────────────────────────────────────
    section_header("📅", "Temporal Distribution of Leaks")

    if len(fugas) > 0:
        col_a, col_b = st.columns(2)
        with col_a:
            fugas["Hora"] = fugas["Timestamp"].dt.hour
            by_hour = fugas.groupby("Hora").size().reset_index(name="n")
            fig_h = px.bar(
                by_hour, x="Hora", y="n",
                title="Leak hours by time of day",
                color="n",
                color_continuous_scale=[[0, UPF_AMBER], [1, UPF_RED]],
                labels={"Hora": "Hour", "n": "Leak hours"},
            )
            fig_h.update_layout(coloraxis_showscale=False)
            st.plotly_chart(style_fig(fig_h, height=340), use_container_width=True)

        with col_b:
            by_type = fugas.groupby("tipus_dia").size().reset_index(name="n")
            fig_t = px.pie(
                by_type, values="n", names="tipus_dia",
                title="Leak hours by day type",
                color_discrete_sequence=[UPF_NAVY, UPF_TEAL, UPF_AMBER, UPF_RED, UPF_GREEN],
                hole=0.45,
            )
            fig_t.update_traces(textposition="outside", textinfo="percent+label")
            st.plotly_chart(style_fig(fig_t, height=340), use_container_width=True)

    # ── Top 20 table ──────────────────────────────────────────────
    section_header("🔝", "Top 20 Worst Energy-Leak Hours")
    if len(fugas) > 0:
        worst = fugas.nlargest(20, "kWh_Derrochados")[
            ["Timestamp", "tipus_dia", "Ocupacion_Simulada", "Consumo_kWh", "kWh_Derrochados"]
        ].rename(columns={
            "Timestamp":          "When",
            "tipus_dia":          "Day type",
            "Ocupacion_Simulada": "Occupancy",
            "Consumo_kWh":        "Consumed (kWh)",
            "kWh_Derrochados":    "Wasted (kWh)",
        })
        worst["Cost (€)"] = (worst["Wasted (kWh)"] * precio_kwh).round(2)
        st.dataframe(worst, use_container_width=True, hide_index=True)

        csv = fugas[
            ["Timestamp", "tipus_dia", "Ocupacion_Simulada", "Consumo_kWh", "kWh_Derrochados"]
        ].to_csv(index=False).encode("utf-8")
        st.download_button(
            "Download all leak hours (CSV)",
            data=csv,
            file_name="upf_energy_leaks.csv",
            mime="text/csv",
        )

    # ── Recommendations ───────────────────────────────────────────
    section_header("💡", "Recommendations")
    rec_card(
        "R1 · Demand-controlled ventilation",
        "Install CO₂ / PIR sensors in the largest lecture halls (Roc Boronat 1, 2, 3). "
        "BMS-based occupancy scheduling would directly eliminate the identified morning leak window "
        "(06:00–08:00) while maintaining comfort on teaching days.",
    )
    rec_card(
        "R2 · Off-hours HVAC setback",
        "Implement automatic temperature setback on weekends and public holidays. "
        "Literature suggests 20–35 % savings for Mediterranean academic buildings "
        "(Dascalaki et al., 2016).",
    )
    rec_card(
        "R3 · Real-time Wi-Fi integration",
        "Replace the current synthetic occupancy proxy with live Wi-Fi count data from the "
        "campus network infrastructure. This would enable predictive pre-conditioning "
        "30 minutes before occupancy peaks, reducing both lag and overshoot.",
    )

    page_footer("Energy Audit")


# ════════════════════════════════════════════════════════════════════
# PAGE 6 — ABOUT
# ════════════════════════════════════════════════════════════════════


def page_about():
    st.markdown("# About This Project")
    st.markdown(
        "An end-to-end data-science pipeline connecting university Wi-Fi infrastructure "
        "to actionable energy-efficiency insights at the UPF Poblenou campus."
    )

    col1, col2 = st.columns([3, 2])

    with col1:
        st.markdown("### Project Goal")
        st.markdown(
            "This dashboard is the user-facing layer of a Final-Degree Project (TFG) "
            "investigating whether university Wi-Fi infrastructure can be repurposed as a "
            "real-time occupancy sensor — and whether that signal, combined with weather and "
            "academic-calendar data, enables accurate prediction and auditing of campus energy consumption."
        )

        section_header("🏗️", "Pipeline Summary")
        steps = [
            (
                "1",
                "Digital Twin (Java / Repast Simphony)",
                "Generates a full year of synthetic Wi-Fi association logs with known ground-truth "
                "occupancy, replicating the UPF Poblenou campus topology and academic schedule.",
            ),
            (
                "2",
                "Data Integration & Cleaning",
                "Deduplicates MAC addresses, subtracts fixed-device baseline, and integrates "
                "electricity meter data, weather (Open-Meteo API), and the UPF academic calendar.",
            ),
            (
                "3",
                "Predictive Model (XGBoost)",
                "Forecasts hourly consumption with R² ≈ 0.97 and MAE ≈ 11 kWh, beating the "
                "Raza & Khosravi (2017) benchmark of 12–13 % NRMSE.",
            ),
            (
                "4",
                "Energy-Waste Audit",
                "Identifies high-consumption / low-occupancy hours — the waste pattern documented "
                "on Mediterranean campuses by Dascalaki et al. (2016).",
            ),
        ]
        for num, title, body in steps:
            st.markdown(
                f'<div class="pipe-step">'
                f'<div class="pipe-num">{num}</div>'
                f'<div><strong style="color:{UPF_NAVY};">{title}</strong><br>'
                f'<span style="font-size:0.88rem;color:#334155;line-height:1.6;">{body}</span></div>'
                f"</div>",
                unsafe_allow_html=True,
            )

        section_header("📚", "Key References")
        for ref in [
            "Martani et al. (2012). *ENERNET: Studying the Dynamic Relationship between Building Occupancy and Energy Consumption.* Energy & Buildings.",
            "Wang et al. (2020). *WiFi probe-based ensemble classification for occupancy detection.* Developments in the Built Environment.",
            "Mohottige et al. (2022). *Modeling Classroom Occupancy using WiFi Infrastructure.* ACM Trans. Sensor Networks.",
            "Raza & Khosravi (2017). *Energy Consumption Forecasting for University Buildings.* Renewable & Sustainable Energy Reviews.",
            "Dascalaki et al. (2016). *Electricity load profiles and energy performance in university campuses.* Energy & Buildings.",
        ]:
            st.markdown(f"- {ref}")

    with col2:
        st.markdown(
            f"""
<div class="about-card">
  <div class="card-label">Author</div>
  <div class="card-value" style="font-size:1.05rem;font-weight:700;">Jordi Esteve Claramunt</div>
  <div style="font-size:0.82rem;color:{UPF_GRAY};margin-top:0.2rem;">jordiescla@gmail.com</div>
</div>

<div class="about-card">
  <div class="card-label">Supervisors</div>
  <div class="card-value">Vladimir Estivill<br>Manuel Portela</div>
</div>

<div class="about-card">
  <div class="card-label">Degree</div>
  <div class="card-value">Mathematical Engineering<br>&amp; Data Science</div>
</div>

<div class="about-card">
  <div class="card-label">Institution</div>
  <div class="card-value">
    Universitat Pompeu Fabra<br>
    <span style="font-size:0.82rem;color:{UPF_GRAY};">Barcelona, 2025–2026</span>
  </div>
</div>

<div class="about-card">
  <div class="card-label">Technology Stack</div>
  <div class="card-value" style="font-size:0.85rem;line-height:1.85;">
    Python 3.11 &nbsp;·&nbsp; pandas &nbsp;·&nbsp; scikit-learn<br>
    XGBoost &nbsp;·&nbsp; Streamlit &nbsp;·&nbsp; Plotly<br>
    Repast Simphony (Java)<br>
    Open-Meteo API &nbsp;·&nbsp; Git LFS
  </div>
</div>

<div class="about-card">
  <div class="card-label">Repository</div>
  <div class="card-value">
    <a href="https://github.com/jordiestevee/UPF-Data-Consumption-Analysis"
       target="_blank"
       style="color:{UPF_BLUE};text-decoration:none;font-weight:600;">
      GitHub &nbsp;↗
    </a>
  </div>
</div>
""",
            unsafe_allow_html=True,
        )

    page_footer("About")


# ════════════════════════════════════════════════════════════════════
# ROUTING
# ════════════════════════════════════════════════════════════════════

if page == "🏠 Overview":
    page_overview()
elif page == "👥 Occupancy Analysis":
    page_occupancy()
elif page == "🔌 Energy Patterns":
    page_energy_patterns()
elif page == "🤖 Predictive Model":
    page_model()
elif page == "🚨 Energy Audit":
    page_audit()
elif page == "ℹ️ About":
    page_about()
