#import "@preview/tablex:0.0.6": tablex, hlinex, vlinex, colspanx, rowspanx
#import "@preview/codelst:2.0.1": sourcecode
// Display inline code in a small box
// that retains the correct baseline.
#set text(font:("Times New Roman","Source Han Serif SC"))
#show raw.where(block: false): box.with(
  fill: luma(230),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)
#show raw: set text(
    font: ("consolas", "Source Han Serif SC")
  )
#set page(
  paper: "a4",
)
#set text(
    font:("Times New Roman","Source Han Serif SC"),
    style:"normal",
    weight: "regular",
    size: 13pt,
)

#let nxtIdx(name) = box[ #counter(name).step()#counter(name).display()]
#set math.equation(numbering: "(1)")

#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
)

#set math.equation(numbering: "(1)")

#set page(
  paper:"a4",
  number-align: right,
  margin: (x:2.54cm,y:4cm),
  header: [
    #set text(
      size: 25pt,
      font: "KaiTi",
    )
    #align(
      bottom + center,
      [ #strong[暨南大学本科实验报告专用纸(附页)] ]
    )
    #line(start: (0pt,-5pt),end:(453pt,-5pt))
  ]
)

/*----*/

= R-BTree的基本实现
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") R-BTree的基本实现 #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  08  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的

实现RB-tree的基本结构 


= 实验环境

计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

对于一个二叉搜索树，标记所有叶节点为`NIL`，并在路径上标记红黑节点，使得：
+ `NIL`节点为黑色
+ 红色节点的子节点为黑色
+ 从根节点到`NIL`节点路径上的黑色节点数量相同

定义旋转
#image("091.svg",width: 50%)

对于每次插入与删除，需要基于红黑节点性质进行平衡维护。具体实现见代码。

容易证明，满足红黑性质的红黑树，为近似平衡二叉搜索树。

可得插入复杂度为$OO(log_2 n)$，删除复杂度为$OO(log_2 n)$，随机访问复杂度为$OO(log_2 n)$

#pagebreak()

= 程序代码

== `memDeleteTest.cpp`
#sourcecode[```cpp
#include <iostream>
#include <new>
#include <stdlib.h>
using namespace std;

class testClass{
public:
	int a = 0;
	testClass(){a=1;};
	~testClass(){cout << "Distroy TestClass\n";};
};
int main()
{
	testClass * arr = new testClass[10];
	cout << "Finish Alloc\n";
	for(int i = 0;i < 10;i ++)
		arr[i].~testClass();
	if(arr)
		//delete[] arr;
		::operator delete[](arr);
	else cout << "nullPtr\n";
	cout << "Finish Delete\n";
	return 0;
}


```]
== `RB_Tree.h`
#sourcecode[```cpp
#ifndef RBTREE_MAP_HPP
#define RBTREE_MAP_HPP

#ifdef __PRIVATE_DEBUGE
#include <iostream>
#endif

#include <vector>
#include <stdlib.h>
#include "Dev\02\myVector.h"

using std::vector;


namespace myDS
{
    template <typename VALUE_TYPE>
    class RBtree{
    private:
        // using int size_t;
        enum COLOR {RED,BLACK};

    protected:
        //节点类
        class Node{
        public:
            VALUE_TYPE value;
            COLOR color;
            Node *leftSubTree,  //左子树根节点指针
                    *rightSubTree, //右子树根节点指针
                    *parent;       //父节点指针
            
            explicit Node() :
                value(VALUE_TYPE()), 
                color(COLOR::RED),
                leftSubTree(nullptr),
                rightSubTree(nullptr),
                parent(nullptr) { }; 

            //获取父节点指针
            inline Node * getParent() {
                return parent;
            }

            //获取祖父节点指针
            inline Node * getGrandParent() { 
                if(parent == nullptr) return nullptr;
                else return parent->parent;
            }

            //获取叔叔节点指针
            inline Node * getUncle() {
                Node* __gp = this->getGrandParent();
                if(__gp == nullptr) return nullptr;
                else if(parent == __gp->rightSubTree) return __gp->leftSubTree;
                else return __gp->rightSubTree;
            }

            //获取兄弟节点指针
            inline Node * getSibling(){
                if(parent == nullptr) return nullptr;
                else if(parent->leftSubTree == this) return parent->rightSubTree;
                else return parent->leftSubTree;
            }

        };
    
        class iterator{
        friend RBtree;
        protected:
            Node * ptr;
            Node * NIL;

            void loop2Begin() {
                if(ptr == NIL){ptr = nullptr;return;}
                while(ptr->leftSubTree != NIL) ptr = ptr->leftSubTree;
            }

            void loop2End() {
                if(ptr == NIL){ptr = nullptr;return;}
                if(ptr->parent == nullptr){ ptr = nullptr;return;}
                while(ptr->parent->leftSubTree != ptr) {
                    ptr = ptr->parent;
                    if(ptr->parent == nullptr){ ptr = nullptr;return;}
                }
                ptr = ptr->parent;
            }

            void getNextNode() {
                if(ptr->rightSubTree != NIL){
                    ptr = ptr->rightSubTree;
                    loop2Begin();
                } else {
                    loop2End();
                }
            }

        public:
            iterator(Node * _ptr,Node * _NIL) {
                ptr = _ptr;
                NIL = _NIL;
            }

            const VALUE_TYPE & operator*()
            {
                return ptr->value;
            }

            VALUE_TYPE *operator->() //?
            {
                return ptr;
            }

             myDS::RBtree<VALUE_TYPE>::iterator operator++() {
                auto old = *this;
                getNextNode();
                return old;
            }

             myDS::RBtree<VALUE_TYPE>::iterator operator++(int) {
                getNextNode();
                return (*this);
            }

            bool operator==( myDS::RBtree<VALUE_TYPE>::iterator _b) {
                return ptr == _b.ptr;
            }

            bool operator!=( myDS::RBtree<VALUE_TYPE>::iterator _b) {
                return ptr != _b.ptr;
            }
        };

    public:
        //树结构
        Node *root, *NIL;
        
        RBtree() {
            NIL = new Node();
            NIL->color = COLOR::BLACK;
            root = nullptr;
        };

        ~RBtree(){
            auto DeleteSubTree = [&](auto self,Node *p) -> void{
                if(p == nullptr || p == NIL) return;
                self(self,p->leftSubTree);
                self(self,p->rightSubTree);
                delete p;
                return;
            };
            if(!(root == nullptr)) DeleteSubTree(DeleteSubTree,root);
            delete NIL;
        }

        void insert(VALUE_TYPE data) {
            if(root == nullptr) {
                root = new Node();
                root->color = COLOR::BLACK;
                root->leftSubTree = NIL;
                root->rightSubTree = NIL;
                root->value = data;
            } else {
                if(this->locate(data,root)) return;
                subInsert(root,data);
            }
        }

        VALUE_TYPE find(VALUE_TYPE tar) {
            if(locate(tar,root) != nullptr) return locate(tar,root)->value;
            else return -1;
        }

        bool erase(VALUE_TYPE data) {
            return subDelete(root,data); 
        }

         myDS::RBtree<VALUE_TYPE>::iterator begin(){ 
            auto rt = iterator(root,NIL);
            rt.loop2Begin();
            return rt;
        }

         myDS::RBtree<VALUE_TYPE>::iterator end(){
            return iterator(nullptr,NIL);
        }

#ifdef __PRIVATE_DEBUGE
        void printDfsOrder()
        {
            auto dfs = [&](auto self,Node * p ) -> void {
                if(p == nullptr){ std::cout << "ED\n";return;}
                if(p->leftSubTree == nullptr && p->rightSubTree == nullptr) {std::cout << "[NIL] \n";return;}
                std::cout << "["<< p->value << " : " << (p->color == COLOR::BLACK ?"BLACK":"RED") << "] ";
                self(self,p->leftSubTree);
                self(self,p->rightSubTree);
                return;
            };
            dfs(dfs,root);
        }

        vector<int> printList;
        void printIterOrder()
        {
            auto dfs = [&](auto self,Node * p) -> void{
                if(p->leftSubTree == nullptr && p->rightSubTree == nullptr) {std::cout << "[NIL] \n";return;}
                self(self,p->leftSubTree);
                std::cout << "["<< p->value << " : " << (p->color == COLOR::BLACK ?"BLACK":"RED") << "] ";
                self(self,p->rightSubTree);
            };
            dfs(dfs,root);
        }
#endif
    private:
        Node * locate(VALUE_TYPE t,Node * p) {
            if(p == NIL) return nullptr;
            else if(p->value == t) return p;
            else if(p->value > t) return locate(t,p->leftSubTree);
            else return locate(t,p->rightSubTree);
        }

        //右旋某个节点
        void rotateRight(Node *p)
        {
            Node * _gp = p->getGrandParent();
            Node * _pa = p->getParent();
            Node * _rotY = p->rightSubTree;
            _pa->leftSubTree = _rotY;
            if(_rotY != NIL) _rotY->parent = _pa;
            p->rightSubTree = _pa;
            _pa->parent = p;

            if(root == _pa) root = p;
            p->parent = _gp;
            if(_gp != nullptr) if(_gp->leftSubTree == _pa) _gp->leftSubTree = p;
                else _gp->rightSubTree = p;
            return;
        }

        //左旋某个节点
        void rotateLeft(Node *p)
        {
            if(p->parent == nullptr){
                root = p;
                return;
            }
            Node *_gp = p->getGrandParent();
            Node *_pa = p->parent;
            Node *_rotX = p->leftSubTree;
            
#ifdef __DETIL_DEBUG_OUTPUT
            printIterOrder();
#endif
            _pa->rightSubTree = _rotX;

#ifdef __DETIL_DEBUG_OUTPUT
            printIterOrder();
#endif

            if(_rotX != NIL)
                _rotX->parent = _pa;

#ifdef __DETIL_DEBUG_OUTPUT
            printIterOrder();
#endif
            p->leftSubTree = _pa;
#ifdef __DETIL_DEBUG_OUTPUT
            printIterOrder();
#endif
            _pa->parent = p;
#ifdef __DETIL_DEBUG_OUTPUT
            printIterOrder();
#endif
            if(root == _pa)
                root = p;
            p->parent = _gp;

#ifdef __DETIL_DEBUG_OUTPUT
            printIterOrder();
#endif
            if(_gp != nullptr){
                if(_gp->leftSubTree == _pa)
                    _gp->leftSubTree = p;
                else
                    _gp->rightSubTree = p; //?!
            }
#ifdef __DETIL_DEBUG_OUTPUT
            printIterOrder();
#endif
        }

        //插入节点递归部分
        void subInsert(Node *p,VALUE_TYPE data)
        {
            if(p->value >= data){ //1 2
                if(p->leftSubTree != NIL) //3
                    subInsert(p->leftSubTree, data);
                else {
                    Node *tmp = new Node();//3
                    tmp->value = data;
                    tmp->leftSubTree = tmp->rightSubTree = NIL;
                    tmp->parent = p;
                    p->leftSubTree = tmp;
                    resetStatus_forInsert(tmp);
                }
            } else {
                if(p->rightSubTree != NIL) //1 2
                    subInsert(p->rightSubTree, data);
                else {
                    Node *tmp = new Node();
                    tmp->value = data;
                    tmp->leftSubTree = tmp->rightSubTree = NIL;
                    tmp->parent = p;
                    p->rightSubTree = tmp;
                    resetStatus_forInsert(tmp);
                }
            }
        }

        //插入后的平衡维护
        void resetStatus_forInsert(Node *p) {
            //case 1:
            if(p->parent == nullptr){
                root = p;
                p->color = COLOR::BLACK;
                return;
            }
            //case 2-6:
            if(p->parent->color == COLOR::RED){
                //case 2: pass
                if(p->getUncle()->color == COLOR::RED) {
                    p->parent->color = p->getUncle()->color = COLOR::BLACK;
                    p->getGrandParent()->color = COLOR::RED;
                    resetStatus_forInsert(p->getGrandParent());
                } else {
                    if(p->parent->rightSubTree == p && p->getGrandParent()->leftSubTree == p->parent) {
                        //case 3:
                        rotateLeft(p);
                        p->color = COLOR::BLACK;
                        p->parent->color = COLOR::RED;
                        rotateRight(p);
                    } else if(p->parent->leftSubTree == p && p->getGrandParent()->rightSubTree == p->parent) {  //this
                        //case 4:
                        rotateRight(p);
                        p->color = COLOR::BLACK;
                        p->parent->color = COLOR::RED;
                        rotateLeft(p);
                    } else if(p->parent->leftSubTree == p && p->getGrandParent()->leftSubTree == p->parent) {
                        //case 5:
                        p->parent->color = COLOR::BLACK;
                        p->getGrandParent()->color = COLOR::RED;
                        rotateRight(p->parent);
                    } else if(p->parent->rightSubTree == p && p->getGrandParent()->rightSubTree == p->parent) {
                        //case 6: BUG HERE
                        p->parent->color = COLOR::BLACK;
                        p->getGrandParent()->color = COLOR::RED;
                        rotateLeft(p->parent);
                    }
                }
            }
        }

        //删除时的递归部分
        bool subDelete(Node *p, VALUE_TYPE data){

            //获取最接近叶节点的儿子
            auto getLowwestChild = [&](auto self,Node *p) -> Node*{
                if(p->leftSubTree == NIL) return p;
                return self(self,p->leftSubTree);
            };

            if(p->value > data){
                if(p->leftSubTree == NIL){
                    return false;
                }
                return subDelete(p->leftSubTree, data);
            } else if(p->value < data){
                if(p->rightSubTree == NIL){
                    return false;
                }
                return subDelete(p->rightSubTree, data);
            } else if(p->value == data){
                if(p->rightSubTree == NIL){
                    deleteChild(p);
                    return true;
                }
                Node *smallChild = getLowwestChild(getLowwestChild,p->rightSubTree);
                std::swap(p->value, smallChild->value);
                deleteChild(smallChild);

                return true;
            }else{
            return false;
            }
        }

    //     //删除入口
    //     bool deleteChild(Node *p, int data){
    //     if(p->value > data){
    //         if(p->leftSubTree == NIL){
    //             return false;
    //         }
    //         return deleteChild(p->leftSubTree, data);
    //     } else if(p->value < data){
    //         if(p->rightSubTree == NIL){
    //             return false;
    //         }
    //         return deleteChild(p->rightSubTree, data);
    //     } else if(p->value == data){
    //         if(p->rightSubTree == NIL){
    //             delete_one_child (p);
    //             return true;
    //         }
    //         Node *smallest = getSmallestChild(p->rightTree);
    //         swap(p->value, smallest->value);
    //         delete_one_child (smallest);

    //         return true;
    //     }else{
    //        return false;
    //      }
    // }

        //删除处理：删除某个儿子
        void deleteChild(Node *p){
            Node *child = p->leftSubTree == NIL ? p->rightSubTree : p->leftSubTree;
            if(p->parent == nullptr && p->leftSubTree == NIL && p->rightSubTree == NIL){
                p = nullptr;
                root = p;
                return;
            }
            if(p->parent == nullptr){
                delete  p;
                child->parent = nullptr;
                root = child;
                root->color = COLOR::BLACK;
                return;
            }
            if(p->parent->leftSubTree == p) p->parent->leftSubTree = child;
            else p->parent->rightSubTree = child;

            child->parent = p->parent;
            if(p->color == COLOR::BLACK){
                if(child->color == COLOR::RED){
                    child->color = COLOR::BLACK;
                } else
                    resetStatus_forDelete(child);
            }

            delete p;
        }

        //删除后的平衡维护
        void resetStatus_forDelete(Node *p){
            if(p->parent == nullptr){
                //case 0-0:
                p->color = COLOR::BLACK;
                return;
            }
            if(p->getSibling()->color == COLOR::RED) {
                //case 0-1:
                p->parent->color = COLOR::RED;
                p->getSibling()->color = COLOR::BLACK;
                if(p == p->parent->leftSubTree) rotateLeft(p->parent);
                else rotateRight(p->parent);
            }
            if( p->parent->color == COLOR::BLACK &&
                p->getSibling()->color == COLOR::BLACK &&
                p->getSibling()->leftSubTree->color == COLOR::BLACK && 
                p->getSibling()->rightSubTree->color == COLOR::BLACK) {
                //case 1-1:
                p->getSibling()->color = COLOR::RED;
                resetStatus_forDelete(p->parent);
            } else if(p->parent->color == COLOR::RED && p->getSibling()->color == COLOR::BLACK&& p->getSibling()->leftSubTree->color == COLOR::BLACK && p->getSibling()->rightSubTree->color == COLOR::BLACK) {
                //case 1-2:
                p->getSibling()->color = COLOR::RED;
                p->parent->color = COLOR::BLACK;
            } else {
                if(p->getSibling()->color == COLOR::BLACK) {
                    if(p == p->parent->leftSubTree && p->getSibling()->leftSubTree->color == COLOR::RED && p->getSibling()->rightSubTree->color == COLOR::BLACK) {
                        //case 1-3:
                        p->getSibling()->color = COLOR::RED;
                        p->getSibling()->leftSubTree->color = COLOR::BLACK;
                        rotateRight(p->getSibling()->leftSubTree);
                    } else if(p == p->parent->rightSubTree && p->getSibling()->leftSubTree->color == COLOR::BLACK && p->getSibling()->rightSubTree->color == COLOR::RED) {
                        //case 1-4:
                        p->getSibling()->color = COLOR::RED;
                        p->getSibling()->rightSubTree->color = COLOR::BLACK;
                        rotateLeft(p->getSibling()->rightSubTree);
                    }
                }
                p->getSibling()->color = p->parent->color;
                p->parent->color = COLOR::BLACK;
                //case 1-5:
                if(p == p->parent->leftSubTree){
                    //case 0-3
                    p->getSibling()->rightSubTree->color = COLOR::BLACK;
                    rotateLeft(p->getSibling());
                } else {
                    //case 0-4
                    p->getSibling()->leftSubTree->color = COLOR::BLACK;
                    rotateRight(p->getSibling());
                }
            }
        }


    };
} // namespace myDS
#endif

```]
== `_PRIV_TEST.cpp`
#sourcecode[```cpp
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
            

}

```]



= 测试数据与运行结果

运行上述`_PRIV_TEST.cpp`测试代码中的正确性测试模块，得到以下内容：

```
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


i 1
i 2
i 3
i 5
i 4
p
===DFS  Order===
[2 : BLACK] [1 : BLACK] [NIL]
[NIL]
[4 : BLACK] [3 : RED] [NIL]
[NIL]
[5 : RED] [NIL]
[NIL]
===Iter Order===
[NIL]
[1 : BLACK] [NIL]
[2 : BLACK] [NIL]
[3 : RED] [NIL]
[4 : BLACK] [NIL]
[5 : RED] [NIL]
===Use  Bg Ed===
1 2 3 4 5

```

可以看出，代码运行结果与预期相符，可以认为代码正确性无误。

运行`_PRIV_TEST.cpp`中的内存测试模块，在保持CPU高占用率运行一段时间后内存变化符合预期，可以认为代码内存安全性良好。

#image("03.png")