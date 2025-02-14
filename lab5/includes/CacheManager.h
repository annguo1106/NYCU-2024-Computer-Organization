#pragma once
#include <bits/stdc++.h>
#include "Cache.h"
#include "Memory.h"


class CacheManager
{
private:
/*
* 1. TAs' simulator will check if you store data in cache or not,
*    so make sure that you use cache correctly 
* 2. When cache miss, you should call memory to get data.
* 3. Don't modify original member function and variable, however, 
*    you are allow to declare addtional ones (such as dirty bit) 
* 4. You should actually manage *cache, don't try to cheat evaluator
*    by declare a large data structure to replace the usage of cache
* 5. Follow rules above, otherwise, you will get failed in this lab. 
* 6. Let's do lab peacefully together!!
*/
    Memory *memory;
    Cache *cache;
    unsigned int size;       // bytes
    unsigned int tag_bits;
    // int block_size = 4;
    int lines;              // how many lines in cache (a line contains {way} blocks)
    int way = 128;           // n way associative
    int time = 0;               // record last use time
    int index_bits;         // bits needed for index
    std::vector<int> dirty_bits;
    std::vector<int> valid_bits;
    std::vector<int> least_used_block;
    std::pair<unsigned, unsigned> associative_map(unsigned int addr);
public:

    CacheManager(Memory *memory, Cache *cache);
    ~CacheManager();
    unsigned int* find(unsigned int addr);
    unsigned int  read(unsigned int addr);
    void write(unsigned int addr, unsigned value);
};