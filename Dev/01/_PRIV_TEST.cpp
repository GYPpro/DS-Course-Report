#define DS_TOBE_TEST linkedList

#define _PRIVATE_DEBUG

#include "Dev\01\linkedList.h"

#include <iostream>
#include <math.h>
#include <vector>

using namespace std;

using TBT = myDS::DS_TOBE_TEST<int>;

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
            tc.innerPrint();
            cout << "Iter with index:\n";
            for(int i = 0;i < tc.size();i ++) cout << tc[i] << " ";cout << "\n";
            cout << "Iter with begin end\n";
            for(auto x = tc.begin();x != tc.end();x ++) cout << (*x) << " ";cout << "\n";
            cout << "Iter with AUTO&&\n";
            for(auto x:tc) cout << x << " ";cout << "\n";  
        } else if(op == "iterB") //正序遍历
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
  pf 3
  pb 3
  iterF
  iterB
  delEL 3
  iterF
  delPS 1
  clr
  pb 1
  pb 2
  iterF
  delPS 0
  delEL 2
  iterF


  pb 1
  pb 2
  pb 3
  pb 4
  pf 3
  pb 3
  iterF
--Header[0x662720]: 0
--Tail[0x662770]: 0
-----------
cur:6
[0x662720] ->next:0x662540 ->priv:0 ||data:0
[0x662540] ->next:0x662590 ->priv:0x662720 ||data:3
[0x662590] ->next:0x6625e0 ->priv:0x662540 ||data:1
[0x6625e0] ->next:0x662630 ->priv:0x662590 ||data:2
[0x662630] ->next:0x662680 ->priv:0x6625e0 ||data:3
[0x662680] ->next:0x6626d0 ->priv:0x662630 ||data:4
[0x6626d0] ->next:0x662770 ->priv:0x662680 ||data:3
[0x662770] ->next:0 ->priv:0x6626d0 ||data:0
Iter with index:
3 1 2 3 4 3
Iter with begin end
3 1 2 3 4 3
Iter with AUTO&&
3 1 2 3 4 3
  iterB
--Header[0x662720]: 0
--Tail[0x662770]: 0
-----------
cur:6
[0x662720] ->next:0x662540 ->priv:0 ||data:0
[0x662540] ->next:0x662590 ->priv:0x662720 ||data:3
[0x662590] ->next:0x6625e0 ->priv:0x662540 ||data:1
[0x6625e0] ->next:0x662630 ->priv:0x662590 ||data:2
[0x662630] ->next:0x662680 ->priv:0x6625e0 ||data:3
[0x662680] ->next:0x6626d0 ->priv:0x662630 ||data:4
[0x6626d0] ->next:0x662770 ->priv:0x662680 ||data:3
[0x662770] ->next:0 ->priv:0x6626d0 ||data:0
Iter with index:
3 4 3 2 1 3
Iter with begin end
3 4 3 2 1 3
  delEL 3
3
  iterF
--Header[0x662720]: 0
--Tail[0x662770]: 0
-----------
cur:3
[0x662720] ->next:0x662590 ->priv:0 ||data:0
[0x662590] ->next:0x6625e0 ->priv:0x662720 ||data:1
[0x6625e0] ->next:0x662680 ->priv:0x662590 ||data:2
[0x662680] ->next:0x662770 ->priv:0x6625e0 ||data:4
[0x662770] ->next:0 ->priv:0x662680 ||data:0
Iter with index:
1 2 4
Iter with begin end
1 2 4
Iter with AUTO&&
1 2 4
  delPS 1
1
  clr
Unexpected Delete at :4 with next:16187728
  pb 1
  pb 2
  iterF
--Header[0x6625e0]: 0
--Tail[0x662680]: 0
-----------
cur:2
[0x6625e0] ->next:0x662540 ->priv:0 ||data:0
[0x662540] ->next:0x662630 ->priv:0x6625e0 ||data:1
[0x662630] ->next:0x662680 ->priv:0x662540 ||data:2
[0x662680] ->next:0 ->priv:0x662630 ||data:0
Iter with index:
1 2
Iter with begin end
1 2
Iter with AUTO&&
1 2
  delPS 0
1
  delEL 2
1
  iterF
--Header[0x6625e0]: 0
--Tail[0x662680]: 0
-----------
cur:0
[0x6625e0] ->next:0x662680 ->priv:0 ||data:0
[0x662680] ->next:0 ->priv:0x6625e0 ||data:0
Iter with index:

Iter with begin end

Iter with AUTO&&


 
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

signed main()
{
    // accuracyTest();
    memLeakTest();
}