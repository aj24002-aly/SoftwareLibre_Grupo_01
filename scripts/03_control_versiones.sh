#!/bin/bash

# =============================================
# Script: 03_control_versiones.sh
# Descripción: Control de Versiones - Parte 3
# Proyecto: ISL135 - Introducción al Software Libre
# =============================================

# Configuración
PROJECT_DIR="/proyecto"
GITHUB_REPO="proyecto-linux-grupo01"
GITHUB_USER="tuusuario"  # Cambiar por tu usuario de GitHub

echo "========================================="
echo "  CONTROL DE VERSIONES - PARTE 3"
echo "  Proyecto ISL135 - Grupo 01"
echo "========================================="
echo ""

# =============================================
# 1. VERIFICAR INSTALACIÓN DE GIT
# =============================================

echo "=== VERIFICANDO INSTALACIÓN DE GIT ==="

if ! command -v git &> /dev/null; then
    echo "Git no está instalado. Instalando..."
    sudo apt update
    sudo apt install -y git
    echo "✅ Git instalado correctamente"
else
    echo "✅ Git ya está instalado"
    git --version
fi
echo ""

# =============================================
# 2. CONFIGURAR USUARIO GIT
# =============================================

echo "=== CONFIGURANDO USUARIO GIT ==="

cd "$PROJECT_DIR"

# Configurar usuario global de Git
git config --global user.email "grupo01@isl135.edu.sv"
git config --global user.name "Grupo 01 ISL135"

echo "✅ Configuración de Git establecida:"
git config --list | grep -E "(user.name|user.email)"
echo ""

# =============================================
# 3. INICIALIZAR REPOSITORIO GIT
# =============================================

echo "=== INICIALIZANDO REPOSITORIO GIT ==="

# Verificar si ya es un repositorio Git
if [ -d ".git" ]; then
    echo "⚠️  El directorio ya es un repositorio Git"
else
    git init
    echo "✅ Repositorio Git inicializado"
fi

# Mostrar estado inicial
echo "Estado del repositorio:"
git status
echo ""

# =============================================
# 4. CREAR ARCHIVO README.md
# =============================================

echo "=== CREANDO DOCUMENTACIÓN ==="

# Crear archivo README.md
cat > README.md << 'EOF'
# Proyecto Linux - Grupo 01

## Introducción al Software Libre
### Universidad de El Salvador


**Descripción del proyecto:**
Implementación de un servidor Linux automatizado con Docker, incluyendo:
- Administración básica del sistema
- Automatización con scripts y Cron
- Servicios web containerizados
- Redes y volúmenes Docker

**Estructura del proyecto:**
