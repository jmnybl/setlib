#include "tset.h"

using namespace tset;

int main() {
    TSet s = TSet(100);
    TSet other = TSet(100);
    s.copy(&other);
    s.intersection_update(&other);

}
