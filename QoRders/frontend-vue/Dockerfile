# Usa una imagen base con Node.js
FROM node:18

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de configuración y dependencias de npm
COPY package*.json ./

# Instala las dependencias del proyecto
RUN npm install

# Copia todos los archivos de la aplicación
COPY . .

# Expone el puerto predeterminado de desarrollo de Vue.js
EXPOSE 5001

# Comando por defecto para iniciar el servidor de desarrollo
CMD ["npm", "run", "dev"]