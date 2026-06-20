#include <stdio.h>
#include <stdlib.h>
#include "Cache.hpp"
#include "Parser.hpp"
#include <iostream>


//compile com: 
//g++ -std=c++23 Main.cpp Cache.cpp Parser.cpp -o cache_simulator.exe

int main(int argc, char** argv){
    Cache cache(argc, argv);
    Parser parser( cache.getBenchmark() );
    
    uint32_t currentAddress = 0;

    while ( parser.getAddress( currentAddress ) ) {
        cache.insert( currentAddress );
    }
    cache.printReport();
}

