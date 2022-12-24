;=====================================================================
;=============== Assembly course 1st semester - 2022 =================
;================    An-najah national university   ==================
;=================     Instructor : Ahmad Awwad.   ===================
;=====================================================================
; This code was written by:
;       1.Saif Khalifa.
;       2.Ameer Al-Sousa.
;       3.Mousab Sawafta.
;=====================================================================
;=====================================================================

.MODEL small
.stack 100h
;******************** MACROS & PROCEDURES ******************** 
print MACRO MSG ;A macro to print.
    MOV AH,09h
    LEA DX,MSG
    INT 21H
ENDM 

print_center MACRO MSG ;A macro to print string in the center of the console.     
    MOV AH,02H
    MOV BH,00H;page NO.
    MOV DH,0CH;ROW
    MOV DL,23H;COL
    INT 10H
    
    MOV AH,09h
    LEA DX,MSG
    INT 21H    
ENDM

get_s_list MACRO STR ;A macro to take string input from the console.
    LEA DX,STR
    MOV AH,0AH
    INT 21H
ENDM   

CLS MACRO ;A macro to clear console screen. 
    MOV AX,0600H
    MOV BH,07H ;BG and FG color.
    MOV CX,0000H ;from upper left corner of the console.
    MOV DX,184FH ;To lower right corner of the console. (Full screen)
    INT 10H
ENDM

setCur_center MACRO ;Set text cursor to the center of the console.
    MOV AH,02H
    MOV DX,0C19H
    INT 10H
ENDM

endl MACRO
    MOV AH,02H ;Print service
    
    MOV DL,10 ;New line in ASCII.
    INT 21H
    
    MOV DL,13 ;Carriage return (Set the text cursor on the beginning of the new line).
    INT 21H
ENDM



;******************** END MACROS & PROCEDURES ******************** 

.DATA
    parList LABEL BYTE
    max DB 101 ;Maximum number of characters in the string, 100 charcter and 1 for the enter.
    actLen DB ?;Actual length of the string.
    str DB 101 DUP('$') ;string (Array of characters).
    ;********************************************************
    
    prompt DB "Please enter the paragraph to extract the arithmetic expression from :",13,10,"$"
    
    error1 DB "The maximum number of characters is 100, Please enter a valid paragraph or type 'exit' to stop the program !",13,10,"$" 
    error2 DB "There are no numbers or arithmetic operation in the text you've entered !",13,10,"$"
    
    numeric_value DB ?
    operation DB ? ;1:addition / 2:subtraction / 3:multiplication / 4:division.
    result DB "$"
.CODE
START:
    MOV AX,@data
    MOV DS,AX
    
    print prompt
    
    get_s_list parList
    
    endl
    
    
    
    ;CLS
    
    .EXIT ;Return control to the OS.    
END START

PROC strPrc NEAR
    LEA SI,str
    MOV numeric_value,0
    MOV operation,0
    
    loop_start:
        CMP BYTE PTR[SI],00h ;00 : ASCII code for 'null', if null found that means the string is ended.
        JE strEnd    
        
        CMP BYTE PTR[SI],'0';if it was less than 0 and greater than 9 it will not be considered.
        JB not_a_number
        
        CMP BYTE PTR [SI],'9'
        JA not_a_number
        
        SUB BYTE PTR[SI],'0'
        ADD numeric_value,AX
        
        INC SI
        JMP loop_start
        
    not_a_number:
        ;addition
        CMP WORD PTR[SI],'add'
        JE do_add
        
        CMP WORD PTR[SI],'addition'
        JE do_add
        
        CMP WORD PTR[SI],'+'
        JE do_add
        
        ;multiplication
        CMP WORD PTR[SI],'multiply'    
        JE do_mul
        
        CMP WORD PTR[SI],'multiplication'    
        JE do_mul
        
        CMP WORD PTR[SI],'mul'    
        JE do_mul
        
        CMP WORD PTR[SI],'*'    
        JE do_mul
        
        ;division
        CMP WORD PTR[SI],'div'
        JE do_div
        
        CMP WORD PTR[SI],'divide'
        JE do_div
        
        CMP WORD PTR[SI],'division'
        JE do_div
        
        CMP WORD PTR[SI],'/'
        JE do_div
        
        ;subtraction
        CMP WORD PTR[SI],'sub'
        JE do_sub
        
        CMP WORD PTR[SI],'subtract'
        JE do_sub
        
        CMP WORD PTR[SI],'subtraction'
        JE do_sub
        
        CMP WORD PTR[SI],'-'
        JE do_sub
        
        INC SI
        JMP loop_start
    
    do_add:
        MOV operaiton,1
        INC SI
        JMP loop_start
        
    do_sub:
        MOV operation,2
        INC SI 
        JMP loop_start
    do_mul:
        MOV operation,3
        INC SI 
        JMP loop_start
    do_div:
        MOV operation,4
        INC SI 
        JMP loop_start         
        ;CMP BYTE PTR [SI], '0'
        ;JB operator_error
        
        ;CMP BYTE PTR [SI], '9'
        ;JA operator_error

    strEnd:
        cmp operation, 1
        JE add_result
        
        CMP operation, 2
        JE subtract_result
        
        CMP operation, 3
        JE multiply_result
        
        CMP operation, 4
        JE divide_result
        
    add_result:
    
    subtract_result:
    
    multiply_result:
    
    divide_result:
    
    arrow_loop:
        MOV AH, 0x00
        INT 0x16
        CMP AL, 0x25
        JE move_left
        CMP AL, 0x26
        JE move_up
        CMP AL, 0x                    
ENDP