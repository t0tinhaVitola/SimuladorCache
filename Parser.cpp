#include "Parser.hpp"
#include <bit>

Parser::Parser(const std::string &file_name):   
    file(file_name, std::ios::binary)
{     
}

bool Parser::getAddress(uint32_t &new_address){
    return file.read(reinterpret_cast<char*>(&new_address),sizeof(new_address))
    ? (new_address = std::byteswap(new_address),true) 
    : (false);
    
    
}


