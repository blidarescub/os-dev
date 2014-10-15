[BITS 16]

MOV AX,CS ; initialize
MOV DS,AX ; segments
MOV ES,AX ; correctly

CALL Clear_screen
CALL Draw_rect
CALL Delay
CALL Clear_screen
CALL Reset_cursor
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

Clear_screen:
	PUSHA
	MOV AH, 0x06
	MOV AL, 0
	MOV BH, 0
	MOV CX, 0
	MOV DH, 0x1E
	MOV DL, 0x50
	INT 0x10
	POPA
	RET

Reset_cursor:
	PUSHA
	MOV AH, 0x02
	MOV BH, 0
	MOV DH, 0
	MOV DL, 0
	INT 0x10
	POPA
	RET

PrintChar:
	CALL Delay_char
	MOV BL, 0xA
	MOV BH, 0
	MOV AH, 0xE
	INT 0x10
	RET

PrintCharShell:
	MOV BL, 0xA
	MOV BH, 0
	MOV AH, 0xE
	INT 0x10
	RET

PrintCharWarning:
	CALL Delay_char
	MOV BL, 0xC
	MOV BH, 0
	MOV AH, 0xE
	INT 0x10
	RET

PrintCharWarningShell:
	MOV BL, 0xC
	MOV BH, 0
	MOV AH, 0xE
	INT 0x10
	RET

PrintCharInfo:
	CALL Delay_char
	MOV BL, 0xB
	MOV BH, 0
	MOV AH, 0xE
	INT 0x10
	RET

PrintCharInfoShell:
	MOV BL, 0xB
	MOV BH, 0
	MOV AH, 0xE
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

PrintWarning:
	PUSHA
	next_characterWarning:
		MOV AL, [SI]
		INC SI
		OR AL, AL
		JZ exit_printWarning
		CALL PrintCharWarning
		JMP next_characterWarning
	exit_printWarning:
	POPA
	RET

PrintWarningShell:
	PUSHA
	next_characterWarningShell:
		MOV AL, [SI]
		INC SI
		OR AL, AL
		JZ exit_printWarningShell
		CALL PrintCharWarningShell
		JMP next_characterWarningShell
	exit_printWarningShell:
	POPA
	RET

PrintInfo:
	PUSHA
	next_characterInfo:
		MOV AL, [SI]
		INC SI
		OR AL, AL
		JZ exit_printInfo
		CALL PrintCharInfo
		JMP next_characterInfo
	exit_printInfo:
	POPA
	RET

PrintInfoShell:
	PUSHA
	next_characterInfoShell:
		MOV AL, [SI]
		INC SI
		OR AL, AL
		JZ exit_printInfoShell
		CALL PrintCharInfoShell
		JMP next_characterInfoShell
	exit_printInfoShell:
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
	CALL PrintWarning
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
	CALL ReadShell
	RET

ReadShell:
    MOV AH,0x0
    INT 0x16
    CALL PrintCharShell
    CMP AL, 0x54 ;T
    JE Check_t
    CMP AL, 0x74 ;t
    JE Check_t
    CMP AL, 0x44 ;D
    JE Check_d
    CMP AL, 0x64 ;d
    JE Check_d
    CMP AL, 0x48 ;H
    JE Check_h
    CMP AL, 0x68 ;h
    JE Check_h
    CMP AL, 0x52 ;R
    JE Check_r
    CMP AL, 0x72 ;r
    JE Check_r
    CMP AL, 0x63 ;c
    JE Check_c
    CMP AL, 0x42 ;C
    JE Check_c
    CMP AL, 0xD  ;CRLF
    JE NewLineShell
    JMP ReadShell
NewLineShell:
	MOV SI, EMPTY_LINE
	CALL PrintShell
	MOV SI, SHELL_PROMPT
	CALL PrintShell
	JMP ReadShell
Check_t:
	MOV AH,0x0
    INT 0x16
    CALL PrintCharShell
    CMP AL, 0xD
    JE t_print_time
    JMP ReadShell
t_print_time:
	CALL Time
	CALL Convert_hours
	CALL Convert_minutes
	CALL Convert_seconds
	MOV SI, EMPTY_LINE
	CALL PrintShell
	MOV SI, TIME_FIELD
	CALL PrintInfoShell
	MOV SI, EMPTY_LINE
	CALL PrintShell
	MOV SI, SHELL_PROMPT
	CALL PrintShell
	JMP ReadShell
Check_d:
	MOV AH,0x0
    INT 0x16
    CALL PrintCharShell
    CMP AL, 0xD
    JE d_print_date
    JMP ReadShell
d_print_date:
	CALL Date
	CALL Convert_month
	CALL Convert_day
	CALL Convert_century
	CALL Convert_year
	MOV SI, EMPTY_LINE
	CALL PrintShell
	MOV SI, DATE_FIELD
	CALL PrintInfoShell
	MOV SI, EMPTY_LINE
	CALL PrintShell
	MOV SI, SHELL_PROMPT
	CALL PrintShell
	JMP ReadShell
Check_h:
	MOV AH,0x0
    INT 0x16
    CALL PrintCharShell
    CMP AL, 0xD
    JE h_print_help
    JMP ReadShell
h_print_help:
	MOV SI, HELP
	CALL PrintInfoShell
	MOV SI, SHELL_PROMPT
	CALL PrintShell
	JMP ReadShell
Check_r:
	MOV AH,0x0
    INT 0x16
    CALL PrintCharShell
    CMP AL, 0xD
    JE read_exit
    JMP ReadShell
Check_c:
	MOV AH,0x0
    INT 0x16
    CALL PrintCharShell
    CMP AL, 0xD
    JE c_clear_screen
    JMP ReadShell
c_clear_screen:
	CALL Clear_screen
    CALL Reset_cursor
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


Date:
	MOV AH, 0x04
	INT 0x1A
	RET
	;CH - CENTURY
	;CL - YEAR
	;DH - MONTH
	;DL - DAY
Convert_month:
	MOV BH,DH
	SHR BH,1
	SHR BH,1
	SHR BH,1
	SHR BH,1
	ADD BH,30H
	MOV [DATE_FIELD + 3],BH
	MOV BH,DH
	AND BH,0FH
	ADD BH,30H
	MOV [DATE_FIELD + 4],BH
	RET
Convert_day:
	MOV BH,DL
	SHR BH,1
	SHR BH,1
	SHR BH,1
	SHR BH,1
	ADD BH,30H
	MOV [DATE_FIELD],BH
	MOV BH,DL
	AND BH,0FH
	ADD BH,30H
	MOV [DATE_FIELD + 1],BH
	RET
Convert_century:
	MOV BH,CH
	SHR BH,1
	SHR BH,1
	SHR BH,1
	SHR BH,1
	ADD BH,30H
	MOV [DATE_FIELD + 6],BH
	MOV BH,CH
	AND BH,0FH
	ADD BH,30H
	MOV [DATE_FIELD + 7],BH
	RET
Convert_year:
	MOV BH,CL
	SHR BH,1
	SHR BH,1
	SHR BH,1
	SHR BH,1
	ADD BH,30H
	MOV [DATE_FIELD + 8],BH
	MOV BH,CL
	AND BH,0FH
	ADD BH,30H
	MOV [DATE_FIELD + 9],BH
	RET

Time:
	MOV AH,02H
	INT 1AH
	RET
	;CH - HOURS
	;CL - MINUTES
	;DH - SECONDS
Convert_hours:
	MOV BH,CH
	SHR BH,1
	SHR BH,1
	SHR BH,1
	SHR BH,1
	ADD BH,30H
	MOV [TIME_FIELD],BH
	MOV BH,CH
	AND BH,0FH
	ADD BH,30H
	MOV [TIME_FIELD + 1],BH
	RET
Convert_minutes:
	MOV BH,CL
	SHR BH,1
	SHR BH,1
	SHR BH,1
	SHR BH,1
	ADD BH,30H
	MOV [TIME_FIELD + 3],BH
	MOV BH,CL
	AND BH,0FH
	ADD BH,30H
	MOV [TIME_FIELD + 4],BH
	RET
Convert_seconds:
	MOV BH,DH
	SHR BH,1
	SHR BH,1
	SHR BH,1
	SHR BH,1
	ADD BH,30H
	MOV [TIME_FIELD + 6],BH
	MOV BH,DH
	AND BH,0FH
	ADD BH,30H
	MOV [TIME_FIELD + 7],BH
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
HELP:
	db 0dh, 0ah, 0dh, 0ah, "    h -- show this help summary", 0dh, 0ah, "    t -- print time", 0dh, 0ah, "    d -- print date", 0dh, 0ah, "    c -- clear screen", 0dh, 0ah, "    r -- reboot", 0dh, 0ah, 0dh, 0ah, 0
DATE_FIELD:
	db '00/00/0000', 0
TIME_FIELD:
	db '00:00:00', 0

times 2048 -( $ - $$ ) db 0
