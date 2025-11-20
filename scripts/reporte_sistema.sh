#!/bin/bash

# Script: reporte_sistema.sh
# Descripción: Reporte de monitoreo del sistema
# Proyecto: ISL135 - Grupo 01

echo "========================================="
echo "    REPORTE DEL SISTEMA - $(date)"
echo "========================================="

# - Fecha y hora actual
echo "Fecha y hora actual: $(date)"

# - Nombre del host del sistema
echo "Nombre del host: $(hostname)"

# - Número de usuarios conectados
echo "Usuarios conectados: $(who | wc -l)"

echo "-----------------------------------------"

# - Espacio libre en el disco principal
echo "Espacio libre en disco:"
df -h / | awk 'NR==2{print "  " $4 " libres de " $2 " (" $5 " usado)"}'

# - Memoria RAM disponible
echo "Memoria RAM disponible:"
free -h | awk 'NR==2{print "  " $7 " disponibles de " $2}'

# - Número de contenedores Docker activos
if command -v docker &> /dev/null; then
    echo "Contenedores Docker activos: $(docker ps -q | wc -l)"
else
    echo "Contenedores Docker activos: Docker no instalado"
fi

echo "========================================="
echo ""
