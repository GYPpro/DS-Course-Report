#ifndef _HUFFMAN_TREE_HPP
#define _HUFFMAN_TREE_HPP

#include <functional>
#include <string>
#include <map>
#include <vector>
#include <queue>

namespace myDS {
    class huffmanTree {
    protected:
        std::vector<int> pa;
        std::vector<int> wei;
        std::vector<std::pair<int,int>> s2code;

        bool comp(std::pair<char,int> a,std::pair<char,int> b)
        {
            return a > b;
        }

        std::size_t cap = 0;
        std::size_t MEX = 0;

        void link(int a,int b) {
            pa[a] = cap,pa[b] = cap;
            s2code[cap] = {a,b};
        }

    public:
        huffmanTree() { }

        huffmanTree(std::vector<int> _wei) {buildup(_wei);}
        
        void buildup(std::vector<int> _wei) {
            wei = _wei;
            MEX = wei.size()-1;
            pa.resize(MEX * 2 + 2);
            s2code.resize(MEX * 2 + 2);
            std::priority_queue<std::pair<int,int>,std::vector<std::pair<int,int>>,std::greater<std::pair<int,int>>> values;
            cap = MEX;
            for(int i = 1;i <= MEX;i ++) {
                values.push({wei[i],i});
            }
            while(values.size()) {
                cap ++;
                auto a = values.top();
                values.pop();
                if (values.size() == 0) 
                    break;
                auto b = values.top();
                values.pop();
                link(a.second,b.second);
                values.push({a.first + b.first,cap});
            }
        }

        int getWPL() {
            int t = 0;
            for(int i = 1;i <= MEX;i ++) t += wei[i] * (getPath(i).size());
        }

        std::vector<char> getPath(std::size_t n) {
            std::vector<char> rt;
            int t = n;
            while(pa[t]) {
                rt.push_back(s2code[pa[t]].first == t);
                t = pa[t];
            }
            std::vector<char> path;
            for(int i = 0;i < rt.size();i ++) path.push_back(rt[rt.size()-1-i]);
            return path;
        }

        std::vector<int> getC(std::vector<char> t) {
            int ori = cap-1;
            std::vector<int> rt;
            for(auto x:t) {
                if(s2code[ori] == std::pair<int,int>()){
                    rt.push_back(ori);
                    ori = cap-1;
                }
                if(x == 0) ori = s2code[ori].second;
                else ori = s2code[ori].first;
            } 
            if(s2code[ori] == std::pair<int,int>()){
                rt.push_back(ori);
                ori = cap;
            }
            return rt;
        }
        
    };

    class huffmanEncoder : huffmanTree {
    private:
        
        std::map<char,int> wordCounter;
        std::map<char,int> c2i;
        std::map<int,char> i2c;
        std::string init;

    public:
        huffmanEncoder(std::string _init) : huffmanTree(){
            init = _init;
            for(auto x:_init) wordCounter[x] ++;
            pa.resize(wordCounter.size()*2+1);
            std::vector<std::pair<char,int>> gt(1);
            for(auto x:wordCounter) gt.push_back(x);
            for(int i = 1;i < gt.size();i ++) c2i[gt[i].first] = i;
            for(int i = 1;i < gt.size();i ++) i2c[i] = gt[i].first;
            std::vector<int> wei;
            for(auto x:gt) wei.push_back(x.second);
            buildup(wei);
        };

        std::vector<char> encode(std::string s) {
            std::vector<char> rt;
            auto add = [&](std::vector<char> addit) -> void{
                for(int i = 0;i < addit.size();i ++) rt.push_back(addit[i]);
            };
            for(auto x:s) add(this->getPath(c2i[x]));
            return rt;
        }

        std::string decode(std::vector<char> r) {
            std::string rt;
            for(auto x:getC(r)) rt.push_back(i2c[x]);
            return rt;
        }

    };

};

#endif