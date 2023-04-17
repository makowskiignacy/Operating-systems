# Inverse permutation

## Implement a function called from C in assembler:

bool inverse_permutation(size_t n, int *p);

The arguments of the function are a pointer p to a non-empty array of integers and the size of this array n. If the array pointed to by p contains a permutation of numbers between 0 and n-1, the function inverts this permutation in place, and the function result is true. Otherwise, the result of the function is false, and the contents of the array pointed to by p after the function is completed are the same as when the function was called. The function should detect obviously invalid values of n - see the usage example. In contrast, it is free to assume that the pointer p is correct.
Rendering the solution

## The solution will be compiled with the command:

nasm -f elf64 -w+all -w+error -o inverse_permutation.o inverse_permutation.asm

## Compiling

The solution will be compiled with the command:

nasm -f elf64 -w+all -w+error -o inverse_permutation.o inverse_permutation.asm

## Example of use

The usage example is in the file inverse_permutation_example.c. It can be compiled and consolidated with the solution with the commands:

gcc -c -Wall -Wextra -std=c17 -O2 -o inverse_permutation_example.o inverse_permutation_example.c
gcc -z noexecstack -o inverse_permutation_example inverse_permutation_example.o inverse_permutation.o
