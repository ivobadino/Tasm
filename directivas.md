lo primero que necesitamos es que se cren variables en el data set de 
cartelitos para cada situcion
tu puntos son : 000
tus cartas : A y J
cartas del crupier: A y la otra es una sorpresa para mas tarde

selecciona que quieres hacer 1=vas a pedir carta o te dio miedo  2= plantarse cobarde  3 = rendirse cangó

ganaste cornudo
perdiste por pendejo

 

cartas el maso db "texto"
cartas del jugador db "texto"
cartas del crupier db "texto"

valor cartas jugador db nr 
valor cartas crupier db nr

un detector de caracteres que elimine el carácter de el array mientras van apareciendo y otro que valide que el array 
no este lleno de $ y si lo esta que reinicie el maso y que muestre un cartel tipo como el crupier se quedo sin cartas 
esta mesclando el maso y que continue ejecutando el codigo

---
por el otro también falta hacer el segundo menu que te pedir carta, plantarse o salir que en este  que si se plata que recién en este 
punto se muestre la carta del crupier y que sume los puntos de el 
una función sumar así no modificamos los datos guardados en los reg , que compare si el valor de las cartas del crupier es menor a 17 
pida carta si es mayor a 21 perdió y si esta en ese rango compare con el jugador y quien la tenga mas grande gana y cree una que comapre 
cuando el jugador pida cartas que si se pasa de 21 vuelva otravez a repartir cartas y que muertre perdió

---

y falta una que vuelva a llenar el array creo que lo mas fácil es tener dos iguales y cuando se bacie una función que copie en axiliar en 
el que si se usa

persona 1

yo diría que uno haga las variables en .data para:
	Cartas del jugador (cartas_jugador db "texto")
	Cartas del crupier (cartas_crupier db "texto")
	Valores de las cartas (valor_cartas_jugador db nr, valor_cartas_crupier 	db nr)
	Carteles de juego (ganaste, perdiste, mezclando mazo, etc.)
	
Implementar mecanismo de eliminación de cartas del array.
imprlementas mecansimo para volver a cargar cuando se llene de los $

persona 2

Mostrar cartas iniciales del juagado y del crupir pero solo una
Opciones del jugador: 1 = pedir carta, 2 = plantarse, 3 = rendirse 0= voler a menu.
cárteles de puntos y cartas 
contador de puntos (la función que suma el valor de las cartas y ahi tiene que haber cmp 
que si hay un A en las cartas y la suma de das demás cartas es menor a 11 el A vale 11 si es mayo a 11 el A vale 1 )
y el cmp si los puntos del juagador es mayor 21 pedio 

persona 3
que haga los casos del crupir y balck jack
Si tiene menos de 17, debe pedir carta.
Si es mayor o igual a 17, se planta y compara puntos.
Si supera 21, pierde automáticamente.
si el jugar consigue los 21 puntos en las do sprimeras carts que salte a mostrar las cartas del crupir y cmp si tiene 
mas o menos de 20 si tiene menos gana el jugador y si tine 21 es empate y no puede tener mas porque es apenas se reparten las 
dos primeras cartas asi que es imposible 

persona 4  (yo estaba haciedo esto igual casi todo necesitamos si o si el coso para generar los nuemros)
mostrar reglas 
menu principal 
en menu mostrar las estadísticas de cuantas victorias y derrortas tobo la persona
