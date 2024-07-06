// #define _PRIVATE_DEBUG
#ifndef INTERFACE_STACK_HPP
#define INTERFACE_STACK_HPP

#ifdef _PRIVATE_DEBUG
#include <iostream>
#endif

namespace myDS
{
    template<typename VALUE_TYPE>
    class stack{
    protected: 
    private:
        vector<VALUE_TYPE> _data;
    public:
        stack(){ }

        void push(VALUE_TYPE t) {
            _data.push_back(t);
        }
        
        VALUE_TYPE pop() {
            VALUE_TYPE t = _data.back();
            _data.pop_back();
            return t;
        }

        VALUE_TYPE top() {
            return _data.back();
        }

        bool empty() {
            return _data.empty();
        }

        int size() {
            return _data.size();
        }

        void clear() {
            _data.clear();
        }

        ~stack() { }
    };
}
#endif