#!/bin/bash

# Script para la instalación y configuración de Docker
# Parte 4.1 y 4.2 del ejercicio

echo "=========================================="
echo "      INSTALACIÓN Y CONFIGURACIÓN DOCKER"
echo "=========================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para mostrar mensajes de éxito
success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

# Función para mostrar mensajes de error
error() {
    echo -e "${RED}[✗] $1${NC}"
}

# Función para mostrar advertencias
warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Verificar si el script se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    error "Este script debe ejecutarse como root o con sudo"
    exit 1
fi

echo ""
echo "=== 4.1 INSTALACIÓN Y CONFIGURACIÓN ==="

# Paso 1: Instalar Docker
echo "Instalando Docker..."
apt update > /dev/null 2>&1
if apt install docker.io -y > /dev/null 2>&1; then
    success "Docker instalado correctamente"
else
    error "Error al instalar Docker"
    exit 1
fi

# Paso 2: Habilitar e iniciar servicio Docker
echo "Configurando servicio Docker..."
systemctl enable docker > /dev/null 2>&1
systemctl start docker > /dev/null 2>&1

# Verificar estado del servicio
if systemctl is-active --quiet docker; then
    success "Servicio Docker iniciado y habilitado"
else
    error "Error al iniciar el servicio Docker"
    exit 1
fi

# Paso 3: Agregar usuarios al grupo docker
echo "Agregando usuarios al grupo docker..."
for usuario in adminsys tecnico; do
    if id "$usuario" &>/dev/null; then
        usermod -aG docker "$usuario"
        success "Usuario $usuario agregado al grupo docker"
    else
        warning "Usuario $usuario no existe, omitiendo..."
    fi
done

# Paso 4: Aplicar cambios de grupo sin necesidad de cerrar sesión
echo "Aplicando cambios de grupo..."
for usuario in adminsys tecnico; do
    if id "$usuario" &>/dev/null; then
        # Usar su -c para ejecutar newgrp en el contexto del usuario
        su - $usuario -c "newgrp docker" &
        success "Cambios de grupo aplicados para $usuario"
    fi
done

# Pequeña pausa para que los cambios se procesen
sleep 2

# Paso 5: Verificaciones de instalación
echo "Realizando verificaciones..."

# Verificar versión de Docker
docker_version=$(docker --version 2>/dev/null)
if [ $? -eq 0 ]; then
    success "Docker version: $docker_version"
else
    error "No se pudo obtener la versión de Docker"
    exit 1
fi

# Verificar info de Docker
if docker info > /dev/null 2>&1; then
    success "Docker está funcionando correctamente"
else
    error "Problema con la configuración de Docker"
    exit 1
fi

echo ""
echo "=== 4.2 VERIFICACIÓN INICIAL ==="

# Paso 1: Ejecutar contenedor hello-world
echo "Ejecutando contenedor de prueba hello-world..."
if docker run --rm hello-world > /dev/null 2>&1; then
    success "Contenedor hello-world ejecutado correctamente"
else
    # Intentar descargar la imagen primero
    warning "Descargando imagen hello-world..."
    docker pull hello-world > /dev/null 2>&1
    if docker run --rm hello-world > /dev/null 2>&1; then
        success "Contenedor hello-world ejecutado correctamente"
    else
        error "Error al ejecutar el contenedor hello-world"
        exit 1
    fi
fi

# Paso 2: Listar contenedores e imágenes
echo "Listando contenedores..."
if docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | head -n 10; then
    success "Lista de contenedores mostrada correctamente"
else
    error "Error al listar contenedores"
fi

echo ""
echo "Listando imágenes descargadas..."
if docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | head -n 10; then
    success "Lista de imágenes mostrada correctamente"
else
    error "Error al listar imágenes"
fi

echo ""
echo "=== VERIFICACIÓN DE USUARIOS ==="

# Verificar que los usuarios pueden usar Docker sin sudo
for usuario in adminsys tecnico; do
    if id "$usuario" &>/dev/null; then
        echo "Verificando permisos Docker para $usuario..."
        if su - $usuario -c "docker ps > /dev/null 2>&1"; then
            success "Usuario $usuario puede ejecutar comandos Docker sin sudo"
        else
            warning "Usuario $usuario aún necesita configurar newgrp manualmente"
            echo "  Ejecutar manualmente: su - $usuario -> newgrp docker"
        fi
    fi
done

echo ""
echo "=========================================="
success "INSTALACIÓN Y VERIFICACIÓN COMPLETADAS"
echo "=========================================="
echo ""
warning "NOTA: Si algún usuario aún no puede usar Docker sin sudo,"
warning "ejecutar manualmente:"
echo "  su - usuario"
echo "  newgrp docker"
echo "=========================================="
