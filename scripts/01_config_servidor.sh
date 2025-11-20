# =============================================
# Script: 01_config_servidor.sh
# Descripción: Configuración inicial del servidor - Parte 1
# Autores: Alisson , Danilo, Medardo, Alyson - Grupo 01
# Proyecto: ISL135 - Introducción al Software Libre
# =============================================

set -euo pipefail

# Configuración
readonly HOSTNAME="servidor-grupo01"
readonly PROJECT_DIR="/proyecto"
readonly LOG_FILE="/var/log/proyecto/parte1.log"

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# =============================================
# FUNCIONES DE LOGGING Y FORMATO
# =============================================

init_log() {
    echo "=== INICIO DE CONFIGURACIÓN - $(date) ===" | sudo tee "$LOG_FILE"
    log "INFO" "Iniciando script de configuración Parte 1"
}

log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | sudo tee -a "$LOG_FILE"
}

info() { 
    echo -e "${BLUE}[INFO]${NC} $1"
    log "INFO" "$1"
}

success() { 
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    log "SUCCESS" "$1"
}

warn() { 
    echo -e "${YELLOW}[WARNING]${NC} $1"
    log "WARNING" "$1"
}

error() { 
    echo -e "${RED}[ERROR]${NC} $1"
    log "ERROR" "$1"
}

# =============================================
# FUNCIONES DE VERIFICACIÓN
# =============================================

check_sudo() {
    info "Verificando privilegios de sudo..."
    if ! sudo -v; then
        error "Se requieren privilegios de sudo para continuar"
        exit 1
    fi
    success "Privilegios de sudo verificados"
}

check_os() {
    info "Verificando sistema operativo..."
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        info "Sistema detectado: $NAME $VERSION"
    else
        warn "No se pudo detectar el sistema operativo"
    fi
}

# =============================================
# FUNCIONES PRINCIPALES
# =============================================

configure_hostname() {
    info "1. Configurando hostname del sistema..."
    
    local current_hostname=$(hostname)
    info "Hostname actual: $current_hostname"
    
    if [[ "$current_hostname" == "$HOSTNAME" ]]; then
        warn "El hostname ya está configurado como $HOSTNAME"
        return 0
    fi
    
    info "Cambiando hostname a: $HOSTNAME"
    sudo hostnamectl set-hostname "$HOSTNAME"
    
    # Verificar cambio
    if [[ $(hostname) == "$HOSTNAME" ]]; then
        success "Hostname configurado exitosamente: $(hostname)"
    else
        error "Error al configurar hostname"
        return 1
    fi
}

create_groups() {
    info "2. Creando grupos del sistema..."
    
    local groups=("soporte" "web")
    
    for grupo in "${groups[@]}"; do
        info "Verificando grupo: $grupo"
        if getent group "$grupo" > /dev/null; then
            warn "El grupo $grupo ya existe"
        else
            if sudo groupadd "$grupo"; then
                success "Grupo $grupo creado exitosamente"
            else
                error "Error al crear grupo $grupo"
                return 1
            fi
        fi
    done
    
    info "Mostrando grupos creados:"
    getent group soporte web
}

create_users() {
    info "3. Creando usuarios del sistema..."
    
    info "Creando usuario: adminsys"
    if id "adminsys" &>/dev/null; then
        warn "El usuario adminsys ya existe"
    else
        sudo useradd -m -s /bin/bash -c "Administrador del Sistema" adminsys
        success "Usuario adminsys creado"
    fi
    
    info "Creando usuario: tecnico"
    if id "tecnico" &>/dev/null; then
        warn "El usuario tecnico ya existe"
    else
        sudo useradd -m -s /bin/bash -c "Técnico de Soporte" tecnico
        success "Usuario tecnico creado"
    fi
    
    info "Creando usuario: visitante"
    if id "visitante" &>/dev/null; then
        warn "El usuario visitante ya existe"
    else
        sudo useradd -m -s /bin/bash -c "Usuario Visitante" visitante
        success "Usuario visitante creado"
    fi
    
    info "Resumen de usuarios creados:"
    echo "adminsys: $(id adminsys)"
    echo "tecnico: $(id tecnico)"
    echo "visitante: $(id visitante)"
}

set_passwords() {
    info "4. Estableciendo contraseñas de usuarios..."
    
    # Contraseñas seguras
    declare -A passwords=(
        ["adminsys"]="Admin1235d!"
        ["tecnico"]="Techno34/a!"
        ["visitante"]="Visit2024!"
    )
    
    for usuario in "${!passwords[@]}"; do
        info "Estableciendo contraseña para: $usuario"
        if echo "$usuario:${passwords[$usuario]}" | sudo chpasswd; then
            success "Contraseña establecida para $usuario"
        else
            error "Error al establecer contraseña para $usuario"
        fi
    done
}

configure_user_groups() {
    info "5. Configurando membresías de grupos..."
    
    info "Configurando usuario adminsys (sudo + soporte)"
    sudo usermod -aG sudo adminsys
    sudo usermod -aG soporte adminsys
    
    info "Configurando usuario tecnico (soporte)"
    sudo usermod -aG soporte tecnico
    
    info "Configurando usuario visitante (web)"
    sudo usermod -aG web visitante
    
    success "Membresías de grupos configuradas"
    
    info "Verificando configuraciones:"
    echo "adminsys: $(groups adminsys)"
    echo "tecnico: $(groups tecnico)" 
    echo "visitante: $(groups visitante)"
}

create_directory_structure() {
    info "6. Creando estructura de directorios..."
    
    info "Creando directorio base: $PROJECT_DIR"
    sudo mkdir -p "$PROJECT_DIR"
    
    local directories=("datos" "web" "scripts" "capturas")
    
    for dir in "${directories[@]}"; do
        local full_path="$PROJECT_DIR/$dir"
        info "Creando directorio: $full_path"
        sudo mkdir -p "$full_path"
    done
    
    success "Estructura de directorios creada"
    
    info "Mostrando estructura:"
    ls -la "$PROJECT_DIR"
}

set_directory_permissions() {
    info "7. Configurando permisos de directorios..."
    
    info "Configurando directorio datos/ (grupo soporte)"
    sudo chgrp soporte "$PROJECT_DIR/datos"
    sudo chmod 775 "$PROJECT_DIR/datos"
    sudo chmod g+s "$PROJECT_DIR/datos"  # SGID
    
    info "Configurando directorio web/ (grupo web)"
    sudo chgrp web "$PROJECT_DIR/web"
    sudo chmod 775 "$PROJECT_DIR/web"
    sudo chmod g+s "$PROJECT_DIR/web"    # SGID
    
    info "Configurando directorios scripts/ y capturas/ (root)"
    sudo chown root:root "$PROJECT_DIR/scripts"
    sudo chown root:root "$PROJECT_DIR/capturas"
    sudo chmod 755 "$PROJECT_DIR/scripts"
    sudo chmod 755 "$PROJECT_DIR/capturas"
    
    success "Permisos configurados correctamente"
}

verify_configuration() {
    info "8. Verificando configuración final..."
    
    echo "=== VERIFICACIÓN FINAL ==="
    echo "1. Hostname: $(hostname)"
    echo ""
    
    echo "2. Usuarios y grupos:"
    echo "   adminsys: $(groups adminsys)"
    echo "   tecnico: $(groups tecnico)"
    echo "   visitante: $(groups visitante)"
    echo ""
    
    echo "3. Estructura de directorios:"
    ls -la "$PROJECT_DIR"
    echo ""
    
    echo "4. Permisos SGID:"
    find "$PROJECT_DIR" -type d -perm -g+s 2>/dev/null
    echo ""
    
    echo "5. Grupos del sistema:"
    getent group soporte web
    echo ""
    
    success "Verificación completada"
}

generate_report() {
    info "Generando reporte de configuración..."
    
    local report_file="$PROJECT_DIR/capturas/reporte_parte1.txt"
    
    sudo cat > "$report_file" << EOF
REPORTE DE CONFIGURACIÓN - PARTE 1
==================================
Proyecto: ISL135 - Introducción al Software Libre
Grupo: 01
Fecha: $(date)

CONFIGURACIÓN REALIZADA:
------------------------
1. HOSTNAME: $(hostname)

2. USUARIOS CREADOS:
   - adminsys: $(id adminsys)
   - tecnico: $(id tecnico) 
   - visitante: $(id visitante)

3. GRUPOS CREADOS:
   - soporte: $(getent group soporte)
   - web: $(getent group web)

4. ESTRUCTURA DE DIRECTORIOS:
$(ls -la $PROJECT_DIR)

5. PERMISOS CONFIGURADOS:
   - $PROJECT_DIR/datos: $(ls -ld $PROJECT_DIR/datos)
   - $PROJECT_DIR/web: $(ls -ld $PROJECT_DIR/web)
   - $PROJECT_DIR/scripts: $(ls -ld $PROJECT_DIR/scripts)
   - $PROJECT_DIR/capturas: $(ls -ld $PROJECT_DIR/capturas)

6. PERMISOS SGID:
$(find $PROJECT_DIR -type d -perm -g+s 2>/dev/null)

CONFIGURACIÓN COMPLETADA: $(date)
EOF

    success "Reporte generado en: $report_file"
}

# =============================================
# FUNCIÓN PRINCIPAL
# =============================================

main() {
    echo "========================================="
    echo "  CONFIGURACIÓN DEL SERVIDOR - PARTE 1"
    echo "  Proyecto ISL135 - Grupo 01"
    echo "========================================="
    echo ""
    
    # Inicializar sistema
    check_sudo
    check_os
    init_log
    
    # Ejecutar configuración paso a paso
    configure_hostname
    create_groups
    create_users
    set_passwords
    configure_user_groups
    create_directory_structure
    set_directory_permissions
    verify_configuration
    generate_report
    
    echo ""
    success "=== CONFIGURACIÓN DE LA PARTE 1 COMPLETADA ==="
    info "Log completo disponible en: $LOG_FILE"
    info "Reporte generado en: $PROJECT_DIR/capturas/reporte_parte1.txt"
    echo ""
    info "Próximo paso: Ejecutar la Parte 2 - Automatización y Monitoreo"
}

# Manejar interrupciones
trap 'error "Script interrumpido por el usuario"; exit 1' INT TERM

# Ejecutar función principal
main "$@"
