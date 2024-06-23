// #define _PRIVATE_DEBUG
#ifndef PRVLIBCPP_DEQUE_HPP
#define PRVLIBCPP_DEQUE_HPP

#include <map>
#include <vector>

#ifdef _PRIVATE_DEBUG
#include <iostream>
#endif

namespace myDS
{
    template<typename VALUE_TYPE>
    class deque{
    protected: 

    private:
        using coddinate = std::pair<std::int32_t,std::int32_t>;

        // < L : 0 , R : 1 >
        std::vector<std::vector<VALUE_TYPE>> _indexs;

        std::int32_t _size = 0;
        std::int32_t _L = 1;
        std::int32_t _R = -1;

        VALUE_TYPE & get(coddinate p) {
            return _indexs[p.first][p.second];
        }

        coddinate index2cod(std::int32_t p) {
            if(p+_L > 0) return coddinate(1,p+_L-1);
            else return coddinate(0,-p-_L);
        }

        void _reDistribute() {
            if(_L * _R <= 0) return;
            if(abs(_L - _R) + 1 < std::min(abs(_L),abs(_R))) {
                if(_L > 0) { // < --- 0 : 0 --- L -- R --- > 
                    std::vector<VALUE_TYPE> N;
                    for(int i = _L-1;i <= _R;i ++) N.push_back(_indexs[1][i]);
                    _indexs[1] = N;
                    _L = 1;
                    _R = N.size() - 1;
                } else { // < --- L(<0) -- R(<0) --- 0 : 0 --- > 
                    std::vector<VALUE_TYPE> N;
                    for(int i = -_R-1;i <= -_L;i ++) N.push_back(_indexs[0][i]);
                    _indexs[0] = N;
                    _L = -N.size()+1;
                    _R = -1;
                }
            } else return;
        }

    public:
        deque(){
            _indexs.push_back(std::vector<VALUE_TYPE>());
            _indexs.push_back(std::vector<VALUE_TYPE>());
        }

        void push_back(VALUE_TYPE t) {
            _R ++;
            if(_R >= 0) {
                _indexs[1].push_back(t);
            } else {
                _indexs[0][_R-1] = t;
                _reDistribute();
            }
        }

        void push_frount(VALUE_TYPE t) {
                _L --;
            if(_L <= 0) {
                _indexs[0].push_back(t);
            } else {
                _indexs[1][_L-1] = t;
                _reDistribute();
            }
        }

        VALUE_TYPE pop_back() {
            if(!this->size()) throw std::out_of_range("Pop from empty deque");
            VALUE_TYPE t ;
            if(_R >= 0) {
                t = _indexs[1].back();
                _indexs[1].pop_back();
                _R --;
            } else {
                t = _indexs[0][-_R-1];
                _R --;
                _reDistribute();
            }
            return t;
        }

        VALUE_TYPE pop_frount() {
            if(!this->size()) throw std::out_of_range("Pop from empty deque");
            VALUE_TYPE t;
            if(_L <= 0) {
                t = _indexs[0].back();
                _indexs[0].pop_back();
                _L ++;
            } else {
                t = _indexs[1][_L-1];
                _L ++;
                _reDistribute();
            }
            return t;
        }

        void clear() {
            _indexs[0].clear();
            _indexs[1].clear();
            _L = 1;
            _R = -1;
        }

        std::int32_t size() {
            return _R - _L + 2;
        }

#ifdef _PRIVATE_DEBUG
        void innerPrint() {
            std::cout << "L : " << _L << " R : " << _R << "\n";
            std::cout << "L : ";
            for(auto x:_indexs[0]) std::cout << x << " ";
            std::cout << "\n";
            std::cout << "R : ";
            for(auto x:_indexs[1]) std::cout << x << " ";
            std::cout << "\n";
        }
#endif

        // myDS::deque<VALUE_TYPE>::_iterator begin() { }
        
        // myDS::deque<VALUE_TYPE>::_iterator rbegin() { }

        // myDS::deque<VALUE_TYPE>::_iterator end() { }

        // myDS::deque<VALUE_TYPE>::_iterator rend() { }

        // myDS::deque<VALUE_TYPE>::_iterator get(std::int32_t p) { }

        VALUE_TYPE & operator[](std::int32_t p) {
            return get(index2cod(p));
        }
    };
}
#endif