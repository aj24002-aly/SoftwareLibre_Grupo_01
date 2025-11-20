Proyecto Linux - Grupo 01
Descripción del Proyecto
Implementación de un servidor Linux automatizado utilizando tecnologías de contenedores Docker, integrando prácticas de administración de sistemas, control de versiones y virtualización.

Arquitectura del Proyecto
Estructura de Directorios

/proyecto/
├── datos/          # Archivos de configuración
├── web/            # Archivos del sitio web
├── scripts/        # Scripts de automatización
└── capturas/       # Evidencias del proyecto

Usuarios y Grupos
adminsys: Usuario con privilegios sudo

tecnico: Pertenece al grupo soporte

visitante: Pertenece al grupo web

Grupos
soporte: Grupo para usuarios técnicos

web: Grupo para usuarios visitantes

Instalación y Configuración
1. Preparación del Entorno Servidor
Configuración básica del sistema:

# Establecer nombre del host
sudo hostnamectl set-hostname servidor-grupoX

# Crear usuarios
sudo useradd -m -s /bin/bash adminsys
sudo useradd -m -s /bin/bash tecnico
sudo useradd -m -s /bin/bash visitante

# Crear grupos
sudo groupadd soporte
sudo groupadd web

# Asignar usuarios a grupos
sudo usermod -aG sudo adminsys
sudo usermod -aG soporte tecnico
sudo usermod -aG web visitante
Crear estructura de directorios:

sudo mkdir -p /proyecto/{datos,web,scripts,capturas}
2. Docker
Instalación y configuración:

# Ejecutar script de instalación
chmod +x scripts/04_install_config_docker.sh
sudo ./scripts/04_install_config_docker.sh
Verificación:

docker --version
docker ps
docker run hello-world
3. Servidor Web Containerizado
Configuración del servidor Nginx:

# Ejecutar script del servidor web
chmod +x scripts/05_servidor_web_docker.sh
sudo ./scripts/05_servidor_web_docker.sh
Acceso al servicio:
URL: http://localhost:8080

Directorio contenido: /proyecto/web/

Contenedor: nginx-grupo01

Scripts de Automatización
Script de Monitoreo del Sistema
Ubicación: /proyecto/scripts/reporte_sistema.sh

Funcionalidad: Monitorea estado del sistema cada 30 minutos

Log: /var/log/proyecto/reporte_sistema.log

Configuración Cron

# Editar crontab
crontab -e

# Agregar línea para ejecución cada 30 minutos
*/30 * * * * /proyecto/scripts/reporte_sistema.sh >> /var/log/proyecto/reporte_sistema.log
Contenedores Docker Implementados
1. Nginx Oficial
Puerto: 8080 → 80

Volumen: /proyecto/web/ → /usr/share/nginx/html

Estado:  En producción

Comandos Útiles
Gestión de Contenedores

# Ver contenedores en ejecución
docker ps

# Ver logs de contenedor
docker logs nginx-grupo01

# Detener contenedor
docker stop nginx-grupo01

# Iniciar contenedor
docker start nginx-grupo01
Gestión de Imágenes

# Listar imágenes
docker images

# Construir desde Dockerfile
docker build -t servidor-grupoX .
Verificación de Servicios

# Probar servidor web
curl http://localhost:8080

# Verificar puertos en uso
netstat -tulpn | grep 8080

# Ver logs del sistema
tail -f /var/log/proyecto/reporte_sistema.log
Configuración de Permisos
Directorios y Grupos
bash
# Asignar grupos a directorios
sudo chgrp soporte /proyecto/datos/
sudo chgrp web /proyecto/web/

# Configurar permisos de herencia
sudo chmod g+s /proyecto/datos/
sudo chmod g+s /proyecto/web/
Monitoreo
Métricas Recopiladas
Uso de CPU y memoria

Espacio en disco

Usuarios conectados

Contenedores Docker activos

Estado de servicios

Solución de Problemas
Problemas Comunes
Docker no inicia


sudo systemctl start docker
sudo systemctl enable docker
Permisos denegados


sudo usermod -aG docker $USER
newgrp docker
Puerto en uso


sudo lsof -i :8080
sudo kill -9 <PID>
Integrantes del Grupo
Integrante 1 - Rol: Administración de Sistema

Integrante 2 - Rol: Desarrollo Web

Integrante 3 - Rol: Automatización y Scripts

Integrante 4 - Rol: Contenedores Docker

© 2025 Proyecto Linux - Grupo 01. Universidad de El Salvador.
