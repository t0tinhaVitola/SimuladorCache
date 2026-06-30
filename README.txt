# Requisitos
Linguagem de programação: C++ 
SO: Windows 11 / Ubuntu
O programa pode ser compilado e executado tanto no CMD quanto no VS Code;

Para compilar (Windows): g++ Main.cpp Parser.cpp Cache.cpp -o cache_simulator
Para compilar (Ubuntu): g++ Main.cpp Parser.cpp Cache.cpp -o cache_simulator
(OBS: Lembre-se de abrir o terminal dentro da pasta em que os arquivos cpp, hpp e bin estão.)

Para executar, digite no terminal: ./cache_simulator <nsets> <bsize> <assoc> <substituição> <flag_saida> <arquivo.bin>

# Requisitos
Linguagem de programação: Assembly
SO: Windows 11 (Foi apenas testado nessa SO)
Necessário jdk
O programa pode ser compilado e executado no CMD, terminal do VS-Code e na IDE Mars.
Caso CMD/VS usar comando:
java -jar Mars4_5.jar sm p main.asm pa cache_simulator <nsets> <bsize> <assoc> <substituição> <flag_saida> <arquivo.bin>
Caso MARS:
É necessário habilitar em SETTINGS:
- Program Arguments provided to MIPS Program;
- Assemble all files in directory;
- Initialize Program Counter to global 'main' if defined;
- Permit extended (pseudo) instructions and formats;
Após isso apenas inserir os parâmetros na zona de execução do MIPS no formato:
cache_simulator <nsets> <bsize> <assoc> <substituição> <flag_saida> <arquivo.bin>


