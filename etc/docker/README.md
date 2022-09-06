# ORGA2 + MacOS

Este pequeño script levanta un container Docker con Ubuntu 22.10 y las herramientas de ORGA2 ya instaladas. De esta forma podes codear usando tu editor favorito directamente en MacOS, y luego compilar, ejecutar y debugear en Linux.

## Configuración

### Docker
Instalar [Docker](https://docs.docker.com/desktop/mac/install/) si no lo tenés.

### PATH

Agregá esta carpeta en tu `$PATH` así podes ejecutar el comando `orga2shell` desde cualquier ubicación.

### Imagen de Docker

La primera vez que ejecutes el script se va a buildear la imagen de Docker. Esto puede tardar un ratito, pero después ya queda cacheado localmente.

## Modo de uso

Te parás en cualquier carpeta de tu filesystem, generalmente donde tenes el código fuente en asembler o C, y ejecutas este comando.

```bash
orga2shell
```

Adentro del container, vas a tener montado en `/workspace` la carpeta del host (MacOS) donde estabas al momento de ejecutar el comando.
