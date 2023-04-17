global polynomial_degree
polynomial_degree:
  mov eax, -1 ; wynik
  lea rdx, [8*rsi]
  push rbp
  mov rbp, rsp  ; Zapamiętaj w rbp, gdzie był wierzchołek stosu.
  sub rsp, rdx  ; Alokuj rdx bajtów. Wartość w rdx musi być wielokrotnością 8.
  xor r9, r9 ; zmienna równa 0 wartości wielomianu są trywialne
  mov rcx, rsi ; indeks pętli od n do 1
.dupl_loop: ; przepisuje początkową dane do danych roboczych
  xor rdx, rdx
  mov edx, dword [rdi + 4*rcx - 4] ; ładuję do rdx kolejną wartość wielomianu
  mov qword [rsp + 8*rcx - 8], rdx ; przepisuje wartość wielomianu do stosu
  or r9, qword [rsp + 8*rcx - 8]
  loop .dupl_loop ; powtarzam aż przepiszę wszystkie
  cmp r9, 0 ; czy wszystkie wartości wielomianu są zerami
  je .done
  inc eax
.init:
  mov rcx, 1 ; indeks zewnętrznej pętli
.outerLoop:
  mov rdx, rsi ; rdx = n
  cmp rcx, rdx; zewnętrzna pętla od 1 do n-1
  je .done
  mov r10, rsi ; indeks wewnętrznej pętli
  xor r9, r9 ; zmienna równa 0 wartości wielomianu są trywialne
.innerLoop:
  cmp rcx, r10 ; wewnętrzna pętla od 0 do n
  je .innerLoopDone
  ;wnętrze pętli
  mov rdx, qword [rsp + 8*r10 - 16] ; pobieram wartość wcześniejszego elementu
  sub qword [rsp + 8*r10 - 8], rdx ; odejmuję ją od aktualnego elementu
  or r9, qword [rsp + 8*r10 - 8] ; jedna wartość wielonianu różna 0 zmienia zmienną
  ;obsługa pętli
  dec r10
  jmp .innerLoop
.innerLoopDone:
  inc rcx
  cmp r9, 0 ; czy wszystkie wartości wielomianu są zerami
  je .done
  inc eax
.outerLoopDone:
  jmp .outerLoop
.done:
  leave
  ret
