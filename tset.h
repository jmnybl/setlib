typedef unsigned long aelem;

class TSet {
    public:
        int tree_length;
        int array_len;
        aelem *bitdata;

        TSet(int length);
        void intersection_update(TSet *other);

};
