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

get_s MACRO txt ;A macro to take string input from the console.
    LEA DX,txt
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
    actLen DB ?;Actual length of the string.
    TXT DB 101 DUP('$') ;string (Array of characters).
    ;********************************************************
    
    prompt DB "Please enter the paragraph to extract the arithmetic expression from :",13,10,"$"
    
    error1 DB "There are no numbers or arithmetic operation in the text you've entered !",13,10,"$"
    
    numeric_value DW ?
    operation DB 0 ;1:addition / 2:subtraction / 3:multiplication / 4:division.
    result DW ?
    buffer DB 50 DUP(0) ;To store the result as string, actualy we can store it directly in the result variable above but we could lose the original value in it.
.CODE
START:
    MOV AX,@data
    MOV DS,AX
    
    print prompt
    
    get_s_list parList
    
    endl
    
    CALL strPrc
    
    ;CLS
    
    .EXIT ;Return control to the OS.    


PROC strPrc ;NEAR
    LEA SI,str
    MOV numeric_value,0
    MOV operation,0
    
    loop_start:
        CMP BYTE PTR[SI],00h ;00 : ASCII code for 'null', if null found that means the string is ended.
        JE strEnd    
        
        CMP BYTE PTR[SI],'0'
        JNE not_a_number
        
        LEA DI,str
        LEA CX,actLen
        MOV AL,'z'
        CLD 
        REPE CMPSB
        JZ zero_found
        ;CMP BYTE PTR[SI],'zero'
        JMP not_a_number
        
        CMP BYTE PTR[SI],'1'
        JNE not_a_number
        CMP BYTE PTR[SI],'one'
        JNE not_a_number

        CMP BYTE PTR[SI],'2'
        JNE not_a_number
        CMP BYTE PTR[SI],'two'
        JNE not_a_number

        CMP BYTE PTR[SI],'3'
        JNE not_a_number
        CMP WORD PTR[SI],'three'
        JNE not_a_number

        CMP BYTE PTR[SI],'4'
        JNE not_a_number
        CMP WORD PTR[SI],'four'
        JNE not_a_number

        CMP BYTE PTR[SI],'5'
        JNE not_a_number
        CMP WORD PTR[SI],'five'
        JNE not_a_number

        CMP BYTE PTR[SI],'6'
        JNE not_a_number
        CMP WORD PTR[SI],'six'
        JNE not_a_number

        CMP BYTE PTR[SI],'7'
        JNE not_a_number
        CMP WORD PTR[SI],'seven'
        JNE not_a_number

        CMP BYTE PTR [SI],'8'
        JNE not_a_number
        CMP WORD PTR[SI],'eight'
        JNE not_a_number

        CMP BYTE PTR[SI],'9'
        JNE not_a_number
        CMP WORD PTR[SI],'nine'
        JNE not_a_number
        
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
        MOV operation,1
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
        CMP operation, 1
        JE add_result
        
        CMP operation, 2
        JE subtract_result
        
        CMP operation, 3
        JE multiply_result
        
        CMP operation, 4
        JE divide_result
        
    add_result:
        MOV AX,numeric_value
        ADD CX,AX
        MOV result,CX        
    
    subtract_result:
        MOV AX,numeric_value
        SUB CX,AX
        MOV result,CX
            
    multiply_result:
        MOV AX,numeric_value
        MUL CX
        MOV result,AX
        
    divide_result:
        MOV AX,numeric_value
        DIV CX
        MOV result,AX
            
    arrow_loop:
        ;MOV AH, 0h
;        INT 16h
;        CMP AL, 25h
;        JE move_left
;        CMP AL, 26h
;        JE move_up
;        CMP AL, 0h
        
        ; Check for up arrow key input
        CMP AH, 48h
        JE move_up

        ; Check for down arrow key input
        CMP AH, 50h
        JE move_down

        ; Check for left arrow key input
        CMP AH, 4Bh
        JE move_left

        ; Check for right arrow key input
        CMP AH, 4Dh
        JE move_right

        ; If none of the above, return to the beginning of the loop
        JMP arrow_loop
    move_up:
        ; Move the text cursor up by one row
        MOV AH, 02h
        MOV BH, 00h ; Page number
        MOV DH, -1 ; Number of rows to move up
        MOV DL, 00h ; Column position (not changed)
        INT 10h
        
        ; Convert the result value to a string
        MOV SI, 0
        MOV AX, result
        div_loop:
            CMP AX, 0
            JE done
            
            MOV buffer[SI], AH
            INC SI
            MOV BX, 10
            DIV BX
            JMP div_loop
            
            done:
                MOV buffer[SI], 0

                ; Load the address of the buffer into the dx register
                LEA DX, buffer

                ; Print the string
                MOV AH, 09h
                INT 21h
                
                RET
    zero_found:                    
ENDP

findLen PROC
    LEA SI,TXT
    MOV CX,0

    next_ch:
        MOV AL,[SI]
        INC CX
        CMP AL,0
        JNE next_ch

        MOV actLen,CX
        RET
ENDP
END START