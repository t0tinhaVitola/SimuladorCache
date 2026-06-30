# Requisitos
Linguagem de programação: C++ 
SO: Windows 11 / Ubuntu
O programa pode ser compilado e executado tanto no CMD quanto no VS Code;
Para compilar (Windows): g++ Main.cpp Parser.cpp Cache.cpp -o cache_simulator
Para compilar (Ubuntu): g++ Main.cpp Parser.cpp Cache.cpp -o cache_simulator

Para executar: ./cache_simulator <nsets> <bsize> <assoc> <substituição> <flag_saida> <arquivo.bin>