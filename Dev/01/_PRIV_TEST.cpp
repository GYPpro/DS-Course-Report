#define DS_TOBE_TEST linkedList

#include "Dev\01\linkedList.h"

#include <iostream>
#include <math.h>
#include <vector>

using namespace std;

using TBT = myDS::DS_TOBE_TEST<int>;

void accuracyTest() {//结构正确性测试
    for(;;)
    {
        string op;
        cin >> op;
        TBT tc = TBT();
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
        } else if(op == "at")//随机访问
        {
            int p;
            cin >> p;
            cout << tc[p] << "\n";
        } else if(op == "delEL")//删除所有等于某值元素
        {
            int p;
            cin >> p;
            cout << tc.erase(p) << "\n";
        } else if(op == "delPS")//删除某位置上的元素
        {
            int p;
            cin >> p;
            cout << tc.erase(tc.get(p)) << "\n";
        } else if(op == "iterF") //正序遍历
        {
            cout << "Iter with index:\n";
            for(int i = 0;i < tc.size();i ++) cout << tc[i] << " ";cout << "\n";
            cout << "Iter with begin end\n";
            for(auto x = tc.begin();x != tc.end();x ++) cout << (*x) << " ";cout << "\n";
            cout << "Iter with AUTO&&\n";
            for(auto x:tc) cout << x << " ";cout << "\n";  
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

void memLeakTest() {//内存泄漏测试

}

signed main()
{

}