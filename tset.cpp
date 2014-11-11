#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "tset.h"

using namespace tset;

const size_t bit_size_aelem = sizeof(aelem)*8;
const aelem left_one =((aelem) 1)<<(bit_size_aelem-1);

TSet::TSet(int tree_length) {
    this->tree_length=tree_length;
    array_len=tree_length/bit_size_aelem+1;
    bitdata=new aelem[array_len];
    erase();
    delete_memory=true;
}

TSet::TSet(int tree_length, aelem *bitdata) {
    this->tree_length=tree_length;
    array_len=tree_length/bit_size_aelem+1;
    this->bitdata=bitdata;
    delete_memory=false;
}

TSet::~TSet() {
    if (delete_memory) {
        delete[] bitdata;
    }
}

char* TSet::get_data_as_char(int *size) {
    *size=array_len*sizeof(aelem);
    return (char *)(void *)bitdata;
}

void TSet::add_item(int item) {
    bitdata[item/bit_size_aelem] |= left_one>>(item%bit_size_aelem);
}

void TSet::delete_item(int item) {
    bitdata[item/bit_size_aelem] &= ~(left_one>>(item%bit_size_aelem));
}

bool TSet::has_item(int item) {
     return (bitdata[item/bit_size_aelem] & left_one>>(item%bit_size_aelem));
}

bool TSet::is_empty() {
    for (int i=0;i<array_len;i++) {
        if (bitdata[i]!=0) {
            return false;
        }
    }
    return true;
}

void TSet::intersection_update(TSet *other) {

    assert(tree_length==other->tree_length);

    for (int i=0;i<array_len;i++) {
        bitdata[i]&=other->bitdata[i];
        
    }
}

bool TSet::intersection_not_empty(TSet *other) {

    for (int i=0;i<array_len;i++) {
        if (bitdata[i]&other->bitdata[i]!=0) {
            return true;
        }
    }
    return false;
}

void TSet::union_update(TSet *other) {
    assert(tree_length==other->tree_length);
    for (int i=0;i<array_len;i++) {
        bitdata[i]|=other->bitdata[i];
    }
}

void TSet::minus_update(TSet *other) {
    assert(tree_length==other->tree_length);
    for (int i=0;i<array_len;i++) {
        bitdata[i]&=~other->bitdata[i];
    }
}

void TSet::erase() {
    memset(bitdata, 0, array_len*sizeof(aelem));
}

void TSet::copy(TSet *other) {
    assert(tree_length==other->tree_length);
    memcpy(bitdata,other->bitdata,array_len*sizeof(aelem));
}

void TSet::start_iteration() {
    enum_state_idx=0;
    enum_state=bitdata[0];
}

bool TSet::next_item(TSet *result) {
    result->bitdata[enum_state_idx]=0;
    result->bitdata[enum_state_idx]=enum_state&(~enum_state+1);
    enum_state-=result->bitdata[enum_state_idx]; // remove the one we just found
    if (result->bitdata[enum_state_idx]==0) {
        if (enum_state_idx==array_len-1) {
            return false;
        }
        else {
            enum_state_idx++;
            enum_state=bitdata[enum_state_idx];
            return next_item(result);
        }
    }
    return true;
}

void TSet::fill_ones() {
    memset(bitdata,~0,array_len*sizeof(aelem));
}

void TSet::add_serialized_data(const void *data) {
    tree_length=((unsigned short *)data)[0];
    array_len=tree_length/bit_size_aelem+1;
    bitdata=(aelem *)((char *)data+sizeof(unsigned short));
}



TSetArray::TSetArray(int tree_length) {
    this->tree_length=tree_length;
    array_len=(tree_length/bit_size_aelem+1)*tree_length;
    bitdata=new aelem[array_len];
    erase();
}

void TSetArray::erase() {
    memset(bitdata, 0, array_len*sizeof(aelem));
}

void TSetArray::get_set(int index, TSet *result) {
    result->bitdata=bitdata+(tree_length/bit_size_aelem+1)*index;
}

void TSetArray::intersection_update(TSetArray *other) {

    for (int i=0;i<array_len;i++) {
        bitdata[i]&=(other->bitdata[i]);
    }
}

void TSetArray::union_update(TSetArray *other) {

    for (int i=0;i<array_len;i++) {
        bitdata[i]|=(other->bitdata[i]);
    }
}

void TSetArray::deserialize(const void *data, int size) {
    unsigned short *array=(unsigned short *)data;
    tree_length=array[0];
    array_len=(tree_length/bit_size_aelem+1)*tree_length;
    erase();
    
    for (int i=1;i<((size-sizeof(unsigned short))/sizeof(unsigned short));i+=2) {
        aelem *s=(aelem *)(bitdata+(tree_length/bit_size_aelem+1)*array[i]);
        s[array[i+1]/bit_size_aelem] |= left_one>>(array[i+1]%bit_size_aelem);
    }
    
}





