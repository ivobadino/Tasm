.8086
.model small
.stack 100h
.data
	menu1_0 db ("Selecione a donde quiere ingresar"),0ah
	menu1_1 db ("1 = Ver reglas"),0ah
	menu1_2 db ("2 = Juagar"),0ah
	menu1_3 db ("3 = Salir"),0dh,0ah,24h
	menu1_Salir db ("Fin de programa..."),0dh,0ah,24h

    Puntos_juagdor db ("000"),0dh,0ah,24h
    Puntos_Crupier db ("000"),0dh,0ah,24h



    filename db 'estruc.txt',0   ; Nombre del archivo
    buffer db 2462 dup('$')      ; Espacio para
    mensajeContinuar db ("precione tecione una tecla para continuar "),0dh,0ah,24h
    errorMsg db 'Error al abrir el archivo' ,0dh,0ah,24h

;23 × 107 es 2,461.
.code
extrn imprimir:proc
main proc
    mov ax, @data
    mov ds, ax

    call mostrar_menu

    fin:
    mov ax, 4c00h
    int 21h
main endp


mostrar_menu proc   
    push bx
    push ax
        ver_menu:
            xor bx,bx
            lea bx,menu1_0
            call imprimir
            mov ah,1
            int 21h
            call salto_linea
            sub al,30h
            cmp al,1
            je ver_reglas
            cmp al,2
            je jugar
            cmp al, 3
            je salir_del_menu
            jmp ver_menu
    ver_reglas:
        call imprimir_reglas 
        jmp ver_menu
    jugar:
        call game
        jmp ver_menu
    salir_del_menu:
        lea bx,menu1_Salir
        call imprimir
        jmp salir_del_programa

    salir_del_programa:
    pop ax
    pop bx
    ret
mostrar_menu endp

salto_linea proc
    push ax
    push dx
        mov ah,2
        mov dl,0ah
        int 21h
    pop dx
    pop ax
    ret
salto_linea endp
imprimir_reglas proc
    push ax
    push bx
    push dx
    push cx
    push si

        ; Limpiar pantalla
mov ah, 0
mov al, 3      ; Modo texto 80x25
int 10h
        xor ax, ax

        ; Abrir el archivo
        mov ah, 3Dh         ; Función de DOS para abrir archivo
        mov al, 2           ; Modo lectura + compartir
        mov dx, OFFSET filename
        int 21h
        jc error            ; Si falla, mostrar mensaje de error

        mov bx, ax          ; Guardar el manejador del archivo

        ; Leer hasta 2461 caracteres
        mov ah, 3Fh
        mov cx, 2461
        mov dx, OFFSET buffer
        int 21h
        jc error

        ; Agregar terminador de cadena para mostrar
        mov si, ax
        add si, OFFSET buffer
        mov BYTE PTR [si], '$'

        ; Mostrar el contenido leído
        mov dx, OFFSET buffer
        mov ah, 09h
        int 21h

        ; Cerrar el archivo
        mov ah, 3Eh
        mov bx, bx      ; Ya está en bx el handle
        int 21h

        jmp salir_reglas

error:
        lea bx, errorMsg
        call imprimir

salir_reglas:
    esperar:
        mov ah, 0      ; Función 0: Esperar y obtener tecla
int 16h        ; Llama a la interrupción del teclado
; AL tendrá el código ASCII de la tecla
; AH tendrá el código de escaneo
        pop si
        pop cx
        pop dx
        pop bx
        pop ax
        ret
imprimir_reglas endp

game proc
ret
game endp



end