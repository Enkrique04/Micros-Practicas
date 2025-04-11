list p=16f877a
#include <P16f877a.inc>

__CONFIG _WDT_OFF & _PWRTE_ON & _XT_OSC & _LVP_OFF & _CP_OFF

ORG 0x00
    GOTO Inicio

; === Variables ===
Entrada    EQU 0x20
AcarreoM   EQU 0x21
Resultado  EQU 0x27
Multiplo   EQU 0x28
Divisor    EQU 0x30

ORG 0x05
Inicio:
    ; Configuración de puertos
    BCF STATUS, RP0
    BCF STATUS, RP1
    CLRF PORTB
    CLRF PORTD

    BSF STATUS, RP0
    CLRF TRISB         ; Puerto B como salida
    MOVLW 0xFF
    MOVWF TRISD        ; Puerto D como entrada
    BCF STATUS, RP0

LoopPrincipal:
    ; Inicialización de variables
    CLRF Entrada
    CLRF Multiplo
    CLRF AcarreoM
    CLRF Resultado
    CLRF Divisor

    ; Validación de entrada <= 106
    MOVLW D'107'
    SUBWF PORTD, W
    BTFSC STATUS, C
    GOTO Fin

    ; Cargar valores
    MOVLW D'12'
    MOVWF Multiplo
    MOVLW D'5'
    MOVWF Divisor

; === Multiplicación: Entrada = PORTD * 12 ===
Multiplica:
    MOVF PORTD, W
    ADDWF Entrada, W
    MOVWF Entrada
    BTFSC STATUS, C
    INCFSZ AcarreoM, F
    DECFSZ Multiplo, F
    GOTO Multiplica
    INCF AcarreoM, F   ; Asegura redondeo final

; === División: Resultado = Entrada / 5 ===
Divide:
    MOVF Divisor, W
    SUBWF Entrada, W
    MOVWF Entrada
    BTFSS STATUS, C
    DECFSZ AcarreoM, F
    INCF Resultado, F
    ; Si AcarreoM ? 0, seguir dividiendo
    MOVF AcarreoM, W
    BTFSS STATUS, Z
    GOTO Divide

; === Mostrar resultado ===
    MOVF Resultado, W
    MOVWF PORTB
    GOTO LoopPrincipal

Fin:
    END
