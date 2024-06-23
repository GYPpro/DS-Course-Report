// #define _PRIVATE_DEBUG
#ifndef DATA_BLOCK_HPP
#define DATA_BLOCK_HPP

#include <vector>
#include <map>

#define _PRIVATE_DEBUG

#ifdef _PRIVATE_DEBUG
#include <iostream>
#endif

namespace myDS
{
    template<typename VALUE_TYPE>
    class dataBlock{
    protected: 

    private:
        class _iterator 
        {
        private:
            VALUE_TYPE *_ptr;
            std::pair<std::size_t,std::size_t> loc;
            dataBlock<VALUE_TYPE> * _upper_pointer;

        public:
            enum __iter_dest_type
            {
                front,
                back
            };
            __iter_dest_type _iter_dest;
            
            _iterator(myDS::dataBlock<VALUE_TYPE> *_upper,std::pair<std::size_t,std::size_t> _loc,__iter_dest_type _d)
            {
                _upper_pointer = _upper;
                loc = _loc;
                _ptr = &_upper_pointer->_indexs[loc.first][loc.second];
                _iter_dest = _d;
            }

            VALUE_TYPE & operator*()
            {
                return (*_ptr);
            }

            VALUE_TYPE *operator->()
            {
                return _ptr;
            }

            myDS::dataBlock<VALUE_TYPE>::_iterator operator++() {
                if(_iter_dest == front)
                {
                    loc = _upper_pointer->nextPII(loc);
                }
                else
                {
                    loc = _upper_pointer->prevPII(loc);
                }
                _ptr = &_upper_pointer->_indexs[loc.first][loc.second];
                return myDS::dataBlock<VALUE_TYPE>::_iterator(_upper_pointer,loc,_iter_dest);
            }

            myDS::dataBlock<VALUE_TYPE>::_iterator operator++(int) {
                myDS::dataBlock<VALUE_TYPE>::_iterator old = *this;
                if(_iter_dest == front)
                {
                    loc = _upper_pointer->nextPII(loc);
                }
                else
                {
                    loc = _upper_pointer->prevPII(loc);
                }
                _ptr = &_upper_pointer->_indexs[loc.first][loc.second];
                return old;
            }

            bool operator==(myDS::dataBlock<VALUE_TYPE>::_iterator _b) {
                return _ptr == _b._ptr;
            }

            bool operator!=(myDS::dataBlock<VALUE_TYPE>::_iterator _b) {
                return _ptr != _b._ptr;
            }
        };

        std::vector<VALUE_TYPE *> _indexs;
        std::pair<std::size_t,std::size_t> _cap = {0,0};
        std::size_t consMEX = 1;
        std::size_t _size = 0;


        void _expension()
        {
            VALUE_TYPE *temp = new VALUE_TYPE[consMEX];
            _indexs.push_back(temp);
            consMEX *= 2;
            _cap.first++;
            _cap.second = 0;
        }

        std::size_t getMEX(std::int32_t p)
        {
            if(p <= 0) return p+1; 
            return (1 << (p-1));
        }

        std::pair<std::size_t,std::size_t> nextPII(std::pair<std::size_t,std::size_t> p)
        {
            p.second++;
            if(p.second >= getMEX(p.first))
            {
                p.first++;
                p.second = 0;
            }
            return p;
        }  

        std::pair<std::size_t,std::size_t> prevPII(std::pair<std::size_t,std::size_t> p)
        {
#ifdef __DETIL_DEBUG_OUTPUT
            std::cout << "{" << p.first << "," << p.second << "}'s prev is";
#endif

            std::int32_t tmp = p.second;
            tmp --;
            if(tmp < 0)
            {
                p.first--;
                p.second = getMEX(p.first) - 1;
            } else p.second --;
#ifdef __DETIL_DEBUG_OUTPUT
            std::cout << "{" << p.first << "," << p.second << "}\n";
#endif

            return p;
        }

    public:
        dataBlock(){
            VALUE_TYPE *tmp = new VALUE_TYPE[1];
            _indexs.push_back(tmp);
        }

        ~dataBlock(){
            clear();
            delete [] (_indexs[0]);
        }

        void push_back(VALUE_TYPE t) {
            if(_cap.second >= getMEX(_cap.first)) {
                _expension();
            }
            _indexs[_cap.first][_cap.second] = t;
            _cap.second++;
            _size++;
        }

        void clear() {
            for(auto x:_indexs) delete [] x;
            _indexs.clear();
            VALUE_TYPE *tmp = new VALUE_TYPE[1];
            _indexs.push_back(tmp);
            consMEX = 1;
            _size = 0;
            _cap = {0,0};
        }

        std::size_t size() {
            return _size;
        }

        myDS::dataBlock<VALUE_TYPE>::_iterator begin() {
            return myDS::dataBlock<VALUE_TYPE>::_iterator(this,{0,0},myDS::dataBlock<VALUE_TYPE>::_iterator::front);
        }
        
        myDS::dataBlock<VALUE_TYPE>::_iterator rbegin() {
            return myDS::dataBlock<VALUE_TYPE>::_iterator(this,prevPII(_cap),myDS::dataBlock<VALUE_TYPE>::_iterator::back);
        }

        myDS::dataBlock<VALUE_TYPE>::_iterator end() {
            return myDS::dataBlock<VALUE_TYPE>::_iterator(this,nextPII(prevPII(_cap)),myDS::dataBlock<VALUE_TYPE>::_iterator::front);
        }

        myDS::dataBlock<VALUE_TYPE>::_iterator rend() {
            return myDS::dataBlock<VALUE_TYPE>::_iterator(this,prevPII({0,0}),myDS::dataBlock<VALUE_TYPE>::_iterator::back);
        }

#ifdef _PRIVATE_DEBUG
        void innerPrint() {
            std::pair<std::size_t,std::size_t> p = {0,0};
            while(p.first <= _cap.first) {
                if(p.second == 0) std::cout << "\nBlock : [" << p.first << "] at:" << _indexs[p.first] << "\n";
                std::cout << _indexs[p.first][p.second] << " ";
                p = nextPII(p);
            }
            std::cout << "\n";
        }
#endif

        VALUE_TYPE & operator[](std::size_t p) {
            if(p == 0) return _indexs[0][0];
            std::int32_t onord = 0;
            std::size_t tmp = p;
            while(tmp) {
                tmp >>= 1;
                onord++;
            }
#ifdef __DETIL_DEBUG_OUTPUT
            std::cout << "onord:" << onord << " p:" << p << " GETMEX :"<< getMEX(onord) << " index:{" << onord << "," << p - getMEX(onord) << "}\n";
#endif
            return _indexs[onord][p - getMEX(onord)];

        }
    };
}
#endif