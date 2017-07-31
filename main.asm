;****************************************************************
;* 
;* Lab 7 Template
;*
;****************************************************************

;---------------------------------------------------- 
; Export Symbols
; KEEP THIS!!
;---------------------------------------------------- 
          XDEF      Entry       ; export 'Entry' symbol
          ABSENTRY  Entry       ; for absolute assembly: mark this as application entry point

;---------------------------------------------------- 
; Derivative-Specific Definitions
; KEEP THIS!!
;----------------------------------------------------
          INCLUDE   'derivative.inc' 

;---------------------------------------------------- 
; Constants Section
; KEEP THIS!!		
;---------------------------------------------------- 
ROM       EQU     $0400
DATA      EQU     $1000
PROG      EQU     $2000

;---------------------------------------------------- 
; Variable/Data Section
; KEEP THIS!!		
;----------------------------------------------------  
          ORG     DATA
                    
OUT       FCB     0
BOT1      FCB     $01
BOT2      FCB     $02
VAR       FDB     18750
MIN       FDB     1875
MAX       FDB     63750
;---------------------------------------------------- 
; Code Section
; KEEP THIS!!		
;---------------------------------------------------- 
          ORG     PROG

; Insert your code following the label "Entry"          
Entry:                          ; KEEP THIS LABEL!!

          LDS     #PROG
          
          BSR     INIT
          BSR     OC_INIT
          
MAIN:
	  LDAA    OUT
          STAA    PORTB
          BRA     MAIN

;---------------------------------------------------- 
; Init Subroutine  
;----------------------------------------------------  
INIT:     
          ;******************************************
          SEI                   ;DISABLES MASKABLE INTERRUPTS
          
          BCLR DDRH, $03        ; Set Port H, LOWER BIT-pins (PB1,PB2)
          BCLR PTH, $03

          MOVB    #$8F, PIEH    ; Enable interrupts on Port H, pins (PB/DIP)                  
          MOVB    #$8F, PIFH    ; Disable interrupts on Port H for clear flag for pin 0, set the rest to 1
          ;******************************************
          BSET DDRB, $FF        ;enables LEDs
          BSET DDRJ, $02
          BCLR PTJ, $02
          ;******************************************
          ; Disable 7-Segment Display
          BSET    DDRP,#$0F     ; Set Port P pins 0-3 to output
          BSET    PTP, #$0F 
          
          CLI                   ;ENABLE MASKABLE INTERRUPTS
          ;******************************************
          RTS        
;---------------------------------------------------- 
; OC Init Subroutine
;---------------------------------------------------- 
OC_INIT:
          ;******************************************
          SEI              ;DISABLES MASKABLE INTERRUPTS
          
          BSET TIOS, #$02  ;OUTPUT COMPARE CHANNEL 1
          BSET DDRT, #$02  ;PT1 OUTPUT
          
          MOVB #$80, TSCR1 ;ENABLES TCNT FUNCTIONS (TEN IS SET)
          MOVB #$07, TSCR2 ;5.33NS CLOCK clock divided by 128
          
          BSET TIE, #$02   ;ARMS INTERRUPTS FOR OC1
          BSET TCTL2, #$04 ;0L1=1. TOGGLE
          BCLR TCTL2, #$08 ;OM3=0
          
          MOVB #$02, TFLG1 ;CLEAR OC1 FLAG
          
          LDD TCNT         ;load the timer count so it can start at 0
          ADDD VAR         ;sets each interruption to every 100 ms     
          STD TC1          ;stores the value at channel 1
          
          CLI              ;ENABLE MASKABLE INTERRUPTS
          ;******************************************          
          RTS   
          
;---------------------------------------------------- 
; OC ISR
;---------------------------------------------------- 
OC1_ISR: 
          ;******************************************          
          MOVB #$02, TFLG1  ;acknowledges the interrupt
          
          LDD TCNT          ;load the timer count
          
          ADDD VAR          ;sets the timer counter so the next interrupt occurs in 100ms
          STD TC1           ;stores the values at channel 1
          INC OUT           ;increments the variable out

          ;******************************************
          RTI               ;return from the interrupt
;---------------------------------------------------- 
; PUSHBUTTON ISR
;----------------------------------------------------
PB_ISR:
          ;****************************************** 
          MOVB #$8F, PIFH   ;acknowledges the interrupt
          
          LDAA PTH          ;LOAD VALUES IMPUTED FROM PORT H
          COMA              ;COMPLEMENTS TO CONVERT TO POSITIVE LOGIC
          
          CMPA BOT1         ;checks if PB1 was pressed
          BEQ FIRST_BOT    ;if the PB1 was pressed branch to subroutine
          
          CMPA BOT2         ;checks if PB2 was pressed
          BEQ SECOND_BOT   ;if the PB2 was pressed branch to subroutine
          
          ;******************************************
RETURN:               
          RTI               ;return from the interrupt
;---------------------------------------------------- 
; PUSHBUTTON SUBROUTINE
;----------------------------------------------------
;******************************************
FIRST_BOT:
         LDD VAR
         
         CPD MAX
         BEQ NO_HIGH 
         ADDD #1875
NO_HIGH:                    
         STD VAR
	 BRA RETURN
;******************************************
SECOND_BOT:
         LDD VAR
         
         CPD MIN
         BEQ NO_LOW 
         SUBD #1875
NO_LOW:         
         STD VAR
         BRA RETURN  
;******************************************  
;---------------------------------------------------- 
; Interrupt Vector
;----------------------------------------------------          
          ;******************************************          
          ;RAM INTERRUPT VECTOR FOR OC1
          ;$FFEC-$C180=$3E6C
          
          ORG $3E6C           ;vector location for the interrupt
          FDB OC1_ISR
          ;******************************************
;---------------------------------------------------- 
; Interrupt Vector
;----------------------------------------------------     
          ;******************************************
          ;RAM INTERRUPT VECTOR FOR PORT H
          ;$FFCC-$C180=$3E4C
          
          ORG $3E4C           ;vector location for the interrupt
          FDB PB_ISR

          ;******************************************

          
                  
          
                 