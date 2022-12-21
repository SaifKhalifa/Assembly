;=====================================================================
;=============== Assembly course 1st semester - 2022 =================
;===============     An-najah national university    =================
;===============       Instructor : Ahmad Awwad.     =================
;=====================================================================
; This code was written in dirty hands and slippery fingers by:
;       1.Saif Khalifa.
;       2.Ameer Al-Sousa.
;       3.Mousab Sawafta.
;=====================================================================
;=====================================================================

.MODEL small
.stack 100h
;******************** MACROS ******************** 
print_S MACRO MSG ;A macro to print string.
    MOV AH,09h
    LEA DX,MSG
    INT 21H
ENDM 

print_s_center MACRO MSG ;A macro to print string in the center of the console.     
    MOV AH,02H
    MOV BH,00H;page NO.
    MOV DH,0CH;ROW
    MOV DL,23H;COL
    INT 10H
    
    MOV AH,09h
    LEA DX,MSG
    INT 21H    
ENDM

get_s MACRO STR ;A macro to take string input from the console.
    LEA DX,STR
    MOV AH,0AH
    INT 21H
ENDM   

CLS MACRO ;A macro to clear console screen. 
    ;MOV AH,00H
    ;MOV AH,03H
    ;INT 10H
    MOV AX,0600H
    MOV BH,07H
    MOV CX,0000H
    MOV DX,184FH
    INT 10H
ENDM

setCur_center MACRO ;Set text cursor to the center of the console.
    MOV AH,02H
    MOV DX,0C19H
    INT 10H
ENDM
;******************** END MACROS ******************** 

.DATA
    parList LABEL BYTE
    max DB 100 ;Maximum number of characters in the string.
    actLen db ?;Actual length of the string.
    str db 100 DUP('$') ;string (Array of characters).
    ;********************************************************
    
    prompt DB "Please enter the paragraph to extract the arithmetic expression from : $"
    
    error1 DB "The maximum number of characters is 100, Please enter a valid paragraph or type 'exit' to stop the program !",13,10,"$" 
    error2 DB "There are no numbers or arithmetic operation in the text you've entered !",13,10,"$"

.CODE
START:
    MOV AX,@data
    MOV DS,AX
    
    ;LEA DX,str1
    ;MOV AH,09h ;display the string until $.
    ;INT 21h 
    
    ;print_s_center str1
    
    CLS
    
    ;print_s_center str2
    ;print_s str1
    
    .EXIT ;Return control to the OS.    
END START

