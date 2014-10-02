#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "tset.h"

TSet::TSet(int tree_length) {
    this->tree_length=tree_length;
    array_len=(tree_length/(sizeof(aelem)*8))+1;
    bitdata=new aelem[array_len];
    memset(bitdata, 0, array_len*sizeof(aelem));
}

void TSet::intersection_update(TSet *other) {

    assert(tree_length==other->tree_length);

    for (int i=0;i<array_len;i++) {
        bitdata[i]&=other->bitdata[i];
        
    }
}


