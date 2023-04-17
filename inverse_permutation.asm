global inverse_permutation

%define n rdi
%define p rsi
%define i rcx
%define idx r8
%define val r9d
%define next_idx r10
%define next_val r11d
%define temp r11d
%define duplicates r11d
%define cycle_begin rdx
%define INT_MAXX 2147483647
%define true 1
%define false 0

inverse_permutation:
        ; if n <= 0
        cmp     n, -1
        je     .return_false
        cmp     n, 0
        je     .return_false
        ; if n > INT_MAX + 1
        cmp     n, INT_MAXX
        ja      .return_false

        ; rcx = i = 0
        mov     i, 0
; for (i = 0; i < n; i++)
.loop_greater_less:
        ; if (i >= n)
        cmp     i, n
        jae     .after_loop_greater_less
        ; eax = p[i] 
        mov     eax, dword [p + i*4]
        ; if (p[i] < 0 || p[i] > n - 1)
        cmp     rax, 0
        jl      .return_false
        cmp     rax, n
        jge     .return_false
        ; i++
        inc     i
        jmp     .loop_greater_less
.after_loop_greater_less:

        ; rcx = i = 0
        mov     i, 0
        mov     duplicates, false
; for (i = 0; i < n; i++)
.loop_check_duplicates:
        ; if (i >= n)
        cmp     i, n
        jae     .loop_retrive_values_init
        ; if (p[i] < 0) skip
        mov     eax, dword [p + i*4]
        cmp     eax, 0
        jl      .loop_check_duplicates_increment
        mov     cycle_begin, i
        mov     idx, i
; while (p[idx] >= 0)
.loop_go_through_cycle:
        ; val = p[i]
        mov     val, dword [p + idx*4]
        cmp     val, 0
        jl      .after_loop_go_through_cycle
        movsx   next_idx, val
        ; p[idx] = - p[idx] - 1
        not     val
        mov     dword [p + idx*4], val
        ; idx = next_idx
        mov     idx, next_idx
        jmp     .loop_go_through_cycle
.after_loop_go_through_cycle:
        ;WYDAJE MI SIE POTENCJALNIE PROBLEMATYCZNE
        ; if (idx != cycle_begin) duplicates = true, break
        cmp     idx, cycle_begin
        je      .loop_check_duplicates_increment
        mov     duplicates, true
        jmp     .loop_retrive_values_init
        

.loop_check_duplicates_increment:
        inc     i
        jmp     .loop_check_duplicates

.loop_retrive_values_init:
        mov     i, 0
; for (int i = 0; i < n; i++)
.loop_retrive_values:
        cmp     i, n
        jge     .after_loop_retrive_values
        mov     val, dword [p + i*4]
        cmp     val, 0
        jg      .loop_retrive_values_inc
        ; if (p[i] < 0) p[i] = - (p[i] + 1)
        not     val
        mov     dword [p + i*4], val
.loop_retrive_values_inc:
        inc     i
        jmp     .loop_retrive_values
.after_loop_retrive_values:
        cmp     duplicates, true
        je      .return_false
        
        mov     i, 0
; for (int i = 0; i < n; i++)
.loop_inverse_permutation:
        cmp     i, n
        jge     .loop_inverse_permutation_end
        ; if (p[i] < 0) skip
        mov     val, dword [p + i*4]
        cmp     val, 0
        jl      .loop_inverse_permutation_inc
        mov     cycle_begin, i
        movsx   idx, val
        mov     val, ecx ; first half of i
        not     val
.loop_cycle:
        mov     temp, dword [p + cycle_begin*4]
        cmp     temp, 0
        jl      .loop_inverse_permutation_inc
        movsx   next_idx, dword [p + idx*4]
        mov     next_val, r8d ; first half of idx
        not     next_val
        mov     dword [p + idx*4], val
        mov     idx, next_idx
        mov     val, next_val
        jmp     .loop_cycle
.loop_inverse_permutation_inc:
        inc     i
        jmp     .loop_inverse_permutation
.loop_inverse_permutation_end:

        mov     i, 0
.loop_restore_values:
        cmp     i, n
        jge     .return_true
        mov     val, dword [p + i*4]
        cmp     val, 0
        jg      .loop_retrive_values_inc
        ; if (p[i] < 0) p[i] = - (p[i] + 1)
        not     val
        mov     dword [p + i*4], val
.loop_restore_values_inc:
        inc     i
        jmp     .loop_restore_values
.return_true:
        mov     eax, true
        ret
.return_false:
        mov     eax, false
        ret