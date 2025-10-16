@echo off
echo ===============================================
echo        Fly Sleep Analyzer - Auto Setup & Launch
echo ===============================================
echo.

REM Change to the directory where this script is located
cd /d "%~dp0"
cd ..

REM Check if setup is needed
if not exist "FlySleepAnalyzer" goto :setup
if not exist "FlySleepAnalyzer\.venv\Scripts\activate.bat" goto :setup
if not exist "FlySleepAnalyzer\Home.py" goto :setup

REM Setup exists, go directly to launch
goto :launch

:setup
echo Setting up Fly Sleep Analyzer for first use...
echo.
echo This will:
echo - Check Python installation
echo - Download the project from GitHub
echo - Create virtual environment
echo - Install dependencies
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause > nul
echo.

echo [1/4] Checking Python installation...
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python not found! Please install Python first.
    echo Visit: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)
echo ✓ Python found

echo [2/4] Downloading project...
if exist "FlySleepAnalyzer.zip" del "FlySleepAnalyzer.zip"
if exist "FlySleepAnalyzer" rmdir /s /q "FlySleepAnalyzer"

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/pkerrwall/FlySleepAnalyzer/archive/refs/heads/main.zip' -OutFile 'FlySleepAnalyzer.zip'"
if %errorlevel% neq 0 (
    echo ERROR: Download failed. Check internet connection.
    pause
    exit /b 1
)

echo [3/4] Extracting files...
powershell -Command "Expand-Archive -Path 'FlySleepAnalyzer.zip' -DestinationPath '.' -Force"
if exist "FlySleepAnalyzer-main" rename "FlySleepAnalyzer-main" "FlySleepAnalyzer"
if exist "FlySleepAnalyzer.zip" del "FlySleepAnalyzer.zip"

echo [4/4] Setting up environment...
cd FlySleepAnalyzer
python -m venv .venv
call .venv\Scripts\activate.bat
if exist "requirements.txt" pip install -r requirements.txt

echo.
echo ✓ Setup complete!
echo.

:launch
cd sleep_analysis
echo Activating virtual environment...
call .venv\Scripts\activate.bat

echo.
echo ✓ Environment ready!
echo.
echo Launching Fly Sleep Analyzer...
echo The tool will open in your web browser.
echo Press Ctrl+C to stop the application.
echo.

streamlit run Home.py

echo.
echo Tool stopped. Press any key to exit...
pause > nul