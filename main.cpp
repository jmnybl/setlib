#include "tset.h"

int main() {
    TSet s = TSet(1);
    TSet other = TSet(1);
    s.intersection_update(&other);

}
