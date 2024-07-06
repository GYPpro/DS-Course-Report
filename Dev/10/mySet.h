#ifndef PRVLIBCPP_SET_HPP
#define PRVLIBCPP_SET_HPP

#include <Dev\08\RB_Tree.h>

namespace myDS
{
    template<typename VALUE_TYPE>
    class set{
    private:
        myDS::RBtree<VALUE_TYPE> dataST;

    public:
        set(){ }

        ~set(){ }

        void insert(VALUE_TYPE _d) {dataST.insert(_d);}
        bool erase(VALUE_TYPE _d) {return dataST.erase(_d);}
        bool find(VALUE_TYPE _d) {return dataST.find(_d);}
        auto begin() {return dataST.begin();}
        auto end() {return dataST.end();}
    };  
} // namespace myDS
#endif
