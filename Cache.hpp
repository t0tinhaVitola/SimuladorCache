#pragma once
#include<string>
#include<vector>
#include<cstdint>

struct Block{
    bool val = false;
    uint32_t tag = 0;
};

enum class Subst{
    RANDOM,
    FIFO,
    LRU
};

enum class Type{
    DIRECT,
    TOTAL,
    MIXED
};

class Cache{
private:
    std::string cache_name;
    uint32_t sets;
    uint32_t bSize;
    uint32_t assoc;
    std::vector<std::vector<Block>> block;
    Subst subst;
    bool output_flag;
    std::string benchmark;
    unsigned int compMisses;
    unsigned int capaMisses;
    unsigned int confMisses;
public:
    Cache(int argc, char**argv);

    void insert(const uint32_t &new_address);
    Type cacheType();
    uint32_t getTag();

    void LRU   (const uint32_t &new_address);
    void RANDOM(const uint32_t &new_address);
    void FIFO  (const uint32_t &new_address);
};

