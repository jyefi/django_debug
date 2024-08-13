# Proyecto para depurar Django con vs code (2024) #

## Setup (Probado en) ##
```bash

           `-/osyhddddhyso/-`               
        .+yddddddddddddddddddy+.           --------------- 
      :yddddddddddddddddddddddddy:         OS: Xubuntu 22.04.4 LTS x86_64 
    -yddddddddddddddddddddhdddddddy-       Kernel: 6.5.0-44-generic 
   odddddddddddyshdddddddh`dddd+ydddo      DE: Xfce 4.16 
 `yddddddhshdd-   ydddddd+`ddh.:dddddy`    WM: Xfwm4 
 sddddddy   /d.   :dddddd-:dy`-ddddddds    WM Theme: Greybird 
:ddddddds    /+   .dddddd`yy`:ddddddddd:   Theme: Greybird [GTK2/3] 
sdddddddd`    .    .-:/+ssdyodddddddddds   Icons: elementary-xfce-darker [GTK2/ 
ddddddddy                  `:ohddddddddd   
dddddddd.                      +dddddddd   
sddddddy                        ydddddds   
:dddddd+                      .oddddddd:   
 sdddddo                   ./ydddddddds    
 `yddddd.              `:ohddddddddddy`    
   oddddh/`      `.:+shdddddddddddddo      
    -ydddddhyssyhdddddddddddddddddy-       
      :yddddddddddddddddddddddddy:         
        .+yddddddddddddddddddy+.           
           `-/osyhddddhyso/-`
```

Este proyecto está descompuesto en cuatro partes:
1. El dockerfile para preparar la parte de depuración
2. El docker compose habilitado para levantar los servicios en producción (gunicorn)
3. El docker compose habilitado para depurar
4. Adjuntar el servicio de depuración en vscode

TODO:
Probar en Windows.

## Prerrequisitos ##
- Docker desktop
- Visual studio Code (este código fue probado con la versiónn 1.92.1 para Linux)
- Extensiones de depuración para python de vscode
- Extensión de Docker para vscode

## Paso 1: Creación del proyecto Django (opcional) ##
El presente proyecto ya viene con un proyecto de eejemplo incorporado, sin embargo, si quieres cambiar el nombre del proyecto o bien, ya tienes un proyecto creado en Django, simplemente debes eliminar los fichero existentes en la carpeta app, y copiar los ficheros de tu proyecto a la misma carpeta (app).

Para crear el proyecto Django, se puede utilizar el fichero django-create-app.sh que se adjunta en el proyecto. Con ello se crea el proyecto en la carpeta app.

En caso de probar en windows, simplemente se puede ejecutar vía línea de comandos:

```bash
docker run -v [ruta_actual]/app:/app -w /app [imagen_python] sh -c "pip install Django==[version_django] && django-admin startproject [nombre_proyecto] ."
```
Donde:
[ruta_actual]: corresponde a la ruta completa del proyecto (C:\Users...)
[imagen_python]: es la imagen que deseas utilizar. Personalmente uso la imagen:  python:slim-bullseye
[version_django]: es la versión que deseas utilizar de Django. Personalmente recomiendo versiones 5.x.x+
[nombre_proyecto]: es el nombre del proyecto django que deseas implementar.

***(Pendiente de probar)***

*Notas*
- Si cambias el nombre de la aplicación, debes replicar los cambios en los ficheros docker-compose
- Esto solo ha sido probado en Linux (también podría funcionar en Mac)

## Paso 2: Dockerfile ##

El Docker file se compila en 2 fases:
1. La fase de la aplicación (app). Esta es una app cualquiera creada con django.
2. La fase de depuración (debug). Aquí se adjunta el módulo de depuración (debugpy)

## Paso 3: ficheros compose ##

### Docker compose (prod) ###
Este docker compose, no difiere de otro tipo de ejecución de contenedores y ejecuta la aplicación en producción (con gunicorn)
```bash
docker compose -f docker-compose.prod.yml -d
```


### Docker compose (debug) ###
Este docker mezcla 2 servicios: El servicio base que se crea a partir del dockerfile base, y los servicios de depuración que quedan expuestos en el puerto 5678.

Cuando se ejecuta:

```bash
docker compose up
```
o bien 
```bash
docker compose up -d
```
Sólo se ejecuta el servicio web de django (la app), por lo que ***no se puede depurar***.


Sin embargo, si se ejecuta:
```bash
docker compose --profile debug up
```
o bien 
```bash
docker compose --profile debug up -d
```
*** Notas ***
''-d'': indica que los servicios se ejecutan en formato *detached*, es decir, se ejecutan en background (no de manera interactiva).

En algunos sistemas de docker se utiliza "docker-compose" en vez de "docker compose"


En el caso de ejecutar la opción con el perfil de depuración, se generan 2 contenedores:
- django_debug-example-web-1 (inactivo) y 
- django_debug-example-debug-1 (activo)


![Contenedores](https://github.com/jyefi/django_debug/blob/main/doc/img/containers.png?raw=true)


Esto ocurre, porque como el perfil de depuración "extiende" desde el servicio web, compose, primero prepara el contenedor del servicio web, y posteriormente genera el contenedor de debug, dejando inactivo el primero.

Si necesitas eliminar memoria, simplemente puedes remover el contenedor, con las extensiones de vscode y docker, o bien vía línea de comandos con docker ps -a y docker rm [id del contenedor].

## Paso 4: adjuntar el proceso remoto  ##
Una vez ejecutado el contenedor en modo debug, simplemente se debe ejecutar y depurar en vscode:

Para ello, vas a la ventana de "Run and debug":


![Run and debug](https://github.com/jyefi/django_debug/blob/main/doc/img/run_and_debug.png?raw=true)

Y das click en play (Attach (Remote Django App))

![Start Debugging](https://github.com/jyefi/django_debug/blob/main/doc/img/start_debbugging.png?raw=true)

Si tienes puntos de depuración marcados en la aplicación, estos se activarán:

![Debugging](https://github.com/jyefi/django_debug/blob/main/doc/img/debugging.png?raw=true)

Finalmente, para terminar la sesión de depuración, simplemente debes hacer clic en el ícono "Disconnect" o bien terminar con Shift + F5.

**IMPORTANTE:**
Este proyecto se distribuye AS-IS, y se puede tomar como plantilla para la depuración de proyectos existentes.

La depuración solo se debe habilitar **en ambientes de desarrollo**. No se recomienda implementar esto en ambientes de **producción**.

### Referencias ###
- Basado en el trabajo de Davi Candido (https://medium.com/@davivc/debugging-django-python-dockerized-applications-ff8ba843e6dd)
- y en el trabajo de Mark Winterbottom (
https://londonappdeveloper.com/debugging-a-dockerized-django-app-with-vscode/)
