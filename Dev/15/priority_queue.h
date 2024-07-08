#ifndef PRIORITY_QUEUE_HPP
#define PRIORITY_QUEUE_HPP

#include <vector>
#include <functional>

#ifdef __PRIVATE_DEBUGE
#include <iostream>
#endif

namespace myDS {
    template<typename VALUE_TYPE, typename Compare = std::less<VALUE_TYPE>>
    class priority_queue {
    private:
        std::vector<VALUE_TYPE> h;
        Compare comp;

        void floow(std::size_t x) {
            while (x > 1 && comp(h[x / 2], h[x])) {
                std::swap(h[x], h[x / 2]);
                x >>= 1;
            }
        }

        void drown(std::size_t x) {
            while (x * 2 <= h.size() - 1) {
                int t = x * 2;
                if (t + 1 <= h.size() - 1 && comp(h[t], h[t + 1])) t++;
                if (!comp(h[x], h[t])) break;
                std::swap(h[x], h[t]);
                x = t;
            }
        }

    public:
        explicit priority_queue(const Compare& comp = Compare()) : comp(comp) { h.push_back(VALUE_TYPE()); }

        ~priority_queue() { }

        void push(const VALUE_TYPE& t) {
            h.push_back(t);
            floow(h.size() - 1);
        }

        const VALUE_TYPE& top() const {
            return h[1];
        }

        VALUE_TYPE pop() {
            auto t = this->top();
            std::swap(h[1], h[h.size() - 1]);
            h.pop_back();
            drown(1);
            return t;
        }

#ifdef __PRIVATE_DEBUGE
        void innerPrint() {
            for (auto x : h) std::cout << x << " ";
            std::cout << "\n";
        }
#endif
    };
} // namespace myDS

#endif
