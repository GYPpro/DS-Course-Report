#define DS_TOBE_TEST dataBlock

#define _PRIVATE_DEBUG
// #define __DETIL_DEBUG_OUTPUT

#include "Dev\03\dataBlock.hpp"

#include <time.h>
#include <iostream>
#include <math.h>
#include <vector>

using namespace std;

using TBT = myDS::dataBlock<int>;

void accuracyTest() {//结构正确性测试

    TBT tc = TBT();
    for(;;)
    {
        string op;
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
        // } else if(op == "pf")//push_frount
        // {
        //     int c;
        //     cin >> c;
        //     tc.push_frount(c);
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
            cout << "Iter with begin end\n";
            for(auto x = tc.begin();x != tc.end();x ++) cout << (*x) << " ";cout << "\n";
            cout << "Iter with AUTO&&\n";
            for(auto x:tc) cout << x << " ";cout << "\n";  
        } else if(op == "iterB") //倒序遍历
        {
            tc.innerPrint();
            cout << "Iter with index:\n";
            for(int i = 0;i < tc.size();i ++) cout << tc[tc.size()-1-i] << " ";cout << "\n";
            cout << "Iter with begin end\n";
            for(auto x = tc.rbegin();x != tc.rend();x ++) cout << (*x) << " ";cout << "\n";
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
  pb 1
  pb 2
  pb 3
  pb 4
  iterF
  iterB
  clr
  pb 0
  pb 3
  pb 1
  pb 2
  pb 3
  pb 4
  iterF
  iterB
  mv 0 3
  iterF
  pb 1
  pb 2
  pb 3
  pb 4
  iterF

Block : [0] at:0x722540
1
Block : [1] at:0x7225c0
2
Block : [2] at:0x722580
3 4
Iter with index:
1 2 3 4
Iter with begin end
1 2 3 4
Iter with AUTO&&
1 2 3 4
  iterB

Block : [0] at:0x722540
1
Block : [1] at:0x7225c0
2
Block : [2] at:0x722580
3 4
Iter with index:
4 3 2 1
Iter with begin end
4 3 2 1
  clr
  pb 0
  pb 3
  pb 1
  pb 2
  pb 3
  pb 4
  iterF

Block : [0] at:0x722540
0
Block : [1] at:0x722580
3
Block : [2] at:0x7225c0
1 2
Block : [3] at:0x722600
3 4 -1163005939 -1163005939
Iter with index:
0 3 1 2 3 4
Iter with begin end
0 3 1 2 3 4
Iter with AUTO&&
0 3 1 2 3 4
  iterB

Block : [0] at:0x722540
0
Block : [1] at:0x722580
3
Block : [2] at:0x7225c0
1 2
Block : [3] at:0x722600
3 4 -1163005939 -1163005939
Iter with index:
4 3 2 1 3 0
Iter with begin end
4 3 2 1 3 0
mv 0 3
  iterF

Block : [0] at:0x722540
3
Block : [1] at:0x722580
3
Block : [2] at:0x7225c0
1 2
Block : [3] at:0x722600
3 4 -1163005939 -1163005939
Iter with index:
3 3 1 2 3 4
Iter with begin end
3 3 1 2 3 4
Iter with AUTO&&
3 3 1 2 3 4
 
 */

void memLeakTest() {//内存泄漏测试
    TBT tc = TBT();
    for(;;){
        tc.push_back(1);
        tc.push_back(1);
        tc.push_back(1);
        tc.push_back(1);
        tc.clear();
    }
}

void speedTest()
{
    TBT tc = TBT();
    int begin = clock(); 
    int N = 1e8;
    for(int i = 0;i < N;i ++)
    {
        tc.push_back(i);
    }
    cout << "myDS::dataBlock Push_back 10000000 elements cost:" << clock() - begin << "ms\n";

    std::vector<int> tmp;
    begin = clock();
    for(int i = 0;i < N;i ++)
    {
        tmp.push_back(i);
    }
    cout << "std::vector push_back 10000000 elements cost:" << clock() - begin << "ms\n";
    system("pause");

    /*
    myDS::dataBlock Push_back 10000000 elements cost:663ms
    std::vector push_back 10000000 elements cost:1618ms
  */
}

signed main()
{
    // accuracyTest();
    // memLeakTest();
    speedTest();
}