# estructura

- menu ( reglas , juego, salir)
- mostrar reglas
- juego()
- aleatorio y decrementar en array
- mostrar y sumar cartas
- petición usuario (pedir, quedarse, retirarse)
- apostar x dinero (pa depues si se puede)
- ganar y perder
- caso AS (si el usuario tiene menos de 11 el A vale 11 si tine mas el A vale 1)
- condiciones del crupier (si tiene mas de 16 no puede pedir mas cartas y si es menor esta obligado a pedir otra)
- perder (si la suma de las cartas en menor a la del crupier cuando se finalizo el turno de  jugador  o  su mano  supera  los 21 el jugar pierde)

# Funcionamiento

## 1-mostrar menu y escoger accion  ( reglas , juego, salir)

## 2-juego
procesos 

- A-generar cartas y repartir
- B-repartir (quitar las cartas del array)
- C-mostrar las dos cartas del jugador y una del crupier y la suma de sus cartas  (black jack)
- D-petición usuario:  si quiere otra carta, no la quiere o se quiere retirarse

1-si quiere 
a-generar carta nueva(quitar la carta del array)
b-mostrar cartas con la nueva carta y la suma con las que tenia y las del crupier
c-petición usuario:  si quiere otra carta o no o se quiere retirar 

2-no quiere 
mostrar la carta oculta del crupier si es meno a 17 pedir una carta si es mayor sumar puntos 
(continua black jack)
		
a-no es mas grande: 
		1-genera una carta para el crupier(quitar la carta del array) 
		2-mostrar la suma de las del crupier y las tuyas y las cartas de cada uno
		3-y repetir si crupier tiene menos de  17 pedir una carta si es mayor sumar puentos

b-si es mas grande:		
		1-comparar puntos del crupier con 21 si es menor 
			a-menor 
				1-compara puntos jugador y puntos crupier quien tenga mas gana y en caso que ser iguales se devulve la plata al jugador 
				2-vuelve a "2- juego"
			b-mayor
				1-si el crupier tiene mas de 21 pierde automáticamente
				2-vuelve a "2- juego"

	

exepciones:
1-(esto solo acurre cuando con las dos primeras cartas repartidas llega a el 21 siendo sin dejar que el usuario escoja termina su turno así que ocurre en la parte de proceso donde dice black jack)
	el usuario usuario tiene 21 black jack (A y 10, A y K, A y Q, A  y J) 
	muestra la carta oculta de crupier asiendo que pasara a donde dice "continua black jack" 

	



