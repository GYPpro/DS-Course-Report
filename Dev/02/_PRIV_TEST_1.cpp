// #include <d:\Desktop\Document\Coding\C++\ProjectC\myDS\myVector.h>
#include "myVector.h"
#include <iostream>
#include <vector>

using namespace myDS;

class testingVector
{
public:
    int t1()
    {
        std::vector<int> c;
        vector<int> a;
        auto x = a.begin();
        auto y = *x;
        vector<std::pair<int, int>> d;
        auto z = d.begin();
        auto zz = (*z).first;

        std::vector<std::pair<int, int>> cc;
        auto z2 = cc.begin();
        auto zz2 = z2->first;
        auto zzz2 = *z2;
        a.push_back(1);
        // auto x = c.begin();
        return 0;
    };

    vector<int> tc;
    std::vector<int> comm;

    class ssdftestcls
    {
    public:
        vector<int> rtt;
        // std::vector<int> rtt;
        int a = 0;
        // ssdftestcls* operator=(const ssdftestcls& mwr)
        // {
        //     ssdftestcls* ctk = new ssdftestcls();
        //     ctk->a = mwr.a;
        //     // rtt = mwr.rtt;
        //     return ctk;
        // }
    };

    class mint
    {
    public:
        int data;
        friend std::ostream &operator<<(std::ostream &output, const mint &D)
        {
            output << D.data;
            return output;
        }
        friend std::istream &operator>>(std::istream &input, mint &D)
        {
            input >> D.data;
            return input;
        }
    };
    vector<mint> tc2;
    vector<mint> comm2;

    void tf2f()
    {
        //
        vector<mint> a;
        // a.push_back(1);
        // a.push_back(2);
        // std::cout << a[1] << " " << a.at(0) << "\n";
        char q;
        std::cin >> q;
        switch (q)
        {
        case 'p':
        {
            mint c;
            std::cin >> c;
            tc2.push_back(c);
            comm2.push_back(c);
        }
        break;
        case 'a':
        {
            int n;
            std::cin >> n;
            for (int i = 0; i < n; i++)
            {
                mint t;
                std::cin >> t;
                tc2.push_back(t);
                comm2.push_back(t);
            }
        }
        break;
        case 'i':
        {
            int c;
            std::cin >> c;
            std::cout << "myDS: " << tc2[c] << " " << tc2.at(c) << "\n";
            std::cout << "STL:  " << comm[c] << " " << comm.at(c) << "\n";
        }
        break;
        case 'r':
        {
            int c;
            std::cin >> c;
            tc2.resize(c);
            comm2.resize(c);
        }
        break;
        case 'w':
        {
            std::cout << "myDS + auto:";
            for (auto x : tc2)
                std::cout << x << " ";

            std::cout << "\nmyDS + for :";
            for (int i = 0; i < tc2.size(); i++)
                std::cout << tc2[i] << " ";

            std::cout << "\nSTL  + for :";
            for (int i = 0; i < comm2.size(); i++)
                std::cout << comm2[i] << " ";
            std::cout << "\n";
        }
        break;
        case 's':
        {
            std::cout << "myDS:" << tc2.size() << "\n";
            std::cout << "STL: " << comm2.size() << "\n";
        }
        break;

        default:
            break;
        }
        // ssdftestcls tcl;
        // vector<ssdftestcls> arr(4);
        // for(auto x = arr.begin();x != arr.end();x ++)
        // {
        //     auto y = arr.end();
        //     std::cout << (*x).a << " ";
        // }
        // arr[0].rtt = vector<int>(15);
    }

    void t2()
    {
        //
        vector<int> a;
        // a.push_back(1);
        // a.push_back(2);
        // std::cout << a[1] << " " << a.at(0) << "\n";
        char q;
        std::cin >> q;
        switch (q)
        {
        case 'p':
        {
            int c;
            std::cin >> c;
            tc.push_back(c);
            comm.push_back(c);
        }
        break;
        case 'a':
        {
            int n;
            std::cin >> n;
            for (int i = 0; i < n; i++)
            {
                int t;
                std::cin >> t;
                tc.push_back(t);
                comm.push_back(t);
            }
        }
        break;
        case 'i':
        {
            int c;
            std::cin >> c;
            std::cout << "myDS: " << tc[c] << " " << tc.at(c) << "\n";
            std::cout << "STL:  " << comm[c] << " " << comm.at(c) << "\n";
        }
        break;
        case 'r':
        {
            int c;
            std::cin >> c;
            tc.resize(c);
            comm.resize(c);
        }
        break;
        case 'w':
        {
            std::cout << "myDS + auto:";
            for (auto x : tc)
                std::cout << x << " ";

            std::cout << "\nmyDS + for :";
            for (int i = 0; i < tc.size(); i++)
                std::cout << tc[i] << " ";

            std::cout << "\nSTL  + for :";
            for (int i = 0; i < comm.size(); i++)
                std::cout << comm[i] << " ";
            std::cout << "\n";
        }
        break;
        case 's':
        {
            std::cout << "myDS:" << tc.size() << "\n";
            std::cout << "STL: " << comm.size() << "\n";
        }
        break;

        default:
            break;
        }
        // ssdftestcls tcl;
        vector<ssdftestcls> arr(4);
        arr.push_back(ssdftestcls());
        for (auto x = arr.begin(); x != arr.end(); x++)
        {
            auto y = arr.end();
            std::cout << (*x).a << " ";
        }
        // arr[0].rtt = vector<int>(15);
    }

    class dtc
    {
    public:
        ~dtc()
        {
            // std::cout << "DTC";
        }
    };

    void t3()
    {
        vector<dtc> arr(1);
        dtc *_begin = new dtc[20];
        dtc __tmp = dtc();
        delete &_begin[2];
        _begin[2] = __tmp;
    }

    void t4() // test case 4:template = calss(without operator= defined)
              //: memary leak!
              // fixed
    {
        // vector<vector<int>> arr(3);
        while (1)
        {
            myDS::vector<dtc> arr(3);
        }
        // arr[0].resize(3);
        // for(auto &x:arr) x.resize(15);
    }

    void t5()
    {
        vector<vector<int>> mtx;
        mtx.resize(15);
        mtx[0].resize(15);
        mtx[0][14] = 1;
        // std::cout << mtx[0][14] << "\n";
    }
};

int main()
{
    testingVector tc;
    int i = 0;
    while (1)
    {
        i++;
        // std::cout << i << "\n";
        tc.t2();
        // system("pause");
    }
    return 0;
}
