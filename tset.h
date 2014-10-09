typedef unsigned long aelem;

namespace tset {
class TSet {
    public:
        int tree_length;
        int array_len;
        aelem *bitdata;
        aelem enum_state; // integer with already enumerated 1s removed
        size_t enum_state_idx; // index in the array

        TSet(int length);
        void intersection_update(TSet *other);
        void union_update(TSet *other);
        void minus_update(TSet *other);
        void add_item(int item);
        bool has_item(int item);
        void erase();
        void copy(TSet *other);
        bool next_item(TSet *result);
        void start_iteration();

};
}
