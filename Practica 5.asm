LIST P=16F877A
#include <P16F877A.INC>
__CONFIG _WDT_OFF & _PWRTE_ON & _XT_OSC & _LVP_OFF & _CP_OFF

ORG 0x0000
GOTO START

TENS  EQU 0x20 
UNITS EQU 0x21  
TEMP  EQU 0x22  
TEMP2 EQU 0x23  

START:
    CLRF PORTB      
    CLRF PORTC     
    BSF STATUS, RP0 
    CLRF TRISB     
    CLRF TRISC     
    BCF STATUS, RP0 

    CLRF TENS     
    CLRF UNITS      

LOOP:
    ; Muestra unidades
    MOVF UNITS, W  
    CALL DIGIT_LOOKUP
    MOVWF PORTB    

    ; Muestra decenas
    MOVF TENS, W    
    CALL DIGIT_LOOKUP
    MOVWF PORTC     

    CALL DELAY      

    ; Incrementa unidades
    INCF UNITS, F
    MOVLW 0x0A
    SUBWF UNITS, W
    BTFSC STATUS, Z 
    GOTO INC_TENS   

    GOTO LOOP       

INC_TENS:
    CLRF UNITS      
    INCF TENS, F    

    MOVLW 0x0A
    SUBWF TENS, W
    BTFSC STATUS, Z  
    CLRF TENS       

    GOTO LOOP       

; Tabla de conversión para display de 7 segmentos
DIGIT_LOOKUP:
    ADDWF PCL, F    
    RETLW 0xC0      
    RETLW 0xF9      
    RETLW 0xA4      
    RETLW 0xB0      
    RETLW 0x99      
    RETLW 0x92      
    RETLW 0x82      
    RETLW 0xF8      
    RETLW 0x80      
    RETLW 0x90      


DELAY:
    MOVLW 0xFF
    MOVWF TEMP
    MOVLW 0xFF
    MOVWF TEMP2
D1: DECFSZ TEMP2, F
    GOTO D1
    DECFSZ TEMP, F
    GOTO D1
    RETURN

END
