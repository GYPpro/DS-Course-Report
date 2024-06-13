/**
 * @file myVector.h
 * @brief A Memory-contiguous, variable-length array
 * @details
 * 不知道该写什么，反正就是vector，正常用就行了
 * @author github.com/GYPpro
 * @version 0.2.0
 */

#ifndef PRVLIBCPP_VECTOR_HPP
#define PRVLIBCPP_VECTOR_HPP

#include <new>
#include <cstddef>
#include <type_traits>
#include <string.h>

namespace myDS
{

    const size_t _EXPENSION_RATIO = 2;
    const size_t _INITIAL_SIZE = 16;

    template <typename TYPE_NAME>
    class vector
    {
    private:
        std::size_t _size;
        std::size_t _max_cap;
        TYPE_NAME *_begin = nullptr;
        TYPE_NAME *_push_back_idx = _begin;

        class _iterator
        {
        private:
            TYPE_NAME *_ptr;
            myDS::vector<TYPE_NAME> * _upper_pointer;
            size_t _upper_idx;

        public:
            enum __iter_dest_type
            {
                front,
                back
            };
            __iter_dest_type _iter_dest;
            
            _iterator(myDS::vector<TYPE_NAME> *_upper, size_t _n, __iter_dest_type _d)
            {
                _upper_idx = _n;
                _upper_pointer = _upper;
                _ptr = &(*_upper_pointer)[_n];        
                _iter_dest = _d;      
            }

            TYPE_NAME & operator*()
            {
                return (*_ptr);
            }

            TYPE_NAME *operator->()
            {
                return _ptr;
            }

            myDS::vector<TYPE_NAME>::_iterator operator++()
            {
                if (_iter_dest == front)
                    _upper_idx++;
                else
                    _upper_idx--;
                _ptr = &((*_upper_pointer)[_upper_idx]);
                return *this;
            }

            myDS::vector<TYPE_NAME>::_iterator operator++(int)
            {
                myDS::vector<TYPE_NAME>::_iterator old = *this;
                if (_iter_dest == front)
                    _upper_idx++;
                else
                    _upper_idx--;
                _ptr = &((*_upper_pointer)[_upper_idx]);
                return old;
            }

            myDS::vector<TYPE_NAME>::_iterator operator+(size_t _n)
            {
                //_upper_idx += _n;
                if (_iter_dest == front)
                    _upper_idx += _n;
                else
                    _upper_idx -= _n;
                _ptr = &((*_upper_pointer)[_upper_idx]);
                return *this;
            }

            bool operator==(myDS::vector<TYPE_NAME>::_iterator _b)
            {
                if (&(*_b) == _ptr)
                    return 1;
                else
                    return 0;
            }

            bool operator!=(myDS::vector<TYPE_NAME>::_iterator _b)
            {
                if (&(*_b) == _ptr)
                    return 0;
                else
                    return 1;
            }
        };

    private:
        void _expension()
        {
            if (_max_cap == 0)
            {
                if(_begin)
                    ::operator delete[](_begin);
                _begin = new TYPE_NAME[_INITIAL_SIZE];
                _max_cap = _INITIAL_SIZE;
            }
            else
            {
                TYPE_NAME *_next_begin = new TYPE_NAME[_EXPENSION_RATIO * (std::size_t)_max_cap];
                // for (std::size_t i = 0; i < _size; i++)
                //     _next_begin[i] = _begin[i];
                memcpy(_next_begin,_begin,_size*sizeof(TYPE_NAME));
                // for(TYPE_NAME * __ptr = _begin;__ptr != _begin + _max_cap;__ptr ++)
                    // __ptr->~TYPE_NAME();
                delete[] _begin;
                _max_cap *= _EXPENSION_RATIO;
                _begin = _next_begin;
            }
            _push_back_idx = _begin + _size;
        }

    public:
        vector() {
            _size = 0;
            _max_cap = 0;
            _push_back_idx = _begin + _size;
        }

        // IT
        vector(std::size_t _n) //
        {
            _size = 0;
            _max_cap = 0;
            resize(_n);
            _push_back_idx = _begin + _size;
        }

        // FIXME:
        vector(std::size_t _n, TYPE_NAME _init_value)
        {
            _begin = new TYPE_NAME[_n];
            _size = _n;
            _max_cap = _n;
            _push_back_idx = _n;
            for (std::size_t i = 0; i < _push_back_idx; i++)
                _begin[i] = _init_value;
        }

        vector(myDS::vector<TYPE_NAME> &_b)
        {
            for (auto x : _b)
                this->push_back(x);
        }

        //IT
        void resize(size_t _n)
        {
            if(_n > _size)
                for(int __i = 0;__i < _n;__i++)
                {
                    if(_size + 1 >= _max_cap)
                        _expension();   
                    // _push_back_idx = new TYPE_NAME();
                    // if(std::is_integral<TYPE_NAME>::value){ __tmp = 0;}
                    // if(std::is_floating_point<TYPE_NAME>::value){ __tmp = 0;}
                    // delete &_begin[_push_back_idx];
                    _size ++;
                    _push_back_idx ++;
                }
            _size = _n;
            _push_back_idx = _begin + _size;
        }

        // HACK:模板参数为未实现=的类
        void push_back(const TYPE_NAME &__tmp)
        {
            if(_size + 1 >= _max_cap)
                _expension();   
            // *_push_back_idx = val;
            memcpy(_push_back_idx,&__tmp,sizeof(TYPE_NAME));
            _push_back_idx++;
            _size++;
        }

        vector<TYPE_NAME>::_iterator begin()
        {
            enum myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s = myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::front;
            return myDS::vector<TYPE_NAME>::_iterator(this, 0,s);
        }

        myDS::vector<TYPE_NAME>::_iterator rbegin()
        {
            enum myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s = myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::back;
            return myDS::vector<TYPE_NAME>::_iterator(this, _size - 1,s);
        }

        myDS::vector<TYPE_NAME>::_iterator end()
        {
            enum myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s = myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::front;
            return myDS::vector<TYPE_NAME>::_iterator(this,_size,s);
        }

        myDS::vector<TYPE_NAME>::_iterator rend()
        {
            enum myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s = myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::back;
            return myDS::vector<TYPE_NAME>::_iterator(this, 0, s);
        }

        TYPE_NAME at(std::size_t _n)
        {
            return _begin[_n];
        }

        std::size_t size()
        {
            return _size;
        }

        bool equal(myDS::vector<TYPE_NAME> _b)
        {
            for (int i = 0; i < _size; i++)
                if (_b[i] != _begin[i])
                    return false;
            return true;
        }

        TYPE_NAME &operator[](std::size_t _n)
        {
            return _begin[_n];
        }

        myDS::vector<TYPE_NAME> &operator=(myDS::vector<TYPE_NAME> _b)
        {
            this->resize(0);
            for(auto __x:_b) this->push_back(__x);
            
        }

        myDS::vector<TYPE_NAME> &operator+(myDS::vector<TYPE_NAME> _b)
        {
            for (auto x : _b)
                this->push_back(x);
        }

        ~vector()
        {
            // for(TYPE_NAME * __ptr = _begin;__ptr != _begin + _max_cap;__ptr ++)
                // __ptr->~TYPE_NAME();
            
            //FIXME:Unknown signal when vector<vector<int>>
            if(_begin)
                // ::operator delete[](_begin);
                delete[] _begin;
        }
    };
} // namespace myDS

#endif
