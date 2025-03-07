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