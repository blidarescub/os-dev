BITS 16
ORG 0x8000:0x0000

CALL Refresh_screen
CALL Draw_rect
CALL Delay
CALL Refresh_screen1
MOV SI, INTRO
CALL PrintShell
MOV SI, EMPTY_LINE
CALL PrintShell
MOV SI, EMPTY_LINE
CALL PrintShell
MOV SI, BUNA_SEARA
CALL Print
MOV SI, EMPTY_LINE
CALL PrintShell
MOV SI, EMPTY_LINE
CALL PrintShell
MOV SI, OPTIONS
CALL PrintShell
MOV SI, EMPTY_LINE
CALL PrintShell
MOV SI, PLEASE
CALL PrintShell
CALL Read


PrintChar:
CALL Delay_char
MOV BL, 0xA
MOV BH, 0
MOV AH, 0x0E
INT 0x10
RET

PrintCharShell:
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

PrintShell:
	PUSHA
	next_characterShell:
		MOV AL, [SI]
		INC SI
		OR AL, AL
		JZ exit_printShell
		CALL PrintCharShell
		JMP next_characterShell
	exit_printShell:
	POPA
	RET

Read:
    MOV AH,0x0
    INT 0x16
    CMP AL, 0x52
    JE read_exit
    CMP AL, 0x49
    JE read_exit_shell
    JMP Read
read_exit:
	MOV BL, 0xC
	MOV BH, 0
	MOV AH,0xE
    INT 0x10
    MOV SI, EMPTY_LINE
	CALL PrintShell
    MOV SI, EMPTY_LINE
	CALL PrintShell
    MOV SI, SEARA_BUNA
	CALL Print
	CALL Delay
	JMP Reboot
	RET
read_exit_shell:
	MOV BL, 0xB
	MOV BH, 0
	MOV AH,0xE
    INT 0x10
    MOV SI, EMPTY_LINE
	CALL PrintShell
	MOV SI, EMPTY_LINE
	CALL PrintShell
    MOV SI, SHELL_PROMPT
	CALL PrintShell
	CALL ReadShell
	RET

ReadShell:
    MOV AH,0x0
    INT 0x16
    CALL PrintCharShell
    CMP AL, 0xD
    JE NewLineShell
    JMP ReadShell
NewLineShell:
	MOV SI, EMPTY_LINE
	CALL PrintShell
	MOV SI, SHELL_PROMPT
	CALL PrintShell
	JMP ReadShell

Reboot:
	INT 19h

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

Draw_rect:
	PUSHA
	MOV AH, 0xC
	MOV BL, 0x32
	MOV CX, 0x140
	MOV DX, 0x12C
	MOV AL, 0xE
	Draw1:
		CALL Delay_char
		INT 0x10
		DEC BL
		DEC CX
		DEC DX
		CMP BL,0
		JE Restore_var1
		JMP Draw1
	Restore_var1:
		MOV BL, 0x32
		MOV CX, 0x140
		MOV DX, 0x12C
		JMP Draw2
	Draw2:
		CALL Delay_char
		INT 0x10
		DEC BL
		INC CX
		DEC DX
		CMP BL, 0
		JE Restore_var2
		JMP Draw2
	Restore_var2:
		MOV BL, 0x32
		MOV CX, 0x10E
		MOV DX, 0xFA
		JMP Draw3
	Draw3:
		CALL Delay_char
		INT 0x10
		DEC BL
		INC CX
		DEC DX
		CMP BL, 0
		JE Restore_var3
		JMP Draw3
	Restore_var3:
		MOV BL, 0x32
		MOV CX, 0x172
		MOV DX, 0xFA
		JMP Draw4
	Draw4:
		CALL Delay_char
		INT 0x10
		DEC BL
		DEC CX
		DEC DX
		CMP BL, 0
		JE Exit_draw
		JMP Draw4
Exit_draw:
	POPA
	RET

Refresh_screen:
	PUSHA
	MOV AH, 0
	MOV AL, 0x12
	INT 0x10
	POPA
	RET

Refresh_screen1:
	PUSHA
	MOV AH, 0
	MOV AL, 0x12
	INT 0x10
	POPA
	RET


INTRO:
    db 0x40, "BLidOS 2014", 0
BUNA_SEARA:
    db "Hello, World!", 0
OPTIONS:
	db "(R) Reboot", 0dh, 0ah,"(I) Interactive shell", 0dh, 0ah, 0
PLEASE:
	db "Please choose an option: ", 0
SEARA_BUNA:
    db 'Goodbye, World!', 0
SHELL_PROMPT:
    db '#> ', 0
EMPTY_LINE:
    db 0dh, 0ah, 0
