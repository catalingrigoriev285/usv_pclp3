; --- print_string macro ---
print_string MACRO string
    mov AH, 09h
    mov DX, offset string
    int 21h
ENDM

; --- read_string macro ---
read_string MACRO string
LOCAL read_string_defines, read_string_main, read_string_end

read_string_defines:
    mov SI, 0
    jmp read_string_main

read_string_main:
    mov AH, 01h
    int 21h

    cmp AL, 13         ; Enter key (carriage return)
    je read_string_end

    mov string[SI], AL
    inc SI

    cmp SI, 11         ; max 11 characters (index 0?11)
    je read_string_end
    jmp read_string_main

read_string_end:
    mov string[SI], '$' ; null-terminate manually
    xor SI, SI
ENDM

; --- compare_strings macro ---
compare_strings MACRO string1, string2
LOCAL compare_strings_loop, strings_equal, strings_different, compare_strings_exit, not_end_str1, strings_ended_str1, strings_ended_str2

    mov SI, 0            
    mov DI, 0

compare_strings_loop:
    mov AL, string1[SI]
    mov BL, string2[DI]

    cmp AL, '$' ; Check if string1 ended
    je strings_ended_str1
    cmp BL, '$' ; Check if string2 ended
    je strings_ended_str2

    cmp AL, BL
    jne strings_different 

    inc SI
    inc DI
    jmp compare_strings_loop

strings_ended_str1:
    cmp BL, '$'        
    je strings_equal      
    jmp strings_different

strings_ended_str2:
    cmp AL, '$'        
    je strings_equal  
    jmp strings_different

strings_equal:
    xor AX, AX ; AX = 0, strings are equal
    jmp compare_strings_exit

strings_different:
    mov AH, 0 ; Clearing AH for AX for holding result
    sub AL, BL
    cbw ; Sign extend AL into AX

compare_strings_exit:
ENDM

; --- show_comparison_result function ---
show_comparison_result PROC
    cmp AX, 0
    je show_equal

    js show_str2_greater
    jmp show_str1_greater

show_equal:
    print_string msg3          ; "Sirurile sunt egale!"
    ret

show_str1_greater:
    print_string msg5          ; "Primul sir este m-ai mare!"
    ret

show_str2_greater:
    print_string msg4          ; "Al doilea sir este m-ai mare!"
    ret

show_comparison_result ENDP

; --- copy_string macro ---
copy_string MACRO source, destination
    LOCAL copy_loop

    mov SI, 0
    mov DI, 0

copy_loop:
    mov AL, source[SI]
    
    cmp AL, '$'
    je copy_done

    mov destination[DI], AL
    
    inc SI
    inc DI
    
    jmp copy_loop

copy_done:
    mov destination[DI], '$'
ENDM

; --- concatenate_strings macro ---
concatenate_strings MACRO str1, str2
    LOCAL concat_loop

    mov SI, 0
    find_end_of_str1:
        mov AL, str1[SI]
        cmp AL, '$'
        je concatenate_start
        inc SI
        jmp find_end_of_str1

    concatenate_start:
    mov DI, SI

    mov SI, 0
    concatenate_loop:
        mov AL, str2[SI]
        cmp AL, '$'
        je concatenate_done
        mov str1[DI], AL
        inc SI
        inc DI
        jmp concatenate_loop

    concatenate_done:
    mov str1[DI], '$'
ENDM

; --- reverse_string macro ---
reverse_string MACRO string
    LOCAL reverse_loop, reverse_end

    mov SI, 0
    find_end_of_string:
        mov AL, string[SI]
        cmp AL, '$'
        je reverse_start
        inc SI
        jmp find_end_of_string

    reverse_start:
    dec SI
    mov DI, 0

    reverse_loop:
        mov AL, string[DI]
        mov BL, string[SI]
        mov string[DI], BL
        mov string[SI], AL
        
        inc DI
        dec SI

        cmp DI, SI
        jl reverse_loop

    reverse_end:
ENDM