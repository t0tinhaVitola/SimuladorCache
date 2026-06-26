#include <stdio.h>
#include <stdlib.h>
#include "Cache.hpp"
#include "Parser.hpp"
#include <iostream>
#include <stdexcept>

int main( int argc, char** argv ){
    if ( argc < 7 ) {
        std::cout << "Argumentos insuficientes!";
        return 1;
    }

    if ( argc > 7 ) {
        std::cout << "Numero de argumentos esta acima do limite!";
        return 1;     
    }

    try {
        Cache cache( argc, argv );
        Parser parser( cache.getBenchmark( ) );
        
        uint32_t currentAddress = 0;

        while ( parser.getAddress( currentAddress ) ) {
            cache.insert( currentAddress );
        }
        cache.printReport( );
    } catch ( const std::invalid_argument& e ) {
        std::cerr << "Erro: " << e.what();
        return 1;
    }
}

