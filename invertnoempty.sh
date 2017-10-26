
#!/bin/bash
# invertnoempty.sh
# Exemplo invertnoempty.sh -f relatorio.txt -gr palavra -o relatorio1.txt 
# Caso queira o resultado guardado em um arquivo.
# Seleciona o inverso da expressão dada e retira espaços e linhas vazias
# Guarda em um arquivo especifico o resultado.
# 
#
# Versão 1: Na escolha de um arquivo retira suas linhas em branco 
# e linhas que tenha o mesmo padrão passados no segundo argumento
#
# ParaFazer: Manter intacto quebras de linhas
# Ramon, Outubro de 2017
#
MENSAGEM_USO="
Uso: $(basename "$0") [opções]
  É obrigatorio o uso da opção -f e -gr
  OPÇÕES:
	-h, --help Mostra esta tela de ajuda e sai
	-V, --version Mostra a versão do programa e sai
	
	-s, --sort Ordena por ordem alfabética a saída
	-r, --reverse Inverte a listagem
	-u, --uppercase Mostra a listagem em MAIÚSCULAS
	-d, --delimiter C Usa o caractere C como delimitador
	-f, --file F será o arquivo de input
	-o, --output O arquivo que guardará o resultado, caso contrário será mostrado na tela
	-gr, --grepregex GR Qual será a regex não aceita
"
if [ $# -lt 1 ]; then
	echo "$MENSAGEM_USO"
fi
lista=""
# Tratamento das opções de linha de comando
while [ $# -gt 0 ] #Enquanto houver opções
do
	case $1 in
		-h | --help)
			echo "$MENSAGEM_USO"
			exit 0
		;;
		-V | --version)
			echo -n $(basename "$0")
			# Extrai a versão diretamente dos cabeçalhos do programa
			grep '^# Versão ' "$0" | tail -1 | cut -d : -f 1 | tr -d \#
			exit 0
		;;
		-d | --delimiter)
			shift #Descarta a opção -d ou --delimiter
			delim="$1" #Com a opção descartada sobra o argumento
			if test "$delim" = $(echo "*") #XXX bug o * não pode ser delimitador e não sei como impedir
			then	
				echo "* não pode ser usado como delimitador"
				exit 1
			fi
			echo "$delim"
			if test -z "$delim" #Testando se há argumento
			then
				echo "Falto o argumento para o -d"
				exit 1
			fi
		;;
		-s | --sort) # Ordena em ordem alfabética
			lista=$(echo "$lista" | sort)
		;;
		-r | --reverse) # Ordena em ordem reversa
			lista=$(echo "$lista" | tac)
		;;
		-u | --uppercase) # Todas as palavra com Capslock
			lista=$(echo "$lista" | tr a-z A-Z)
		;;
		-f | --file) # Arquivo de entrada
			shift #Descarta a opção -f ou --file
			lista=$(echo "$1")
		;;
		-o | --output) # Arquivo de saida
			shift #Descarta a opção -o ou --output
			echo $lista > $1
			exit 0 
		;;
		-gr | --grepregex) # Arquivo de saida
			shift #Descarta a opção -gr ou --grepregex
			lista=$(cat $lista | grep -v $1 | grep -v -e '^[[:space:]]*$')
		;;
		*) #Demais opções serão inválidas
			[ $1 ] && {
				echo Opção inválida: $1
				exit 1
			}
			
		;;
	esac
	shift
done

echo $lista
