#!/bin/bash

# Script para servidor web containerizado con Nginx
# Parte 5.1 y 5.2 del ejercicio

echo "=========================================="
echo "    SERVIDOR WEB CONTAINERIZADO - NGINX"
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

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    error "Docker no está instalado. Ejecuta primero el script de instalación de Docker."
    exit 1
fi

echo ""
echo "=== 5.1 CONTENEDOR NGINX BÁSICO ==="

# Paso 1: Crear directorio y archivo index.html
echo "Creando directorio y archivo index.html..."
sudo mkdir -p /proyecto/web

# Crear archivo index.html profesional
sudo tee /proyecto/web/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Servidor Web Containerizado - Grupo 01</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            padding: 60px 20px;
            color: white;
        }

        .header h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            font-weight: 300;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .header p {
            font-size: 1.3rem;
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }

        .main-content {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            margin-top: 30px;
        }

        .status-card {
            background: linear-gradient(135deg, #00b09b, #96c93d);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
        }

        .status-card i {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        .status-card h2 {
            font-size: 1.8rem;
            margin-bottom: 10px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin: 40px 0;
        }

        .card {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .card h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .card i {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 15px;
        }

        .specs {
            background: #2c3e50;
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin: 30px 0;
        }

        .specs h3 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 1.5rem;
        }

        .spec-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .spec-item {
            text-align: center;
            padding: 15px;
        }

        .spec-item i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #3498db;
        }

        .tech-stack {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin: 30px 0;
        }

        .tech-item {
            background: #34495e;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.9rem;
        }

        .footer {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
            color: white;
            opacity: 0.8;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 2.5rem;
            }
            
            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-server"></i><br>Servidor Web Containerizado</h1>
            <p>Infraestructura moderna con Docker y Nginx</p>
        </div>

        <div class="main-content">
            <div class="status-card">
                <i class="fas fa-check-circle"></i>
                <h2>Sistema Operando Correctamente</h2>
                <p>Servidor web funcionando de manera óptima</p>
            </div>

            <div class="grid">
                <div class="card">
                    <i class="fas fa-docker"></i>
                    <h3>Containerizado con Docker</h3>
                    <p>Implementación en contenedores para mayor escalabilidad y portabilidad.</p>
                </div>

                <div class="card">
                    <i class="fas fa-shield-alt"></i>
                    <h3>Seguro y Aislado</h3>
                    <p>Entorno aislado que garantiza la seguridad y estabilidad del servicio.</p>
                </div>

                <div class="card">
                    <i class="fas fa-rocket"></i>
                    <h3>Alto Rendimiento</h3>
                    <p>Optimizado para ofrecer el mejor rendimiento con Nginx.</p>
                </div>
            </div>

            <div class="specs">
                <h3><i class="fas fa-cogs"></i> Especificaciones Técnicas</h3>
                <div class="spec-grid">
                    <div class="spec-item">
                        <i class="fas fa-network-wired"></i>
                        <h4>Red y Puertos</h4>
                        <p>Puerto 8080 (Host) → 80 (Contenedor)</p>
                    </div>
                    <div class="spec-item">
                        <i class="fas fa-folder"></i>
                        <h4>Volúmenes</h4>
                        <p>/proyecto/web → /usr/share/nginx/html</p>
                    </div>
                    <div class="spec-item">
                        <i class="fas fa-box"></i>
                        <h4>Contenedor</h4>
                        <p>nginx:latest</p>
                    </div>
                    <div class="spec-item">
                        <i class="fas fa-play-circle"></i>
                        <h4>Modo</h4>
                        <p>Detached (Segundo Plano)</p>
                    </div>
                </div>
            </div>

            <div class="tech-stack">
                <span class="tech-item">Docker</span>
                <span class="tech-item">Nginx</span>
                <span class="tech-item">HTML5</span>
                <span class="tech-item">CSS3</span>
                <span class="tech-item">JavaScript</span>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <h3>Estado del Sistema</h3>
                <p><strong>Grupo 01</strong> | <span id="fecha-hora"></span></p>
            </div>
        </div>

        <div class="footer">
            <p>&copy; 2024 Servidor Web Containerizado - Grupo 01. Todos los derechos reservados.</p>
        </div>
    </div>

    <script>
        // Actualizar fecha y hora
        function actualizarFechaHora() {
            const ahora = new Date();
            const opciones = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            };
            document.getElementById('fecha-hora').textContent = 
                ahora.toLocaleDateString('es-ES', opciones);
        }
        
        actualizarFechaHora();
        setInterval(actualizarFechaHora, 1000);
    </script>
</body>
</html>
EOF

if [ -f "/proyecto/web/index.html" ]; then
    success "Archivo index.html creado correctamente en /proyecto/web/"
else
    error "Error al crear el archivo index.html"
    exit 1
fi

# Paso 2: Detener contenedor existente si existe
echo "Verificando contenedores existentes..."
if docker ps -a | grep -q nginx-grupo01; then
    warning "Contenedor nginx-grupo01 existente encontrado, deteniendo y eliminando..."
    docker stop nginx-grupo01 > /dev/null 2>&1
    docker rm nginx-grupo01 > /dev/null 2>&1
    success "Contenedor anterior eliminado"
fi

# Paso 3: Ejecutar contenedor Nginx
echo "Ejecutando contenedor Nginx..."
if docker run -d \
    --name nginx-grupo01 \
    -p 8080:80 \
    -v /proyecto/web:/usr/share/nginx/html \
    --restart unless-stopped \
    nginx:latest > /dev/null 2>&1; then
    success "Contenedor Nginx ejecutado correctamente"
else
    error "Error al ejecutar el contenedor Nginx"
    exit 1
fi

# Paso 4: Verificar que el contenedor está funcionando
echo "Verificando estado del contenedor..."
sleep 3
if docker ps | grep -q nginx-grupo01; then
    success "Contenedor Nginx está en ejecución"
else
    error "El contenedor no se está ejecutando"
    docker logs nginx-grupo01
    exit 1
fi

echo ""
echo "=== 5.2 VERIFICACIÓN DEL SERVICIO WEB ==="

# Paso 5: Verificar acceso web
echo "Verificando acceso al servidor web..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200"; then
    success "Servidor web responde correctamente (HTTP 200)"
else
    error "El servidor web no responde correctamente"
    docker logs nginx-grupo01
    exit 1
fi

# Paso 6: Verificar contenido servido
echo "Verificando contenido servido..."
if curl -s http://localhost:8080 | grep -q "Servidor Web Containerizado"; then
    success "Contenido HTML se está sirviendo correctamente"
else
    error "El contenido no se está sirviendo correctamente"
    exit 1
fi

# Paso 7: Revisar logs del contenedor
echo "Revisando logs del contenedor..."
if docker logs nginx-grupo01 2>&1 | grep -q -E "(error|Error|ERROR)"; then
    warning "Se encontraron errores en los logs:"
    docker logs nginx-grupo01 | grep -E "(error|Error|ERROR)"
else
    success "No se encontraron errores en los logs del contenedor"
fi

# Paso 8: Mostrar información final
echo ""
echo "=== INFORMACIÓN DEL SERVICIO ==="
success " Servidor web containerizado configurado exitosamente"
echo ""
echo " INFORMACIÓN:"
echo "    URL de acceso: http://localhost:8080"
echo "    Directorio contenido: /proyecto/web/"
echo "    Contenedor: nginx-grupo01"
echo "    Puerto: 8080 (Host) → 80 (Contenedor)"
echo "    Volumen: /proyecto/web → /usr/share/nginx/html"
echo ""
echo " COMANDOS ÚTILES:"
echo "   Ver logs: docker logs nginx-grupo01"
echo "   Ver estado: docker ps nginx-grupo01"
echo "   Detener: docker stop nginx-grupo01"
echo "   Iniciar: docker start nginx-grupo01"
echo "   Reiniciar: docker restart nginx-grupo01"
echo ""
echo "=========================================="
success "SERVIDOR WEB CONTAINERIZADO - CONFIGURACIÓN COMPLETADA"
echo "=========================================="
