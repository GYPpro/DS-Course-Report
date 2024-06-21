// #include <d:\Desktop\Document\Coding\C++\ProjectC\myDS\myVector.h>
// #include "myVector.h"
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

 i 5
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]
[4 : BLACK] [NIL]
[5 : RED] [NIL]
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]
[NIL]
[3 : RED] [NIL]
[4 : BLACK] [NIL]
[5 : RED] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]


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

}
