# ORGA2 + MacOS

Este pequeño script levanta un container Docker con Ubuntu 22.10 y las herramientas de ORGA2 ya instaladas. De esta forma podes codear usando tu editor favorito directamente en MacOS, y luego compilar, ejecutar y debugear en Linux.

## Configuración

### Docker

- Instalá [Docker](https://docs.docker.com/desktop/mac/install/) si no lo tenés.
- Activá la opción para usar [VirtioFS](https://www.docker.com/blog/speed-boost-achievement-unlocked-on-docker-desktop-4-6-for-mac/) (sino vas a tener serios problemas de performance al leer/escribir archivos).

### PATH

Agregá en tu `$PATH` la carpeta donde está este README así podes ejecutar el comando `orga2shell` desde cualquier ubicación.

### Imagen de Docker

La primera vez que ejecutás el script se va a buildear la imagen de Docker. Esto puede tardar un ratito, pero después ya queda cacheado localmente.

## Modo de uso

Te parás en cualquier carpeta de tu filesystem, generalmente donde tenes el código fuente en assembler o C, y ejecutás este comando.

```bash
orga2shell
```

Adentro del container, vas a tener montado en `/workspace` la carpeta del host (MacOS) donde estabas al momento de ejecutar el comando.

## Bochs

Para correr bochs hay que hacer algunos malabares porque tiene una interfaz gráfica. Si bien hay una opción para compilar Bochs de forma nativa para MacOS, no me funcionó. Lo que hacemos entonces es correr Bochs adentro del container usando `vncsrv` como display library. Algo así como correrlo en modo "headless" y luego conectarse desde afuera del container con algún cliente VNC, por ejemplo [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/).

Adentro del container corrés Bochs normalmente, y luego de inicializar algunas cosas se queda en este mensaje esperando la conexión por VNC.

```
Bochs VNC server waiting for client
```

En MacOS abrís el cliente de VNC, te conectás a `localhost:5900` y listo.
