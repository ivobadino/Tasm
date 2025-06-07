;LIBRERIA DE FUNCIONES PARA ASSEMBLER
;libreria creada por Badino Ivan

.8086
.model small
.stack 100h
.data
	auxiliares 				db 100,10,1
	indice					db 0
	txtdebug 				db "ok",0dh,0ah,24h
	txtNoCaracter			db "el carcter ingresado no es valido, vuelva a ingresar todo el texto",0ah,0dh,24h 
	caracteresLetrNUm 		db	30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,41h,42h,43h,44h,45h,46h,47h,48h,49h,4ah
							db	4bh,4ch,4dh,4eh,4fh,50h,51h,52h,53h,54h,55h,56h,57h,58h,59h,5ah,61h,62h,63h,64h
							db	65h,66h,67h,68h,69h,6ah,6bh,6ch,6dh,6eh,6fh,71h,72h,73h,74h,75h,76h,77h,78h,79h,7ah,24h
	caracteresEspeciales 	db  0 
.code

	;╔╦═════╦╦══LISTA DE FUNCIONES══════════╦╦══════════════╦╗
	;║║		║║								║║				║║
	;║║ 01. ║║ 		IMPRIMIR TEXTO 		-->>║║	linea 71	║║
	 ║║		║║	public imprimirTextof		║║				║║
	;║║		║║								║║				║║
	;║║ 02. ║║		CARAGAR CARACTERES 	-->>║║	linea 73	║║
	 ║║		║║	public cargaCaracteresf		║║				║║
	;║║		║║								║║				║║
	;║║ 03. ║║ CARGA DE NUMEROS Y LETRAS-->>║║	linea 105	║║
	 ║║		║║	public cargaAlfaNumericaf	║║				║║
	;║║		║║								║║				║║
	;║║ 04. ║║		CARGA DE NUMEROS	-->>║║	linea 156	║║
	 ║║		║║	public cargaNumericaf 		║║				║║
	;║║		║║								║║				║║
	;║║ 05. ║║		ASCII A NUMEROS		-->>║║	linea 199	║║
	 ║║		║║	public asciiToRegf 			║║				║║
	;║║		║║								║║				║║
	;║║ 06. ║║		NUMEROS A ASCII		-->>║║	linea 241	║║
	 ║║		║║	public regToAsciif  		║║				║║
	;║║		║║								║║				║║
	;║║ 07. ║║		ASCII A BINARIO		-->>║║	linea 289	║║
	 ║║		║║	public asciiTobinf			║║				║║
	;║║		║║								║║				║║
	;║║ 08. ║║		BINARIO A ASCII		-->>║║	linea 327	║║
	 ║║		║║	public binToAsciif			║║				║║
	;║║		║║								║║				║║
	;║║ 09. ║║ CONTAR CARACTERES GENERAL-->>║║	linea 363	║║
	 ║║		║║	public ContarCaracteresf	║║				║║
	;║║		║║								║║				║║
	;║║ 10. ║║ CONTAR CARACTERES UNICOS -->>║║	linea 389	║║
	 ║║		║║	public ContarCaracterf		║║				║║
	;║║		║║								║║				║║
	;║║ 11. ║║ CAMBIO DE CARACTER UNICO -->>║║	linea 113	║║
	 ║║		║║	public cambioCaracterf		║║				║║
	;║║		║║								║║				║║
	;║║ 12. ║║ CAMBIO DE CARACTER VARIOS-->>║║	linea 416	║║
	 ║║		║║	public	cambioCaracteresf	║║				║║
	;║║		║║								║║				║║
	;║║ 13. ║║	  IMPRIMIR printmenu    -->>║║	linea571	║║
	 ║║		║║	public	printmenu			║║				║║
	;║║		║║								║║				║║
	;║║ 13. ║║							-->>║║	linea 416	║║
	 ║║		║║	public						║║				║║
	;║║		║║								║║				║║
	;║║ 13. ║║							-->>║║	linea 416	║║
	 ║║		║║	public						║║				║║
	;║║		║║								║║				║║
	;║║ 13. ║║							-->>║║	linea 416	║║
	 ║║		║║	public						║║				║║
	;║║		║║								║║				║║
	;╚╩═════╩╩══LISTA DE FUNCIONES══════════╩╩══════════════╩╝

;||01||==FUNCION==PARA==IMPRIMIR==TEXTO===========================================================================================
;
	imprimirTextof proc
	;funcion para imprimir por pantalla un texto completo (POR STACK)
	;recibo por dx el offset de la variable que contiene el texto
		push bp
		mov bp,sp
		push dx
		push ax

		mov dx,ss:[bp+4]

		mov ah,9
		int 21h

		pop ax
		pop dx
		pop bp
		ret 2
	imprimirTextof endp

;||02||==FUNCION==PARA==CARGAR==CARACTERES=====================================================================================================
;
	cargaCaracteresf proc
	;funcion para cargar todo tipo de caracteres
	;en bx tengo el offset de la variable a rellenar con caracteres
	;en cx,tengo la cantidad de caracteres que se van a leer
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push si 
			
			xor ch,ch
			carga: 
				mov ah,1
				int 21h
				cmp al,0ah
				je fincarga
				mov [bx],al
				inc bx
			loop carga
			fincarga:
		
		pop si
		pop cx
		pop bx
		pop ax
		pop bp
		ret
	cargaCaracteresf endp

;||03||==FUNCION==PARA==CARGAR==SOLO==CARACTERES==Y==NUMEROS===================================================================================================
;
	cargaAlfaNumericaf proc
	;funcion para caragar caracteres excusivamente alfanumericos(POR STACK)
	;en bx recibo el offset de la variable a rellenar con caracteres
	;en cx recibo la cantidad de caracteres que se van a leer
		push bp
		mov bp,sp
		push ax
		push bx
		push cx
		push si 

			volver:
			mov cx,ss:[bp+4]
			mov bx,ss:[bp+6]
			lea si,caracteresLetrNUm
			carga1: 
				mov ah,1
				int 21h

				cmp al,0ah
				je fincarga
				verif:
					cmp al,[si]
					je esletra
					cmp byte ptr [si],24h
					je noesln
					inc si
					jmp verif
				esletra:
				mov [bx],al
				inc bx
			loop carga
			fincarga1:

			jmp finnoesln

			noesln:
				mov ah,9
				mov dx,offset txtNoCaracter
				int 21h
				jmp volver
			finnoesln:

		pop si
		pop cx
		pop bx
		pop ax
		pop bp
		ret 4
	cargaAlfaNumericaf endp

;||04||==FUNCION==PARA==CARGAR==SOLO====NUMEROS======================================================================================
;
	cargaNumericaf proc
	;funcion para cargar caracteres exvlusivamente numericos(POR STACK)
	;recibo en bx el offset de la varaible a rellenar con numeros
		push bp
		mov bp,sp
		push bx
		push cx
		push ax
		push dx

			mov bx,ss:[bp+4]

			volver2:

			mov cx,3
			carga2:
				mov ah,1
				int 21h
				cmp al,30h
				jb noesnum
				cmp al,39h
				ja noesnum
				mov [bx],al
				inc bx
			loop carga2
			jmp finnoesnum
			noesnum:
				mov ah,9
				mov dx,offset txtNoCaracter
				int 21h
				jmp volver2
			finnoesnum:

		pop dx
		pop ax
		pop cx
		pop bx
		pop bp
		ret 2
	cargaNumericaf endp

;||05||==FUNCION==PARA==PASAR==DE==CARACTERES==ASCII==A==VALORES==NUMERICOS=======================================================================
;
	asciiToRegf proc
	;funcion para pasar de ascii a numeros(POR STACK)
	;recibo en bx el offset de la variable que contiene a los cararcteres 
	;recibo en si el offset de la variable que tiene los numeros auxiliares para la multiplicacion 
	;en di tengo el puntero de la variable que contiene el numero 
	push bp
	mov bp,sp
	push bx
	push ax
	push si
	push di
	push dx


		mov bx,ss:[bp+8]		;offset de la variable en ascii
		mov di,ss:[bp+6]		;puntero de la variable
		mov si,ss:[bp+4]		;offset de los auxiliares

		xor ax,ax
		xor dx,dx

		mov al,[bx]
		sub al,30h
		mov dl,[si]
		mul dl
		add [di],al

		inc bx
		inc si
		xor ah,ah

		mov al,[bx]
		sub al,30h
		mov dl,[si]
		mul dl 
		add [di],al 

		inc bx
		inc si
		xor ah,ah

		mov al,[bx]
		sub al,30h
		add [di],al


	pop dx
	pop di
	pop si
	pop ax
	pop bx
	pop bp
	ret 6
	asciiToRegf endp

;||06||==FUNCION==PARA==PASAR==DE==VALORES==NUMERICOS==A==CARACTERES==ASCII=======================================================================
;
	regToAsciif proc
	;funcion para pasar de numeros a ascii(POR STACK)
	;recibo en bx el offset de la variable que contiene el valor en ascii en donde sera guardado
	;recibo en si el offset de la variable que contiene los numeros auxiliares
	;recibo en al puntero de la variable con el valor numerico
	push bp
	mov bp,sp
	push ax
	push dx
	push cx
	push si
	push bx
	push di

		mov bx,ss:[bp+8] ;recibe el offset de la variable a guardar en ascii
		mov di,ss:[bp+6] ;recibe el offset de la variable con el numero
		mov si,ss:[bp+4] ;recibe el offset de la variable con auxiliares

		xor ax,ax
		mov al, [di]
		mov dl, [si] 
		div dl 
		add [bx],al

		mov al, ah 
		xor ah, ah 
		inc bx
		inc si

		mov dl, [si]
		div dl 
		add [bx],al
		inc bx
		add [bx],ah
		
	pop di
	pop bx
	pop si
	pop cx
	pop dx
	pop ax
	pop bp
	ret 6
	regToAsciif endp

;||07||==FUNCION==PARA==PASAR==DE==ASCII==A==BINARIO==============================================================================================
; 
	asciiToBinf proc
	;funcion para pasar numeros en ascii a valores numericos en binario(POR STACK)
	;en bx tengo el offset de la variable que contiene los numeros en ascii (recibo 8 bits(un byte))
	;en si tengo el offset de la variable a rellenar con valores numericos
	push bp
	mov bp,sp
	push bx
	push cx
	push dx

		mov si,ss:[bp+4]
		mov bx,ss:[bp+6]

		mov cx,8
		mov dl,0
		a2b:
			shl dl,1
			cmp byte ptr [bx],30h
			jne isone
		sigue1:
		 	inc bx
		loop a2b
		jmp finsigue1
		isone:
			inc dl
		jmp sigue1
		finsigue1:
		mov [si],dl

	pop dx
	pop cx
	pop bx
	pop bp
	ret 4
	asciiToBinf endp

;||08||==FUNCION==PARA==PASAR==DE==BINARIO==A==ASCII==============================================================================================
;
	binToAsciif proc
	;funcion para pasar de valores numericos en binario a numeros en ascii(POR STACK)
	;en bl recibo el valor de el numero en binario
	;en si recibo el offset de la variable a rellenar con numeros en ascii(devuelvo 8 bits)
	push bp
	mov bp,sp
	push cx
	push bx
	push si

		mov cx,8
		mov bl,ss:[bp+6]
		mov si,ss:[bp+4]
		movimiento:
			shl bl,1
			jc esUno
		sigue:
			inc si
		loop movimiento
		jmp fin
		esUno:
			mov byte ptr [si],31h
		jmp sigue
		fin:
		

	pop si
	pop bx
	pop cx
	pop bp
	ret 4
	binToAsciif endp

;||09||==FUNCION==PARA==CONTAR==CARACTERES========================================================================================
;
	ContarCaracteresf proc
	;funcion para contar caracteres de una cadena de caracteres de cualquier longitud 
	;recibe en bx el offset de la cadena de caracteres a evaluar
	;recibe en al el caracter que no se va a contar(si no recibe nada se cuentan todos)
	;devuelve en dl la cantidad de caracteres
	push bx

		xor ah,ah
		mov dx,0
		contar:
			cmp [bx],byte ptr 0ah
			je fincontar
			cmp [bx],al
			je nocuenta
			inc dl
			nocuenta:
			inc bx
		jmp contar
		fincontar:

	pop bx
	ret
	ContarCaracteresf endp

;||10||==FUNCION==PARA==CONTAR==UN==CARACTER==ESPECIFICO=============================================================================================
;
	ContarCaracterf proc
	;funcion para contar las repeticiones de un caracter en una cadena de caracteres de cualquer longitud 
	;recibe en bx el offset de la cadena de caracteres a evaluar
	;recibe en al el caracter que se va a contabilizar
	;devuelve en dl la cantidad contabilizada
	;devuelve en cx la cantidad total de caracteres
	push bx

		xor ah,ah
		xor cx,cx
		xor dx,dx
		mov dx,0
		contar1:
			cmp [bx],byte ptr 0ah
			je fincontar1
			cmp [bx],al
			je cuenta
			inc bx
			inc cx
		jmp contar1
			cuenta:
			inc dx
			inc bx
			inc cx
		jmp contar1
		fincontar1:

	pop bx
	ret
	ContarCaracterf endp

;||11||==FUNCION==PARA==REMPLAZAR==UN==CARACTER=============================================================================================
;
	cambioCaracterf proc
	;funcion para cambiar algun caracter en especifico por otro dentro de una cadena de caracteres (POR STACK)
	;recibo en bx el offset de la cadena de caracteres principal
	;recibo en si el offset de la cadena en donde se va a guardar el texto modificado
	;recibo en al la letra a reemplazar
	;recibo en ah la letra nueva
	push bp
	mov bp,sp
	push bx
	push si
	push ax

		mov bx,ss:[bp+10]
		mov si,ss:[bp+8]
		mov al,ss:[bp+6]
		mov ah,ss:[bp+4]

		buscar:
			cmp [bx],byte ptr 0ah
			je finbuscar
			cmp [bx],al 
			je escaracter
			mov ah,[bx]
			mov [si],ah
			inc bx
			inc si
		jmp buscar
		escaracter:
			mov ah,ss:[bp+4]
			mov [si],ah
			inc bx
			inc si
		jmp buscar
		finbuscar:

	pop ax
	pop si
	pop bx
	pop bp
	ret 8
	cambioCaracterf endp

;||12||==FUNCION==PARA==REMPLAZAR==VARIOS==CARACTERES=============================================================================================
;
	cambioCaracteresf proc
	;funcion para cambiar algun caracter en especifico por otro dentro de una cadena de caracteres (POR STACK)
	;recibo en bx el offset de la cadena de caracteres principal
	;recibo en si el offset de la cadena en donde se va a guardar el texto modificado
	;recibo en al la letra a reemplazar

	;ss:[bp+4] offset del texto base
	;ss:[bp+6] offset donde se guardara el texto
	;ss:[bp+8] ofset de la cadena de caracteres para buscar a remplazar
	;ss:[bp+10] offset de la cadena con los caracteres nuevos 
	push bp
	mov bp,sp
	push bx
	push si
	push ax
	push cx

		xor cx,cx
		mov bx,ss:[bp+10];offset texto base
		mov si,ss:[bp+8];offset texto reseptor

		refill:
			cmp [bx],byte ptr 0ah
			je finrefill
			mov al,[bx]
			mov [si],al 
			inc bx 
			inc si
		finrefill:

		mov bx,ss:[bp+8];offset texto reseptor
		mov si,ss:[bp+6];offset cararcters a buscar
		xor al,al 

		remplazar:
			cmp	[bx],byte ptr 0ah
			je finremplazar
			buscarc:
				cmp [si],byte ptr 0ah
				je finbusarc
				mov al,[si]
				cmp [bx],al 
				je cambio 
				inc si
				inc cx
			jmp buscarc 
			finbusarc:
				inc bx
				xor cx,cx
				mov si,ss:[bp+6]			;devuelvo el ofset a si (el inicio de la cadena de los caracters de busqueda)
			jmp remplazar
		jmp remplazar

		cambio:
			mov si,ss:[bp+4]				;muevo a si el offset de la cadena con los caracteres que van a pisar los anteriores
			add si,cx						;selecciono el caracter	
			mov al,[si]						
			mov [bx],al
		jmp finbusarc 						;piso el caracter
		finremplazar:
	
	pop cx
	pop ax
	pop si
	pop bx
	pop bp
	ret 8
	cambioCaracteresf endp

;||013||==FUNCION==PARA==IMPRIMIR==MENU=========================================================================================
;
	printmenu proc
	; recibe en bx el ofset del menu
	; imprime letra por letra y recibe por al la cantidad de opciones que va a imprimir
	; si por al recibe el tipo de servicio, si es cero imprime hasta el numero indicado en si
	;si recibe distinto de cero imprime solo el texto indicado en si

		push bx
		push ax 
		push cx

		xor cx,cx
		mov ah,2

		cmp al,0
		jne imprimiruno
		imprimir:
			cmp byte ptr[bx],25h
			je finimprimir
			cmp byte ptr[bx],24h 
			je encuesta
			mov dl,byte ptr[bx]
			int 21h
			inc bx
			jmp imprimir

		encuesta:
			cmp si,cx
			je finimprimir
			inc cx
			inc bx
			jmp imprimir

		imprimiruno:
			cmp si,cx
			je printar
			cmp byte ptr[bx],24h
			je incremento
			cmp byte ptr[bx],25h
			je finimprimir
			inc bx 
			jmp imprimiruno
			incremento:
				inc cx
				inc bx
		jmp imprimiruno

		printar:
			mov ah,9
			mov dx,bx
			int 21h

		finimprimir:

		pop cx
		pop ax 
		pop bx

		ret 
	printmenu endp


end 