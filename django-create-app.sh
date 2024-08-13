#!/bin/bash

# Valores predeterminados
DEFAULT_DJANGO_VERSION="5.0.2"
DEFAULT_IMAGE_VERSION="python:slim-bullseye"

# Función para leer la entrada del usuario con un mensaje
read_input() {
    local prompt="$1"
    local var_name="$2"
    local default_value="$3"
    
    read -p "$prompt [$default_value]: " input
    if [ -z "$input" ]; then
        input="$default_value"
    fi
    eval "$var_name=\"$input\""
}

# Pedir el nombre del proyecto (obligatorio)
while [ -z "$PROJECT_NAME" ]; do
    read -p "Ingrese el nombre del proyecto (obligatorio): " PROJECT_NAME
    if [ -z "$PROJECT_NAME" ]; then
        echo "El nombre del proyecto es obligatorio. Por favor, ingréselo nuevamente."
    fi
done

# Leer la versión de Django con valor predeterminado
read_input "Ingrese la versión de Django" DJANGO_VERSION "$DEFAULT_DJANGO_VERSION"

# Leer la versión de la imagen con valor predeterminado
read_input "Ingrese la versión de la imagen" IMAGE_VERSION "$DEFAULT_IMAGE_VERSION"

# Ejecutar el comando Docker con los valores proporcionados
docker run -v ${PWD}/app:/app -w /app "$IMAGE_VERSION" sh -c "pip install Django==$DJANGO_VERSION && django-admin startproject $PROJECT_NAME ."

echo "Proyecto Django '$PROJECT_NAME' creado con Django $DJANGO_VERSION en la imagen $IMAGE_VERSION."