; dados fornecidos pelo professor
MOSTRA MACRO STR 
MOV AH,09H
LEA DX,STR 
INT 21H
ENDM

goto_xy		macro	POSx,POSy
		mov	ah,02h
		mov	bh,0
		mov	dl,POSx
		mov	dh,POSy
		int	10h
endm



.8086
.model small
.stack 2048h

dseg    segment para public 'data'

        Erro_Open       db      'Erro ao tentar abrir o ficheiro$'
        Erro_Ler_Msg    db      'Erro ao tentar ler do ficheiro$'
        Erro_Close      db      'Erro ao tentar fechar o ficheiro$'
		
		menu_inicial	db	13,10,"Trabalho de TAC",13,10
						db 	"Rafael Francisco (21230528)",13,10
						db 	"Vitor Ribeiro (21230473)",13,10
						db	"Menu Principal:",13,10
						db	"1 - Iniciar Jogo",13,10
						db	"2 - Consultar elementos estatisticos",13,10
						db  "3 - Seccao de teste",13,10
						db 	"4 - Sair",13,10
						db	"Opcao:$",13,10
				
		menu_estatistica	db	13,10,"Menu dos dados estatisticos dos seus jogos:",13,10
							db	"1 - Historico de jogos",13,10
							db	"2 - Valores de Referencia",13,10
							db 	"3 - Voltar ao Menu Principal",13,10
							db	"Opcao:$",13,10
							
		menujogo	db	13,10,"Menu para iniciar o jogo",13,10
					db	"1 - Ler o ficheiro",13,10
					db	"2 - Jogar",13,10
					db  "3 - Voltar ao menu Principal",13,10
					db 	"Opcao:$",13,10
		
		dado1			db		99 dup (32)
		oper1			db		99 dup (32)
		dado2			db		99 dup (32)
		oper2			db		99 dup (32)
		dado3			db		99 dup (32)		
		num				db		0
		MAXDIG			db		7
		resultado		db		99 dup (32)
		resposta		dw		9 dup (?)
		
        Fich         	db      'DADOS.TXT',0
		Fich2			db 		'RES.TXT', 0
        HandleFich      dw      0
        car_fich        db      ?
		id1				dw		0
		iop1			dw		0
		id2				dw		0
		iop2			dw		0
		id3				dw		0
		contador		dw		5
		valor 			dw      ?
		POSy			db		5	; a linha pode ir de [1 .. 25]
		POSx			db		10	; POSx pode ir [1..80]	
		p_POSxy 		dw		40	; ponteiro para posicao de escrita
		
		pedevalores		db	13,10,"Introudza o resultado da operacao:$"
		valores_int		db 	"A SUA RESPOSTA:",13,10
		valores_jogos	db 	"Numero total de jogos realizados:$",13,10
		valores_best	db	"Melhor pontuação obtida em todos os jogos:$",13,10
		valores_bad		db	"Pior pontuação obtida em todos os jogos:$",13,10
		valores_media	db	"Media de pontuação obtida em todos os jogos:$",13,10
		
dseg    ends

cseg    segment para public 'code'
		assume  cs:cseg, ds:dseg
				
APAGA_ECRAN	PROC
		PUSH BX
		PUSH AX
		PUSH CX
		PUSH SI
		XOR	BX,BX
		MOV	CX,24*80
		mov bx,160
		MOV SI,BX
APAGA:	
		MOV	AL,' '
		MOV	BYTE PTR ES:[BX],AL
		MOV	BYTE PTR ES:[BX+1],7
		INC	BX
		INC BX
		INC SI
		LOOP	APAGA
		POP SI
		POP CX
		POP AX
		POP BX
		RET
APAGA_ECRAN	ENDP
		
le_tecla proc 

		mov	ah,01h
		int	21h
		mov	ah,0
		cmp	al,0
		jne	SAI_TECLA
		mov	ah, 08h
		int	21h
		mov	ah,1
SAI_TECLA:	RET

le_tecla endp


le_tecla_2 proc ;para ler valor tecla inserida pelo utilizador
	 mov ah,01h
	 int 21h
	 mov ah,0
	 cmp al,0
	 jne sai_tecla
	 mov ah, 08h
	 int 21h
	 mov ah,1

sai_tecla: ret
le_tecla_2 endp

menu_jogo proc

	mov ah, 09h 
	lea dx, menujogo
	int 21h
	call le_tecla_2
	cmp al, '1'
	je le_ficheiro
	cmp al, '2'
	je jogar
	cmp al, '3'
	je voltar

ficheiro: call le_ficheiro
jogar: call recebe_valor
voltar: call Main
menu_jogo endp

menu_esta proc
s_menu:	
	mov ah, 09h 
	lea dx, menu_estatistica
	int 21h
	call le_tecla_2
	cmp al, '1'
	je historico
	cmp al, '2'
	je valores
	cmp al, '3'
	je voltar

voltar: call Main
historico: call historico_jogo
valores: call valores_jogo

menu_esta endp

historico_jogo proc

call menu_esta

historico_jogo endp

valores_jogo proc

	call APAGA_ECRAN
	goto_xy	20,6
	MOSTRA valores_jogo
	goto_xy	20,8	
	MOSTRA valores_best
	goto_xy	20,10
	MOSTRA valores_bad
	goto_xy	20,12
	MOSTRA valores_media
	goto_xy 22,22
	
	
sai: call menu_esta
valores_jogo endp

compara proc
	mov cx, 3
	xor si, si
	xor al, al
ciclo:
	mov al, oper1[si]
	cmp al, '+'
	je adicao
	cmp al, '-'
	je subtracao
	cmp al, '*'
	je multiplicacao
	cmp al, '/'
	je divisao
	xor al, 00h
	inc si
	loop ciclo
	
adicao:
	mov al, 00h
	mov al, dado1[si]
	add al, dado2[si]
	mov resultado[si], al
	mov al, 00h
	jmp ciclo

subtracao:
	mov al, dado1[si]
	sub al, dado2[si]
	mov resultado[si], al
	mov al, 00h
	jmp	ciclo

multiplicacao:
	;mov ax, dado1[si]
	;mul dado2[si]	
	; em falta
divisao:

volta: call Main

compara endp

compara_2 proc

	

compara_2 endp

recebe_valor proc
	xor si, si
ciclo:
	mov ah, 09h 
	lea dx, pedevalores
	int 21h
	call le_tecla
	mov resposta[si], ax
	
	mov     ah, 02h			; anda com o cursor uma linha para baixo
	mov		dl, 10
	int		21h
	
	mov ax, 00h
	inc si
	cmp si, 10
	je sai
	jmp ciclo
	
sai: call Main
	
recebe_valor endp


mostra_resultado proc
	mov cx, 9
	xor si, si
	lea dx, valores_int
ciclo:
	mov bx, resposta[si]
	mov dl, bh
	
	mov ah, 2
	int 21h
	inc si
	loop ciclo
	
call menu_jogo

mostra_resultado endp

le_ficheiro proc

		mov     ax,dseg
        mov     ds,ax
		mov ax,0B800H
		mov es,ax
		

;abre ficheiro
        mov     ah,3dh
        mov     al,0
        lea     dx,Fich
        int     21h				; Chama a rotina de abertura de ficheiro (AX fica com Handle)
        jc      erro_abrir
        mov     HandleFich,ax
		xor		si,si			; indice da matriz dado1 inicia a zero
        jmp     ler_ciclo1

erro_abrir:
        mov     ah,09h
        lea     dx,Erro_Open
        int     21h
		jmp 	sai

		
ler_ciclo1:							; faz a leitura da primeira linha do ficheiro
        mov     ah, 3fh
        mov     bx, HandleFich
        mov     cx, 1				; vai ler apenas um byte de cada vez
        lea     dx, car_fich		; DX fica a apontar para o caracter lido
        int     21h				; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0			; verifica se já chegou o fim de ficheiro EOF? 
		je		fecha_ficheiro	; se chegou ao fim do ficheiro fecha e sai
		cmp		car_fich, 13	; verifica se já chegou ao fim da linha do ficheiro
		je		ler_oper1		; terminou de ler os dados1 e vai agora les os oper1
		
        mov     ah, 02h			; escreve o caracter no ecran
		mov		dl, car_fich
		mov 	dado1[si], dl	; e tambem guarda na matriz dado1
		inc		si		
		int		21h				; escreve no ecran
		jmp		ler_ciclo1		; vai ler o próximo caracter

ler_oper1:						; vai agora tratar a segunda linha do ficheiro
        mov     ah, 02h			; Escreve CR no ecran (anda com o cursor para a primeira coluna 
		mov		dl, 13
		int		21h
		
        mov     ah, 02h			; anda com o cursor uma linha para baixo
		mov		dl, 10
		int		21h

		mov 	dado1[si], '$'	; termina a matriz dado1
		xor		si, si			; inicia o si que agora serve de indice de oper1
		
ler_ciclo2:						; Trata a segunda linha do ficheiro e coloca em oper1
        mov     ah, 3fh
        mov     bx, HandleFich
        mov     cx, 1
        lea     dx, car_fich
        int     21h				; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0			;EOF? 
		je		fecha_ficheiro	; se chegou ao fim do ficheiro fecha e sai
		cmp		car_fich, 13
		je		ler_dado2		; terminou de ler os oper1 e vai agora ler os dados2
	
		
        mov     ah, 02h
		mov		dl, car_fich
		mov 	oper1[si], dl	; guarda o caracter em oper1 e tambem imprime no ecran
		inc		si		
		int		21h
		jmp		ler_ciclo2
		
ler_dado2:		
        mov     ah, 02h
		mov		dl, 13			;CR
		int		21h
		
        mov     ah, 02h
		mov		dl, 10
		int		21h
		
		mov 	oper1[si], '$';
		xor		si, si			
		
ler_ciclo3:							; mais um ciclo parecido com os anteriores para tratar a terceira linha
        mov     ah, 3fh
        mov     bx, HandleFich
        mov     cx, 1
        lea     dx, car_fich
        int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				;EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		cmp		car_fich, 13
		je		ler_oper2	; terminou de ler os dado2
		cmp		car_fich, 10
		je		ler_ciclo3			; se caracter LF (carecter 10) vai buscar outro		
		
        mov     ah, 02h
		mov		dl, car_fich
		mov 	dado2[si], dl	
		inc		si
		int		21h
		jmp		ler_ciclo3	
		
ler_oper2:						; vai agora tratar a quarta linha do ficheiro
        mov     ah, 02h			; Escreve CR no ecran (anda com o cursor para a primeira coluna 
		mov		dl, 13
		int		21h
		
        mov     ah, 02h			; anda com o cursor uma linha para baixo
		mov		dl, 10
		int		21h

		mov 	dado1[si], '$'	; termina a matriz dado1
		xor		si, si			; inicia o si que agora serve de indice de oper1


ler_ciclo4:						; Trata a quarta linha do ficheiro e coloca em oper1
        mov     ah, 3fh
        mov     bx, HandleFich
        mov     cx, 1
        lea     dx, car_fich
        int     21h				; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0			;EOF? 
		je		fecha_ficheiro	; se chegou ao fim do ficheiro fecha e sai
		cmp		car_fich, 13
		je		ler_dado3		; terminou de ler os oper1 e vai agora ler os dados2
		cmp		car_fich, 10
		je		ler_ciclo4		; se caracter LF (carecter 10) vai buscar outro
		
        mov     ah, 02h
		mov		dl, car_fich
		mov 	oper1[si], dl	; guarda o caracter em oper1 e tambem imprime no ecran
		inc		si		
		int		21h
		jmp		ler_ciclo4
		
ler_dado3:		
        mov     ah, 02h
		mov		dl, 13			;CR
		int		21h
		
        mov     ah, 02h
		mov		dl, 10
		int		21h
		
		mov 	oper2[si], '$';
		xor		si, si		

ler_ciclo5:							; mais um ciclo parecido com os anteriores para tratar a quinta linha
        mov     ah, 3fh
        mov     bx, HandleFich
        mov     cx, 1
        lea     dx, car_fich
        int     21h					; lê um caracter do ficheiro
		jc		erro_ler
		cmp		ax, 0				;EOF? 
		je		fecha_ficheiro		; se chegou ao fim do ficheiro fecha e sai
		cmp		car_fich, 13
		je		fecha_ficheiro	; terminou de ler os dado2
		cmp		car_fich, 10
		je		ler_ciclo3			; se caracter LF (carecter 10) vai buscar outro		
		
        mov     ah, 02h
		mov		dl, car_fich
		mov 	dado3[si], dl	
		inc		si
		int		21h
		jmp		ler_ciclo5	
		
erro_ler:
        mov     ah,09h
        lea     dx,Erro_Ler_Msg
        int     21h

fecha_ficheiro:
        mov     ah,3eh
        mov     bx,HandleFich
        int     21h
        jnc     sai

        mov     ah,09h
        lea     dx,Erro_Close
        Int     21h

mostra_perguntas:
        mov     ah, 02h
		mov		dl, 13
		int		21h
		
        mov     ah, 02h
		mov		dl, 10
		int		21h


		mov 	dado3[si], '$';
		mov		cx, 9	; o numero de operações que se pretende mostrar


sai: call menu_jogo
		
le_ficheiro endp

Main    Proc
	
	 mov ax,dseg
	 mov ds,ax

menu:	
	mov ah, 09h ; printf do menu
	lea dx, menu_inicial
	int 21h

ciclo:
	call le_tecla_2
	cmp al, '1'
	je ler_ficheiro
	cmp al, '2'
	je estatisticas
	cmp al, '3'
	je	pede_uti
	cmp al, '4'
	je sai
	jmp ciclo

ler_ficheiro: call menu_jogo
estatisticas: call menu_esta
pede_uti: call compara_2

sai:
        mov     ah,4ch
        int     21h
Main    endp
cseg	ends
end     Main           

