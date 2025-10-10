import streamlit as st
import json
import os
from datetime import date, time, datetime

DEFAULTS_FILE = "user_defaults.json"

def save_user_defaults(defaults):
    with open(DEFAULTS_FILE, "w") as f:
        json.dump(defaults, f, indent=2, default=str)

def load_user_defaults():
    if os.path.exists(DEFAULTS_FILE):
        with open(DEFAULTS_FILE, "r") as f:
            return json.load(f)
    return {}

st.set_page_config(page_title="Set Analysis Defaults", layout="wide")
st.title("Set Default Settings for Analysis")

existing_defaults = load_user_defaults()

st.subheader("Date Offsets (relative to uploaded data)")
start_offset_days = st.number_input("Default Start Date Offset (days)", 
                                    value=existing_defaults.get("start_offset_days", 0), step=1)
end_offset_days = st.number_input("Default End Date Offset (days)", 
                                  value=existing_defaults.get("end_offset_days", 0), step=1)

st.subheader("Fallback Dates (used if no file is uploaded)")

# Convert string dates back to date objects
default_start = existing_defaults.get("start_date", "2024-01-01")
if isinstance(default_start, str):
    default_start = datetime.strptime(default_start, "%Y-%m-%d").date()

default_end = existing_defaults.get("end_date", "2024-01-31")
if isinstance(default_end, str):
    default_end = datetime.strptime(default_end, "%Y-%m-%d").date()

start_date = st.date_input("Fallback LD Start Date", value=default_start)
end_date = st.date_input("Fallback LD End Date", value=default_end)

st.subheader("DAM System Defaults")
frequency = st.number_input("DAM Frequency (min)", value=existing_defaults.get("frequency", 1), min_value=1)
threshold = st.number_input("Count Threshold", value=existing_defaults.get("threshold", 100), min_value=1)
default_light = existing_defaults.get("light_onset", "06:00")
if isinstance(default_light, str):
    default_light = datetime.strptime(default_light, "%H:%M").time()

light_onset = st.time_input("Light Onset Time", value=default_light)

if st.button("Save Defaults"):
    defaults = {
        "start_offset_days": start_offset_days,
        "end_offset_days": end_offset_days,
        "start_date": start_date.strftime("%Y-%m-%d"),
        "end_date": end_date.strftime("%Y-%m-%d"),
        "frequency": frequency,
        "threshold": threshold,
        "light_onset": light_onset.strftime("%H:%M")
    }
    save_user_defaults(defaults)
    st.success("Defaults saved.")
