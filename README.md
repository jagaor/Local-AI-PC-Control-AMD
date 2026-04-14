# 🚀 Local AI PC Controller (AMD GPU Optimized) 🤖

Este proyecto es un ecosistema de **Inteligencia Artificial 100% privado y local**. Permite chatear con modelos avanzados y otorgarle "manos" a la IA para ejecutar acciones reales en Windows (gestión de archivos, carpetas y sistema) mediante lenguaje natural.

Está optimizado específicamente para GPUs **AMD Radeon (Serie RX 6000/7000)**, solucionando los problemas de compatibilidad y lentitud comunes en Windows al forzar el motor gráfico **Vulkan**.

---

## 🌟 Características Principales

- **Privacidad Total:** Los datos nunca salen de tu máquina. Sin cuotas ni suscripciones.
- **Aceleración por GPU AMD:** Configurado para usar **Vulkan**, logrando respuestas instantáneas en hardware Radeon (probado en RX 6650 XT).
- **Control del Sistema:** Capacidad para crear, mover y listar archivos mediante comandos de PowerShell integrados.
- **Automatización:** Un solo script `.bat` para levantar todo el stack tecnológico.

---

## 🛠️ Stack Tecnológico

| Componente | Herramienta |
| :--- | :--- |
| **Motor de IA** | [Ollama](https://ollama.com/) |
| **Modelo (LLM)** | `Qwen2.5-Coder 7B` (Optimizado para 8GB VRAM) |
| **Interfaz Web** | [Open WebUI](https://github.com/open-webui/open-webui) |
| **Agente de Terminal** | [Open Interpreter](https://openinterpreter.com/) |
| **Aceleración** | Vulkan API (Esquivando limitaciones de ROCm en Windows) |

---


## 🛡️ Casos de Uso para Ciberseguridad & Sec-Devs

Este entorno permite a profesionales de seguridad realizar tareas críticas sin comprometer la confidencialidad de los datos:

- **Auditoría de Logs Local:** Analiza archivos `.log` masivos buscando patrones de intrusión o anomalías sin exponer datos sensibles a nubes públicas.
- **Revisión de Código Privada:** Escanea scripts, archivos de configuración y binarios en busca de vulnerabilidades o *hardcoded credentials* antes de subirlos a producción.
- **Bastionado de Sistemas (Hardening):** Automatiza el cierre de puertos, revisión de permisos de usuario y auditoría de cuentas activas mediante lenguaje natural.
- **Análisis de Malware en Entornos Aislados:** Utiliza la capacidad de razonamiento del modelo para descifrar fragmentos de código ofuscado o entender el comportamiento de scripts maliciosos sin necesidad de conexión a internet.

---

## 🔧 Solución Técnica para AMD en Windows

Para evitar que Ollama ignore la GPU y sature el procesador (CPU), este proyecto inyecta variables de entorno que fuerzan el uso de la API Vulkan. Esto es crítico para tarjetas de la serie 6000:

1. `OLLAMA_VULKAN=1`: Activa el soporte de Vulkan.
2. `HSA_OVERRIDE_GFX_VERSION=10.3.0`: Emula compatibilidad para arquitecturas RDNA2.

---

## 📥 Instalación

### 1. Preparar el Env Virtual (Python)
Ejecuta esto en tu terminal de Windows:
```bash
# Crear entorno virtual
python -m venv oi-env

# Activar entorno
oi-env\Scripts\activate

# Instalar dependencias
pip install open-interpreter open-webui

# Descargar el modelo
ollama pull qwen2.5-coder:7b
```

### 2. Configurar la "Tool" en Open WebUI
Para que la interfaz web pueda ejecutar comandos, añade esta **Herramienta (Tool)** en el panel de Workspace dentro de Open WebUI:

```python
import subprocess

class Tools:
    def ejecutar(self, comando: str) -> str:
        """
        Ejecuta comandos de PowerShell. Úsalo para mkdir, dir, move, etc.
        """
        try:
            process = subprocess.run(
                ["powershell", "-Command", comando],
                capture_output=True, text=True, shell=True
            )
            if process.returncode == 0:
                return process.stdout if process.stdout else "Acción realizada con éxito."
            else:
                return f"Error: {process.stderr}"
        except Exception as e:
            return f"Error técnico: {str(e)}"
```

---

## 🚀 Uso y Automatización

Crea un archivo llamado `Iniciar_IA.bat` en la raíz del proyecto para arrancar todo con un doble clic:

```batch
@echo off
title Centro de Mando IA - AMD
:: Forzar GPU AMD
set OLLAMA_VULKAN=1
set HSA_OVERRIDE_GFX_VERSION=10.3.0

:: Iniciar servidor WebUI
start "WebUI" cmd /c "oi-env\Scripts\activate && open-webui serve"
timeout /t 5

:: Abrir navegador
start http://localhost:8080

:: Iniciar Open Interpreter
start "Terminal IA" cmd /k "oi-env\Scripts\activate && interpreter --model openai/qwen2.5-coder:7b --api_base http://localhost:11434/v1 --api_key ollama"
```

> [!IMPORTANTE]
> **Ejecuta el archivo `.bat` como Administrador.** De lo contrario, Windows denegará el acceso (Access Denied) cuando la IA intente crear carpetas o modificar archivos en el Escritorio.

---

## 🛡️ Notas de Seguridad
Este sistema otorga capacidad de ejecución de código a un modelo de lenguaje (LLM). Se recomienda supervisar las acciones propuestas y no ejecutar el entorno en redes públicas.

---
*Desarrollado para potenciar el uso de IA local en hardware AMD Radeon.*
