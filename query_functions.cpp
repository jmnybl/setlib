#include "tset.h"
#include <stdio.h>

using namespace tset;

void pairing(TSet *index_set, TSet *other_set, TSetArray *mapping) {
    TSet result(index_set->tree_length,0);
    printf("tl %d\n",index_set->tree_length);
    for (int i=0;i<index_set->tree_length;i++) {
        if (index_set->has_item(i)) {
            mapping->get_set(i,&result);
            //puts("1");
            if (!other_set->intersection_not_empty(&result)) {
                index_set->delete_item(i);
            }
        }
    }

}
