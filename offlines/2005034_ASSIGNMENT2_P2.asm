.MODEL SMALL
.STACK 100H

.DATA
PROMPT_MSG DW '(USE SPACE TO MARK THE TERMINATION OF INPUT)',10,13,'ENTER NUMBER: $'
N DW ?  ;   0<n<65535
RESULT_MSG DW 10,13,'THE SUM OF DIGITS: $'
RESULT DW ?
CR DW 10

.CODE

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,09H
    LEA DX,PROMPT_MSG
    INT 21H
    
    XOR AX,AX
    MOV N,AX
    MOV RESULT,AX
    
    MOV BX,10     
     
INPUT:

    MOV AX,N
    MUL BX
    MOV N,AX
    
    MOV AH,01H
    INT 21H
    
    CMP AL,' '
    JE N_DONE
    
    SUB AL,'0'
    MOV AH,0
    ADD N, AX
    
    JMP INPUT

N_DONE:
    XOR AX,AX
    
    MOV AX,N
    MOV BX,10
    DIV BX
 
    CALL SUM_OF_DIGITS
    
    MOV AH,09H
    LEA DX,RESULT_MSG
    INT 21H
    
    XOR AX,AX
    
    MOV AX,RESULT
    
    CALL PRINT    
    
TERMINATE:
    MOV AH,4CH
    INT 21H
    ENDP
      

PRINT PROC           
     
    XOR CX,CX
    XOR DX,DX
    
    PUSH_INTO_STACK:
        CMP AX,0
        JE POP_PRINT      
         
        MOV BX,10         
        DIV BX
                          
        PUSH DX              

        INC CX              
        
        XOR DX,DX
        JMP PUSH_INTO_STACK
        
    POP_PRINT:
        CMP CX,0
        JE EXIT
        
        POP DX
        ADD DX,48
         
        MOV AH,02H
        INT 21H
         
        DEC CX
        JMP POP_PRINT
EXIT:
RET

PRINT ENDP

SUM_OF_DIGITS PROC
    
    CMP AX,0
    JE DONE    
    
    DIV BX
    ADD RESULT,DX
    
    XOR DX,DX
    
    CALL SUM_OF_DIGITS
    
DONE:
RET

SUM_OF_DIGITS ENDP

END MAIN


