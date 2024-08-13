# Proyecto para depurar Django con vs code (2024) #

Este proyecto está descompuesto en tres partes:
1. El dockerfile para preparar la parte de depuración
2. El docker compose habilitado para levantar los servicios en producción (gunicorn)
3. El docker compose habilitado para depurar

## Dockerfile ##
El Docker file se compila en 2 fases:
1. La fase de la aplicación (app). Esta es una app cualquiera creada con django.
2. La fase de depuración (debug). Aquí se adjunta el módulo de depuración (debugpy)

## Docker compose (prod) ##
Este docker compose, no difiere de otro tipo de ejecución de contenedores y ejecuta la aplicación en producción (con gunicorn)


## Docker compose (debug, por defecto) ##
Este docker mezcla 2 servicios: El servicio base que se crea a partir del dockerfile base, y los servicios de depuración que quedan expuestos en el puerto 5678.

Cuando se ejecuta:

```bash
docker compose up
```
o bien 
```bash
docker compose up -d
```
Sólo se ejecuta el servicio web de django (la app), por lo que no se puede depurar.

Sin embargo, si se ejecuta:
```bash
docker compose --profile debug up
```
o bien 
```bash
docker compose --profile debug up -d
```



