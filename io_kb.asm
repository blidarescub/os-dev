
.model small

.stack 256

CR	equ	13d

LF	equ	10d

.data

msg1	db	‘Enter your favourite colour: ‘, 0

msg2	db	CR, LF,‘Yuk ! Puie Monta ‘, 0

colour	db	80 dup (0)

.code

start:

mov	ax, @data

mov	ds, ax

mov	ax, offset msg1

call	put_str	; display prompt

mov	ax, offset colour

call	get_str	; read colour

mov	ax, offset msg2

call	put_str	; display msg2

mov	ax, offset colour

call	put_str	; display colour entered by user

mov	ax, 4c00h

int 21h	; finished, back to dos


put_str:	; display string terminated by 0

; whose address is in ax

push	ax	; save registers

push	bx

push	cx

push	dx

mov	bx, ax	; store address in bx

mov	al, byte ptr [bx]	; al = first char in string

put_loop:	cmp	al, 0	; al == 0 ?

je	put_fin	; while al != 0

call	putc	; display character

inc	bx	; bx = bx + 1

mov	al, byte ptr [bx]	; al = next char in string

jmp	put_loop	; repeat loop test

put_fin:

pop	dx	; restore registers

pop	cx

pop	bx

pop	ax

ret


get_str:	; read string terminated by CR into array

; whose address is in ax

push	ax	; save registers

push	bx

push	cx

push	dx

mov	bx, ax

call	getc	; read first character

mov	byte ptr [bx], al	; In C: str[i] = al

get_loop:	cmp	al, 13	; al == CR ?

je	get_fin	;while al != CR

inc	bx	; bx = bx + 1

call	getc	; read next character

mov	byte ptr [bx], al	; In C: str[i] = al

jmp get_loop	; repeat loop test

get_fin:	mov	byte ptr [bx], 0	; terminate string with 0

pop	dx	; restore registers

pop	cx

pop	bx

pop	ax

ret



putc:	; display character in al

push	ax	; save ax

push	bx	; save bx

push	cx	; save cx

push	dx	; save dx

mov	dl, al

mov	ah, 2h

int	21h

pop	dx	; restore dx

pop	cx	; restore cx

pop	bx	; restore bx

pop	ax	; restore ax

ret

getc:	; read character into al

push	bx	; save bx

push	cx	; save cx

push	dx	; save dx

mov ah, 1h

int 21h

pop	dx	; restore dx

pop	cx	; restore cx

pop	bx	; restore bx

ret

end start