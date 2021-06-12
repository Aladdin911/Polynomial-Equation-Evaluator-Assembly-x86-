INCLUDE Irvine32.inc
.data
equ1 BYTE 100 dup (?)
lengequ dword ?
result dword 0
xvalu dword 0
part dword 0
ten dword 10
tmp dword 0
messgage1 byte "Enter your equation",0
messgage2 byte "Enter x-value",0
messgage3 byte "Result= ",0

part_sign byte'+'
.code


main PROC  
	
		MOV EDX, OFFSET messgage1
		call writeString
		CALL CRLF


	MOV EDX, OFFSET equ1
	MOV ECX, lengthof equ1
	CALL ReadString
	MOV lengequ, EAX				;MOV to ecx the read string count (1)
	mov ecx,eax
		MOV EDX, OFFSET messgage2
		call writeString
		CALL CRLF
	CALL Readint				;Reads a char into AL
				
	MOV xvalu, EAx					;BL has the x to search for						
	MOV ESI, OFFSET equ1		;ESI has the offset of the string 

CALL calc				
	MOV EDX, OFFSET messgage3
		call writeString
mov eax,result
Call Writeint
	CALL CRLF
	exit
main ENDP
;-------------------------
calc PROC USES ESI ECX 
	MOV EAX, 0
	L1:
mov bl,byte ptr [esi]
;--------------------check about part sign and save it 
	cmp  byte ptr [esi],43	;-------------its postive
je change_sign ;
	cmp  byte ptr [esi],45
je change_sign ;
;-----------here else
jmp out_change_sign_of_part
;----------------
change_sign:
push ebx
mov bl,byte ptr [esi]
mov part_sign,bl
pop ebx
add esi,1
sub ecx,1
;-----------------------
out_change_sign_of_part:
cmp byte ptr [esi],42 ;---------------or byte=='*')
	je out_check_equal_x;-----------------------------
	cmp byte ptr [esi],32 ;---------------or byte=='space')
	je out_check_equal_x;-----------------------------

	cmp byte ptr [esi],120 ;---------------(byte=='x'--------------
	je equal_x;-----------------------------
	cmp byte ptr [esi],88 ;---------------or byte=='X')
	je equal_x;-----------------------------
		;not_equal_X {-------------------else of(byte==x)--
			;------------ take integer num neigbor x convet string to num 
			mov Ebx,0
			add bl,byte ptr [Esi]
			sub ebx,48
			imul ten
			add eax,ebx
		;--------------condation equ end
		cmp byte ptr [esi+1],0
		je end_equ
		jmp out_end_equ
		end_equ:
		call sum
		out_end_equ:
		;--------------

			;-----------------		
		;}-------------------
jmp out_check_equal_x
			equal_x: ;{----------------------
					cmp eax,0 ; ---------"^"	;if no number next x eax=1 
					je be_one

					jmp out_be_one
					be_one:
					mov eax,1
					out_be_one:
		cmp byte ptr [esi+1],94 ; ---------"^"
		je power
		;{----not power
		mov ebx,eax
		imul xvalu
		call sum
		jmp out_check_equal_x
		;}
		power:	;{--------------
		add esi,2 ; point at the power
		mov tmp,eax
		push ecx
			mov Ebx,0
			add bl,byte ptr [Esi]
			sub ebx,48
			mov ecx,ebx
		mov eax ,1 
		power_loop:  
		imul xvalu
		loop power_loop
		imul tmp
		pop ecx
		sub ecx,2
				call sum		
		out_check_equal_x:
			INC ESI
	sub ecx,1	
	cmp ecx,0
	jne l1

RET
calc ENDP
sum proc
	;----------------------add or sub accoring the part sign 
						cmp  part_sign,43	;-------------its postive
						je add_to_result ;
						cmp  part_sign,45 ;--------------its negtive
						je sub_to_result;
						jmp out_calc_res;
					add_to_result:
					add result,eax
					jmp out_calc_res;
					sub_to_result:
					sub result,eax
				 out_calc_res:
				 mov eax,0
				 RET
							;-----------------------------
					;}------------------------------------------ end power part
sum ENDP
END main
