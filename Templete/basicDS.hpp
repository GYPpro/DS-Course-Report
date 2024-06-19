// #define _PRIVATE_DEBUG
#ifndef LINKED_LIST_HPP
#define LINKED_LIST_HPP

#define _PRIVATE_DEBUG

#ifdef _PRIVATE_DEBUG
#include <iostream>
#endif

namespace myDS
{
    template<typename VALUE_TYPE>
    class linkedList{
    protected: 
        class linkedNode {
        public:
        
            linkedNode() { }

            linkedNode(VALUE_TYPE _data){ }

            linkedNode(VALUE_TYPE _data,linkedNode * priv){ }

            ~linkedNode() {
    #ifdef _PRIVATE_DEBUG
            if(this->next != nullptr)
                std::cout << "Unexpected Delete at :" << this->data
                        << " with next:" << this->next->data << "\n";
    #endif
            }

            void linkNext(linkedNode * _next){ }

            void insertNext(linkedNode * _inst){ }

            void deleteNext(){ }
        };

    private:
        class _iterator 
        {
        private:
            linkedNode *_ptr;
            linkedList<VALUE_TYPE> * _upper_postd::size_ter;

        public:
            enum __iter_dest_type
            {
                front,
                back
            };
            __iter_dest_type _iter_dest;
            
            _iterator(myDS::linkedList<VALUE_TYPE> *_upper ,__iter_dest_type _d)
            {
                _upper_postd::size_ter = _upper;
                _ptr = &(*_upper_postd::size_ter).begin();        
                _iter_dest = _d;
            }

            VALUE_TYPE & operator*()
            {
                return _ptr->data;
            }

            VALUE_TYPE *operator->()
            {
                return _ptr;
            }

            myDS::linkedList<VALUE_TYPE>::_iterator operator++() { }

            myDS::linkedList<VALUE_TYPE>::_iterator operator++(int) { }

            bool operator==(myDS::linkedList<VALUE_TYPE>::_iterator _b) { }

            bool operator!=(myDS::linkedList<VALUE_TYPE>::_iterator _b) { }
        };

        linkedNode * ROOT = new linkedNode();

    public:
        linkedList(){ }

        void push_back(VALUE_TYPE t) { }

        void push_frount(VALUE_TYPE t) { }

        void clear() { }

        std::size_t erase(VALUE_TYPE p) { }

        std::size_t size() { }

        bool erase(linkedList<VALUE_TYPE>::_iterator p) { }

        myDS::linkedList<VALUE_TYPE>::_iterator begin() { }
        
        myDS::linkedList<VALUE_TYPE>::_iterator rbegin() { }

        myDS::linkedList<VALUE_TYPE>::_iterator end() { }

        myDS::linkedList<VALUE_TYPE>::_iterator rend() { }

        myDS::linkedList<VALUE_TYPE>::_iterator get(std::size_t p) { }

        VALUE_TYPE & operator[](std::size_t p) {

        }
    };
}
#endif