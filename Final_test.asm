.MODEL small
.stack 100h

.data
    ;---we define a parameter list
    parlist label byte
    maxlen DB 20
    actlen DB 0
    namefld DB 20 dup(' ')
    
    parlist2 label byte
    actlen2 DB 0
    namefld2 DB 20 dup(' ')
    ;------------------------
    message DB "Please Enter your Name", 10,13,'$'
    msgFound DB "add found", 13,10,'$'
    msgNotFound DB "add not found", 13,10,'$'
    ;---------------------------------------------
    NO1 DB ?
    NO2 DB ?
    NO3 DB ?
    NO4 DB ?
    NO5 DB ?
    
    buffer DB 10 dup(' ');to check 
    flag DB 0
    operation DB ? ;0:add / 1:multiply / 2:divide
.code
        MOV AX,@data
        MOV DS,AX
        
        CALL clrproc ; clear the screen 
    
    My_Loop:    
        ;---set the cursor in the upperleft corner.
        MOV DX,0000
        CALL  setproc  
        ;-----     
        CALL prompt ;will print prompt    
        CALL readin ; accept input from the keyboard
        CALL clrproc     
        ;--check the input size
        CMP actlen,0
        JE endL    
        ;-------------------- 
        CALL inputproc ; to add $ to the input   
        CALL center
    
    
        JMP My_Loop
    
    endL:
        MOV AX,4c00h  ; exit to the OS.
        INT 21h 
;---------------------------   
;------clear procedure------
clrproc PROC near
     MOV AX, 0600h  ; ah=06h, al=00 
     MOV BH, 30  ; brown
     MOV CX,0000 ; from
     MOV DX, 184Fh ; to 
     INT 10h
     
     RET
 clrproc ENDP   
;----------Set Cursor Procedure----
setproc PROC near
    MOV AH,02h
    MOV BH,00
    INT 10h
    
    RET
  setproc ENDP    
;------------prompt-------------
prompt PROC near
    MOV AH,09h
    LEA DX, message
    INT 21h
    
    RET
prompt ENDP    
;--------------read input from keyboard -----
readin PROC near
    MOV AH,0Ah
    LEA  DX,parlist  
    INT 21h
    
    RET
readin ENDP    
;----------process input------------
inputproc PROC near
    MOV BH,00
    MOV BL, actlen 
    MOV namefld[BX],'$' 
    
    RET
   inputproc ENDP  

;------------procedure to center---------------
center PROC near
      MOV DL, actlen
      SHR DL,1 ; divide by two.
      NEG DL ; 
      ADD DL,40
      MOV DH, 12
      CALL setproc
      
      ; to print the input
      MOV AH,09h
      LEA DX, namefld
      INT 21h
    RET
   center ENDP

inputProcess PROC near
    ;LEA SI,txt
;    MOV operation,0
    
    MOV CX,10
    loop_start:
    LEA DI,namefld
    MOV AL,'a'
    REPNE SCASB
    
    JZ found 
    
    JNZ not_found
    
    found:
        LEA SI,namefld
        
        CMP [SI + 1],'d'
        JNE loop_start
        
        CMP[SI + 2],'d'
        JNE loop_start
        
        MOV operation,0
        LEA SI,namefld
        LEA DL,namefld2
        
        MOV CX,3
        REP MOVSB

    ;found:
;        LEA SI,namefld
;        LEA DL,namefld2
;        
;        MOV CX,actlen
;        REP MOVSB
;        
;        MOV AH,09h
;        LEA DX,msgFound
;        INT 21H
    not_found:
        MOV AH,09h
        LEA DX,msgNotFound
        INT 21H    
    ;loop_start:
;        CMP BYTE PTR[SI],00h ;00 : ASCII code for 'null', if null found that means the string is ended.
;        JE txtEnd
        
        ;CMP BYTE PTR[SI],'a'
;        INC SI
;        JNE loop_start
;        PUSH 'a'
;        
;        CMP BYTE PTR[SI],'d'
;        INC SI
;        JNE loop_start
;        PUSH 'd'
;        
;        CMP BYTE PTR[SI],'d'
;        INC SI
;        JNE loop_start
;        PUSH 'd'
                        
inputProcess ENDP
END