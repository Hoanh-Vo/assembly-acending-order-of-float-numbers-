;****************************************************************************************************************************
;Program name: "Floating IO".  This program demonstrates the input of multiple float numbers from the standard input device *
;using a single instruction and the output of multiple float numbers to the standard output device also using a single      *
;instruction.  Copyright (C) 2019 Floyd Holliday.                                                                           *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
;version 3 as published by the Free Software Foundation.                                                                    *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************


;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Floyd Holliday
;  Author email: holliday@fullerton.edu
;
;Program information
;  Program name: Floating IO
;  Programming languages: One modules in C and one module in X86
;  Date program began: 2019-Oct-25
;  Date of last update: 2019-Oct-26
;  Date of reorganization of comments: 2019-Oct-29
;  Files in this program: manage-floats.c, float-input-output.asm
;  Status: Finished.  The program was tested extensively with no errors in Xubuntu19.04.
;
;This file
;   File name: float-input-output.asm
;   Language: X86 with Intel syntax.
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l float-input-output.lis -o float-input-output.o float-input-output.asm


;===== Begin code area ============================================================================================================
extern printf
extern scanf
global floatio

segment .data
welcome db "The Assembly function floatio has begun execution",10,0
input1prompt db "Please input 1 floating point number and press enter with no ws.  Do not press cntl+d: ",0
input2prompt db "Please input 2 floating point numbers separated by ws and press enter.  Do not press cntl+d: ",0
input3prompt db "Please input 3 floating point numbers separated by ws and press enter.  Do not press cntl+d: ",0
good_bye db "The floating module will return the large number to the caller.  Have a nice afternoon",10,0
one_float_format db "%lf",0
two_float_format db "%lf %lf",0
three_float_format db "%lf%lf%lf",0
output_one_float db "The one number is %5.3lf",10,0
output_two_float db "The two numbers are %5.3lf and %5.3lf.",10,0
output_three_float db "The three numbers in ascending order are %7.5lf, %7.5lf, and %7.5lf",10,0

segment .bss  ;Reserved for uninitialized data

segment .text ;Reserved for executing instructions.

floatio:

;Prolog ===== Insurance for any caller of this assembly module ====================================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov  rbp,rsp
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

;Display a welcome message to the viewer.
mov rax, 0                     ;A zero in rax means printf uses no data from xmm registers.
mov rdi, welcome               ;"The Assembly function floatio has begun execution"
call printf



;Display a prompt message asking for inputs
;push qword 99
mov rax, 0
mov rdi, input3prompt          ;"Please input 3 floating point numbers using the keyboard: "
call printf
;pop rax






;input 3 float number 
push qword 0
push qword -1
push qword -2
push qword -3
mov rax, 0
mov rdi, three_float_format;
mov rsi, rsp
mov rdx, rsp
add rdx, 8
mov rcx, rsp
add rcx, 16
call scanf
movsd xmm15, [rsp]
movsd xmm14, [rsp+8]
movsd xmm13, [rsp+16]
pop rax
pop rax
pop rax
pop rax





ucomisd xmm13, xmm14	;
jbe next1		; if xmm13 <=xmm14
	
	movsd xmm10, xmm13
	movsd xmm13, xmm14
	movsd xmm14, xmm10

next1:
	ucomisd xmm13, xmm15
jbe next2	; if xmm13 << xmm15
	
	movsd xmm10, xmm13
	movsd xmm13, xmm15
	movsd xmm15, xmm10

next2:
	ucomisd xmm14, xmm15
	jbe next3
	
	movsd xmm10, xmm14
	movsd xmm14, xmm15
	movsd xmm15, xmm10
next3:
	
	mov rax, 3
	mov rdi, output_three_float
	movsd xmm0, xmm13
	movsd xmm1, xmm14
	movsd xmm2,xmm15
	call printf
	
mov rax, 0
mov rdi, good_bye
call printf

movsd xmm0, xmm15
;call
;===== Restore original values to integer registers ===============================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret

;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
