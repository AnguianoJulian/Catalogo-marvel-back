# Base PHP con FPM
FROM php:8.2-fpm

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libonig-dev \
    libzip-dev \
    zip \
    curl \
    && docker-php-ext-install pdo_mysql mbstring zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Configurar directorio de trabajo
WORKDIR /var/www/html

# Copiar proyecto
COPY . .

# Instalar dependencias Laravel
RUN composer install --optimize-autoloader --no-dev

# Generar key de Laravel
RUN php artisan key:generate

# Crear storage link (opcional si usas storage)
RUN php artisan storage:link

# Exponer puerto que Render necesita
EXPOSE 8000

# Comando para arrancar Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
