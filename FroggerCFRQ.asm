#           Proyecto Numero 1 - Organizacion del Computador	
#			Universidad Metropolitana de Caracas - Venezuela
# 			Elaborado por:
#			  - Carlos Fontes
#			  - Rafael Quintero
#
#	$s7 --> Posicion de la rana
#	$s1 --> Tecla presionada
#	$s6 --> Color abajo de la rana (futuro)
#	$t5 --> Posicion actual
#
#	Comer mosca --> 15 pts
#	Llegar a un goal --> 60 pts
#

.data
tiempo: .word 0
mapa: .word 0x10000000
vidasNum: .word 3 #Iniciamos el contador de vidas con 3
puntuacion: .word 0 #Iniciamos el contador de puntos con 0
goalsLlegados: .word 0 #Iniciamos el contador de goals
perdiste: .asciiz "¡Perdiste! D: Tu puntuacion final es: "
ganaste: .asciiz "¡Ganaste! :D Tu puntuacion final es: "
tiempoJugado: .asciiz "El tiempo jugado fue de (seg):  "
pregunta: .asciiz "Desea volver a jugar?"
#Declaracion de los tiempos seg/pixel
tiempoMosca: .word 5000 #5000ms --> 5 segundos
tiempoTronco: .word 1000 #1000ms --> 1 segundo
tiempoVehiculo: .word 200 #200ms --> 0.2 segundos
#Declaracion de los randoms
random1: .word 0
random2: .word 0
random3: .word 0
random4: .word 0
random5: .word 0
random6: .word 0 


#Colores
borde: .word 0x000000
borde2: .word 0x000001
borde3: .word 0x000002
calle1: .word 0x424949
calle2: .word 0x515A5A
rio1: .word 0x21618C
safe: .word 0x239B56
safeNo: .word 0x0B5345
rana: .word 0xA93226
carro: .word 0xB9A029
camion: .word 0x1F5DB6
mosca: .word 0xFF0040
tronco: .word 0x2F0701
llegada: .word 0x2471A3
llegadaOk: .word 0xF4D03F
vidas: .word 0xB40404
vidaNo: .word 0xFFFFFF
negro: .word 0x000000
letra: .word 0x244062
carga: .word 0x494529


.text

#Macro para hacer los randoms afuera del loop
.macro randomAfuera($dir)
li $v0, 30
syscall
li $v0, 42
li $a1, 50
syscall
mul $t8, $a0, 100
sw $t8, $dir
.end_macro

#Macro para hacer los randoms adentro del loop
.macro randomAdentro($dir)
li $v0, 30
syscall
li $v0, 42
li $a1, 46
syscall
add $a0, $a0, 4
mul $t8, $a0, 100
sw $t8, $dir
.end_macro

#Macro para pintar un pixel de carro/camion
.macro pintar($posicion, $color)
lw $t4, mapa($zero)
lw $t6, $color
addi $t4, $t4, $posicion
sw $t6, ($t4)
.end_macro

#Macro para pintar todo el mapa de negro
.macro pintarFondo()
leep:
lw $t2, negro
sw $t2, ($t1)
addi $t1, $t1, 4
addi $t5, $t5, 1
ble $t5, 1020, leep
.end_macro



# -----------PINTAMOS EL MAPA DONDE SE MOVERA LA RANA-----------

#Reinicio de variables del juego
inicioJuego:

jal pintarBienvenida

addi $t9, $zero, 0
sw $t9, tiempo
sw $t9, puntuacion
sw $t9, goalsLlegados
addi $t9, $zero, 3
sw $t9, vidasNum

	lw $t1, mapa($zero) #Posicion en el mapa a cero
	lw $t0, safeNo #Color con el que vamos a pintar
	addi $t5, $zero, 0 #Inicializamos el contador

	pintarSafeArriba:
	sw $t0, ($t1) #Pintamos la posicion ($t1) con el color que esta almacenado en $t0
	addi $t1, $t1, 4 #Movimiento de la posicion para poder pintar de izquierda a derecha
	addi $t5, $t5, 1 #Contador++
	blt $t5, 64, pintarSafeArriba #Bifurcacion
	
	#Pintamos los SafeNo de la ultima fila individualmente
	lw $t1, mapa($zero)
	addi $t1, $t1, 260
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 264
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 272
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 276
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 284
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 288
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 296
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 300
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 308
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 312
	sw $t0, ($t1)
	
	#Pintamos los puntos de llegada
	lw $t1, mapa($zero)
	addi $t1, $t1, 268
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 280
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 292
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 304
	lw $t0, llegada
	addi $t5, $zero, 0
	sw $t0, ($t1)

	#Reiniciamos todo para pintar
	lw $t1, mapa($zero) #Posicion en el mapa a cero
	addi $t1, $t1, 512 #Posicion en la que queremos empezar a pintar
	lw $t0, safe #Color con el que vamos a pintar
	addi $t5, $zero, 0 #Iniciamos el contador del while a cero

	pintarSafeMedio:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarSafeMedio
	
	#Reiniciamos todo para pintar
	lw $t1, mapa($zero)
	addi $t1, $t1, 768
	lw $t0, safe
	addi $t5, $zero, 0
	
	pintarSafeAbajo:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 64, pintarSafeAbajo
	
	#Reiniciamos todo para pintar
	lw $t1, mapa($zero)
	lw $t2, mapa($zero)
	addi $t1, $t1, 0
	addi $t2, $t2, 960
	lw $t0, borde
	addi $t5, $zero, 0
	
	pintarBordes:
	sw $t0, ($t2)
	addi $t2, $t2, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarBordes
	
	addi $t5, $zero, 0 #Reiniciamos el contador
	
	pintarBordes3:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 48, pintarBordes3
	
	#Pintamos las vidas
	lw $t1, mapa($zero)
	addi $t1, $t1, 72
	lw $t0, vidas
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 80
	lw $t0, vidas
	sw $t0, ($t1)
	
	lw $t1, mapa($zero)
	addi $t1, $t1, 88
	lw $t0, vidas
	sw $t0, ($t1)
	
	
	#Loop donde reiniciará la posicion de la rana
	recargarMapa:
	
	
	#Reiniciamos todo para pintar
	lw $t1, mapa($zero)
	addi $t1, $t1, 320
	lw $t0, rio1
	addi $t5, $zero, 0
	
	pintarRio:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 48, pintarRio
	
	#Reiniciamos todo para pintar
	lw $t1, mapa($zero)
	lw $t2, mapa($zero)
	addi $t1, $t1, 576
	addi $t2, $t2, 704
	lw $t0, calle1
	addi $t5, $zero, 0

	pintarCalle1:
	sw $t0, ($t1)
	sw $t0, ($t2)
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarCalle1
	
	#Reiniciamos todo para pintar
	lw $t1, mapa($zero)
	addi $t1, $t1, 640
	lw $t0, calle2
	addi $t5, $zero, 0
	
	pintarCalle2:
	sw $t0, ($t1)
	addi $t1, $t1, 4
	addi $t5, $t5, 1
	blt $t5, 16, pintarCalle2
	
	#Reiniciamos todo para editar
	lw $t1, mapa($zero)
	lw $t2, mapa($zero)
	addi $t1, $t1, 0
	addi $t2, $t2, 60
	lw $t0, borde2
	lw $t3, borde3
	addi $t5, $zero, 0
	
	pintarBordes2:
	sw $t0, ($t1)
	sw $t3, ($t2)
	addi $t1, $t1, 64
	addi $t2, $t2, 64
	addi $t5, $t5, 1
	blt $t5, 16, pintarBordes2
	
	#Pintamos la rana
	lw $t1, mapa($zero)
	addi $t1, $t1, 860
	lw $t0, rana
	addi $t5, $zero, 0
	sw $t0, ($t1)
	
			
# ------------ ALGORITMO PARA MOVER A LA RANA -------------

	li $s7, 860 #Posicion inicial de la rana
	lw $t1, mapa($zero) #Posicion inicial del mapa
	lw $s6, safe #Cargamos en $s6 el color del safe, que es el color donde estara la rana al principio
	
	#Creacion de Randoms iniciales
	randomAfuera(random1)
	randomAfuera(random2)
	randomAfuera(random3)
	randomAfuera(random4)
	randomAfuera(random5)
	randomAfuera(random6)
	
	loop: #Loop principal del movimiento
	
	lw $t1, mapa($zero) #Reiniciamos $t1 a la posicion inical del mapa
	
	#Timer del programa
	li $v0, 30 #Syscall para saber el tiempo actual
	syscall
	addi $t8, $a0, 100 #Le sumamos 100ms
	loopTimer:
	li $v0, 30 #Sabemos el tiempo actual otra vez
	syscall
	blt $a0, $t8, loopTimer #Comparamos el tiempo actual a ver si es menor al anterior con 100ms adicionales, si es mayor quiere decir que ya pasaron 100ms
	lw $t8, tiempo #Obtenemos lo que tiene el espacio de memoriadel tiempo
	addi $t8, $t8, 100 #Como ya pasaron 100ms le sumamos 100ms al tiempo
	sw $t8, tiempo #Guardamos el tiempo transcurrido en pa posicion de memoria
	
	#Branches para la creacion/movimiento de los carros/camiones/troncos
	jal generarMosquita
	jal crearCarro1
	jal crearCamion2
	jal crearCarro3
	jal crearTronco4
	jal crearTronco5
	jal crearTronco6
	jal moverCarro1
	jal moverCamion2
	jal moverCarro3
	jal moverTronco4
	jal moverTronco5
	jal moverTronco6
	
	
	obtenerTecla: #Loop que revisara si se obtiene alguna tecla
	la $s0, 0xffff0000 #Almacenamos el valor del booleano del teclado para saber si se eligio alguna tecla o no
	lw $s0, 0($s0) #Almacenamos el valor del booleano del teclado para saber si se eligio alguna tecla o no
	beq $s0, 1, teclado #Si se obtuvo alguna tecla (1 = true | 0 = false) ir al label "teclado", sino. vuelve a loop
	j loop
	
	teclado:
	add $t1, $t1, $s7 #Ponemos en $t1 la posicion actual de la rana ($s7)
	sw $s6, ($t1) #Pintamos con el color $s6, la posicion actual de la rana
	lw $t1, mapa($zero) #Reiniciamos la posicion de $t1
	move $t5, $s7 #Movemos a $t5 la posicion actual de la rana
	
	la $s1, 0xffff0004 
	lw $s1, 0($s1) #Se obtiene la tecla que se presiono en $s1
	
	beq $s1, 119, arriba #Si la tecla es "w"	
	beq $s1, 87, arriba #Si la tecla es "W"
	beq $s1, 115, abajo #Si la tecla es "s"
	beq $s1, 83, abajo #Si la tecla es "S"
	beq $s1, 97, izquierda #Si la tecla es "a"
	beq $s1, 65, izquierda #Si la tecla es "A"
	beq $s1, 100, derecha #Si la tecla es "d"
	beq $s1, 68, derecha #Si la tecla es "D"
	beq $s1, 27, salir #Si la tecla es "Esc"
	lw $t2, rana #Si ninguna de esas teclas fue pulsada pintamos del color de la rana ptra vez ese lugar
	add $t1, $t1, $s7 #Si ninguna de esas teclas fue pulsada pintamos del color de la rana ptra vez ese lugar
	sw $t2, ($t1) #Si ninguna de esas teclas fue pulsada pintamos del color de la rana ptra vez ese lugar
	b loop
	
	#--------------------------------------------------------------------------------------------
	salir:
	li $v0, 10 #Se detiene el programa
	syscall
	
	arriba:
	addi $s7, $s7, -64 #Disminuimos en 64 la posicion, lo que equivale a subir un pixel
	j moverRana
	
	abajo:
	addi $s7, $s7, 64 #Aumentamos en 64 la posicion, lo que equivale a bajar un pixel
	j moverRana
	
	izquierda:
	addi $s7, $s7, -4 #Disminuimos en 4 la posicion, lo que equivale a desplazarse hacia la izquierda un pixel
	j moverRana
	
	derecha:
	addi $s7, $s7, 4 #Aumentamos en 4 la posicion, lo que equivale a desplazarse hacia la derecha un pixel
	j moverRana
	#--------------------------------------------------------------------------------------------
	
	moverRana:
	add $t1, $t1, $s7 #Se añade a $t1 adonde se quiere mover ($s7 tenia la posicion actual, pero fue modificada en las funciones de arriba)
	lw $s6, ($t1) #Se coloca en $s6 el color de la posicion futura
	jal evaluar #Se va a la etiqueta "evaluar" para evaluar que es la posicion futura
	
	#Esto solo se va a ejecutar si la rana no se murio o se estampo contra un borde
	lw $t2, rana #Se carga el color de la rana
	sw $t2, ($t1) #Se pinta la proxima posicion con el color de la rana (Se mueve la rana)
	j loop
	
	evaluar: #Se evalua que es la proxima posicion, para saber que hacer
	beq $s6, 0xB9A029, perderVida #Carro
	beq $s6, 0x1F5DB6, perderVida #Camion
	beq $s6, 0x21618C, perderVida #Rio
	beq $s6, 0x000000, stop1 #BordeAbajo o BordeArriba 
	beq $s6, 0x000001, stop2 #BordeIzquierda
	beq $s6, 0x000002, stop3 #BordeDerecha
	beq $s6, 0x0B5345, stop4 #SafeNo
	beq $s6, 0x2471A3, goal #Meta no alcanzada
	beq $s6, 0xF4D03F, stop4 #Meta ya alcanzada
	beq $s6, 0xFF0040, mosquita #Comer una mosquita
	jr $ra #Se devuelve a "jal evaluar"
	
	stop1: #Funcion para que la rana no pueda pasar los bordes de Arriba o Abajo del mapa
	lw $t1, mapa($zero) #Iniciamos $t1 con la posicion cero del mapa
	add $t1, $t1, $t5 #Ponemos en $t1 la posicion actual de la rana (Antes de intentar moverse)
	lw $t2, rana #Cargamos el color de la rana en $t2
	sw $t2, ($t1) #Pintamos la posicion actual con el color la rana otra vez (Debido a que no se movio)
	move $s7, $t5 #Movemos a la $s7 (Posicion actual) la posicion de $t5, debido a que no cambio de posicion (La rana no se movio)
	lw $s6, safe #Guardamos la posicion de abajo de la rana (Siempre sera safe)
	j loop
	
	stop2: #Funcion para que la rana no pueda pasar el borde de la izquierda del mapa
	lw $t1, mapa($zero) #Iniciamos $t1 con la posicion cero del mapa
	add $t1, $t1, $t5 #Ponemos en $t1 la posicion actual de la rana (Antes de intentar moverse)
	lw $t2, rana #Cargamos el color de la rana en $t2
	sw $t2, ($t1) #Pintamos la posicion actual con el color la rana otra vez (Debido a que no se movio)
	move $s7, $t5 #Movemos a la $s7 (Posicion actual) la posicion de $t5, debido a que no cambio de posicion (La rana no se movio)
	lw $s6, 4($t1) #Guardamos la posicion de abajo de la rana (Siempre sera la misma que esta a la derecha de la rana)
	j loop
	
	stop3: #Funcion para que la rana no pueda pasar el borde de la derecha del mapa
	lw $t1, mapa($zero) #Iniciamos $t1 con la posicion cero del mapa
	add $t1, $t1, $t5 #Ponemos en $t1 la posicion actual de la rana (Antes de intentar moverse)
	lw $t2, rana #Cargamos el color de la rana en $t2
	sw $t2, ($t1) #Pintamos la posicion actual con el color la rana otra vez (Debido a que no se movio)
	move $s7, $t5 #Movemos a la $s7 (Posicion actual) la posicion de $t5, debido a que no cambio de posicion (La rana no se movio)
	lw $s6, -4($t1) #Guardamos la posicion de abajo de la rana (Siempre sera la misma que esta a la izquierda de la rana)
	j loop
	
	stop4: #Funcion para que la rana no pueda pasar el borde de arriba (SafeNo) del mapa
	lw $t1, mapa($zero) #Iniciamos $t1 con la posicion cero del mapa
	add $t1, $t1, $t5 #Ponemos en $t1 la posicion actual de la rana (Antes de intentar moverse)
	lw $t2, rana #Cargamos el color de la rana en $t2
	sw $t2, ($t1) #Pintamos la posicion actual con el color la rana otra vez (Debido a que no se movio)
	move $s7, $t5 #Movemos a la $s7 (Posicion actual) la posicion de $t5, debido a que no cambio de posicion (La rana no se movio)
	lw $s6, tronco #Guardamos la posicion de abajo de la rana (Siempre sera tronco)
	j loop
	
	goal: #La rana llego a un goal
	lw $t8, goalsLlegados #Almacenamos los goalsLlegados en $t8
	add $t8, $t8, 1 #Aumentamos en 1 los goals llegados debido a que la rana acabo de llegar a uno	
	sw $t8, goalsLlegados #Guardamos la nueva cantidad de goals llegados
	lw $t9, puntuacion #Obtenemos el puntaje que se lleva
	addi $t9, $t9, 60 #Le sumamos 60 pts
	sw $t9, puntuacion #Almacenamos la nueva puntuacion en el espacio de memoria	  
	lw $t2, llegadaOk #Se almacena en $t2 el color de "llegadaOk"
	sw $t2, ($t1) #Se pinta de color "llegadaOk" el cuadro donde llego la rana
	  beq $t8, 4, ganar #Bifurcacion para saber si ya se llego a los 4 goals
	j recargarMapa
	
	perderVida: #Se pierde una vida de la rana
	lw $t9, vidasNum #Pongo en $t9 el valor de las vidas
	addi $t9, $t9, -1 #Le resto uno a las vidas
	sw $t9, vidasNum #Almaceno el nuevo valor de las vidas en la posicion de memoria
	beq $t9, 2, lost1 #Si solo se ha perdido 1 vida
	beq $t9, 1, lost2 #Si se han perdido 2 vidas
	beq $t9, 0, lost3 #Si se han perdido 3 vidas
	j recargarMapa
	
	lost1: #Eliminamos la primera vida del bitmap
	lw $t2, vidaNo #Establecemos el color para quitar la vida
	lw $t1, mapa($zero) #Reiniciamos $t1 a la posicion cero del mapa
	addi $t1, $t1, 88 #Nos ponemos en la posicion de la 1era vida
	sw $t2, ($t1) #Pintamos la 1era vida de blanco
	j recargarMapa
	
	lost2: #Eliminamos la segunda vida del bitmap
	lw $t2, vidaNo #Establecemos el color para quitar la vida
	lw $t1, mapa($zero) #Reiniciamos $t1 a la posicion cero del mapa
	addi $t1, $t1, 80 #Nos ponemos en la posicion de la 2da vida
	sw $t2, ($t1) #Pintamos la 2da vida de blanco
	j recargarMapa
	
	lost3: #Eliminamos la tercera vida del bitmap y gameover
	lw $t2, vidaNo #Establecemos el color para quitar la vida
	lw $t1, mapa($zero) #Reiniciamos $t1 a la posicion cero del mapa
	addi $t1, $t1, 72 #Nos ponemos en la posicion de la 3ra vida
	sw $t2, ($t1) #Pintamos la 3era vida de blanco
	li $v0, 56 #Desplegamos el mensaje de perder
	la $a0, perdiste #Desplegamos el mensaje de perder
	lw $t9, puntuacion #Almacenamos en $t9 el valor del contador de puntos
	move $a1, $t9 #Movemos el valor de los puntos a $a1 para que se muestre en el mensaje
	syscall
	li $v0, 56 #Desplegamos el mensaje de mostrar tiempo
	la $a0, tiempoJugado #Desplegamos el mensaje de mostrar tiempo
	lw $t9, tiempo #Almacenamos en $t9 el valor del contador de tiempo
	li $s5, 1000 #Almacenamos 1000en $s5
	div $t9, $s5 #Pasamos el tiempo a segundos
	mflo $a1 #Pasamos el resultado entero del tiempo a $a0
	syscall
	j terminarPartida
	
	ganar: 
	li $v0, 56 #Desplegamos el mensaje de ganar
	la $a0, ganaste #Desplegamos el mensaje de perder
	lw $t9, puntuacion #Almacenamos en $t9 el valor del contador de puntos
	move $a1, $t9 #Movemos el valor de los puntos a $a1 para que se muestre en el mensaje
	syscall
	li $v0, 56 #Desplegamos el mensaje de mostrar tiempo
	la $a0, tiempoJugado #Desplegamos el mensaje de mostrar tiempo
	lw $t9, tiempo #Almacenamos en $t9 el valor del contador de tiempo
	li $s5, 1000 #Almacenamos 1000en $s5
	div $t9, $s5 #Pasamos el tiempo a segundos
	mflo $a1 #Pasamos el resultado entero del tiempo a $a0
	syscall
	j terminarPartida
	
	mosquita: #La rana se comio una mosca
	lw $t9, puntuacion #Obtenemos el puntaje que se lleva
	addi $t9, $t9, 15 #Le sumamos 15 pts
	sw $t9, puntuacion #Almacenamos la nueva puntuacion en el espacio de memoria	
	lw $t2, rana #Se carga el color de la rana
	sw $t2, ($t1) #Se pinta la proxima posicion con el color de la rana (Se mueve la rana)
	lw $t9, mapa($zero) #Se carga el mapa en t9
	addi $t9, $t9, 640 #Se le suma 640 a la posicion 0 del mapa
	blt $t1, $t9, caso1 #Si la posicion de la mosca es menor que 640, esta en calle 3 y se va a caso 1, si no, continua
	lw $t9, mapa($zero)#Se carga el mapa en t9
	addi $t9, $t9, 704 #Se le suma 704 a la posicion 0 del mapa
	bgt $t1, $t9, caso1 #Si la posicion de la mosca es mayor que 704, esta en calle 1 y se va a caso 1, si no, esta en calle 2
	lw $s6, calle2 #Se deja almacenado que el color de abajo de la rana es de color gris de la calle
	j loop
	
	caso1:
	lw $s6, calle1 #Se deja almacenado que el color de abajo de la rana es de color gris de la calle
	j loop
	
	
	
	
	
	
	#--------------------------Algoritmos de los vehiculos--------------------------
	
	#---------Carro Fila 1---------
	crearCarro1:
	lw $t4, mapa($zero) #Reiniciar la posicion en el mapa a la cero
	addi $t4, $t4, 708 #Obtener la posicion 708
	lw $t4, 8($t4) #Obtener 2 posiciones adelante [PARA HABILITAR CARROS SEGUIDOS PONER 4]
	beq $t4, 0xB9A029, regresar #Verificar si 2 pixeles a la derecha es una carro, si es, no generar ninguno
	lw $t4, random1 #Almacenamos el random1
	lw $t6, tiempo #Almacenamos el tiempo
	div $t6, $t4 #Dividimos el tiempo entre el random1
	mfhi $t6 #Agarramos el residuo de la division
	bnez $t6, regresar #Vemos si es divisible el tiempo con el random si no es no generamos carro
	#Verificamos si hay una rana en el lugar que se generara el carro, para perder una vida al jugador
	lw $t6, mapa($zero) #Reiniciamos la posicion de $t6 a la del mapa (cero)
	addi $t6, $t6, 708 #Obtenemos la posicion 708 del mapa (Donde se genera el carro)
	lw $t6, ($t6) #Obtenemos el color
	beq $t6, 0xA93226, perderVida #Si el color es de Rana, se pierde una vida
	pintar(708, carro) #Pintamos el carro (Lo generamos)
	randomAdentro(random1) #Generamos un nuevo Random
	j regresar #Regresamos a donde fue llamado crearCarro1
	
	moverCarro1:
	lw $t6, tiempo #Cargamos tiempo
	lw $t4, tiempoVehiculo #Cargamos 200ms a $t4
	div $t6, $t4 #Dividimos el tiempo entre 200
	mfhi $t6 #Agarramos el residuo
	bnez $t6, regresar #Si no es cero, no hay que mover los carros
	#Movemos el carro
	lw $t6, mapa($zero) #Reiniciamos $t6 a la posicion cero del mapa
	addi $t6, $t6, 756 #Lo llevamos a la posicion anterior a la final
	li $s3, 0 #Reiniciamos el contador
	
	movimiento1:
	lw $t3, ($t6) #Obtenemos el color que esta en la posicion de $t6
	beq $s3, 13, continuar1 #Si el contador llego a una casilla antes del final nos vamos al branch "continuar"
	addi $s3, $s3, 1 #Aumentamos en 1 el contador	
	beq $t3, 0xB9A029, car1 #Color del carro
	beq $t3, 0x424949, cal1 #Color de la calle
	beq $t3, 0xA93226, ran1 #Color de la rana
	beq $t3, 0xFF0040, mos1 #Si es color de mosca
	
	mos1:
	lw $t2, calle1 #Cargamos el color de calle1 en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xA93226, mos11 #Si es color de rana
	sw $t2, 4($t6) #Pintar calle1
	mos11:
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento1
	
	ran1:
	lw $t2, calle1 #Cargamos el color de calle1 en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xFF0040, ran11 #Si es color de mosca
	sw $t2, 4($t6) #Pintamos el color "calle1" la posicion de la derecha a la posicion actual en $t2
	ran11:
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento1
	
	car1:
	lw $t2, carro #Cargamos el color de carro en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xA93226, perderVida #Color Rana (Atropellar)
	sw $t2, 4($t6) #Pintamos el color "carro" la posicion de la derecha a la posicion actual en $t2
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento1

	cal1:
	lw $t2, calle1 #Cargamos el color de calle1 en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xFF0040, cal11 #Color mosca
	beq $t9, 0xA93226, cal11 #Color rana
	sw $t2, 4($t6) #Pintamos el color "calle1" la posicion de la derecha a la posicion actual en $t2
	
	cal11:
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento1
	
	continuar1:
	lw $t6, mapa($zero) #Reiniciamos $t6 con el mapa en la posicion cero
	addi $t6, $t6, 708 #Nos movemos a la posicion 708 del mapa
	lw $t2, ($t6) #Cargamos el color de la posicion actual en $t2
	lw $t3, 4($t6) #Cargamosel color de la posicion siguiente a la actual en $t3
	beq $t2, $t3, P1 #Verificamos si los dos colores son iguales
	j regresar
	
	P1:
	bne $t3, 0xB9A029, regresar #Si en $t3 hay un carro, nos regresamos
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 30 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t9, 8($t6) #Almacenar el color de 2 posiciones siguientes
	beq $t9, 0xA93226, perderVida #Color Rana (La rana fue atropellada xD ponecita D:)
	lw $t4, calle1  #Almacenamos el color de la "calle1" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color de la calle
	lw $t4, carro #Almacenamos el color del "carro" en $t4
	sw $t4, 8($t6) #Pintamos el color "calle1" 2 veces la posicion de la derecha a la posicion actual en $t2
	
	regresar:
	jr $ra #Regresamos a donde fue llamada la funcion
	
	
	
	
	
	#---------Carro Fila 3---------
	crearCarro3:
	lw $t4, mapa($zero) #Reiniciar la posicion en el mapa a la cero
	addi $t4, $t4, 580 #Obtener la posicion 580
	lw $t4, 8($t4) #Obtener 2 posiciones adelante [PARA HABILITAR CARROS SEGUIDOS PONER 4]
	beq $t4, 0xB9A029, regresar3 #Verificar si 2 pixeles a la derecha es una carro, si es, no generar ninguno
	lw $t4, random3 #Almacenamos el random1
	lw $t6, tiempo #Almacenamos el tiempo
	div $t6, $t4 #Dividimos el tiempo entre el random3
	mfhi $t6 #Agarramos el residuo de la division
	bnez $t6, regresar3 #Vemos si es divisible el tiempo con el random si no es no generamos carro
	#Verificamos si hay una rana en el lugar que se generara el carro, para perder una vida al jugador
	lw $t6, mapa($zero) #Reiniciamos la posicion de $t6 a la del mapa (cero)
	addi $t6, $t6, 580 #Obtenemos la posicion 580 del mapa (Donde se genera el carro)
	lw $t6, ($t6) #Obtenemos el color
	beq $t6, 0xA93226, perderVida #Si el color es de Rana, se pierde una vida
	pintar(580, carro) #Pintamos el carro (Lo generamos)
	randomAdentro(random3) #Generamos un nuevo Random
	j regresar3 #Regresamos a donde fue llamado crearCarro1
	
	moverCarro3:
	lw $t6, tiempo #Cargamos tiempo
	lw $t4, tiempoVehiculo #Cargamos 200ms a $t4
	div $t6, $t4 #Dividimos el tiempo entre 200
	mfhi $t6 #Agarramos el residuo
	bnez $t6, regresar3 #Si no es cero, no hay que mover los carros
	#Movemos el carro
	lw $t6, mapa($zero) #Reiniciamos $t6 a la posicion cero del mapa
	addi $t6, $t6, 628 #Lo llevamos a la posicion anterior a la final
	li $s3, 0 #Reiniciamos el contador
	
	movimiento3:
	lw $t3, ($t6) #Obtenemos el color que esta en la posicion de $t6
	beq $s3, 13, continuar3 #Si el contador llego a una casilla antes del final nos vamos al branch "continuar"
	addi $s3, $s3, 1 #Aumentamos en 1 el contador	
	beq $t3, 0xB9A029, car3 #Color del carro
	beq $t3, 0x424949, cal3 #Color de la calle
	beq $t3, 0xA93226, ran3 #Color de la rana
	beq $t3, 0xFF0040, mos3 #Si es color de mosca
	
	mos3:
	lw $t2, calle1 #Cargamos el color de calle1 en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xA93226, mos33 #Si es color de rana
	sw $t2, 4($t6) #Pintar calle1
	mos33:
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento3
	
	ran3:
	lw $t2, calle1 #Cargamos el color de calle1 en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xFF0040, ran33 #Si es color de mosca
	sw $t2, 4($t6) #Pintamos el color "calle1" la posicion de la derecha a la posicion actual en $t2
	ran33:
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento3
	
	car3:
	lw $t2, carro #Cargamos el color de carro en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xA93226, perderVida #Color Rana (Atropellar)
	sw $t2, 4($t6) #Pintamos el color "carro" la posicion de la derecha a la posicion actual en $t2
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento3

	cal3:
	lw $t2, calle1 #Cargamos el color de calle1 en $t2
	lw $t9, 4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xFF0040, cal33 #Color mosca
	beq $t9, 0xA93226, cal33 #Color rana
	sw $t2, 4($t6) #Pintamos el color "calle1" la posicion de la derecha a la posicion actual en $t2
	
	cal33:
	addi $t6, $t6, -4 #Le restamos 4 a la posicion del movimiento
	j movimiento3
	
	continuar3:
	lw $t6, mapa($zero) #Reiniciamos $t6 con el mapa en la posicion cero
	addi $t6, $t6, 580 #Nos movemos a la posicion 708 del mapa
	lw $t2, ($t6) #Cargamos el color de la posicion actual en $t2
	lw $t3, 4($t6) #Cargamosel color de la posicion siguiente a la actual en $t3
	beq $t2, $t3, P3 #Verificamos si los dos colores son iguales
	j regresar3
	
	P3:
	bne $t3, 0xB9A029, regresar3 #Si en $t3 no hay un carro, nos regresamos
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 30 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t9, 8($t6) #Almacenar el color de 2 posiciones siguientes
	beq $t9, 0xA93226, perderVida #Color Rana (La rana fue atropellada xD ponecita D:)
	lw $t4, calle1  #Almacenamos el color de la "calle1" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color de la calle
	lw $t4, carro #Almacenamos el color del "carro" en $t4
	sw $t4, 8($t6) #Pintamos el color "calle1" 2 veces la posicion de la derecha a la posicion actual en $t2
	
	regresar3:
	jr $ra #Regresamos a donde fue llamada la funcion
	
	
	
	
	
	#---------Camion Fila 2---------
	crearCamion2:
	lw $t4, mapa($zero) #Reiniciar la posicion en el mapa a la cero
	addi $t4, $t4, 696 #Obtener la posicion 580
	lw $t4, -12($t4) #Obtener 3 posiciones adelante [PARA HABILITAR CARROS SEGUIDOS PONER 4]
	beq $t4, 0x1F5DB6, regresar2 #Verificar si 2 pixeles a la izquierda es una camion, si es, no generar ninguno
	lw $t4, random2 #Almacenamos el random2
	lw $t6, tiempo #Almacenamos el tiempo
	div $t6, $t4 #Dividimos el tiempo entre el random1
	mfhi $t6 #Agarramos el residuo de la division
	bnez $t6, regresar2 #Vemos si es divisible el tiempo con el random si no es no generamos camion
	#Verificamos si hay una rana en el lugar que se generara el camion, para perder una vida al jugador
	lw $t6, mapa($zero) #Reiniciamos la posicion de $t6 a la del mapa (cero)
	addi $t6, $t6, 696 #Obtenemos la posicion 580 del mapa (Donde se genera el camion)
	lw $t6, ($t6) #Obtenemos el color
	beq $t6, 0xA93226, perderVida #Si el color es de Rana, se pierde una vida
	pintar(696, camion) #Pintamos el camion (Lo generamos)
	pintar(692, camion) #Pintamos el camion (Lo generamos)
	randomAdentro(random2) #Generamos un nuevo Random
	j regresar2 #Regresamos a donde fue llamado crearCamion1
	
	moverCamion2:
	lw $t6, tiempo #Cargamos tiempo
	lw $t4, tiempoVehiculo #Cargamos 200ms a $t4
	div $t6, $t4 #Dividimos el tiempo entre 200
	mfhi $t6 #Agarramos el residuo
	bnez $t6, regresar2 #Si no es cero, no hay que mover los camion
	#Movemos el camion
	lw $t6, mapa($zero) #Reiniciamos $t6 a la posicion cero del mapa
	addi $t6, $t6, 648 #Lo llevamos a la posicion anterior a la final
	li $s3, 0 #Reiniciamos el contador
	
	movimiento2:
	lw $t3, ($t6) #Obtenemos el color que esta en la posicion de $t6
	beq $s3, 13, continuar2 #Si el contador llego a una casilla antes del final nos vamos al branch "continuar"
	addi $s3, $s3, 1 #Aumentamos en 1 el contador	
	beq $t3, 0x1F5DB6, cam2 #Color del camion
	beq $t3, 0x515A5A, cal2 #Color de la calle
	beq $t3, 0xA93226, ran2 #Color de la rana
	beq $t3, 0xFF0040, mos2 #Si es color de mosca
	
	mos2:
	lw $t2, calle2 #Cargamos el color de calle2 en $t2
	lw $t9, -4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xA93226, mos22 #Si es color de rana
	sw $t2, -4($t6) #Pintar calle2
	mos22:
	addi $t6, $t6, 4 #Le sumamos 4 a la posicion del movimiento
	j movimiento2
	
	ran2:
	lw $t2, calle2 #Cargamos el color de calle2 en $t2
	lw $t9, -4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xFF0040, ran22 #Si es color de mosca
	sw $t2, -4($t6) #Pintamos el color "calle2" la posicion de la izquierda a la posicion actual en $t2
	ran22:
	addi $t6, $t6, 4 #Le sumamos 4 a la posicion del movimiento
	j movimiento2
	
	cam2:
	lw $t2, camion #Cargamos el color de camion en $t2
	lw $t9, -4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xA93226, perderVida #Color Rana (Atropellar)
	sw $t2, -4($t6) #Pintamos el color "camion" la posicion de la izquierda a la posicion actual en $t2
	addi $t6, $t6, 4 #Le sumamos 4 a la posicion del movimiento
	j movimiento2

	cal2:
	lw $t2, calle2 #Cargamos el color de calle2 en $t2
	lw $t9, -4($t6) #Almacenar el color de la posicion siguiente
	beq $t9, 0xFF0040, cal22 #Color mosca
	beq $t9, 0xA93226, cal22 #Color rana
	sw $t2, -4($t6) #Pintamos el color "calle2" la posicion de la izquierda a la posicion actual en $t2
	
	cal22:
	addi $t6, $t6, 4 #Le sumamos 4 a la posicion del movimiento
	j movimiento2
	
	continuar2:
	lw $t6, mapa($zero) #Reiniciamos $t6 con el mapa en la posicion cero
	addi $t6, $t6, 696 #Nos movemos a la posicion 708 del mapa
	lw $t2, ($t6) #Cargamos el color de la posicion actual en $t2
	lw $t3, -4($t6) #Cargamos el color de la posicion siguiente a la actual en $t3
	bne $t2, $t3, regresar2 #Verificamos si los dos colores no son iguales
	lw $t2, -8($t6) #Cargamos el color de 2 veces la posicion siguiente a la actual en $t3
	beq $t2, $t3, P2 #Verificamos si los dos colores no son iguales
	j regresar2
	
	P2:
	bne $t3, 0x1F5DB6, regresar2 #Si en $t3 no hay un camion, nos regresamos
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 30 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t9, -12($t6) #Almacenar el color de 2 posiciones siguientes
	beq $t9, 0xA93226, perderVida #Color Rana (La rana fue atropellada xD ponecita D:)
	lw $t4, calle2  #Almacenamos el color de la "calle2" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color de la calle
	lw $t4, camion #Almacenamos el color del "camion" en $t4
	sw $t4, -8($t6) #Pintamos el color "calle2" 2 veces la posicion de la izquierda a la posicion actual en $t2
	sw $t4, -12($t6) #Pintamos el color "calle2" 3 veces la posicion de la izquierda a la posicion actual en $t2
	regresar2:
	jr $ra #Regresamos a donde fue llamada la funcion








	#--------------------------Algoritmos de los troncos--------------------------

	#---------Tronco Fila 1---------
	crearTronco4:
	lw $t4, mapa($zero) #Reiniciar la posicion en el mapa a la cero
	addi $t4, $t4, 504 #Obtener la posicion 580
	lw $t4, -12($t4) #Obtener 3 posiciones adelante [PARA HABILITAR CARROS SEGUIDOS PONER 4]
	beq $t4, 0x2F0701, regresar4 #Verificar si 2 pixeles a la izquierda es una tronco, si es, no generar ninguno
	lw $t4, random4 #Almacenamos el random2
	lw $t6, tiempo #Almacenamos el tiempo
	div $t6, $t4 #Dividimos el tiempo entre el random1
	mfhi $t6 #Agarramos el residuo de la division
	bnez $t6, regresar4 #Vemos si es divisible el tiempo con el random si no es no generamos tronco
	pintar(504, tronco) #Pintamos el tronco (Lo generamos)
	pintar(500, tronco) #Pintamos el tronco (Lo generamos)
	randomAdentro(random4) #Generamos un nuevo Random
	j regresar4 #Regresamos a donde fue llamado crearTronco4
	
	moverTronco4:
	lw $t6, tiempo #Cargamos tiempo
	lw $t4, tiempoTronco #Cargamos 1000ms a $t4
	div $t6, $t4 #Dividimos el tiempo entre 1000
	mfhi $t6 #Agarramos el residuo
	bnez $t6, regresar4 #Si no es cero, no hay que mover los tronco
	#Movemos el tronco
	lw $t6, mapa($zero) #Reiniciamos $t6 a la posicion cero del mapa
	addi $t6, $t6, 456 #Lo llevamos a la posicion anterior a la final
	li $s3, 0 #Reiniciamos el contador
	lw $t9, mapa($zero)
	addi $t9, $t9, 452 #Almacenamos 452 en $t9 que es la ultima posicion que puede tomar la rana
	lw $t8, ($t9) #Obtenemos el color que esta en $t9
	beq $t8, 0xA93226, perderVida #La rana pierde una vida debido a que esta en su ultimo lugar donde puede estar
	
	
	movimiento4:
	lw $t3, ($t6) #Obtenemos el color que esta en la posicion de $t6
	beq $s3, 13, continuar4 #Si el contador llego a una casilla antes del final nos vamos al branch "continuar"
	addi $s3, $s3, 1 #Aumentamos en 1 el contador	
	beq $t3, 0xA93226, ran4 #Si hay rana
	#Si no es una rana
	sw $t3, -4($t6) #Almacenamos el color de la posicion de la izquierda a $t6
	addi $t6, $t6, 4 #Le sumamos 1 pixel a la posicion $t6
	j movimiento4
	
	ran4:
	sw $t3, -4($t6)  #Almacenamos el color de al posicion de la izquierda de $t6
	addi $t6, $t6, 4 #Le sumamos 4 a $t6
	addi $s7, $s7, -4 #Le restamos 4 a la posicion de la rana
	j movimiento4
	
	continuar4:
	lw $t6, mapa($zero) #Reiniciamos $t6 con el mapa en la posicion cero
	addi $t6, $t6, 504 #Nos movemos a la posicion 708 del mapa
	lw $t2, ($t6) #Cargamos el color de la posicion actual en $t2
	beq $t2, 0xA93226, continuar41
	lw $t3, -4($t6) #Cargamos el color de la posicion siguiente a la actual en $t3
	beq $t3, 0xA93226, continuar42
	bne $t2, $t3, regresar4 #Verificamos si los dos colores no son iguales
	lw $t2, -8($t6) #Cargamos el color de 2 veces la posicion siguiente a la actual en $t3
	beq $t2, $t3, P4 #Verificamos si los dos colores no son iguales
	j regresar4
	
	P4:
	bne $t3, 0x2F0701, regresar4 #Si en $t3 no hay un tronco, nos regresamos
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 100 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t4, rio1  #Almacenamos el color de la "rio1" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color del rio
	lw $t4, tronco #Almacenamos el color del "tronco" en $t4
	sw $t4, -8($t6) #Pintamos el color "tronco" 2 veces la posicion de la izquierda a la posicion actual en $t2
	sw $t4, -12($t6) #Pintamos el color "tronco" 3 veces la posicion de la izquierda a la posicion actual en $t2
	j regresar4
	
	continuar41:
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 100 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t4, rio1  #Almacenamos el color de la "rio1" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color del rio
	lw $t8, rana #Guardamos el color rana en t8
	lw $t4, tronco #Almacenamos el color del "tronco" en $t4
	addi $s7, $s7, -8
	sw $t8, -8($t6)
	sw $t4, -12($t6) #Pintamos el color "rio1" 3 veces la posicion de la izquierda a la posicion actual en $t2
	j regresar4
	
	continuar42:
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 100 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t4, rio1  #Almacenamos el color de la "rio1" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color del rio
	lw $t8, rana #Guardamos el color rana en t8
	lw $t4, tronco #Almacenamos el color del "tronco" en $t4
	addi $s7, $s7, -8
	sw $t4, -4($t6)
	sw $t4, -8($t6) #Pintamos el color "rio1" 3 veces la posicion de la izquierda a la posicion actual en $t2
	sw $t8, -12($t6)
	
	regresar4:
	jr $ra #Regresamos a donde fue llamada la funcion
	
	
	
	
	
	#---------Tronco Fila 2---------
	crearTronco5:
	lw $t4, mapa($zero) #Reiniciar la posicion en el mapa a la cero
	addi $t4, $t4, 388 #Obtener la posicion 580
	lw $t4, 12($t4) #Obtener 3 posiciones adelante [PARA HABILITAR CARROS SEGUIDOS PONER 4]
	beq $t4, 0x2F0701, regresar5 #Verificar si 2 pixeles a la izquierda es una tronco, si es, no generar ninguno
	lw $t4, random5 #Almacenamos el random2
	lw $t6, tiempo #Almacenamos el tiempo
	div $t6, $t4 #Dividimos el tiempo entre el random1
	mfhi $t6 #Agarramos el residuo de la division
	bnez $t6, regresar5 #Vemos si es divisible el tiempo con el random si no es no generamos tronco
	pintar(388, tronco) #Pintamos el tronco (Lo generamos)
	pintar(392, tronco) #Pintamos el tronco (Lo generamos)
	randomAdentro(random5) #Generamos un nuevo Random
	j regresar5 #Regresamos a donde fue llamado crearTronco6
	
	moverTronco5:
	lw $t6, tiempo #Cargamos tiempo
	lw $t4, tiempoTronco #Cargamos 1000ms a $t4
	div $t6, $t4 #Dividimos el tiempo entre 1000
	mfhi $t6 #Agarramos el residuo
	bnez $t6, regresar5 #Si no es cero, no hay que mover los tronco
	#Movemos el tronco
	lw $t6, mapa($zero) #Reiniciamos $t6 a la posicion cero del mapa
	addi $t6, $t6, 436 #Lo llevamos a la posicion anterior a la final
	li $s3, 0 #Reiniciamos el contador
	lw $t9, mapa($zero)
	addi $t9, $t9, 440 #Almacenamos 440 en $t9 que es la ultima posicion que puede tomar la rana
	lw $t8, ($t9) #Obtenemos el color que esta en $t9
	beq $t8, 0xA93226, perderVida #La rana pierde una vida debido a que esta en su ultimo lugar donde puede estar
	
	movimiento5:
	lw $t3, ($t6) #Obtenemos el color que esta en la posicion de $t6
	beq $s3, 13, continuar5 #Si el contador llego a una casilla antes del final nos vamos al branch "continuar"
	addi $s3, $s3, 1 #Aumentamos en 1 el contador	
	beq $t3, 0xA93226, ran5 #Si hay rana
	#Si no es una rana
	sw $t3, 4($t6) 
	addi $t6, $t6, -4
	j movimiento5
	
	ran5:
	sw $t3, 4($t6)  #Almacenamos el color de al posicion de la izquierda de $t6
	addi $t6, $t6, -4 #Le restamos 4 a $t6
	addi $s7, $s7, 4 #Le sumamos 4 a la posicion de la rana
	j movimiento5
	
	continuar5:
	lw $t6, mapa($zero) #Reiniciamos $t6 con el mapa en la posicion cero
	addi $t6, $t6, 388 #Nos movemos a la posicion 708 del mapa
	lw $t2, ($t6) #Cargamos el color de la posicion actual en $t2
	lw $t3, 4($t6) #Cargamos el color de la posicion siguiente a la actual en $t3
	bne $t2, $t3, regresar5 #Verificamos si los dos colores no son iguales
	lw $t2, 8($t6) #Cargamos el color de 2 veces la posicion siguiente a la actual en $t3
	beq $t2, $t3, P5 #Verificamos si los dos colores no son iguales
	j regresar5
	
	P5:
	bne $t3, 0x2F0701, regresar5 #Si en $t3 no hay un tronco, nos regresamos
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 100 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t4, rio1  #Almacenamos el color de la "rio1" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color del rio
	lw $t4, tronco #Almacenamos el color del "tronco" en $t4
	sw $t4, 8($t6) #Pintamos el color "rio1" 2 veces la posicion de la izquierda a la posicion actual en $t2
	sw $t4, 12($t6) #Pintamos el color "rio1" 3 veces la posicion de la izquierda a la posicion actual en $t2
	regresar5:
	jr $ra #Regresamos a donde fue llamada la funcion

	
	
	
	
	
	
	
	#---------Tronco Fila 3---------
	crearTronco6:
	lw $t4, mapa($zero) #Reiniciar la posicion en el mapa a la cero
	addi $t4, $t4, 376 #Obtener la posicion 580
	lw $t4, -12($t4) #Obtener 3 posiciones adelante [PARA HABILITAR CARROS SEGUIDOS PONER 4]
	beq $t4, 0x2F0701, regresar6 #Verificar si 2 pixeles a la izquierda es una tronco, si es, no generar ninguno
	lw $t4, random6 #Almacenamos el random2
	lw $t6, tiempo #Almacenamos el tiempo
	div $t6, $t4 #Dividimos el tiempo entre el random1
	mfhi $t6 #Agarramos el residuo de la division
	bnez $t6, regresar6 #Vemos si es divisible el tiempo con el random si no es no generamos tronco
	pintar(376, tronco) #Pintamos el tronco (Lo generamos)
	pintar(372, tronco) #Pintamos el tronco (Lo generamos)
	randomAdentro(random6) #Generamos un nuevo Random
	j regresar6 #Regresamos a donde fue llamado crearTronco6
	
	moverTronco6:
	lw $t6, tiempo #Cargamos tiempo
	lw $t4, tiempoTronco #Cargamos 1000ms a $t4
	div $t6, $t4 #Dividimos el tiempo entre 1000
	mfhi $t6 #Agarramos el residuo
	bnez $t6, regresar6 #Si no es cero, no hay que mover los tronco
	#Movemos el tronco
	lw $t6, mapa($zero) #Reiniciamos $t6 a la posicion cero del mapa
	addi $t6, $t6, 328 #Lo llevamos a la posicion anterior a la final
	li $s3, 0 #Reiniciamos el contador
	lw $t9, mapa($zero) #Almacenamos la posicion cero del mapa en $t9
	addi $t9, $t9, 324 #Almacenamos 324 en $t9 que es la ultima posicion que puede tomar la rana
	lw $t8, ($t9) #Obtenemos el color que esta en $t9
	beq $t8, 0xA93226, perderVida #La rana pierde una vida debido a que esta en su ultimo lugar donde puede estar
	
	movimiento6:
	lw $t3, ($t6) #Obtenemos el color que esta en la posicion de $t6
	beq $s3, 13, continuar6 #Si el contador llego a una casilla antes del final nos vamos al branch "continuar"
	addi $s3, $s3, 1 #Aumentamos en 1 el contador	
	beq $t3, 0xA93226, ran6 #Si hay rana
	#Si no es una rana
	sw $t3, -4($t6) #En $t3 almacenamos el color de la izquierda de la posicion de $t6
	addi $t6, $t6, 4 #Aumentamos la posicion de $t6 al proximo pixel para la proxima pasada
	j movimiento6
	
	ran6:
	sw $t3, -4($t6)  #Almacenamos el color de al posicion de la izquierda de $t6
	addi $t6, $t6, 4 #Le sumamos 4 a $t6
	addi $s7, $s7, -4 #Le restamos 4 a la posicion de la rana
	j movimiento6
	
	continuar6:
	lw $t6, mapa($zero) #Reiniciamos $t6 con el mapa en la posicion cero
	addi $t6, $t6, 376 #Nos movemos a la posicion 708 del mapa
	lw $t2, ($t6) #Cargamos el color de la posicion actual en $t2
	lw $t3, -4($t6) #Cargamos el color de la posicion siguiente a la actual en $t3
	bne $t2, $t3, regresar6 #Verificamos si los dos colores no son iguales
	lw $t2, -8($t6) #Cargamos el color de 2 veces la posicion siguiente a la actual en $t3
	beq $t2, $t3, P6 #Verificamos si los dos colores no son iguales
	j regresar6
	
	P6:
	bne $t3, 0x2F0701, regresar6 #Si en $t3 no hay un tronco, nos regresamos
	li $v0, 32 #Sleep para agilizar el movimiento
	li $a0, 100 #Sleep para agilizar el movimiento
	syscall #Sleep para agilizar el movimiento
	lw $t4, rio1  #Almacenamos el color de la "rio1" en $t4
	sw $t4, ($t6) #Pintamos la posicion actual del color del rio
	lw $t4, tronco #Almacenamos el color del "tronco" en $t4
	sw $t4, -8($t6) #Pintamos el color "rio1" 2 veces la posicion de la izquierda a la posicion actual en $t2
	sw $t4, -12($t6) #Pintamos el color "rio1" 3 veces la posicion de la izquierda a la posicion actual en $t2
	regresar6:
	jr $ra #Regresamos a donde fue llamada la funcion
	
	
	
	
	
	
	#--------------------------Algoritmo para generar la mosca--------------------------
	generarMosquita:
	addi $t8, $zero, 0 #Reiniciamos $t8
	lw $t4, tiempo #Almacenamos el tiempo actual del programa en $t4
	lw $t6, tiempoMosca #Almacenamos 5000ms en $t6
	div $t4, $t6 #Dividimos el tiempo entre 5000ms
	mfhi $t6 #Agarramos el residuo de la division anterior
	bnez $t6, regresar7 #Revisamos si han pasado 5 segundos, si no han pasado no se genera mosca
	#Procedemos a generar una mosca
	
	#Generamos el random
	generarRandom:
	li $v0, 30 #Buscamos un seed aleatorio que sera el tiempo actual
	syscall
	li $v0, 42 #Syscall para generar un random
	li $a1, 45 #El max bound para el random sera de 46 (Posibles posiciones entre el 580-760)
	syscall
	mul $t8, $a0, 4 #Para tener la posicion exacta y no el numero de casilla
	addi $t8, $t8, 580 #Obtener la posicion en la cual aparecera la mosquita xD
	lw $t9, mapa($zero) #Reiniciamos $t9 a la posicion cero del mapa
	add $t9, $t9, $t8 #Le sumamos a la posicion inicial del mapa la posicion en la cual va a aparecer la mosquita xD
	lw $t4, ($t9) #Cargamos el color de donde quiere aparecer la mosca
	beq $t4, 0xA93226 ,generarRandom #Si quiere aparecer en un lugar donde esta la rana
	beq $t4, 0xB9A029 ,generarRandom #Si quiere aparecer en un lugar donde hay un carro
	beq $t4, 0x1F5DB6 ,generarRandom #Si quiere aparecer en un lugar donde hay un camion
	beq $t4, 0x000001 ,generarRandom #Si quiere aparecer en un borde de la izquierda
	beq $t4, 0x000002 ,generarRandom #Si quiere aparecer en un borde de la derecha
	#Pintar mosquita xD
	lw $t6, mosca #Cargamos el color de la mosca
	sw $t6, ($t9) #Pintamos la posicion generada con color mosquita xD
	
	regresar7:
	jr $ra #Regresamos a donde fue llamada la funcion
	
	


	#-----------Algoritmo para terminar la partida-----------
	terminarPartida:
	li $v0, 50 #Numero del syscall de confirmacion
	la $a0, pregunta #Almacenar en $a0 la pregunta de si quiere volver a jugar
	syscall
	beq $a0, 0, inicioJuego #Reiniciamos el juego
	li $v0, 10 #Cerramos la ejecucion
	syscall
	
	
	
	
	
	
	
	
	#-----------Pintamos la pantalla de bienvenida-----------
	pintarBienvenida:
	
	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()
	
	li $v0 32
	li $a0, 600
	syscall
	
	#PrimerMov
	pintar(8, letra)
	pintar(12, letra)
	pintar(16, letra)
	pintar(24, letra)
	
	pintar(984, letra)
	pintar(988, letra)
	pintar(992, letra)
	pintar(1000, letra)
	pintar(1004, letra)
	pintar(1008, letra)
	
	li $v0 32
	li $a0, 600
	syscall
	
	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()
	
	#SegundoMov
	pintar(72, letra)
	pintar(76, letra)
	pintar(80, letra)
	pintar(88, letra)
	
	pintar(920, letra)
	pintar(924, letra)
	pintar(928, letra)
	pintar(936, letra)
	pintar(940, letra)
	pintar(944, letra)
	
	pintar(8, letra)
	pintar(24, letra)
	pintar(28, letra)
	
	pintar(984, letra)
	pintar(992, letra)
	pintar(1000, letra)
	pintar(1008, letra)
	
	li $v0 32
	li $a0, 600
	syscall
	
	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()
	
	#TercerMov
	pintar(1008, letra)
	pintar(1000, letra)
	pintar(1004, letra)
	pintar(1012, letra)
	pintar(992, letra)
	pintar(984, letra)
	pintar(944, letra)
	pintar(936, letra)
	pintar(924, letra)
	pintar(920, letra)
	pintar(880, letra)
	pintar(872, letra)
	pintar(864, letra)
	pintar(856, letra)
	pintar(816, letra)
	pintar(812, letra)
	pintar(808, letra)
	pintar(800, letra)
	pintar(796, letra)
	pintar(792, letra)
	pintar(152, letra)
	pintar(156, letra)
	pintar(216, letra)
	pintar(200, letra)
	pintar(204, letra)
	pintar(208, letra)
	pintar(136, letra)
	pintar(88, letra)
	pintar(72, letra)
	pintar(24, letra)
	pintar(28, letra)
	pintar(32, letra)
	pintar(8, letra)
	pintar(12, letra)
	pintar(16, letra)
	
	li $v0 32
	li $a0, 600
	syscall
	
	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	pintarFondo()
	
	
	#CuartoMov
	pintar(944, letra)
	pintar(948, letra)
	pintar(940, letra)
	pintar(936, letra)
	pintar(928, letra)
	pintar(920, letra)
	pintar(880, letra)
	pintar(872, letra)
	pintar(860, letra)
	pintar(856, letra)
	pintar(816, letra)
	pintar(808, letra)
	pintar(800, letra)
	pintar(792, letra)
	pintar(752, letra)
	pintar(748, letra)
	pintar(744, letra)
	pintar(736, letra)
	pintar(732, letra)
	pintar(728, letra)
	pintar(280, letra)
	pintar(272, letra)
	pintar(268, letra)
	pintar(264, letra)
	pintar(220, letra)
	pintar(216, letra)
	pintar(200, letra)
	pintar(152, letra)
	pintar(136, letra)
	pintar(96, letra)
	pintar(92, letra)
	pintar(88, letra)
	pintar(80, letra)
	pintar(76, letra)
	pintar(72, letra)
	
	li $v0 32
	li $a0, 1500
	syscall
	
	
	#Barra de carga1
	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	lw $t2, carga
	addi $s4, $t1, 900
	addi $s5, $t1, 904
	carga1:
	sw $t2, ($s4)
	sw $t2, ($s5)
	addi $s4, $s4, -64
	addi $s5, $s5, -64
	addi $t5, $t5, 1
	
	li $v0 32
	li $a0, 100
	syscall
	
	ble $t5, 7, carga1
	
	
	#Barra de carga2
	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	lw $t2, carga
	addi $s4, $t1, 460
	addi $s5, $t1, 524
	carga2:
	sw $t2, ($s4)
	sw $t2, ($s5)
	addi $s4, $s4, 4
	addi $s5, $s5, 4
	addi $t5, $t5, 1
	
	li $v0 32
	li $a0, 100
	syscall
	
	ble $t5, 11, carga2
	
	
	#Barra de carga3
	addi $t5, $zero, 0
	lw $t1, mapa($zero)
	lw $t2, carga
	addi $s4, $t1, 436
	addi $s5, $t1, 440
	carga3:
	sw $t2, ($s4)
	sw $t2, ($s5)
	addi $s4, $s4, -64
	addi $s5, $s5, -64
	addi $t5, $t5, 1
	
	li $v0 32
	li $a0, 100
	syscall
	
	ble $t5, 5, carga3
	
	
	li $v0 32
	li $a0, 2000
	syscall
	
	
	jr $ra #Volvemos para generar el mapa