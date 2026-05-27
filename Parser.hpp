#pragma once

#include <fstream>
#include <string>

class Parser{
    private:
    std::ifstream file;

    public:
    Parser(const std::string &file_name):   
    file(file_name)
    {     
    }

    bool Get_address(uint32_t new_address);
    


};
