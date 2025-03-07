# ArquitecturaSFV-P1

# Evaluación Práctica - Ingeniería de Software V

## Información del Estudiante

- **Nombre:** Juan David Colonia Aldana
- **Código:** A00395956
- **Fecha:** 7 de marzo de 2025

## Resumen de la Solución

Esta solución implementa la contenerización de una aplicación Node.js utilizando Docker, permitiendo un despliegue reproducible y escalable. Además, se ha desarrollado un script de automatización en Bash para gestionar la construcción, ejecución y verificación del servicio sin intervención manual. Se han aplicado principios clave de DevOps como automatización, infraestructura como código y monitoreo para asegurar una entrega eficiente y confiable del software.

## Dockerfile

```Dockerfile
# Usa la imagen base de Node.js
FROM node:22-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos package*.json para instalar dependencias
COPY package*.json ./

# Instala las dependencias
RUN npm install --production

# Copia el resto de los archivos de la aplicación
COPY . .

# Expone el puerto en el que se ejecutará la aplicación
EXPOSE 8080

# Define las variables de entorno
ENV PORT=8080
ENV NODE_ENV=production

# Comando para ejecutar la aplicación
CMD ["npm", "start"]
```

### Decisiones Técnicas

El Dockerfile se ha diseñado siguiendo buenas prácticas para optimizar la imagen:

- Se usa una imagen base oficial de Node.js para asegurar compatibilidad.
- Se copian únicamente los archivos necesarios para minimizar el tamaño de la imagen.
- Se utiliza`npm install --only=production` para reducir dependencias innecesarias en producción.
- Se expone el puerto 8080, que es el definido en las variables de entorno.
- Se establece el comando de inicio como `CMD ["node", "app.js"]` para ejecutar la aplicación.

## Script de Automatización

```bash
#!/bin/bash

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null
then
    echo "Error: Docker no está instalado."
    exit 1
fi

# Definir variables
IMAGE_NAME="devops-app"
CONTAINER_NAME="devops-container"
PORT=8080
NODE_ENV=production

# Construir la imagen de Docker
echo "Construyendo la imagen de Docker..."
docker build -t $IMAGE_NAME .

# Verificar si ya hay un contenedor en ejecución y detenerlo
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "Deteniendo contenedor existente..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

# Ejecutar el contenedor
echo "Ejecutando el contenedor..."
docker run -d --name $CONTAINER_NAME -p $PORT:$PORT -e NODE_ENV=$NODE_ENV $IMAGE_NAME

# Verificar si el contenedor está en ejecución
if [ $? -ne 0 ]; then
    echo "Error al ejecutar el contenedor."
    exit 1
fi

# Esperar unos segundos para asegurar que el contenedor esté en marcha
sleep 5

# Realizar una prueba básica con curl
echo "Realizando prueba básica..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT)

if [ "$response" == "200" ]; then
    # Imprimir el código de estado y el cuerpo de la respuesta
    echo "Código de estado: $response"
    # Imprimir el contenido de la respuesta
    echo "Cuerpo de la respuesta:"
    curl -s http://localhost:$PORT
    echo ""
    # Imprimir un log exitoso
    echo "La aplicación está funcionando correctamente."
else
    echo "Error: La aplicación no respondió como se esperaba."
    exit 1
fi

# Resumen del estado
echo "Resumen del estado:"
echo " - Docker está instalado."
echo " - La imagen se construyó correctamente."
echo " - El contenedor está en ejecución."
echo " - La prueba básica fue exitosa."
```

### Funcionalidades Implementadas

- **Verificación de Docker:** Verifica si Docker está instalado antes de proceder.
- **Construcción de la Imagen:** Construye la imagen de Docker automáticamente.
- **Verificación de Contenedor:** Verifica si existe un contenedor en ejecución. Si lo hay lo detiene y elimina.
- **Ejecución del Contenedor:** Ejecuta el contenedor con las variables de entorno adecuadas.
- **Verificación de Ejecución:** Verifica si el contenedor está en ejecución.
- **Prueba Básica:** Realiza una prueba básica utilizando curl para verificar que la aplicación responde correctamente.
- **Manejo de Errores:** El script maneja errores en cada paso y proporciona un resumen del estado al final.

## Principios DevOps Aplicados

1. **Automatización de Procesos:** Se implementó un script de automatización que verifica la instalación de Docker, construye la imagen, ejecuta el contenedor y valida el funcionamiento de la aplicación. Esto reduce la intervención manual y minimiza errores humanos.
2. **Contenerización:** La aplicación se contenerizó utilizando Docker, lo que garantiza que funcione de manera consistente en cualquier entorno (desarrollo, pruebas, producción). Esto facilita la implementación en diferentes infraestructuras.
3. **Integración Continua (CI):** Aunque no se implementó un pipeline de CI en esta solución, el script de automatización sienta las bases para integrarse con herramientas como Jenkins o GitHub Actions, permitiendo builds y despliegues automatizados.

## Captura de Pantalla

![Image](./images/Captura%20de%20pantalla%202025-03-07%20124553.png)

## Mejoras Futuras

1. **Implementación de un Pipeline de CI/CD:** Integrar la solución con herramientas de integración y despliegue continuo (como Jenkins, GitHub Actions) para automatizar completamente el proceso de construcción, pruebas y despliegue.
2. **Pruebas Automatizadas:** Añadir pruebas unitarias, de integración y de carga para garantizar la calidad del código y la estabilidad de la aplicación en diferentes escenarios.
3. **Escalabilidad y Orquestación:** Utilizar un orquestador de contenedores como Kubernetes para gestionar múltiples instancias de la aplicación, mejorar la escalabilidad y garantizar alta disponibilidad.
4. **Gestión de Configuraciones:** Utilizar herramientas Terraform para gestionar configuraciones y despliegues de manera más eficiente y reproducible.
5. **Optimización de la Imagen Docker:** Mejorar el Dockerfile utilizando técnicas como multi-stage builds para reducir el tamaño de la imagen y eliminar dependencias innecesarias.

## Instrucciones para Ejecutar

1. **Clonar el Repositorio:**

   ```bash
   git clone https://github.com/jdColonia/ArquitecturaSFV-P1
   cd ArquitecturaSFV-P1
   ```

2. **Ejecutar el Script de Automatización:**

   ```bash
   chmod +x script.sh
   ./script.sh
   ```

3. **Verificar la Aplicación:**
   - Abre tu navegador y visita `http://localhost:8080`.
   - Deberías ver un mensaje de bienvenida y la información del servidor. También por consola deberías poder ver los logs.
