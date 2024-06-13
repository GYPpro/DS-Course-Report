#ifndef RBTREE_MAP_HPP
#define RBTREE_MAP_HPP


#include <vector>
#include <stdlib.h>
#include "Dev\02\myVector.h"

using std::vector;


namespace myDS
{
    template <typename VALUE>
    class RBtree{
    private:
        using int size_t;
        enum COLOR {RED,BLACK};

        protected:
            class Node{
            public:
                VALUE value;
                COLOR color;
                Node *leftSubTree,  //左子树根节点指针
                     *rightSubTree, //右子树根节点指针
                     *parent;       //父亲节点指针
                
                constexpr Node() : //构造函数
                    value(VALUE()), 
                    color(COLOR::RED),
                    leftSubTree(nullptr),
                    rightSubTree(nullptr),
                    parent(nullptr) { }; 

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
        
    };
} // namespace myDS
#endif
