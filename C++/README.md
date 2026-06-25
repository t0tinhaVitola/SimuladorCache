# SimuladorCache
Este trabalho consiste na implementação de um simulador de cache em C++, a cache será parametrizável, quanto ao número de conjuntos, tamanho do bloco, nível de associatividade e política de substituição.
(Disclaimer: a cache foi pensada para ser endereçada à bytes e o endereço possui 32 bits.)

A configuração de cache deverá ser repassada por linha de comando e formatada com os seguintes parâmetros (o arquivo de entrada poderá ter extensão): "cache_simulator <nsets> <bsize> <assoc> <substituição> <flag_saida> arquivo_de_entrada"

Onde cada um destes campos possui o seguinte significado:
● cache_simulator - nome do arquivo de execução principal do simulador (todos devem usar este nome, independente da linguagem escolhida;
● nsets - número de conjuntos na cache (número total de “linhas” ou “entradas” da cache);
● bsize - tamanho do bloco em bytes;
● assoc - grau de associatividade (número de vias ou blocos que cada conjunto possui);
● substituição - política de substituição, que pode ser Random (R), FIFO (F) ou L (LRU);
● flag_saida - flag que ativa o modo padrão de saída de dados;
● arquivo_de_entrada - arquivo com os endereços para acesso à cache.

O tamanho da cache é dado pelo produto do número de conjuntos na cache (<nsets>), tamanho do bloco em bytes (<bsize>) e associatividade (<assoc>).
