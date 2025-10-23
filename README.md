# Instalación y ejecución de los entornos

A continuación se detallan las instrucciones para la **instalación y ejecución** de la aplicación utilizando **Docker** y **Makefile**.

---

## Requisitos

Antes de comenzar, asegúrate de tener instalados los siguientes componentes:

- **Docker** ≥ 24.x  
- **Docker Compose** ≥ v2.20  
- **GNU Make**, necesario para ejecutar los comandos definidos en el `Makefile`

Verifica que Docker y Compose estén correctamente instalados ejecutando:

```bash
docker --version
docker compose version

git clone https://github.com/tu-usuario/tu-proyecto.git
cd tu-proyecto

```
Instalación entorno de desarrollo
```bash
make build-dev
```
Ejecución entorno de desarrollo
```bash
make up-dev
```
Acceso entorno de desarrollo en el puerto 5005
http://localhost:5005

Endpoint para comprobar estado de los servicios
http://localhost:5005/status

Para parar el entorno y eliminar los contenedores
```bash
make stop-dev     # Detiene los contenedores sin eliminarlos
make down-dev     # Elimina los contenedores sin borrar volúmenes
make clean-dev    # Limpia todo (contenedores + volúmenes + caché Docker)
```
---

Instalación entorno de producción
```bash
make build-prod
```
Ejecución entorno de producción
```bash
make up-prod
```
Acceso entorno de producción en el puerto 5010
http://localhost:5010

Endpoint para comprobar estado de los servicios
http://localhost:5010/status

Para parar el entorno y eliminar los contenedores
```bash
make stop-prod     # Detiene los contenedores sin eliminarlos
make down-prod     # Elimina los contenedores sin borrar volúmenes
make clean-prod    # Limpia todo (contenedores + volúmenes + caché Docker)
```
---
## Descripción de los entornos

### Entorno de desarrollo

El entorno de **desarrollo** está pensado para facilitar la programación, las pruebas y la depuración del código.  
A diferencia del entorno de producción, **la aplicación no se incluye dentro de la imagen**, sino que se **monta como un volumen** sobre el contenedor.  
Esto permite realizar cambios en el código fuente y verlos reflejados al momento sin necesidad de reconstruir la imagen.
No se incluye Redis como memoria caché

**Características docker-compose.dev.yml:**
- El contenedor de Flask se ejecuta con `FLASK_DEBUG=1` para permitir que los cambios se vean reflejados sin hacer build.
- También con la variable `FLASK_ENV=development` que permite que la aplicación se configure en modo desarrollo.
- La aplicación se monta como volumen `../app:/app` para permitir edición en tiempo real.  
- Define únicamente los servicios `web` (Flask) y `db` (MySQL).  
- Usa variables de entorno desde el archivo `.env`.  

---

### Entorno de producción

El entorno de **producción** está diseñado para ejecutar la aplicación en un entorno estable, seguro e inmutable.  
En este caso, la aplicación **se incluye dentro de la imagen Docker** durante la fase de build, lo que evita modificaciones accidentales en el despliegue. 
No se monta ningún volumen, garantizando que el código no pueda alterarse en ejecución.  
También se incluye un usuario no root y permisos limitados dentro del contenedor Flask.

**Características docker-compose.prod.yml:**
- Incluye tres servicios:  
  - `web` → Aplicación Flask.  
  - `db` → Base de datos MySQL persistente.  
  - `cache` → Redis como sistema de caché en memoria.  
- Solo el servicio `web` expone un puerto al exterior (por ejemplo, `5010:5000`).  
- Gestiona las variables sensibles mediante `.env`.

---

**Resumen comparativo**

| Característica              | Desarrollo                          | Producción                          |
|-----------------------------|-------------------------------------|-------------------------------------|
| Montaje de código           | Volumen local (`../app:/app`)       | Incluido en la imagen               |
| Recarga automática          | Sí (`debug` activo)                 | No (`debug` desactivado)            |
| Servicios activos           | Flask + MySQL                       | Flask + MySQL + Redis               |
| Caché Redis                 | Deshabilitada                       | Activada                            |
| Exposición de puertos       | `5005:5000`                         | `5010:5000`                         |
| Seguridad                   | Usuario root                        | Usuario no root, permisos limitados |
| Objetivo principal          | Desarrollo y pruebas                | Despliegue estable y seguro         |
 ---------------------------------------------------------------------------------------------------------

Estructura del proyecto

Practica1/
│
├── app/                        			# Código fuente de la aplicación Flask
│   	├── __init__.py                	# Crea la app Flask y carga configuración
│   	├── routes.py                  	# Blueprint con las rutas principales
│   	├── cache.py                   	# Funciones de conexión y acceso a Redis
│   	├── config.py                  	# Clases de configuración (dev/prod)
│   	├── templates/
│   	│   	├── index.html		        # Interfaz web principal
│   	│   	└── status.html		        # Página del estado de los servicios
│   	└── static/
│       		└── style.css             # Estilos CSS de la interfaz
│
├── dev_env/                    			# Entorno de desarrollo
│   	├── Dockerfile                 	# Dockerfile para entorno desarrollo
│   	├── docker-compose.dev.yml     	# Docker-compose desarrollo
│   	├── .env                      	# Variables de entorno para dev
│   	├── .dockerignore              	# Excluye archivos innecesarios en build desarrollo
│   	├── init.sql                  	# Script SQL inicial (desarrollo)
│   	└── requirements.txt           	# Dependencias de Python para desarrollo
│
├── prod_env/                   			# Entorno de producción
│   	├── Dockerfile                 	# Dockerfile para entorno producción
│   	├── docker-compose.prod.yml    	#  Docker-compose producción
│   	├── .env                       	# Variables de entorno para producción
│   	├── .dockerignore              	# Excluye archivos innecesarios en build producción
│   	├── init.sql                   	# Script SQL inicial (producción)
│   	└── requirements.txt           	# Dependencias de Python para producción
│
├── Makefile                       		# Automatiza tareas (build, up, down, logs, etc.)
└── README.md                      		# Guía completa de instalación, uso y arquitectura

---
## Pruebas realizadas

### Entorno de desarrollo

Se ha realizado un conjunto de pruebas funcionales y de comportamiento sobre el entorno de desarrollo.  
Todas las pruebas han sido satisfactorias.

| Nº |  Descripción de la prueba | Resultado  |
|----|---------------------------|------------|
| 1  | Se ha hecho el **build de la imagen** .....................................................................| ✅ OK |
| 2  | Se han **levantado los servicios** con `docker compose` ...................................................| ✅ OK |
| 3  | Acceso correcto a la aplicación: [http://localhost:5005](http://localhost:5005) ...........................| ✅ OK |
| 4  | Acceso correcto al endpoint de estado: [http://localhost:5005/status](http://localhost:5005/status) .......| ✅ OK |
| 5  | Se **cargan los usuarios** desde la base de datos .........................................................| ✅ OK |
| 6  | Se **añade un nuevo usuario** correctamente ...............................................................| ✅ OK |
| 7  | Se **elimina un usuario** correctamente ...................................................................| ✅ OK |
| 8  | Se **detiene la base de datos** y la aplicación continúa funcionando ......................................| ✅ OK |
| 9  | Con la BD parada, se intenta cargar usuarios y la app responde correctamente con error controlado .........| ✅ OK |
| 10 | En el endpoint `/status`, el estado de la BD cambia a **DOWN** ............................................| ✅ OK |
| 11 | Se **reinicia el contenedor de la base de datos** .........................................................| ✅ OK |
| 12 | Se **vuelven a cargar los usuarios**, comprobando que la conexión se restablece ...........................| ✅ OK |
| 13 | En el endpoint `/status`, el estado de la BD vuelve a **UP** ..............................................| ✅ OK |
| 14 | Se **elimina la imagen de la base de datos** y se recrea sin errores ......................................| ✅ OK |
| 15 | Se **cargan los usuarios nuevamente** comprobando la **persistencia de datos** ............................| ✅ OK |


**Conclusión:**  
El entorno de desarrollo funciona correctamente.  
La aplicación mantiene su estabilidad incluso si la base de datos se detiene temporalmente,  
y los endpoints reflejan adecuadamente el estado de los servicios.  
La persistencia de datos ha sido probada con éxito después de haber eliminado y posteriormente creado el contenedor con MYSQL.

### Entorno de producción

Se ha realizado un conjunto de pruebas para verificar el correcto funcionamiento del entorno de producción, incluyendo el uso de caché con Redis.

| Nº |  Descripción de la prueba | Resultado  |
|----|---------------------------|------------|
| 1  | Se ha hecho el **build de la imagen** con `make build-prod` .........................................................| ✅ OK |
| 2  | Se han **levantado los servicios** `web`, `db` y `cache` con `make up-prod` .........................................| ✅ OK |
| 3  | Acceso correcto a la aplicación: [http://localhost:5010](http://localhost:5010) .....................................| ✅ OK |
| 4  | Acceso correcto al endpoint de estado: [http://localhost:5010/status](http://localhost:5010/status) .................| ✅ OK |
| 5  | Se **cargan los usuarios** desde la base de datos MySQL .............................................................| ✅ OK |
| 6  | Se **añade un nuevo usuario** y se refleja correctamente en la interfaz .............................................| ✅ OK |
| 7  | Se **elimina un usuario** correctamente .............................................................................| ✅ OK |
| 8  | Se **detiene la base de datos (MySQL)**, se cargan usuarios, cargan desde la caché ..................................| ✅ OK |
| 9  | En el endpoint `/status`, el estado de la BD cambia a **DOWN** ......................................................| ✅ OK |
| 10 | Se **vuelve a iniciar el contenedor de MySQL** y se restablece la conexión ..........................................| ✅ OK |
| 11 | Se **vuelven a cargar los usuarios**, comprobando que la aplicación vuelve a usar la base de datos ..................| ✅ OK |
| 12 | En el endpoint `/status`, la BD vuelve a **UP** .....................................................................| ✅ OK |
| 13 | Se **detiene el contenedor de Redis (cache)** y se accede al endpoint, caché **DOWN** ...............................| ✅ OK |
| 14 | La aplicación continúa funcionando accediendo directamente a la base de datos .......................................| ✅ OK |
| 15 | Se **vuelve a inicar el contenedor Redis** y el estado vuelve a **UP** automáticamente ..............................| ✅ OK |
| 16 | Se comprueba el estado de los contenedores con `docker ps`, todos **healthy**........................................| ✅ OK |

---

**Conclusión:**  
El entorno de producción funciona correctamente.  
Redis almacena en caché las consultas y permite continuar haciendo las consultas cacheadas.  
Los *healthchecks* reflejan en tiempo real el estado de los servicios (`web`, `db`, `cache`).
Solo el servicio `web` expone su puerto al exterior, cumpliendo con las medidas de aislamiento y seguridad.



---
### Healthcheck
El healthcheck de los contenedores se hace empleando la condiguración healthcheck de docker-compose.
Cada contenedor emplea un comando CMD y sus respectivos parámetros para checkear el contenedor

Contenedor web:
test: ["CMD", "curl", "-f", "http://localhost:5000/"]

Contenedor MYSQL:
test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-p${MYSQL_ROOT_PASSWORD}"]

Contenedor Redis:
test: ["CMD", "redis-cli", "ping"]

Todos ellos con un intervalo y un número de reintentos
Por otro lado se han implementado en la interfaz gráfica de la web recuadro con los servicios y si estado.
Los estados cambian de manera automática gracias a la implementación en la aplicación web.

Por último se ha implementado un healthcheck en el endpoint /status que devuelve simplemente el estado de los servicios.

---
Resumen de comandos disponibles en el Makefile

Los comando se deben ejecutar desde la carpeta raíz del proyecto, se pueden consultar todos con el comando help.

```bash
  make restart                       #- Reinicia el servicio de Docker
  make start c=CONTAINER ID         #- Inicia un contenedor especificado
  make stop c=CONTAINER ID          #- Para un contenedor especificado
  make ps                           #- Muestra todos los contenedores en ejecución
  make up-dev                       #- Levanta el entorno de desarrollo
  make down-dev                     #- Detiene y elimina los contenedores de desarrollo
  make build-prod                   #- Construye la imagen de producción
  make up-prod                      #- Levanta el entorno de producción
  make clean-prod                   #- Limpia contenedores y caché de Docker
  make ps-dev                       #- Muestra el estado de los contenedores dev
  make ps-prod                      #- Muestra el estado de los contenedores prod
```