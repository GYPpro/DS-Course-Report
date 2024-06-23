#define DS_TOBE_TEST deque

#define _PRIVATE_DEBUG
// #define __DETIL_DEBUG_OUTPUT

#include "Dev\04\deque.h"

#include <time.h>
#include <iostream>
#include <math.h>
#include <vector>

using namespace std;

using TBT = myDS::deque<int>;

void accuracyTest() {//结构正确性测试

    TBT tc = TBT();
    for(;;)
    {
        string op;
        cout << ">>>";
        cin >> op;
        if(op == "clr") { //清空
            tc.clear();
        } else if(op == "q") //退出测试
        {
            return;
        } else if(op == "pb")//push_back
        {
            int c;
            cin >> c;
            tc.push_back(c);
        } else if(op == "pf")//push_frount
        {
            int c;
            cin >> c;
            tc.push_frount(c);
        } else if(op == "ob")//pop_back
        {
            cout << tc.pop_back() << "\n";
        } else if(op == "of")//pop_frount
        {
            cout << tc.pop_frount() << "\n";
        } else if(op == "at")//随机访问
        {
            int p;
            cin >> p;
            cout << tc[p] << "\n";
        } else if(op == "at")//随机访问
        {
            int p;
            cin >> p;
            cout << tc[p] << "\n";
        } else if(op == "of")//pop_frount
        {
            
        } else if(op == "at")//随机访问
        {
            int p;
            cin >> p;
            cout << tc[p] << "\n";
        // } else if(op == "delEL")//删除所有等于某值元素
        // {
        //     int p;
        //     cin >> p;
        //     cout << tc.erase(p) << "\n";
        // } else if(op == "delPS")//删除某位置上的元素
        // {
        //     int p;
        //     cin >> p;
        //     cout << tc.erase(tc.get(p)) << "\n";
        } else if(op == "iterF") //正序遍历
        {
            tc.innerPrint();
            cout << "Iter with index:\n";
            for(int i = 0;i < tc.size();i ++) cout << tc[i] << " ";cout << "\n";
            // cout << "Iter with begin end\n";
            // for(auto x = tc.begin();x != tc.end();x ++) cout << (*x) << " ";cout << "\n";
            // cout << "Iter with AUTO&&\n";
            // for(auto x:tc) cout << x << " ";cout << "\n";  
        } else if(op == "iterB") //倒序遍历
        {
            tc.innerPrint();
            cout << "Iter with index:\n";
            for(int i = 0;i < tc.size();i ++) cout << tc[tc.size()-1-i] << " ";cout << "\n";
            // cout << "Iter with begin end\n";
            // for(auto x = tc.rbegin();x != tc.rend();x ++) cout << (*x) << " ";cout << "\n";
            // cout << "Iter with AUTO&&\n";."\n";  
        } else if(op == "mv")//单点修改
        {
            int p;
            cin >> p;
            int tr;
            cin >> tr;
            tc[p] = tr;
        } else if(op == "")
        {
            
        } else {
            op.clear();
        }
    }
}


/*
pb 2
pb 3
pb 4
pf 1
pf 0
iterF

pb 5
pb 6
of
of
of
iterF
of
iterF
of
iterF

>>>pb 2
>>>pb 3
>>>pb 4
>>>pf 1
>>>pf 0
>>>iterF
L : -1 R : 2
L : 1 0
R : 2 3 4
Iter with index:
0 1 2 3 4
>>>
pb 5
>>>pb 6
>>>of
0
>>>of
1
>>>of
2
>>>iterF
L : 2 R : 4
L :
R : 2 3 4 5 6
Iter with index:
3 4 5 6
>>>of
3
>>>iterF
L : 1 R : 2
L :
R : 4 5 6
Iter with index:
4 5 6
>>>of
4
>>>iterF
L : 1 R : 1
L :
R : 5 6
Iter with index:
5 6
 
 */

void memLeakTest1() {//内存泄漏测试
    TBT tc = TBT();
    for(;;){
        tc.push_back(1);
        tc.push_back(1);
        tc.push_back(1);
        tc.push_back(1);
        tc.clear();
    }
}

void memLeakTest2() {//内存泄漏测试
    TBT tc = TBT();
    for(;;){
        tc.push_back(1);
        tc.pop_frount();
    }
}

void speedTest()
{
    TBT tc = TBT();
    int begin = clock(); 
    int N = 1e8;
    for(int i = 0;i < sqrt(N/2);i ++)
    {
        for(int j = 0;j < sqrt(N/2);j ++)
        {
            tc.push_back(i);
        }
        for(int j = 0;j < sqrt(N/2);j ++)
        {
            tc.pop_frount();
        }
    }
    cout << "myDS::deque push_back then pop_frount sqrt(5000000) elements for sqrt(5000000) times cost:" << clock() - begin << "ms\n";

    std::vector<int> tmp;
    begin = clock();
    for(int i = 0;i < N;i ++)
    {
        tmp.push_back(i);
    }
    cout << "std::vector push_back 10000000 elements cost:" << clock() - begin << "ms\n";
    system("pause");

    /*
    myDS::deque push_back then pop_frount sqrt(5000000) elements for sqrt(5000000) times cost:3964ms
    std::vector push_back 10000000 elements cost:1528ms
  */
}

signed main()
{
    // accuracyTest();
    // memLeakTest1();
    // memLeakTest2();
    speedTest();
}