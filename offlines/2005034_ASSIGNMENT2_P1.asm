.MODEL SMALL
.STACK 100H

.DATA
PROMPT_MSG DW 'ENTER NUMBER OF CHOCOLATES AND REQUIRED NUMBER OF WRAPPERS TO BE EXCHANGED WITH A CHOCOLATE: (SEPARATED BY SPACE AND USE SPACE TO MARK THE TERMINATION OF INPUTS AS WELL)',10,13,'$'
N DW ?  ;   0<n<65535
K DW ?  ;   0<1<k<n<65535
WRAP DW ?
CHOC DW ?
RESULT_MSG DW 10,13,'TOTAL NUMBER OF CHOCOLATES THAT SAHIL SIR CAN HAVE IS: $'
INFINITE_MSG DB 10,13,'INFINITE $'
.CODE

MAIN PROC FAR
    MOV AX,@DATA
    MOV DS,AX
    
    MOV AH,09H
    LEA DX,PROMPT_MSG
    INT 21H
    
    XOR AX,AX
    MOV N,AX
    MOV K,AX
    
    MOV BX,10    
     
CHOCOLATES:

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
    
    JMP CHOCOLATES

N_DONE:
    XOR AX,AX
    MOV AX,N
    DIV BX
    
    MOV N,AX
    XOR AX,AX

REQUIRED_WRAPPERS:

    MOV AX,K
    MUL BX
    MOV K,AX
    
    MOV AH,01H
    INT 21H
    
    CMP AL,' ' 
    JE K_DONE
    
    SUB AL,'0'
    MOV AH,0
    ADD K, AX
    
    JMP REQUIRED_WRAPPERS
              
    
K_DONE:

    XOR AX,AX
    MOV AX,K
    DIV BX
    
    MOV K,AX
    XOR AX,AX
    
    MOV AH,09H
    LEA DX,RESULT_MSG
    INT 21H
    
    CMP K,0
    JE INFINITY
    
    CMP K,1
    JE INFINITY
    
    JMP PROCESS
    
INFINITY:
    MOV AH,09H
    LEA DX,INFINITE_MSG
    INT 21H
    
    JMP TERMINATE
    
PROCESS:     
    MOV AX,N
    MOV CHOC,AX
    MOV WRAP,AX
    
    XOR BX,BX 
    MOV BX,K
    
    CMP WRAP,BX
    JAE ADJUST 
    
ADJUST:

    XOR DX,DX

    MOV AX,WRAP
    
    DIV BX
    
    ADD CHOC,AX
    
    ADD AX,DX
    
    MOV WRAP,AX
    
    CMP WRAP,BX
    JAE ADJUST
    
    JMP ANSWER_FOUND
    
ANSWER_FOUND:

    XOR AX,AX
    MOV AX,CHOC    
               
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

END MAIN

