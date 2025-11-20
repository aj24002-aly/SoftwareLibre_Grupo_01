#!/bin/bash

# =============================================
# Script: 02_automatizacion_monitoreo.sh
# Descripción: Automatización y Monitoreo - Parte 2
# Proyecto: ISL135 - Introducción al Software Libre
# =============================================

# Configuración
PROJECT_DIR="/proyecto"
SCRIPT_NAME="reporte_sistema.sh"
CRON_LOG="/var/log/proyecto/reporte_sistema.log"

echo "========================================="
echo "  AUTOMATIZACIÓN Y MONITOREO - PARTE 2"
echo "  Proyecto ISL135 - Grupo 01"
echo "========================================="
echo ""

# =============================================
# 1. CREAR SCRIPT DE MONITOREO
# =============================================

echo "=== CREANDO SCRIPT DE MONITOREO ==="

# Crear el script de monitoreo
sudo cat > "$PROJECT_DIR/scripts/$SCRIPT_NAME" << 'EOF'
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
EOF

# Dar permisos de ejecución
sudo chmod +x "$PROJECT_DIR/scripts/$SCRIPT_NAME"

# Verificar creación
echo "✅ Script creado: $PROJECT_DIR/scripts/$SCRIPT_NAME"
ls -l "$PROJECT_DIR/scripts/$SCRIPT_NAME"
echo ""

# =============================================
# 2. PROBAR SCRIPT DE MONITOREO
# =============================================

echo "=== PROBANDO SCRIPT DE MONITOREO ==="

echo "Ejecutando prueba del script:"
"$PROJECT_DIR/scripts/$SCRIPT_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Script funciona correctamente"
else
    echo "❌ Error en la ejecución del script"
    exit 1
fi
echo ""

# =============================================
# 3. CONFIGURAR DIRECTORIO DE LOGS
# =============================================

echo "=== CONFIGURANDO DIRECTORIO DE LOGS ==="

# Crear directorio de logs
sudo mkdir -p /var/log/proyecto

# Crear archivo de log inicial
sudo touch "$CRON_LOG"
sudo chmod 644 "$CRON_LOG"

echo "✅ Directorio y archivo de log creados:"
ls -la /var/log/proyecto/
echo ""

# =============================================
# 4. CONFIGURAR CRON JOB
# =============================================

echo "=== CONFIGURANDO TAREA CRON ==="

# Verificar cron jobs actuales
echo "Cron jobs actuales:"
crontab -l 2>/dev/null || echo "No hay cron jobs configurados"
echo ""

# Configurar el nuevo cron job (cada 30 minutos)
(crontab -l 2>/dev/null; echo "*/30 * * * * $PROJECT_DIR/scripts/$SCRIPT_NAME >> $CRON_LOG 2>&1") | crontab -

# Verificar que se agregó
echo "✅ Cron job configurado:"
crontab -l | grep "$SCRIPT_NAME"
echo ""

# =============================================
# 5. VERIFICAR SERVICIO CRON
# =============================================

echo "=== VERIFICANDO SERVICIO CRON ==="

# Verificar estado del servicio cron
echo "Estado del servicio cron:"
sudo systemctl status cron --no-pager | head -5

if sudo systemctl is-active cron > /dev/null; then
    echo "✅ Servicio cron está ACTIVO"
else
    echo "❌ Servicio cron está INACTIVO"
    sudo systemctl start cron
    echo "✅ Servicio cron iniciado"
fi

if sudo systemctl is-enabled cron > /dev/null; then
    echo "✅ Servicio cron está HABILITADO"
else
    echo "⚠️  Servicio cron no está habilitado"
    sudo systemctl enable cron
    echo "✅ Servicio cron habilitado"
fi
echo ""

# =============================================
# 6. PROBAR EJECUCIÓN AUTOMÁTICA
# =============================================

echo "=== PROBANDO EJECUCIÓN AUTOMÁTICA ==="

# Ejecutar manualmente para primera prueba
echo "Ejecutando script manualmente para prueba inicial..."
"$PROJECT_DIR/scripts/$SCRIPT_NAME" >> "$CRON_LOG" 2>&1

# Verificar que se escribió en el log
echo "✅ Contenido del log después de prueba:"
tail -10 "$CRON_LOG"
echo ""

# =============================================
# 7. VERIFICACIÓN COMPLETA
# =============================================

echo "=== VERIFICACIÓN COMPLETA ==="

echo "1. ✅ Script de monitoreo creado:"
ls -la "$PROJECT_DIR/scripts/$SCRIPT_NAME"
echo ""

echo "2. ✅ Permisos de ejecución:"
ls -l "$PROJECT_DIR/scripts/$SCRIPT_NAME"
echo ""

echo "3. ✅ Cron job configurado:"
crontab -l | grep "$SCRIPT_NAME"
echo ""

echo "4. ✅ Archivo de log:"
ls -la "$CRON_LOG"
echo ""

echo "5. ✅ Contenido del log:"
tail -5 "$CRON_LOG"
echo ""

echo "6. ✅ Servicio cron activo:"
sudo systemctl is-active cron && echo "SI" || echo "NO"
echo ""

# =============================================
# 8. GENERAR REPORTE
# =============================================

echo "=== GENERANDO REPORTE ==="

# Crear reporte
sudo cat > "/proyecto/capturas/reporte_parte2.txt" << EOF
REPORTE DE CONFIGURACIÓN - PARTE 2
==================================
Proyecto: ISL135 - Automatización y Monitoreo
Grupo: 01
Integrantes: Alisson y Danilo
Fecha: $(date)

CONFIGURACIÓN REALIZADA:
------------------------
1. SCRIPT DE MONITOREO:
   - Nombre: $SCRIPT_NAME
   - Ubicación: $PROJECT_DIR/scripts/$SCRIPT_NAME
   - Permisos: $(ls -l $PROJECT_DIR/scripts/$SCRIPT_NAME | awk '{print $1}')
   - Ejecutable: SI

2. TAREA PROGRAMADA CRON:
   - Frecuencia: Cada 30 minutos
   - Comando: $PROJECT_DIR/scripts/$SCRIPT_NAME >> $CRON_LOG
   - Configuración: $(crontab -l | grep "$SCRIPT_NAME")

3. ARCHIVO DE LOG:
   - Ubicación: $CRON_LOG
   - Tamaño: $(ls -lh $CRON_LOG | awk '{print $5}')

4. INFORMACIÓN MONITOREADA:
   - Fecha y hora actual
   - Nombre del host del sistema
   - Número de usuarios conectados
   - Espacio libre en disco principal
   - Memoria RAM disponible
   - Contenedores Docker activos

VERIFICACIÓN:
-------------
$(tail -8 $CRON_LOG)

CONFIGURACIÓN COMPLETADA: $(date)
EOF

echo "✅ Reporte generado en: /proyecto/capturas/reporte_parte2.txt"
echo ""

# =============================================
# FINALIZACIÓN
# =============================================

echo "========================================="
echo "✅ PARTE 2 COMPLETADA EXITOSAMENTE"
echo "========================================="
echo ""
echo "RESUMEN:"
echo "• Script: /proyecto/scripts/reporte_sistema.sh"
echo "• Cron: Ejecución cada 30 minutos"
echo "• Log: /var/log/proyecto/reporte_sistema.log"
echo "• Reporte: /proyecto/capturas/reporte_parte2.txt"
echo ""
echo "El sistema ahora generará reportes automáticamente cada 30 minutos"
echo "y los guardará en el archivo de log especificado."
echo ""
