# Usar una imagen base de Node.js
FROM node:18

# Establecer el directorio de trabajo
WORKDIR /usr/src/app

# Copiar los archivos necesarios
COPY package*.json ./

# Instalar las dependencias
RUN npm install

# Copiar todo el código de la aplicación
COPY . .

# Exponer el puerto de la aplicación
EXPOSE 3001

# Establecer el comando de inicio
CMD ["npm", "run", "dev"]