#pragma once

#include <fstream>
#include <string>
#include <cstdint>

class Parser{
    private:
    std::ifstream file;

    public:
    Parser(const std::string &file_name);   
   
    
    bool getAddress(uint32_t &new_address);
};
