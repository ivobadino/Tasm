;INTENTO DE JUEGO FUNCIONAL DE CHAT GPT
.model small
.stack 100h
.data
    jugadorMsg db 'Tu puntaje: $'
    crupierMsg db 13,10,'Puntaje del crupier: $'
    ganarMsg db 13,10,'¡Ganaste!', 13,10,'$'
    perderMsg db 13,10,'Perdiste.', 13,10,'$'
    empateMsg db 13,10,'Empate.', 13,10,'$'
    pedirMsg db 13,10,'¿Quieres otra carta? (s/n): $'
    carta db ?
    jugadorTotal db 0
    crupierTotal db 0
    opcion db ?
.code
start:
    mov ax, @data
    mov ds, ax

    ; Inicializar generador de números pseudoaleatorios
    mov ah, 2Ch
    int 21h
    mov ah, dl ; semilla básica

    ; Primer carta jugador
    call generar_carta
    mov jugadorTotal, al
    call mostrar_puntaje_jugador

siguiente_carta:
    lea dx, pedirMsg
    mov ah, 09h
    int 21h

    ; Leer opción
    mov ah, 01h
    int 21h
    mov opcion, al

    cmp al, 's'
    je pedir_carta
    cmp al, 'S'
    je pedir_carta
    jmp turno_crupier

pedir_carta:
    call generar_carta
    add jugadorTotal, al
    call mostrar_puntaje_jugador
    mov al, jugadorTotal
    cmp al, 21
    ja terminar_perder ; si > 21, pierde
    je turno_crupier   ; si == 21, pasa al crupier
    jmp siguiente_carta

turno_crupier:
    ; Crupier roba hasta llegar a 17
crupier_loop:
    call generar_carta
    add crupierTotal, al
    mov al, crupierTotal
    cmp al, 17
    jb crupier_loop

    ; Mostrar puntaje del crupier
    lea dx, crupierMsg
    mov ah, 09h
    int 21h
    mov al, crupierTotal
    call mostrar_num

    ; Comparar resultados
    mov al, jugadorTotal
    mov bl, crupierTotal
    cmp al, 21
    ja terminar_perder
    cmp bl, 21
    ja terminar_ganar

    cmp al, bl
    ja terminar_ganar
    jb terminar_perder
    je terminar_empate

terminar_ganar:
    lea dx, ganarMsg
    mov ah, 09h
    int 21h
    jmp salir

terminar_perder:
    lea dx, perderMsg
    mov ah, 09h
    int 21h
    jmp salir

terminar_empate:
    lea dx, empateMsg
    mov ah, 09h
    int 21h

salir:
    mov ah, 4Ch
    int 21h

; --------------------------------------------------
; Subrutinas
; --------------------------------------------------

generar_carta:
    ; Devuelve una carta entre 1 y 11 en AL
    ; AL = pseudo-random entre 1 y 11
    mov ah, 2Ch
    int 21h
    mov al, dl
    xor ah, ah
    mov bl, 11
    div bl
    add ah, 1
    mov al, ah
    ret

mostrar_puntaje_jugador:
    lea dx, jugadorMsg
    mov ah, 09h
    int 21h
    mov al, jugadorTotal
    call mostrar_num
    ret

mostrar_num:
    ; AL contiene el número (0-255)
    ; Muestra el número en pantalla
    ; convierte a decimal simple
    mov ah, 0
    mov bl, 10
    div bl
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    mov al, ah
    cmp al, 0
    je skip_second_digit
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
skip_second_digit:
    ret
end start