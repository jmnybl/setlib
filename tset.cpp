#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "tset.h"

using namespace tset;

const size_t bit_size_aelem = sizeof(aelem)*8;
const aelem left_one =((aelem) 1)<<(bit_size_aelem-1);

TSet::TSet(int tree_length) {
    if (tree_length>0) {
      set_length(tree_length);
      bitdata=new aelem[array_len];
      erase();
      delete_memory=true;
    }
    else {
      this->tree_length=0;
      array_len=0;
      bitdata=NULL;
      delete_memory=false;
    }
}

TSet::TSet(int tree_length, aelem *bitdata) {
    set_length(tree_length);
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

void TSet::print_set() {
  for (int i=0; i<tree_length; i++) {
    if (has_item(i)) {
      printf("%d ",i);
    }
  }
  printf("\n");
}

bool TSet::is_empty() {
  for (int i=0; i<tree_length; i++) { //TODO: smarter
    if (has_item(i)) {
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

  for (int i=0;i<tree_length;i++) { //TODO:smarter
    if (has_item(i) && other->has_item(i)) {
      return true;
    }
  }
    //     if (bitdata[i]&other->bitdata[i]!=0) {
    //         return true;
    //     }
    // }
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
    if (tree_length%bit_size_aelem!=0) {
        bitdata[array_len-1]&=~0<<(bit_size_aelem-tree_length%bit_size_aelem);
    }
}

void TSet::complement() {
    for (int i=0;i<array_len;i++) {
        bitdata[i]=~bitdata[i];
    }
    if (tree_length%bit_size_aelem!=0) {
        bitdata[array_len-1]&=~0<<(bit_size_aelem-tree_length%bit_size_aelem);
    }
}

void TSet::set_length(int tree_length) {
    this->tree_length=tree_length;
    array_len=tree_length/bit_size_aelem+1;
}

void TSet::deserialize(const void *data) {

    set_length(((unsigned short *)data)[0]);
    memcpy(bitdata,((char *)data+sizeof(unsigned short)),array_len*sizeof(aelem)); // TODO
    //bitdata=(aelem *)((char *)data+sizeof(unsigned short));
  
}




TSetArray::TSetArray(int tree_length) {
    set_length(tree_length);
    //array_len=(tree_length/bit_size_aelem+1)*tree_length;
    bitdata=new aelem[array_len];
    erase();
}

void TSetArray::erase() {
    memset(bitdata, 0, array_len*sizeof(aelem));
}

void TSetArray::copy(TSetArray *other) {
    memcpy(bitdata,other->bitdata,array_len*sizeof(aelem));
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

void TSetArray::minus_update(TSetArray *other) {

    for (int i=0;i<array_len;i++) {
        bitdata[i]&=~(other->bitdata[i]);
    }
}

void TSetArray::set_length(int tree_length) {
    this->tree_length=tree_length;
    array_len=(tree_length/bit_size_aelem+1)*tree_length;
}

void TSetArray::deserialize(const void *data, int size) {
    unsigned short *array=(unsigned short *)data;
    set_length(array[0]);
    //array_len=(tree_length/bit_size_aelem+1)*tree_length;
    erase();
    for (int i=1;i<((size-sizeof(unsigned short))/sizeof(unsigned short));i+=2) {
        aelem *s=(aelem *)(bitdata+(tree_length/bit_size_aelem+1)*array[i]);
        s[array[i+1]/bit_size_aelem] |= left_one>>(array[i+1]%bit_size_aelem);
    }
    
}


void TSetArray::make_lin(int window) {

    int size=tree_length/bit_size_aelem+1; // same than TSet array_len

    //Fill this with zeros
    this->erase();

    //Go through the lines
    for (int i=0; i<tree_length; i++) {
        aelem *set =(aelem *)(bitdata+(tree_length/bit_size_aelem+1)*i);

        //Win before
        for (int a=1; a<window+1; a++) {

            //Let's keep within the limits!
            if (i-a > -1){
                //Let's add the item
                set[(i-a)/bit_size_aelem] |= left_one>>((i-a)%bit_size_aelem);
            }

        }

        //Win after
        for (int a=1; a<window+1; a++) {

            //Let's keep within the limits!
            if (i+a < tree_length + 1){
                //Let's add the item
                set[(i+a)/bit_size_aelem] |= left_one>>((i+a)%bit_size_aelem);
            }

        }

    }
}



void TSetArray::filter_direction(bool direction) {
    // direction = true; --> LEFT-TO-RIGHT
    // direction = false; --> RIGHT-TO-LEFT

    int size=tree_length/bit_size_aelem+1; // same than TSet array_len

    for (int i=0; i<tree_length; i++) {
        aelem *set =(aelem *)(bitdata+(tree_length/bit_size_aelem+1)*i);
        for (int j=0; j<size; j++) {
            aelem shifted;
            if (i/bit_size_aelem==j) {
                shifted=~(aelem)0>>(i%bit_size_aelem);
            }
            else if (i/bit_size_aelem>j) {
                shifted=(aelem)0;
            }
            else {
                shifted=~(aelem)0;
            }
            if (direction) {
                shifted=~shifted;
            }
   
            set[j]&=shifted;
        }
    } 
}

void TSetArray::print_array() {
    TSet tmp(tree_length,NULL);
    for (int s_idx=0; s_idx<tree_length; s_idx++) {
        get_set(s_idx,&tmp);
        for (int i_idx=0; i_idx<tree_length; i_idx++) {
            if (tmp.has_item(i_idx)) {
                printf("%d[%d]\n",s_idx,i_idx);
            }
        }
    }
}



