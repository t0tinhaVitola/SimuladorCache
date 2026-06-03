#include "Cache.hpp"
#include <stdexcept>


//cache_simulator 256 4 1 R 1 bin_100.bin
//#0#nome#1#sets#2#bsize#3#assoc#4#subst#5#flag_saida#6#bench#


Cache::Cache(int argc, char**argv):
        cache_name(argv[0]),
        sets(std::stoi(argv[1])),
        bSize(std::stoi(argv[2])),
        assoc(std::stoi(argv[3])),
        subst(whatPolicy(argv[4][0])),
        output_flag(std::stoi(argv[5])),
        benchmark(argv[6]),
        block(sets, std::vector<Block>(assoc))
    {
    }

Subst whatPolicy(const char &c){
    switch(c){
    case 'R' : return Subst::RANDOM;
    case 'F' : return Subst::FIFO;
    case 'L' : return Subst::LRU;

    default: 
        throw std::runtime_error("O método de Substituição inserido é inválido\n Deve ser: R, F ou L.\n");
    }
}

void Cache::insert(const uint32_t &new_address){
    switch(this->subst){
        case Subst::RANDOM :
        case Subst::FIFO :
        case Subst::LRU :

    }
}

Type Cache::cacheType(){
    if(assoc == 1 || (assoc == 1 && sets == 1)){
        return Type::DIRECT;
    }else if(sets == 1){
        return Type::TOTAL;
    }else{
        return Type::MIXED;
    }
}

uint32_t getTag(){


}

uint32_t getIdx(){

}