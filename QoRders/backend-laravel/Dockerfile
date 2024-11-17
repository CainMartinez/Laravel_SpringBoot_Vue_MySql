# Usa una imagen base de PHP 8.1 con extensiones necesarias
FROM php:8.1-fpm

# Instala Composer y otras dependencias necesarias
RUN apt-get update && \
    apt-get install -y curl git unzip libpng-dev libonig-dev libxml2-dev zip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala extensiones adicionales de PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto al contenedor
COPY . .

# Instala dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Ajusta permisos de las carpetas requeridas
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expone el puerto HTTP
EXPOSE 8000

# Comando por defecto
CMD ["php-fpm"]
