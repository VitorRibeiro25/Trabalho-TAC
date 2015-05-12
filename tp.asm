.8086
.model small
.stack 2048h
dados	segment	para	'data'
menu_inicial	db	10,13,10,13,"Trabalho de TAC",10,13,10,13
				db 	10,13,"Rafael Francisco (21230528)",13,10
				db 	10,13,"Vitor Ribeiro (21230473)",13,10
				db	10,13,10,13,"Menu Principal:",13,10,13,10
				db	"1 - Iniciar Jogo",13,10,13,10
				db	"2 - Consultar elementos estatisticos",13,10,13,10
				db 	"3 - Sair",13,10,13,10,13,10
				db	"Opcao:$"
				
mes_erro		db	10,13,"Opcao escolhida e invalida",13,10,13,10

dados ends

codigo	segment	para	'code'
		assume  cs:codigo, ds:dados
le_tecla proc ;para ler valor tecla inserida pelo utilizador
	 mov ah,01h
	 int 21h
	 mov ah,0
	 cmp al,0
	 jne sai_tecla
	 mov ah, 08h
	 int 21h
	 mov ah,1

sai_tecla: ret
le_tecla endp

jogo_inicio proc


jogo_inicio endp

el_estatisticos proc

el_estatisticos endp

main proc

menu:	
	mov ah, 09h ; printf do menu
	lea dx, menu_inicial
	int 21h

ciclo: 
	call le_tecla
	cmp al,'1'
	jl men_erro
	cmp al,'3'
	jg men_erro
	cmp al,'1'
	je  iniciar_jogo
	cmp al,'2'
	je  estatisticos
	cmp al,'3'
	je fim
	jmp ciclo
men_erro:
	mov ah,09h ; printf de mensagem de erro
	lea dx, mes_erro
	int 21h
	jmp menu

iniciar_jogo: call jogo_inicio
estatisticos: call el_estatisticos	

fim:
	mov ah, 4ch
	int 21h

main endp
codigo ends
end main