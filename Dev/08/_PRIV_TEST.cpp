// #include <d:\Desktop\Document\Coding\C++\ProjectC\myDS\myVector.h>
// #include "myVector.h"
#define __PRIVATE_DEBUGE
// #define __DETIL_DEBUG_OUTPUT
#include "Dev\08\RB_Tree.h"
#include "Dev\08\eg2.h"
#include <iostream>
#include <vector>


using namespace myDS;

int main()
{
    // testingVector tc;
    int i = 0;
    // bst rbt;
    RBtree<int> rbt;
    while (1)
    {
        // i++;
        char q;
        std::cin >> q;
        switch (q)
        {
        case 'i':
        {
            int t;
            std::cin >> t;
            rbt.insert(t);
        }
            break;
        case 'p':
            std::cout << "===DFS  Order===\n";
            rbt.printDfsOrder();
            std::cout << "===Iter Order===\n";
            rbt.printIterOrder();
            // std::cout << "===Use  Itera===\n";
            // for(auto x:rbt) std::cout << x << " ";
            // cout << "\n";
            std::cout << "===Use  Bg Ed===\n";
            for(auto x = rbt.begin();x != rbt.end();x ++)
            {
                auto & y = *x;
                std::cout << y << " ";
            }cout << "\n";
            
            std::cout << "\n";
            // rbt.inorder();
            break;
        case 'd':
            {
                int t;
                std::cin  >> t;
                // rbt.delete_value(t);
                rbt.erase(t);
            }
            /* code */
            break;
        case 'f':
            {
                // int t;
                // std::cin >> t;
                // std::cout << rbt.find(t);
            }
        
        default:
            break;
        }
        // std::cout << i << "\n";
        // tc.t2();
        // system("pause");
    }
    return 0;

/*
 i 1
 i 2
 i 3
 i 4
 i 5
 i 6
 p
 i 1
 i 2
 i 3
 i 4
 i 5
 i 6
p
===DFS  Order===
[2 : BLACK] [1 : BLACK] [NIL]
[NIL]
[4 : RED] [3 : BLACK] [NIL]
[NIL]
[5 : BLACK] [NIL]
[6 : RED] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : BLACK] [NIL]
[4 : RED] [NIL]
[5 : BLACK] [NIL]
[6 : RED] [NIL]
d 2
p
===DFS  Order===
[3 : BLACK] [1 : BLACK] [NIL]
[NIL]
[5 : RED] [4 : BLACK] [NIL]
[NIL]
[6 : BLACK] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : BLACK] [NIL]
[3 : BLACK] [NIL]
[4 : BLACK] [NIL]
[5 : RED] [NIL]
[6 : BLACK] [NIL]
d 5
p
===DFS  Order===
[3 : BLACK] [1 : BLACK] [NIL]
[NIL]
[6 : BLACK] [4 : RED] [NIL]
[NIL]
[NIL]
===Iter Order===
[NIL]
[1 : BLACK] [NIL]
[3 : BLACK] [NIL]
[4 : RED] [NIL]
[6 : BLACK] [NIL]
d 3
p
===DFS  Order===
[4 : BLACK] [1 : BLACK] [NIL]
[NIL]
[6 : BLACK] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : BLACK] [NIL]
[4 : BLACK] [NIL]
[6 : BLACK] [NIL]
d 2
p
===DFS  Order===
[4 : BLACK] [1 : BLACK] [NIL]
[NIL]
[6 : BLACK] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : BLACK] [NIL]
[4 : BLACK] [NIL]
[6 : BLACK] [NIL]
i 2
p
===DFS  Order===
[4 : BLACK] [1 : BLACK] [NIL]
[2 : RED] [NIL]
[NIL]
[6 : BLACK] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : BLACK] [NIL]
[2 : RED] [NIL]
[4 : BLACK] [NIL]
[6 : BLACK] [NIL]


 i 5
1 2 3 4 5
1 2 3
1 2 3
1 2 3
1 2 3
1 2 3
1 2 3 4 5

 p
*/

/*
i 1
i 2
i 3
i 5
i 4
p

*/

}
