# Imagen base con PHP y extensiones necesarias
FROM php:8.2-fpm

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libonig-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo_mysql mbstring zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar proyecto
WORKDIR /var/www/html
COPY . .

# Instalar dependencias PHP
RUN composer install --optimize-autoloader --no-dev

# Generar key de Laravel
RUN php artisan key:generate

# Exponer puerto
EXPOSE 8000

# Comando para correr Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
