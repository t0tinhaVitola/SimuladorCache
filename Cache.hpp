#pragma once
#include<string>
#include<vector>
#include<cstdint>

struct Block{
    bool val = false;
    int tag = 0;
};

class Cache{
private:
    std::vector<std::vector<Block>> block;
    std::string cache_name;
    uint32_t sets;
    uint32_t bSize;
    uint32_t assoc;
    char subst;
    bool output_flag;
    std::string benchmark;
public:

    //cache_simulator 256 4 1 R 1 bin_100.bin
    //#0#nome#1#sets#2#bsize#3#assoc#4#subst#5#flag_saida#6#bench#
    Cache(int argc, char**argv):
        cache_name(argv[0]),
        sets(std::stoi(argv[1])),
        bSizestd::stoi(argv[2]),
        assoc(std::stoi(argv[3])),
        subst(argv[4][0]),
        output_flag(std::stoi(argv[5])),
        bench(argv[6]),
        block.resize(sets, std::vector<Block>(assoc))
    {
    }




};

