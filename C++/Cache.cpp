#include "Cache.hpp"
#include <random>
#include <stdexcept>
#include <vector>
#include <algorithm>
#include <iostream>
#include <iomanip>
#include "exception"



//cache_simulator 256 4 1 R 1 bin_100.bin
//#0#nome#1#sets#2#bsize#3#assoc#4#subst#5#flag_saida#6#bench#


Subst Cache::whatPolicy(const char &c){
    switch(c){
    case 'R' : return Subst::RANDOM;
    case 'F' : return Subst::FIFO;
    case 'L' : return Subst::LRU;

    default: 
        throw std::runtime_error("O método de Substituição inserido é inválido\n Deve ser: R, F ou L.\n");
    }
}

Cache::Cache(int argc, char**argv) {
        cache_name  = ( argv[0] );
        sets        = ( std::stoi( argv[1] ) );
        bSize       = ( std::stoi( argv[2] ) );
        assoc       = ( std::stoi( argv[3] ) );
        subst       = ( whatPolicy( argv[4][0] ) );
        output_flag = ( std::stoi( argv[5] ) );
        benchmark   = ( argv[6] );
        compMisses  = 0, capaMisses = 0, confMisses = 0, nAccesses = 0, nHit = 0;
        
        if  ( ( sets <= 0  || ( sets & ( sets - 1 ) ) != 0  ) || ( bSize <= 0 || ( bSize & ( bSize - 1 ) ) != 0 ) || ( assoc <= 0 || ( assoc & ( assoc - 1 ) ) != 0 ) )  {
            throw std::invalid_argument("Um dos parametros nao eh um numero válido\n");
        }

        if ( output_flag != 0 && output_flag != 1 ) {
            throw std::invalid_argument("A flag utilizada nao esta disponivel! (tente 0 ou 1)\n"); 
        }

        this->block.resize( this->sets );
        for ( int i = 0; i < this->sets; i++ ) {
            this->block[i].resize(this->assoc);
        }

        this->waysCount.resize(this->sets, 0);
}

void Cache::insert(const uint32_t &new_address){
    uint32_t bits_offset = 0;
    while ( ( bSize >> bits_offset ) > 1 ) {
        bits_offset++;
    }

    uint32_t bits_index = 0;
    while ( ( sets >> bits_index ) > 1) {
        bits_index++;
    }
    
    int fileTag = new_address >> ( bits_offset + bits_index );
    int selectedSet = ( new_address >> bits_offset ) % sets;

    for ( int i = 0; i < assoc; i++ ) {
        if ( block[selectedSet][i].tag == fileTag && block[selectedSet][i].val == true ) {
            nHit++;
            nAccesses += 1;
            if ( this->subst == Subst::LRU ) {
                for ( int v = 0; v < assoc; v++ ) {
                    if ( block[selectedSet][v].val == true && v != i ) {
                        block[selectedSet][v].count++;
                    }
                }
                block[selectedSet][i].count = 0;
            }
            return;
        }
    }

    int selectedWay = 0;
    
    bool isThereAnyFreeSlot = false;
    for ( int i = 0; i < this->assoc; i++ ) {
        if ( block[selectedSet][i].val == false ) {
            isThereAnyFreeSlot = true;
            selectedWay = i;
            break;
        }
    }

    if ( isThereAnyFreeSlot == false ) {
        switch(this->subst){
            case Subst::RANDOM : {
                if ( assoc > 1 ) {
                    static std::random_device entropy;
                    static std::mt19937 gen(entropy()); 
                    std::uniform_int_distribution<> dist(0, this->assoc - 1);
                    selectedWay = dist(gen);
                }
                break;
            }
            case Subst::FIFO : {
                if ( waysCount[selectedSet] >= assoc ) {
                    waysCount[selectedSet] = 0;
                }

                selectedWay = waysCount[selectedSet]++;
                break;
            }
            case Subst::LRU : {
                int oldestAge = -1;
                int oldestBlock = -1;

                for ( int i = 0; i < assoc; i++ ) {
                    if ( block[selectedSet][i].val == false ) {
                        oldestBlock = i;
                        break;
                    }
                }

                if ( oldestBlock == - 1 ) {
                    for ( int i = 0; i < assoc; i++ ) {
                        if ( block[selectedSet][i].count > oldestAge ) {
                            oldestAge = block[selectedSet][i].count;
                            oldestBlock = i;
                        }
                        block[selectedSet][i].count += 1;
                    }
                }

                selectedWay = oldestBlock;
                block[selectedSet][selectedWay].count = 0;
                break;
            }
        }
    }
    if ( block[selectedSet][selectedWay].val == false) {
        compMisses++;
        block[selectedSet][selectedWay].val = true;

    }   else   {
        
        bool all_Occupied = std::all_of(block.begin(), block.end(), [](const std::vector<Block>& set) {
            return std::all_of(set.begin(), set.end(), [](const Block& b) { 
                return b.val; 
            });
        });

        if ( all_Occupied == true ) {
            capaMisses++;
        } else {
            confMisses++;
        }
    }

    nAccesses += 1;
    block[selectedSet][selectedWay].tag = fileTag;

}

const std::string& Cache::getBenchmark() {
    return benchmark;
}

void Cache::printReport() const {
    uint32_t totalMisses = compMisses + capaMisses + confMisses;

    double hitRate  = (double) nHit / (double) nAccesses;
    double missRate = (double) totalMisses / (double) nAccesses;
    double compRate = (double) compMisses / (double) totalMisses;
    double capaRate = (double) capaMisses / (double) totalMisses;
    double confRate = (double) confMisses / (double) totalMisses;

    if  ( output_flag == 0 )  {

    std::cout << "====================================================\n";
    std::cout << "           RELATORIO DE SIMULACAO DA CACHE          \n";
    std::cout << "====================================================\n";
    std::cout << " Total de Acessos:     " << nAccesses << "\n\n";
    
    std::cout << " Cache Hits:           " << nHit << " (" <<  hitRate * 100.0 << "%)\n";
    std::cout << " Cache Misses:         " << totalMisses << " (" << missRate * 100.0 << "%)\n";
    std::cout << "----------------------------------------------------\n";
    std::cout << " Detalhamento dos Misses (Em relacao ao total de misses):\n";
    std::cout << "  - Compulsorios (Cold): " << compMisses << " (" << compRate * 100.0 << "%)\n";
    std::cout << "  - Capacidade:         " << capaMisses << " (" << capaRate * 100.0 << "%)\n";
    std::cout << "  - Conflito:           " << confMisses << " (" << confRate * 100.0 << "%)\n";
    std::cout << "====================================================\n";
    }   else if ( output_flag == 1 )    {
        std::cout << nAccesses << " " << std::fixed << std::setprecision(4) << hitRate << " " << missRate << " " << compRate << " " << capaRate << " " << confRate;
    }
}   