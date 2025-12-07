# GPT-OSS-20B-Auto-Installer

One-command installer and uninstaller for **GPT-OSS 20B HERETIC uncensored AI model**. Automatically downloads, verifies, and runs locally on Windows with llama.cpp.

## 🚀 Features

- **One-Command Install**: Single PowerShell command to set up everything
- **One-Command Uninstall**: Complete removal with confirmation
- **Auto-Verification**: Checks all files are downloaded correctly
- **Auto-Prerequisites**: Installs Git and CMake if missing
- **Optimized Settings**: Pre-configured with recommended parameters from the model card
- **Launcher Script**: Easy-to-use batch file to start the AI server

## 📋 Requirements

- **OS**: Windows 10/11
- **RAM**: 16GB+ recommended
- **Storage**: ~12GB free space for model
- **Internet**: For downloading model and dependencies

## ⚡ Quick Start

### Install (One Command)

Open **PowerShell** (right-click Start → Windows PowerShell) and paste:

```powershell
irm https://raw.githubusercontent.com/Issaquah2247/GPT-OSS-20B-Auto-Installer/main/install.ps1 | iex
```

### Run the AI Model

After installation, double-click:
```
C:\Users\YourName\GPT-OSS-20B\run.bat
```

Or from PowerShell:
```powershell
& "$env:USERPROFILE\GPT-OSS-20B\run.bat"
```

The server will start at **http://localhost:8080**

### Uninstall (One Command)

To completely remove everything:

```powershell
irm https://raw.githubusercontent.com/Issaquah2247/GPT-OSS-20B-Auto-Installer/main/uninstall.ps1 | iex
```

Type `YES` when prompted to confirm deletion.

## 📦 What Gets Installed

- **llama.cpp**: Built from source with optimizations
- **GPT-OSS 20B Model**: Q5_1 quantized GGUF file (~12GB)
- **Launcher**: Batch script with optimized parameters
- **Location**: `C:\Users\YourName\GPT-OSS-20B\`

## ⚙️ Model Configuration

The launcher uses these optimized settings from the [model card](https://huggingface.co/DavidAU/OpenAi-GPT-oss-20b-HERETIC-uncensored-NEO-Imatrix-gguf):

- **Context**: 8192 tokens
- **Temperature**: 0.8
- **Repetition Penalty**: 1.1
- **Top-K**: 40
- **Top-P**: 0.95
- **Min-P**: 0.05
- **Port**: 8080

## 🔧 Troubleshooting

### Installation Fails

1. Run PowerShell as Administrator
2. Enable script execution:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Try the install command again

### Model Won't Start

- Check if port 8080 is already in use
- Verify model downloaded completely (should be ~12GB)
- Check `C:\Users\YourName\GPT-OSS-20B\models\` exists

### Out of Memory

- Close other applications
- Try the smaller Q4 quantization (edit `install.ps1` model name)
- Increase virtual memory in Windows settings

## 📝 Manual Installation

If you prefer to review the scripts first:

1. Download `install.ps1` from this repo
2. Review the code
3. Run: `powershell -ExecutionPolicy Bypass -File install.ps1`

## 🗑️ Complete Removal

The uninstaller removes:
- All model files
- llama.cpp installation
- Launcher scripts
- Installation directory

**Manual cleanup** (if needed):
```powershell
Remove-Item -Path "$env:USERPROFILE\GPT-OSS-20B" -Recurse -Force
```

## 🔒 Security Note

This model is **uncensored** and has safety filters removed. Use responsibly and in accordance with local laws.

## 📄 License

Installer scripts: MIT License  
Model: See [DavidAU's model card](https://huggingface.co/DavidAU/OpenAi-GPT-oss-20b-HERETIC-uncensored-NEO-Imatrix-gguf)  
llama.cpp: MIT License

## 🙏 Credits

- **Model**: [DavidAU](https://huggingface.co/DavidAU) - GPT-OSS 20B HERETIC
- **Runtime**: [llama.cpp](https://github.com/ggerganov/llama.cpp) by Georgi Gerganov
- **Base Model**: GPT-OSS 20B by Huihui

## ⚠️ Disclaimer

This is an unofficial installer. Not affiliated with model creators. Use at your own risk.
