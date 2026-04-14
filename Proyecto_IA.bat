@echo off
setlocal
title Centro de Mando IA Local - AMD Optimizado

:: --- CONFIGURACIÓN DE HARDWARE AMD ---
echo [+] Configurando entorno para GPU AMD (Vulkan)...
set OLLAMA_VULKAN=1
set HSA_OVERRIDE_GFX_VERSION=10.3.0

:: --- RUTA DEL PROYECTO ---
:: Cambia esta ruta si mueves el proyecto de sitio
set "BASE_PATH=C:\Users\javie"
cd /d "%BASE_PATH%"

echo.
echo [!] Comprobando privilegios de administrador...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Ejecutando con permisos de Administrador.
) else (
    echo [ADVERTENCIA] No tienes permisos de administrador. 
    echo Algunas tareas de gestion de archivos podrian fallar.
)

echo.
echo [+] Iniciando Servidor Open WebUI (Puerto 8080)...
start "Servidor WebUI" cmd /c "oi-env\Scripts\activate && open-webui serve"

echo [+] Esperando que el servidor responda...
timeout /t 5 /nobreak > NUL

echo [+] Abriendo interfaz en el navegador...
start http://localhost:8080

echo.
echo [+] Iniciando Open Interpreter en terminal...
:: Lanzamos OI configurado para hablar con Ollama (Qwen 7B)
start "Open Interpreter" cmd /k "oi-env\Scripts\activate && interpreter --model openai/qwen2.5-coder:7b --api_base http://localhost:11434/v1 --api_key ollama"

echo.
echo [LISTO] Todo el ecosistema esta en marcha.
echo [INFO] No cierres las ventanas negras mientras uses la IA.
pause
exit
