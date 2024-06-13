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
                VALUE value;
                COLOR color;
                Node *leftSubTree,  //左子树根节点指针
                     *rightSubTree, //右子树根节点指针
                     *parent;       //父亲节点指针
                
                constexpr Node() : 
                    value(VALUE()), 
                    color(COLOR::RED),
                    leftSubTree(nullptr),
                    rightSubTree(nullptr),
                    parent(nullptr) { }; 
            }
    };
} // namespace myDS
#endif
