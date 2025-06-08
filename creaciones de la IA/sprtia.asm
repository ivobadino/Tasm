.MODEL SMALL
.STACK 100h

; ----------------------------------------------------
; 1. Definición de Constantes EQU
; ----------------------------------------------------
SPRITE_WIDTH    EQU 4
SPRITE_HEIGHT   EQU 4

.DATA
    ; --- Definición del Sprite 4x4 ---
    SPRITE_DATA     DB 1, 1, 1, 1   ; Fila 1
                    DB 1, 2, 2, 1   ; Fila 2
                    DB 1, 2, 2, 1   ; Fila 3
                    DB 1, 1, 1, 1   ; Fila 4

    ; Posición actual y anterior del sprite
    sprite_x        DW  100
    sprite_y        DW  50
    prev_sprite_x   DW  ?
    prev_sprite_y   DW  ?

    ; Dirección del movimiento
    dir_x           DB  1
    dir_y           DB  1

    ; Buffer para guardar los píxeles del fondo
    BACKGROUND_BUFFER DB SPRITE_WIDTH * SPRITE_HEIGHT DUP(?)

.CODE

; ----------------------------------------------------
; 2. Subrutinas
; ----------------------------------------------------

; Rutina: DRAW_SPRITE (Dibuja el sprite en (sprite_x, sprite_y))
DRAW_SPRITE PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DI
    PUSH SI
    PUSH DX

    MOV AX, 0A000h
    MOV ES, AX

    MOV SI, OFFSET SPRITE_DATA
    MOV DX, sprite_y

    MOV CX, SPRITE_HEIGHT
    ROW_LOOP_DRAW:
        PUSH CX
        MOV AX, DX
        MOV BX, 320
        MUL BX
        ADD AX, sprite_x
        MOV DI, AX

        MOV CX, SPRITE_WIDTH
        PIXEL_LOOP_DRAW:
            MOV AL, [SI]
            MOV ES:[DI], AL
            INC SI
            INC DI
        LOOP PIXEL_LOOP_DRAW

        INC DX
        POP CX
    LOOP ROW_LOOP_DRAW

    POP DX
    POP SI
    POP DI
    POP CX
    POP BX
    POP AX
    RET
DRAW_SPRITE ENDP

; Rutina: SAVE_BACKGROUND_CURRENT_POS (Guarda el área rectangular del fondo en la posición actual)
SAVE_BACKGROUND_CURRENT_POS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DI
    PUSH SI
    PUSH DX

    MOV AX, 0A000h
    MOV ES, AX

    MOV SI, OFFSET BACKGROUND_BUFFER
    MOV DX, sprite_y                 ; Usar la posición ACTUAL del sprite
    MOV BX, sprite_x                 ; Usar la posición ACTUAL del sprite

    MOV CX, SPRITE_HEIGHT
    SAVE_CURRENT_ROW_LOOP:
        PUSH CX
        MOV AX, DX
        MOV BP, 320
        MUL BP
        ADD AX, BX
        MOV DI, AX

        MOV CX, SPRITE_WIDTH
        SAVE_CURRENT_PIXEL_LOOP:
            MOV AL, ES:[DI]
            MOV [SI], AL
            INC SI
            INC DI
        LOOP SAVE_CURRENT_PIXEL_LOOP

        INC DX
        POP CX
    LOOP SAVE_CURRENT_ROW_LOOP

    POP DX
    POP SI
    POP DI
    POP CX
    POP BX
    POP AX
    RET
SAVE_BACKGROUND_CURRENT_POS ENDP


; Rutina: RESTORE_BACKGROUND_PREV_POS (Restaura el área rectangular del fondo en la posición ANTERIOR)
RESTORE_BACKGROUND_PREV_POS PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DI
    PUSH SI
    PUSH DX

    MOV AX, 0A000h
    MOV ES, AX

    MOV SI, OFFSET BACKGROUND_BUFFER
    MOV DX, prev_sprite_y            ; Usar la POSICIÓN ANTERIOR del sprite
    MOV BX, prev_sprite_x            ; Usar la POSICIÓN ANTERIOR del sprite

    MOV CX, SPRITE_HEIGHT
    RESTORE_PREV_ROW_LOOP:
        PUSH CX
        MOV AX, DX
        MOV BP, 320
        MUL BP
        ADD AX, BX
        MOV DI, AX

        MOV CX, SPRITE_WIDTH
        RESTORE_PREV_PIXEL_LOOP:
            MOV AL, [SI]
            MOV ES:[DI], AL
            INC SI
            INC DI
        LOOP RESTORE_PREV_PIXEL_LOOP

        INC DX
        POP CX
    LOOP RESTORE_PREV_ROW_LOOP

    POP DX
    POP SI
    POP DI
    POP CX
    POP BX
    POP AX
    RET
RESTORE_BACKGROUND_PREV_POS ENDP


; ----------------------------------------------------
; 3. PROGRAMA PRINCIPAL
; ----------------------------------------------------
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    ; Establecer el modo de video 13h
    MOV AH, 00h
    MOV AL, 13h
    INT 10h

    ; ----------------------------------------------------
    ; Bucle principal de animación
    ; ----------------------------------------------------
    ANIM_LOOP:

        ; PASO 1: Borrar el sprite de su posición ANTERIOR
        ; (Esto solo tiene efecto a partir del segundo frame)
        CALL RESTORE_BACKGROUND_PREV_POS

        ; PASO 2: Guardar la posición actual del sprite para el borrado en el SIGUIENTE ciclo
        MOV AX, sprite_x
        MOV prev_sprite_x, AX
        MOV AX, sprite_y
        MOV prev_sprite_y, AX

        ; PASO 3: Actualizar la posición del sprite (movimiento y rebote)
        MOV AX, sprite_x
        ADD AX, WORD PTR dir_x
        MOV sprite_x, AX

        MOV AX, sprite_y
        ADD AX, WORD PTR dir_y
        MOV sprite_y, AX

        ; Comprobar límites X
        MOV AX, sprite_x
        CMP AX, 320 - SPRITE_WIDTH
        JNLE  SKIP_JUMP_X_MAX     ; JUMP SI NO CUMPLE (i.e. si AX > 320 - SW)
        JMP   CHECK_X_MIN         ; Si es <=, saltar a CHECK_X_MIN
SKIP_JUMP_X_MAX:                  ; Si AX > 320 - SW, ejecutar esto
        MOV BYTE PTR dir_x, -1
        MOV sprite_x, 320 - SPRITE_WIDTH
        JMP CHECK_Y_BOUNDS

CHECK_X_MIN:
        MOV AX, sprite_x
        CMP AX, 0
        JNGE  SKIP_JUMP_Y_BOUNDS  ; JUMP SI NO CUMPLE (i.e. si AX < 0)
        JMP   CHECK_Y_BOUNDS      ; Si es >=0, saltar a CHECK_Y_BOUNDS
SKIP_JUMP_Y_BOUNDS:               ; Si AX < 0, ejecutar esto
        MOV BYTE PTR dir_x, 1
        MOV sprite_x, 0

CHECK_Y_BOUNDS:
        ; Comprobar límites Y
        MOV AX, sprite_y
        CMP AX, 200 - SPRITE_HEIGHT
        JNLE  SKIP_JUMP_Y_MAX     ; JUMP SI NO CUMPLE (i.e. si AX > 200 - SH)
        JMP   CHECK_Y_MIN         ; Si es <=, saltar a CHECK_Y_MIN
SKIP_JUMP_Y_MAX:                  ; Si AX > 200 - SH, ejecutar esto
        MOV BYTE PTR dir_y, -1
        MOV sprite_y, 200 - SPRITE_HEIGHT
        JMP DRAW_SPRITE_AND_SAVE_BACKGROUND

CHECK_Y_MIN:
        MOV AX, sprite_y
        CMP AX, 0
        JNGE  SKIP_JUMP_DRAW_SPRITE ; JUMP SI NO CUMPLE (i.e. si AX < 0)
        JMP   DRAW_SPRITE_AND_SAVE_BACKGROUND ; Si es >=0, saltar a DRAW_SPRITE_AND_SAVE_BACKGROUND
SKIP_JUMP_DRAW_SPRITE:             ; Si AX < 0, ejecutar esto
        MOV BYTE PTR dir_y, 1
        MOV sprite_y, 0

        ; PASO 4: Dibujar el sprite en la NUEVA posición
DRAW_SPRITE_AND_SAVE_BACKGROUND:
        CALL DRAW_SPRITE

        ; PASO 5: Guardar el fondo DEBAJO del sprite en su NUEVA posición
        CALL SAVE_BACKGROUND_CURRENT_POS


        ; Pequeño retardo
        MOV CX, 0FFFFh
        DELAY_LOOP:
            LOOP DELAY_LOOP

        ; Comprobar si se ha pulsado una tecla para salir
        MOV AH, 01h
        INT 16h
        JNZ   EXIT_PROGRAM        ; JUMP SI SE PULSA TECLA (ZF=0)
        JMP   ANIM_LOOP           ; Si no se pulsa, seguir el bucle (ZF=1)
EXIT_PROGRAM:                     ; Etiqueta para salir

    ; Restaurar el modo de texto
    MOV AH, 00h
    MOV AL, 03h
    INT 10h

    ; Terminar el programa
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

END MAIN