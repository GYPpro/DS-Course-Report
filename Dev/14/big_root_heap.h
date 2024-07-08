#ifndef PRIORITY_QUEUE_HPP
#define PRIORITY_QUEUE_HPP

#include <vector>

#ifdef __PRIVATE_DEBUGE
#include <iostream>
#endif

namespace myDS
{
    template<typename VALUE_TYPE>
    class big_root_heap{
    private:
        std::vector<VALUE_TYPE> h;

        void floow(std::size_t x) {
            while(x > 1 && h[x] > h[x/2]) {
                std::swap(h[x],h[x/2]);
                x >>= 1;
            }
        }

        void drown(std::size_t x) {
            while(x * 2 <= h.size()-1) {
                int t = x * 2;
                if(t + 1 <= h.size()-1 && h[t + 1] > h[t]) t ++;
                if(h[t] <= h[x]) break;
                std::swap(h[x],h[t]);
                x = t;
            }
        }

    public:

        big_root_heap() {h.push_back(0);}

        ~big_root_heap() { }

        void push(VALUE_TYPE t)
        {
            h.push_back(t);
            floow(h.size()-1);
        }

        VALUE_TYPE top(){
            return h[1];
        }

        VALUE_TYPE pop(){
            auto t = this->top();
            std::swap(h[1],h[h.size()-1]);
            h.pop_back();
            drown(1);
            return t;
        }

#ifdef __PRIVATE_DEBUGE
        void innerPrint(){
            for(auto x:h) std::cout << x << " ";
            std::cout << "\n";
        }
#endif
    };
} // namespace myDS


#endif