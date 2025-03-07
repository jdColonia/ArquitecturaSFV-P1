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
