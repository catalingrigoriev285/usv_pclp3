.model small
.stack 100h
.data
    
.code
MAIN:
    mov AX, @data
    mov DS, AX

    mov AH, 4Ch
    int 21h
end MAIN
