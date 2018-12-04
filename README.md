# Frogger [MIPS - Assembly]

## ***Introducción***
Juego arcade ***Frogger*** hecho en lenguaje ensamblador. Simula el clásico juego, que tiene el objetivo de llevar a una rana desde el principio, hasta el final, cruzando *obstaculos* tales como *carros, camiones, y un río* que tiene que pasar montándose en troncos que flotan. En el camino se puede encontrar *moscas* por donde pasan los carros, las cuales dan *puntos*, en caso de que la rana se la coma. Al finalizar la partida, te da el *puntaje total*, así como también el *tiempo que jugaste*.


## ***Instrucciones para la ejecución***
1. Descargar el IDE [Mars](http://courses.missouristate.edu/KenVollmar/mars/ "Página Oficial de MARS")
    * > El .jar de MARS está en este repositorio
2. Abrir el archivo ***FroggerCFRQ*** con el IDE Mars
3. Expandir la pestaña *Tools* y abrir el **Bitmap Display** y el **Keyboard and Display MMIO Simulator**.
4. Conectar estas dos herramientas a MARS, con el botón *Connect to MIPS*
5. Configurar el Bitmap Display de la siguiente forma:
    ```bash
        UnitWidth = 16
        UnitHeigth = 16
        DisplayWidth = 256
        DisplayHeigth = 256
        BaseAddress = 0x10000000 (GlobalData)
    ```
6. **Compilar** el código en el botón de la *llave inglesa y el destornillador* en la barra de herramientas de MARS
7. Pisar el botón de *play* al lado del de compilar
8. Jugar con las teclas W, A, S y D escribiendolas en el recuadro de abajo del **Keyboard and Display MMIO Simulator**


## ***ScreenShots***

### *Inicio del juego*
![Inicio del juego](https://i.ibb.co/ngRmFNB/Frogger1.png)

### *Rana montada en un tronco a punto de llegar a una meta*
![Rana montada en un tronco a punto de llegar a una meta](https://i.ibb.co/M8psDf6/Frogger2.png)

### *Rana con una sola vida restante y con 2 objetivos listos*
![Rana con una sola vida restante y con 2 objetivos listos](https://i.ibb.co/mJnH4GY/Frogger3.png)


## ***Especificaciones de desarrollo***
> Software desarrollado con el IDE *MARS*, en el lenguaje ***MIPS (Assembly)***


## ***Especificaciones del Sistema***
Se le ha solicitado implementar un sistema en MIPS (utilizando las instrucciones
syscalls necesarios y las herramientas de Bitmap y MMIO keyboard) que emule el videojuego “Frogger”. Este juego consiste de una rana que debe cruzar una calle llena de vehículos y un río con troncos para llegar a su meta.

Funcionalidad:

* La rana puede moverse hacia cualquier dirección (Arriba, abajo, izquierda o derecha)
tomando en cuenta que no puede atravesar los bordes del área de juego.
* Deben haber mínimo 3 filas de automóviles y 3 filas de troncos (puede observar la
imagen como referencia). Para ambos casos, las filas impares se mueven de izquierda a derecha y las pares se mueve de derecha a izquierda.
* La rana debe aparecer por primera vez en una fila donde no corra ningún peligro.
* Debe tener una fila de descanso entre los vehículos y los troncos.
* Los carros y los troncos deberán aparecer aleatoriamente dentro de un intervalo de
tiempo de máximo 5 segundos, tomando en cuenta el tiempo mínimo para que no pueda
aparecer uno encima de otro. (Para generar los numeros aleatorios deberá utilizar el
syscall 40 para generar una semilla pseudoaleatoria y el syscall 42 para generar un
número en un intervalo de valores dados)
* Luego de que atraviese todos los obstáculos exitosamente, la rana debe caer en una
última fila, una vez ahí, el usuario recibirá una cierta cantidad de puntos y la rana debe ir a la fila donde aparece por primera vez.
* La rana debe poder caminar sobre la calle y sobre los troncos, tomando en cuenta que si es pisada por un vehículo o cae en el agua, se perderá una vida y el jugador debe comenzar de nuevo en la fila inicial.
* El jugador deberá comenzar con 3 vidas y poder ver su puntaje acumulado.
* Cuando el jugador pierda las tres vidas, el juego debe finalizar, mostrando su puntuación total, el tiempo jugado y ofreciendo la opción de jugar de nuevo.

Requerimientos:

* El usuario debe poder moverse un pixel por cada tecleo con las teclas WASD a traves de el Keyboard MMIO (tomando en cuenta que las letras pueden ser minusculas o
mayusculas).
* Debe haber al menos 1 fila de camiones y 1 fila de carros. Ejemplo: Si realiza 3 filas de vehículos puede utilizar 2 filas de camiones y 1 de carros o viceversa.
* Los troncos deben ser de 3 pixeles de largo, los camiones de 3 y los carros de 2.
* La velocidad de movimiento de los vehículos deberá ser constante a 0.2seg/pixel (Para esto deberá utilizar el syscall 32, correspondiente a la función de Sleep y simular el movimiento pausando ciclos de ejecución).
* La velocidad de los troncos debe ser fija en 1seg/pixel.
* Cada 5 segundos debe aparecer una mosca en el área de la calle de forma aleatoria con el syscall 42, si la rana se come la mosca (pasándole por encima), esto sumará puntos adicionales al jugador. Debe tomar en cuenta que si un carro pasa por encima de la mosca, la misma desaparecerá y que la mosca no puede aparecer en la misma posición en la que está un carro.