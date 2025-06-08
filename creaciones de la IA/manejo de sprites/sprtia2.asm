;2DO INTENTO DE GEMINI EN MOSTRAR UN CUADRADO(SPRITE) EN EL CENTRO DE LA PANTALLA
.8086
; Asegura el modelo de memoria (SMALL para código y datos en 64KB)
.MODEL SMALL
; Define el tamaño de la pila (100h = 256 bytes, suficiente para este ejemplo)
.STACK 100h

; -----------------------------------------------------------------------------
; 1. DEFINICIÓN DE CONSTANTES (EQU)
;    Estas deben estar al principio del archivo para que TASM las reconozca
;    antes de que se usen en la sección .DATA o .CODE.
; -----------------------------------------------------------------------------
SPRITE_WIDTH    EQU 4
SPRITE_HEIGHT   EQU 4

; -----------------------------------------------------------------------------
; 2. SECCIÓN DE DATOS (.DATA)
;    Aquí se definen las variables y los datos del sprite.
; -----------------------------------------------------------------------------
.DATA
    ; Datos del sprite 4x4. Cada byte es un índice de color (0-255).
    ; En modo 13h, el color 1 suele ser azul, el color 2 suele ser verde.
    SPRITE_DATA     DB 1, 1, 1, 1   ; Fila 1 del sprite
                    DB 1, 2, 2, 1   ; Fila 2
                    DB 1, 2, 2, 1   ; Fila 3
                    DB 1, 1, 1, 1   ; Fila 4

    ; Variables para almacenar la posición X,Y donde se dibujará el sprite.
    ; Se calcularán para centrar el sprite en la pantalla.
    draw_x          DW  ?
    draw_y          DW  ?

; -----------------------------------------------------------------------------
; 3. SECCIÓN DE CÓDIGO (.CODE)
;    Aquí se definen las subrutinas y el programa principal.
; -----------------------------------------------------------------------------
.CODE

; --- SUBRUTINAS ---
; Es una buena práctica definir las subrutinas antes del MAIN PROC
; para que el ensamblador las conozca antes de que sean llamadas.

; DRAW_SPRITE PROC
; Descripción: Dibuja el sprite definido por SPRITE_DATA en las coordenadas (draw_x, draw_y).
; Entradas: Los valores de draw_x y draw_y deben estar cargados previamente.
; Registros afectados: AX, BX, CX, DI, SI, DX (se guardan y restauran en la pila).
DRAW_SPRITE PROC
    PUSH AX    ; Guarda el valor original de AX
    PUSH BX    ; Guarda el valor original de BX
    PUSH CX    ; Guarda el valor original de CX
    PUSH DI    ; Guarda el valor original de DI
    PUSH SI    ; Guarda el valor original de SI
    PUSH DX    ; Guarda el valor original de DX (se usará como contador de fila temporal)

    ; Configura el registro de segmento extra (ES) para apuntar a la memoria de video.
    ; En modo 13h (320x200x256), la memoria de video comienza en A000h.
    MOV AX, 0A000h
    MOV ES, AX

    ; Carga el offset del inicio de los datos del sprite en SI.
    MOV SI, OFFSET SPRITE_DATA
    ; Copia la coordenada Y de dibujo a DX para usarla como contador de fila.
    MOV DX, draw_y

    ; Bucle exterior: Itera a través de cada fila del sprite (SPRITE_HEIGHT veces).
    MOV CX, SPRITE_HEIGHT
    ROW_LOOP_DRAW:
        PUSH CX                 ; Guarda el contador de filas (CX) antes del bucle interior.

        ; Calcula el desplazamiento (offset) en la memoria de video para la fila actual.
        ; Fórmula: (Y_actual * AnchoDePantalla) + X_sprite
        MOV AX, DX              ; AX = Y_actual (la coordenada Y de la fila actual)
        MOV BX, 320             ; Ancho de la pantalla en modo 13h (320 píxeles).
        MUL BX                  ; Multiplica AX por BX (Y_actual * 320). El resultado (16 bits) va a AX.
                                ; (Si el resultado fuera > 65535, la parte alta iría a DX, pero aquí no ocurre).
        ADD AX, draw_x          ; Suma la coordenada X de dibujo para obtener el offset horizontal.
        MOV DI, AX              ; Mueve el offset calculado a DI. ES:DI apuntará al píxel de inicio de la fila.

        ; Bucle interior: Itera a través de cada píxel en la fila actual (SPRITE_WIDTH veces).
        MOV CX, SPRITE_WIDTH
        PIXEL_LOOP_DRAW:
            MOV AL, [SI]        ; Carga el byte del color del píxel desde los datos del sprite (DS:SI).
            MOV ES:[DI], AL     ; Escribe el byte del color en la memoria de video (ES:DI).
            INC SI              ; Avanza al siguiente byte en los datos del sprite.
            INC DI              ; Avanza al siguiente píxel en la memoria de video.
        LOOP PIXEL_LOOP_DRAW    ; Decrementa CX, si CX no es cero, salta a PIXEL_LOOP_DRAW.

        INC DX                  ; Incrementa DX para pasar a la siguiente fila (siguiente Y_actual).
        POP CX                  ; Restaura el contador de filas (CX) para el bucle exterior.
    LOOP ROW_LOOP_DRAW          ; Decrementa CX, si CX no es cero, salta a ROW_LOOP_DRAW.

    POP DX    ; Restaura el valor original de DX
    POP SI    ; Restaura el valor original de SI
    POP DI    ; Restaura el valor original de DI
    POP CX    ; Restaura el valor original de CX
    POP BX    ; Restaura el valor original de BX
    POP AX    ; Restaura el valor original de AX
    RET       ; Retorna de la subrutina
DRAW_SPRITE ENDP


; -----------------------------------------------------------------------------
; 4. PROGRAMA PRINCIPAL (MAIN PROC)
;    Punto de entrada de la aplicación.
; -----------------------------------------------------------------------------
MAIN PROC
    ; Inicializa los registros de segmento DS (Data Segment) y ES (Extra Segment).
    ; @DATA es un operador de MASM/TASM que obtiene la dirección del segmento de datos.
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX ; ES también apunta a DATA inicialmente, luego se cambiará a la memoria de video.

    ; --- 1. Establecer el modo de video 13h ---
    ; INT 10h, Servicio 00h: Establecer modo de video.
    ; AL = 13h: Modo 320x200 píxeles, 256 colores.
    MOV AH, 00h
    MOV AL, 13h
    INT 10h

    ; --- 2. Calcular la posición central del sprite ---
    ; Posición X: (Ancho de pantalla / 2) - (Ancho de sprite / 2)
    MOV AX, 320             ; Ancho de pantalla (320 píxeles)
    MOV CX, 2               ; Divisor (para dividir por 2)
    DIV CX                  ; AX = 160 (320 / 2)
    MOV BX, SPRITE_WIDTH    ; Ancho del sprite (4 píxeles)
    DIV CX                  ; AX = 2 (4 / 2)
    SUB AX, BX              ; (160 - 2 = 158) -> ¡ERROR LÓGICO AQUÍ, DEBE SER 160 - 2, NO AX - BX!
    ; --- CORRECCIÓN DEL CÁLCULO DE draw_x ---
    MOV AX, 320             ; Cargar el ancho de la pantalla
    MOV BX, 2               ; Divisor
    DIV BX                  ; AX = 160 (centro horizontal de la pantalla)
    PUSH AX                 ; Guarda el valor central (160) en la pila

    MOV AX, SPRITE_WIDTH    ; Ancho del sprite
    MOV BX, 2               ; Divisor
    DIV BX                  ; AX = 2 (mitad del ancho del sprite)
    POP BX                  ; Recupera el centro horizontal de la pantalla (160) en BX
    SUB BX, AX              ; BX = 160 - 2 = 158
    MOV draw_x, BX          ; Guarda el resultado en draw_x

    ; Posición Y: (Alto de pantalla / 2) - (Alto de sprite / 2)
    ; --- CORRECCIÓN DEL CÁLCULO DE draw_y (misma lógica que draw_x) ---
    MOV AX, 200             ; Cargar el alto de la pantalla
    MOV BX, 2               ; Divisor
    DIV BX                  ; AX = 100 (centro vertical de la pantalla)
    PUSH AX                 ; Guarda el valor central (100) en la pila

    MOV AX, SPRITE_HEIGHT   ; Alto del sprite
    MOV BX, 2               ; Divisor
    DIV BX                  ; AX = 2 (mitad del alto del sprite)
    POP BX                  ; Recupera el centro vertical de la pantalla (100) en BX
    SUB BX, AX              ; BX = 100 - 2 = 98
    MOV draw_y, BX          ; Guarda el resultado en draw_y


    ; --- 3. Dibujar el sprite en la posición calculada (centro de la pantalla) ---
    CALL DRAW_SPRITE

    ; --- 4. Esperar a que el usuario presione una tecla para salir ---
    ; INT 16h, Servicio 00h: Espera la pulsación de cualquier tecla.
    ; El programa se pausará aquí hasta que se presione una tecla.
    MOV AH, 00h
    INT 16h

    ; --- 5. Restaurar el modo de texto (80x25, monocromo o color) ---
    ; Esto es importante para que el sistema DOS vuelva a su estado normal.
    MOV AH, 00h
    MOV AL, 03h
    INT 10h

    ; --- 6. Terminar el programa ---
    ; INT 21h, Servicio 4Ch: Terminar proceso.
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; La directiva END debe ser la última línea del archivo y debe indicar el punto de entrada del programa.
END MAIN