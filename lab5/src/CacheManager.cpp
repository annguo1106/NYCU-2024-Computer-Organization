#include "CacheManager.h"
#include <math.h>

CacheManager::CacheManager(Memory *memory, Cache *cache){
    // TODO: implement your constructor here
    // TODO: set tag_bits accord to your design.
    // Hint: you can access cache size by cache->get_size();
    // Hint: you need to call cache->set_block_size();
    this->memory = memory;
    this->cache = cache;
    cache->set_block_size(4);
    size = cache->get_size();
    lines = cache->get_len() / way;   // block_size is 4
    index_bits = int(log2(lines));
    tag_bits = 32 - index_bits - 2;    // 2 is for OFFSET
    dirty_bits.resize(cache->get_len(), 0); // every block need a dirty bit
    valid_bits.resize(cache->get_len(), 0);
    least_used_block.resize(cache->get_len(), 0); 
};

CacheManager::~CacheManager(){

};

std::pair<unsigned, unsigned> CacheManager::associative_map(unsigned int addr){
    // map addr by directed-map method
    unsigned int index = (addr >> (tag_bits + 2)) % (lines); 
    unsigned int tag = (addr << (index_bits)) >> (index_bits + 2);
    return {index, tag};
}


unsigned int* CacheManager::find(unsigned int addr){
    // TODO:: implement function determined addr is in cache or not
    // if addr is in cache, return target pointer, otherwise return nullptr.
    // you shouldn't access memory in this function.
    auto [line_index, tag] = associative_map(addr);
    for(unsigned int block_index = way * line_index; block_index < way * (line_index + 1); block_index++){
        if((*cache)[block_index].tag == tag && valid_bits[block_index]){
            least_used_block[block_index] = time;
            time++;
            return &((*cache)[block_index][0]);
        }
    }
    return nullptr;
}

unsigned int CacheManager::read(unsigned int addr){
    // TODO:: implement replacement policy and return value 
    unsigned int* value_ptr = find(addr);
    if(value_ptr != nullptr)
        return *value_ptr;
    else{
        // not in cache
        auto [line_index, tag] = associative_map(addr);
        unsigned int lru_index = way * line_index;
        int lru_time = least_used_block[way * line_index];
        for(unsigned int block_index = way * line_index; block_index < way * (line_index + 1); block_index++){
            if(least_used_block[block_index] < lru_time){
                lru_index = block_index;
                lru_time = least_used_block[block_index];
            }
            if(!valid_bits[block_index]){  // the block doesn't contain any contains
                valid_bits[block_index] = 1;
                dirty_bits[block_index] = 0;
                least_used_block[block_index] = time;
                time++;
                (*cache)[block_index].tag = tag;
                return (*cache)[block_index][0] = memory->read(addr);
            }
        }
        // of lru is dirty -> write to memory
        if(dirty_bits[lru_index]){
            unsigned int write_add = ((*cache)[lru_index].tag << (2)) + (line_index << (tag_bits + 2));
            memory->write(write_add, (*cache)[lru_index][0]);
        }
        // handle read from memory
        valid_bits[lru_index] = 1;
        dirty_bits[lru_index] = 0;
        least_used_block[lru_index] = time;
        time++;
        (*cache)[lru_index].tag = tag;
        return (*cache)[lru_index][0] = memory->read(addr);
    }
};

void CacheManager::write(unsigned int addr, unsigned value){
    // TODO:: write value to addr
    auto [line_index, tag] = associative_map(addr);
    for(unsigned int block_index = way * line_index; block_index < way * (line_index + 1); block_index++){
        if((*cache)[block_index].tag == tag){
            if(dirty_bits[block_index]){
                unsigned int write_add = ((*cache)[block_index].tag << (2)) + (line_index << (tag_bits + 2));
                memory->write(write_add, value);
                dirty_bits[block_index] = 0;
            }
            else dirty_bits[block_index] = 1;  // will be write back to mem later
            
            least_used_block[block_index] = time;
            time++;
            (*cache)[block_index][0] = value;
            return;
        }
        
    }
    
    // if write miss -> then write around
    read(addr);
    write(addr, value);
    return;
};