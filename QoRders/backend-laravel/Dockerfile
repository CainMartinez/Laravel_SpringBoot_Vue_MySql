# Usa una imagen base de PHP 8.1 con las extensiones necesarias para Laravel
FROM php:8.1-fpm

# Instala Composer
RUN apt-get update && \
    apt-get install -y curl git unzip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala dependencias adicionales de PHP
RUN docker-php-ext-install pdo pdo_mysql

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia los archivos de la aplicación a la imagen
COPY . .

# Instala las dependencias de Composer
RUN composer install

# Genera la clave de aplicación y optimiza el autoload
RUN php artisan key:generate && \
    php artisan config:cache && \
    php artisan route:cache

# Expone el puerto en el que el servidor de Laravel servirá la aplicación
EXPOSE 8000

# Comando por defecto para iniciar el servidor
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]