#ifndef RBTREE_MAP_HPP
#define RBTREE_MAP_HPP


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
            
            explicit Node() : //构造函数
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
    
    public:
        //树结构
        Node *root, *NIL;
        
        //构造函数
        explicit RBtree() {
            NIL = new Node();
            NIL->color = COLOR::BLACK;
            root = nullptr;
        };

        //析构函数
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
            } else subInsert(root,data);
        }

        bool erase(VALUE_TYPE data) {
            return deleteChild(root,data); 
        }

    private:
        //右旋某个节点
        void rotateRight(Node *p)
        {
            Node * _gp = p->getGrandParent();
            Node * _pa = p->getParent();
            Node * _rotY = p->rightSubTree;
            _pa->leftSubTree = _rotY;
            if(_rotY != NIL) _rotY->parent = _pa;
            p->parent = _pa;
            _pa->parent = p;

            if(root == _pa) root = p;
            p->parent = _gp;
            if(_gp != nullptr) if(_gp->leftSubTree == _pa) _gp->leftSubTree = p;
                else _gp->leftSubTree = p;
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
            Node *_pa = p->getParent();
            Node *_rotX = p->leftSubTree;
            _pa->rightSubTree = _rotX;
            if(_rotX != NIL)
                _rotX->parent = _pa;
            p->leftSubTree = _pa;
            _pa->parent = p;

            if(root == _pa)
                root = p;
            p->parent = _gp;

            if(_gp != nullptr){
                if(_gp->leftSubTree == _pa)
                    _gp->leftSubTree = p;
                else
                    _gp->leftSubTree = p;
            }
        }

        //插入节点递归部分
        void subInsert(Node *p,VALUE_TYPE data)
        {
            if(p->value >= data){
            if(p->leftSubTree != NIL)
                subInsert(p->leftSubTree, data);
            else {
                Node *tmp = new Node();
                tmp->value = data;
                tmp->leftSubTree = tmp->rightSubTree = NIL;
                tmp->parent = p;
                p->leftSubTree = tmp;
                resetStatus_forInsert(tmp);
            }
            } else {
                if(p->rightSubTree != NIL)
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
                //case 2:
                if(p->uncle()->color == COLOR::RED) {
                    p->parent->color = p->uncle()->color = COLOR::BLACK;
                    p->getGrandParent()->color = COLOR::RED;
                    insert_case(p->getGrandParent());
                } else {
                    if(p->parent->rightSubTree == p && p->getGrandParent()->leftSubTree == p->parent) {
                        //case 3:
                        rotate_left(p);
                        p->color = COLOR::BLACK;
                        p->parent->color = COLOR::RED;
                        rotate_right(p);
                    } else if(p->parent->leftSubTree == p && p->getGrandParent()->rightSubTree == p->parent) {
                        //case 4:
                        rotate_right(p);
                        p->color = COLOR::BLACK;
                        p->parent->color = COLOR::RED;
                        rotate_left(p);
                    } else if(p->parent->leftSubTree == p && p->getGrandParent()->leftSubTree == p->parent) {
                        //case 5:
                        p->parent->color = COLOR::BLACK;
                        p->getGrandParent()->color = COLOR::RED;
                        rotate_right(p->parent);
                    } else if(p->parent->rightSubTree == p && p->getGrandParent()->rightSubTree == p->parent) {
                        //case 6:
                        p->parent->color = COLOR::BLACK;
                        p->getGrandParent()->color = COLOR::RED;
                        rotate_left(p->parent);
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
                swap(p->value, smallChild->value);
                deleteChild(smallChild);

                return true;
            }else{
            return false;
            }
        }

        //删除入口：删除某个儿子
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
            if(p->sibling()->color == COLOR::RED) {
                //case 0-1:
                p->parent->color = COLOR::RED;
                p->sibling()->color = COLOR::BLACK;
                if(p == p->parent->leftSubTree) rotate_left(p->parent);
                else rotate_right(p->parent);
            }
            if( p->parent->color == COLOR::BLACK &&
                p->sibling()->color == COLOR::BLACK &&
                p->sibling()->leftSubTree->color == COLOR::BLACK && 
                p->sibling()->rightSubTree->color == COLOR::BLACK) {
                //case 1-1:
                p->sibling()->color = COLOR::RED;
                resetStatus_forDelete(p->parent);
            } else if(p->parent->color == COLOR::RED && p->sibling()->color == COLOR::BLACK&& p->sibling()->leftSubTree->color == COLOR::BLACK && p->sibling()->rightSubTree->color == COLOR::BLACK) {
                //case 1-2:
                p->sibling()->color = COLOR::RED;
                p->parent->color = COLOR::BLACK;
            } else {
                if(p->sibling()->color == COLOR::BLACK) {
                    if(p == p->parent->leftSubTree && p->sibling()->leftSubTree->color == COLOR::RED && p->sibling()->rightSubTree->color == COLOR::BLACK) {
                        //case 1-3:
                        p->sibling()->color = COLOR::RED;
                        p->sibling()->leftSubTree->color = COLOR::BLACK;
                        rotate_right(p->sibling()->leftSubTree);
                    } else if(p == p->parent->rightSubTree && p->sibling()->leftSubTree->color == COLOR::BLACK && p->sibling()->rightSubTree->color == COLOR::RED) {
                        //case 1-4:
                        p->sibling()->color = COLOR::RED;
                        p->sibling()->rightSubTree->color = COLOR::BLACK;
                        rotate_left(p->sibling()->rightSubTree);
                    }
                }
                p->sibling()->color = p->parent->color;
                p->parent->color = COLOR::BLACK;
                //case 1-5:
                if(p == p->parent->leftSubTree){
                    //case 0-3
                    p->sibling()->rightSubTree->color = COLOR::BLACK;
                    rotate_left(p->sibling());
                } else {
                    //case 0-4
                    p->sibling()->leftSubTree->color = COLOR::BLACK;
                    rotate_right(p->sibling());
                }
            }
        }


    };
} // namespace myDS
#endif
