#include "Parser.hpp"
#include <bit>
Parser::Parser(const std::string &file_name) : file(file_name, std::ios::binary) {}

bool Parser::getAddress(uint32_t &new_address) {
    file.read( reinterpret_cast<char*>( &new_address ), sizeof( new_address ) );
    if ( file ) {
        new_address = ( ( new_address >> 24 ) & 0x000000FF ) | ( ( new_address >>  8 ) & 0x0000FF00 ) | ( ( new_address <<  8 ) & 0x00FF0000 ) | ( ( new_address << 24 ) & 0xFF000000 );
        return true;
    }
    return false;
}