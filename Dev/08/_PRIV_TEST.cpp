// #include <d:\Desktop\Document\Coding\C++\ProjectC\myDS\myVector.h>
// #include "myVector.h"
#include "Dev\08\RB_Tree.h"
#include <iostream>
#include <vector>

using namespace myDS;

int main()
{
    // testingVector tc;
    int i = 0;
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
            break;
        case 'd':
            {
                int t;
                std::cin  >> t;
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
 i 6
 p
 i 5
 p
*/

}
