.model small
.stack 100h
.data
    ; messages
    msg1 db "Introdu primul sir = ", '$'
    msg2 db "Introdu al doilea sir = ", '$'
    msg3 db 0Ah, "Sirurile sunt egale!", '$'
    msg4 db 0Ah, "Al doilea sir este m-ai mare!", '$'
    msg5 db 0Ah, "Primul sir este m-ai mare!", '$'
    msg6 db 0Ah, "Primul sir concatenat este = ", '$'
    
    ; strings
    str1 db 12 DUP(' ')
    str2 db 12 DUP(' ')
.code
include procs.asm
MAIN:
    mov AX, @data
    mov DS, AX
    
    ; init strings
    mov SI, 11
    mov str1[SI], '$'
    mov str2[SI], '$'
    
    xor SI, SI
    
    print_string msg1
    read_string str1
    
    reverse_string str1
    print_string str1
    
    print_string msg2
    read_string str2
    
    compare_strings str1 str2 ; stores result in AX
    call show_comparison_result
    
    concatenate_strings str1, str2
    print_string msg6
    print_string str1   
    
    copy_string str1 str2
    compare_strings str1 str2
    call show_comparison_result
    
    mov AH, 4Ch
    int 21h
end MAIN
