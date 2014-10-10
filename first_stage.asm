BITS 16
ORG 0x7C00

CALL Refresh_screen
MOV SI, LOADING
CALL Print
MOV SI, POINT
CALL Print
MOV SI, POINT
CALL Print
MOV SI, POINT
CALL Print
MOV SI, EMPTY_LINE
CALL Print
MOV SI, EMPTY_LINE
CALL Loader_bar
CALL Delay
CALL Read_disk

PrintChar:
CALL Delay_char
MOV BL, 0xA
MOV BH, 0
MOV AH, 0x0E
INT 0x10
RET

Print:
	PUSHA
	next_character:
		MOV AL, [SI]
		INC SI
		OR AL, AL
		JZ exit_print
		CALL PrintChar
		JMP next_character
	exit_print:
	POPA
	RET

Delay:
	PUSHA
	MOV BL, 10h
	MOV AH, 0
	INT 0x1A
	ADD BX, DX
	tloop:
		MOV AH, 0
		INT 0x1A
		CMP DX, BX
		JG tloop2
		JMP tloop
	tloop2:
		POPA
		RET

Delay_char:
	PUSHA
	MOV BL, 0
	MOV AH, 0
	INT 0x1A
	ADD BX, DX
	tloop3:
		MOV AH, 0
		INT 0x1A
		CMP DX, BX
		JG tloop4
		JMP tloop3
	tloop4:
		POPA
		RET

Refresh_screen:
	PUSHA
	MOV AH, 0
	MOV AL, 0x12
	INT 0x10
	POPA
	RET

Loader_bar:
	PUSHA
	MOV BL, 0x12
	MOV SI, BAR
	start:
		OR BL, BL
		JZ exit_loader
		CALL Print
		DEC BL
		JMP start
exit_loader:
	POPA
	RET

Read_disk:
	XOR AH, AH
	INT 0x13
    MOV BX, 0x8000  ; segment
    MOV ES, BX
    MOV BX, 0x0000  ; offset

    MOV AH, 0x02  ; read function
    MOV AL, 0x01  ; sectors - this might be wrong, trying to read from hd
    MOV CH, 0x00  ; cylinder
    MOV CL, 0x02  ; sector
    MOV DH, 0x00  ; head
    MOV DL, 0x80  ; drive - trying to read from hd
    INT 0x13   ; disk int
    JC Read_disk
    JMP 0x8000:0x0000   ; buffer

LOADING:
	db 'LOADING BOOTLOADER', 0
POINT:
	db '.', 0
BAR:
	db 0x7C, 0
EMPTY_LINE:
    db 0dh, 0ah, 0

times 510 -( $ - $$ ) db 0
dw 0xaa55