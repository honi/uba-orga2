# Preguntas teóricas

Explicar cómo es que en el arranque el procesador x86 accede a la dirección física 0xFFFFFFF0, a partir de los valores de los registros que intervienen en la determinación de su dirección física, y si el procesador está en Modo Real.

Al arrancar la máquina, el procesador comienza en Modo Real. Una vez realizado el POST y entregado el control al bootloader, el sistema operativo se encarga de pasar a modo protegido.

A su vez, al arrancar la máquina el IP apunta a la dirección 0xFFF0, el cual se denomina reset vector. Al transformar esta dirección lógica/virtual en una dirección física, se utiliza el registro CS (Code Segment). Este registro de 8 bytes en realidad contiene 2 partes, en su parte alta contiene el Base Address y en su parte baja el Limit.

La operación que se hace para obtener la dirección física es la siguiente:

```
CS[15-8] + IP = BaseAddress + IP = 0xFFFF0000 + 0xFFF0 = 0xFFFFFFF0
```

---

Dados dos registros SIMD que tienen los siguientes valores:

```
3892 F145 DEDA A164
532F 1768 E234 94BA
```

indicar cuánto valen las sumas con aritmética de desborde y con aritmética saturada con y sin signo si cada paquete es de 16 bits.

*Nota: interpreto que cada fila indica el valor contenido en cada registro SIMD.*

**Suma con aritmética de desborde**

```
3892 F145 DEDA A164
+
532F 1768 E234 94BA
=
8BC1 08AD C10E 361E
```

**Suma con aritmética de saturada, con signo**

```
3892 F145 DEDA A164
+
532F 1768 E234 94BA
=
7FFF 08AD C10E 8000
```

**Suma con aritmética de saturada, sin signo**

```
3892 F145 DEDA A164
+
532F 1768 E234 94BA
=
8BC1 FFFF FFFF FFFF
```
