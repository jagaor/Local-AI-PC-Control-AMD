# 🚀 Local AI PC Controller (AMD GPU Optimized) 🤖

This project is a **100% private and local AI ecosystem**. It allows you to chat with advanced models and grant "hands" to the AI to perform real actions on Windows (file management, folder organization, and system tasks) using natural language.

It is specifically optimized for **AMD Radeon GPUs (RX 6000/7000 Series)**, solving common compatibility and performance issues on Windows by forcing the **Vulkan** graphics engine.

---

## 🌟 Key Features

- **Total Privacy:** Data never leaves your machine. No fees or subscriptions.
- **AMD GPU Acceleration:** Configured to use **Vulkan**, achieving near-instant responses on Radeon hardware (tested on RX 6650 XT).
- **System Control:** Ability to create, move, and list files through integrated PowerShell commands.
- **Automation:** A single `.bat` script to launch the entire technology stack.

---

## 🛠️ Tech Stack

| Component | Tool |
| :--- | :--- |
| **AI Engine** | [Ollama](https://ollama.com/) |
| **Model (LLM)** | `Qwen2.5-Coder 7B` (Optimized for 8GB VRAM) |
| **Web Interface** | [Open WebUI](https://github.com/open-webui/open-webui) |
| **Terminal Agent** | [Open Interpreter](https://openinterpreter.com/) |
| **Acceleration** | Vulkan API (Bypassing ROCm limitations on Windows) |

---

## 🔧 Technical Solution for AMD on Windows

To prevent Ollama from ignoring the GPU and overloading the CPU, this project injects environment variables that force the use of the Vulkan API. This is critical for 6000 series cards:

1. `OLLAMA_VULKAN=1`: Enables Vulkan support.
2. `HSA_OVERRIDE_GFX_VERSION=10.3.0`: Emulates compatibility for RDNA2 architectures.

---

## 📥 Installation

### 1. Prepare the Virtual Environment (Python)
Run this in your Windows terminal:
```bash
# Create virtual environment
python -m venv oi-env

# Activate environment
oi-env\Scripts\activate

# Install dependencies
pip install open-interpreter open-webui

# Download the model
ollama pull qwen2.5-coder:7b
```

### 2. Configure the "Tool" in Open WebUI
To allow the web interface to execute commands, add this **Tool** in the Workspace panel within Open WebUI:

```python
import subprocess

class Tools:
    def execute(self, command: str) -> str:
        """
        Executes PowerShell commands. Use it for mkdir, dir, move, etc.
        """
        try:
            process = subprocess.run(
                ["powershell", "-Command", command],
                capture_output=True, text=True, shell=True
            )
            if process.returncode == 0:
                return process.stdout if process.stdout else "Action completed successfully."
            else:
                return f"Error: {process.stderr}"
        except Exception as e:
            return f"Technical Error: {str(e)}"
```

---

## 🚀 Usage and Automation

Create a file named `Start_AI.bat` in the project root to start everything with a single double-click:

```batch
@echo off
title AI Command Center - AMD
:: Force AMD GPU
set OLLAMA_VULKAN=1
set HSA_OVERRIDE_GFX_VERSION=10.3.0

:: Start WebUI server
start "WebUI" cmd /c "oi-env\Scripts\activate && open-webui serve"
timeout /t 5

:: Open browser
start http://localhost:8080

:: Start Open Interpreter
start "AI Terminal" cmd /k "oi-env\Scripts\activate && interpreter --model openai/qwen2.5-coder:7b --api_base http://localhost:11434/v1 --api_key ollama"
```

> [!IMPORTANT]
> **Run the `.bat` file as Administrator.** Otherwise, Windows will deny access (Access Denied) when the AI tries to create folders or manage files on the Desktop.

---

## 🛡️ Security Notes
This system grants code execution capabilities to a Large Language Model (LLM). It is recommended to supervise the proposed actions and avoid running the environment on public networks or machines with sensitive unencrypted data.

---
*Developed to empower local AI usage on AMD Radeon hardware.*
