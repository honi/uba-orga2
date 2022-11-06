# Ejercicio 1

| Lógica              | Lineal       | Física       | Acción          |
|---------------------|--------------|--------------|-----------------|
| `0x0060:0x00123001` | `0x00123011` | `0x01123001` | Leer código     |
| `0x0060:0x88A94100` | `0x88A94110` | `0x00000110` | Ejecutar código |
| `0x0030:0x00000000` | `0xF0000000` | `0x00000000` | Leer Datos      |
| `0x0030:0x00399FFF` | `0xF0399FFF` | `0x00000FFF` | Escribir Datos  |

## Segmentación

Primero analizamos los selectores de segmento para determinar qué entrada de la GDT se utilizaría para resolver cada dirección lógica. En base a esto, podemos definir las entradas de la GDT necesarias para el mapeo pedido.

### Selectores

Un selector de segmento tiene el siguiente formato:

```
0000000000000 0  00
Index         TI RPL
```

Observemos que en las 4 direcciones lógicas se utilizan únicamente 2 selectores de segmento únicos: `0x0060` y `0x0030`. Por lo tanto vamos a tener que definir solo 2 segmentos.

| Hex      | Binario              | Index | TI        | RPL |
|----------|----------------------|-------|-----------|-----|
| `0x0060` | `0000000001100 0 00` | `0xC` | `0` (GDT) | `0` |
| `0x0030` | `0000000000110 0 00` | `0x6` | `0` (GDT) | `0` |

### Bases

Ya sabemos que hay 2 segmentos. Por las direcciones lógicas a mapear y las acciones a realizar, notemos que el segmento con index `0xC` corresponde a un segmento de código, mientras que el otro con index `0x6` es de datos.

La dirección lineal se obtiene sumando la base del segmento con el offset de la dirección lógica. Conocemos la dirección lineal y el offset, pero no la base. Podemos despejar y obtener así la base de cada segmento.

**Segmento de código**

```
Base + 0x00123001 = 0x00123011 <=> Base = 0x10
Base + 0x88A94100 = 0x88A94110 <=> Base = 0x10
```

**Segmento de datos**

```
Base + 0x00000000 = 0xF0000000 <=> Base = 0xF0000000
Base + 0x00399FFF = 0xF0399FFF <=> Base = 0xF0000000
```

Como es de esperarse, cada par de direcciones lógicas de cada segmento (código y datos) generan las mismas bases. Si no pasara esto habría algún error pues necesariamente la base tiene que ser la misma para todas las direcciones lógicas que utilizan el mismo selector de segmento.

### Límites

Debería ser suficiente tomar el offset máximo usado para cada segmento, y luego sumarle los bytes necesarios para contemplar que debemos acceder únicamente a 4 bytes a partir de ese offset (por enunciado).

El límite de un segmento es el offset del máximo byte direccionable dentro del segmento. Como las acciones realizadas acceden a 4 bytes, debemos sumarle solo 3 bytes al máximo offset.

**Segmento de código**

```
max(0x00123001, 0x88A94100) + 3 = 0x88A94100 + 3 = 0x88A94103
```

**Segmento de datos**
```
max(0x00000000, 0x00399FFF) + 3 = 0x00399FFF + 3 = 0x0039A002
```

Como los límites calculados exceden los 20 bits, vamos a configurar los descriptores con granularidad de 4Kb. Ajustamos los límites teniendo esto en cuenta.

**Segmento de código**

```
0x88A94103 >> 12 = 0x88A94
```

**Segmento de datos**
```
0x0039A002 >> 12 = 0x0039A
```

*Nota: Hubiese sido más rápido y simple utilizar `0xFFFFF` como límite, pero ya los calculé.*

## GDT

Habiendo calculado todos los segmentos necesarios, ya podemos armar la GDT.

En el registro `GDTR` tenemos que cargar la dirección física donde está la GDT en memoria. Es importante reservar esta dirección y que no sea utilizada por ninguna otra parte del sistema para preservar la GDT.

| Index   | GDT Offset | Descripción     | Base          | Límite    | P   | DPL | S   | E   | DC  | RW  | A   | G   | DB  | L   |
|---------|------------|-----------------|---------------|-----------|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| `0x0`   | `0x00`     | Descriptor nulo | `0`           | `0`       | `0` | `0` | `0` | `0` | `0` | `0` | `0` | `0` | `0` | `0` |
| `0xC`   | `0x60`     | Código          | `0x00000010`  | `0x88A94` | `1` | `0` | `1` | `1` | `0` | `1` | `0` | `1` | `1` | `0` |
| `0x6`   | `0x30`     | Datos           | `0xF0000000`  | `0x0039A` | `1` | `0` | `1` | `0` | `0` | `1` | `0` | `1` | `1` | `0` |

Justificación de los atributos:

- `P = 1` indica que el segmento es válido.
- `DPL = 0` indica el nivel de privilegio requerido para acceder al segmento. Por enunciado todos los accesos se realizan desde nivel 0.
- `S = 1` indica que el descriptor es de tipo código o datos (no sistema).
- Los atributos `E`, `DC`, `RW`, `A` indican el tipo de segmento. Para el segmento de código, estos 4 bits indican que el segmento es de código y permitimos la ejecución y lectura. Para el segmento de datos, indican que el segmento es de datos y permitimos leer y escribir.
- `G = 1` configura la granularidad a 4Kb.
- `DB = 1` indica que trabajamos con 32 bits.
- `L = 0` pues no lo usamos en 32 bits.

## Paginación

Ya tenemos nuestros segmentos. Ahora tenemos que configurar la paginación para poder traducir las direcciones lineales a físicas. Para esto, interpretamos las direcciones lineales de la siguiente manera:

```
DirectoryIndex[31:22]:TableIndex[21:12]:Offset[11:0]
```

| Lineal (hex) | Lineal (bin)                         | DirectoryIndex | TableIndex  | Offset  | Física       |
|--------------|--------------------------------------|----------------|-------------|---------|--------------|
| `0x00123011` | `0000000000 0100100011 000000010001` | `0x000`        | `0x123`     | `0x011` | `0x01123001` |
| `0x88A94110` | `1000100010 1010010100 000100010000` | `0x222`        | `0x294`     | `0x110` | `0x00000110` |
| `0xF0000000` | `1111000000 0000000000 000000000000` | `0x3C0`        | `0x000`     | `0x000` | `0x00000000` |
| `0xF0399FFF` | `1111000000 1110011001 111111111111` | `0x3C0`        | `0x399`     | `0xFFF` | `0x00000FFF` |

### Page Directory

Asumimos que en el registro `CR3` ya tenemos cargada la dirección física donde está el Page Directory. Lo que tenemos que armar ahora es el Page Directory en sí. Cada entrada del Page Directory contiene la dirección física (alineada a 4Kb) de la correspondiente Page Table, y a su vez, cada entrada de una Page Table contiene la dirección física (alineada a 4Kb) del Page Frame, a la cual se la suma el offset indicado en la direcciónal lineal para finalmente conseguir la traducción a la dirección física.

Necesitamos configurar solo 3 entradas en el Page Directory ya que de las 4 direcciones lineales, tenemos únicamente 3 DirectoryIndex únicos. Esto significa que las 2 direcciones que acceden a datos utilizan la misma Page Table.

| Index   | PageTable | PCD | PWT | U/S | R/W | P   |
|---------|-----------|-----|-----|-----|-----|-----|
| `0x000` | `0xF0000` | `0` | `0` | `0` | `0` | `1` |
| `0x222` | `0xF0001` | `0` | `0` | `0` | `0` | `1` |
| `0x3C0` | `0xF0002` | `0` | `0` | `0` | `1` | `1` |

Observando las direcciones físicas, vemos que podemos colocar de forma segura las PageTables a partir de la dirección física `0xF0000000` pues no solaparían con ninguna de las direcciones que estamos mapeando para las acciones a realizar.

Justificación de los atributos:

- `PCD = 0` porque no queremos deshabilitar el cache.
- `PWT = 0` porque queremos escribir a través del cache (es decir, delegamos el write-back a cuando el sistema de cache determine que tiene que hacerlo).
- `U/S = 0` porque todos los accesos son de nivel 0 (sistema).
- `R/W` indica que se puede escribir en las páginas mapeadas por el PageTable. Como las 2 acciones relacionadas a datos mapean al mismo PageTable, acá en el Page Directory debemos permitir la escritura. Para las otras entradas no permitimos la escritura pues las vamos a usar para las acciones de leer y ejecutar código.
- `P = 1` porque las PageTables van a estar presentes (las estamos configurando ahora).

### Page Tables

La justificación de los atributos es igual que el Page Directory. El único atributo adicional es `G = 0` que lo configuramos de esa forma porque no queremos que las páginas sean globales. La traducción de las páginas globales persiste en la `TLB` al modificar el registro `CR3`.

**Page Table**: `0xF0000`

| Index   | PageFrame | PCD | PWT | U/S | R/W | P   | G   |
|---------|-----------|-----|-----|-----|-----|-----|-----|
| `0x123` | `0x01123` | `0` | `0` | `0` | `0` | `1` | `0` |

No es posible completar la traducción de la dirección lineal `0x00123011` a la dirección física `0x01123001`. Cuando llegamos a este Page Table, deberíamos obtener la dirección física de la siguiente forma:

```
(PageFrame << 12) + Offset = 0x01123000 + 0x011 = 0x01123011 != 0x01123001
```

Una vez localizada la página, el offset dentro de ella son los 12 bits menos significativos de la dirección lineal, sin ningún tipo de procesamiento. Asumiendo que las direcciones de las páginas están alineadas a 4Kb, siempre tienen que coincidir los 12 bits menos significativos entre la dirección lineal y física.

**Page Table**: `0xF0001`

| Index   | PageFrame | PCD | PWT | U/S | R/W | P   | G   |
|---------|-----------|-----|-----|-----|-----|-----|-----|
| `0x294` | `0x00000` | `0` | `0` | `0` | `0` | `1` | `0` |

**Page Table**: `0xF0002`

| Index   | PageFrame | PCD | PWT | U/S | R/W | P   | G   |
|---------|-----------|-----|-----|-----|-----|-----|-----|
| `0x000` | `0x00000` | `0` | `0` | `0` | `0` | `1` | `0` |
| `0x399` | `0x00000` | `0` | `0` | `0` | `1` | `1` | `0` |
| `0x39A` | `0x00001` | `0` | `0` | `0` | `1` | `1` | `0` |

La dirección física `0x00000FFF` la utiliza la acción de "Escribir Datos". Notemos que esta dirección es el último byte de una página, y como el enunciado dice que las acciones acceden a 4 bytes, tenemos que mapear la página con index `0x39A` a continuación de la `0x399` para poder acceder correctamente a los 4 bytes desde la dirección física `0x00000FFF`.

Acá configuramos de forma independiente el atributo `R/W` para permitir la escritura solo en las páginas utilizadas para la acción "Escribir Datos".
