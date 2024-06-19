// #define _PRIVATE_DEBUG
#ifndef LINKED_LIST_HPP
#define LINKED_LIST_HPP

#ifdef _PRIVATE_DEBUG
#include <iostream>
#endif

namespace myDS
{
    template<typename VALUE_TYPE>
    class linkedList{
    protected: 
        class linkedNode {
        public:
            VALUE_TYPE data = VALUE_TYPE();
            linkedNode * next = nullptr;
            linkedNode * priv = nullptr;

            linkedNode() { }

            linkedNode(VALUE_TYPE _data){
                next = nullptr;
                priv = nullptr;
                data = _data;
            }

            linkedNode(VALUE_TYPE _data,linkedNode * priv)
            {
                next = nullptr;
                priv = priv;
                data = _data;
            }

            ~linkedNode() {
    #ifdef _PRIVATE_DEBUG
            if(this->next != nullptr)
                std::cout << "Unexpected Delete at :" << this->data
                        << " with next:" << this->next->data << "\n";
    #endif
            }

            linkedNode *  linkNext(linkedNode * _next)
            { 
                next = _next;
                _next->priv = this;
                return this->next;
            }
            linkedNode *  linkPriv(linkedNode * _priv)
            { 
                priv = _priv;
                _priv->next = this;
                return this->priv;
            }

            void insertNext(linkedNode * _inst){
                if(_inst == nullptr) return;
                if(this->next == nullptr) linkNext(_inst);
                else {
                    _inst->next = this->next;  
                    this->next->priv = _inst;
                    _inst->priv = this;
                    this->next = _inst;
                }
            }

            void deleteNext()
            {
                if(this->next == nullptr) return;
                else {
                    linkedNode * tmp = this->next;
                    this->next = this->next->next;
                    this->next->priv = this;
                    tmp->next = nullptr;
                    delete tmp;
                }
            }
        };

    private:
        class _iterator 
        {
        private:
            linkedNode *_ptr;

        public:
            enum __iter_dest_type
            {
                front,
                back
            };
            __iter_dest_type _iter_dest;
            
            _iterator(linkedNode * _upper ,__iter_dest_type _d)
            {
                _ptr = _upper;
                _iter_dest = _d;      
            }

            VALUE_TYPE & operator*()
            {
                return _ptr->data;
            }

            VALUE_TYPE *operator->()
            {
                return _ptr;
            }

            myDS::linkedList<VALUE_TYPE>::_iterator operator++()
            {
                if (_iter_dest == front)
                    _ptr = _ptr->next;
                else
                    _ptr = _ptr->priv;
                return *this;
            }

            myDS::linkedList<VALUE_TYPE>::_iterator operator++(int)
            {
                myDS::linkedList<VALUE_TYPE>::_iterator old = *this;
                if (_iter_dest == front)
                    _ptr = _ptr->next;
                else
                    _ptr = _ptr->priv;
                return old;
            }

            // myDS::linkedList<VALUE_TYPE>::_iterator operator+(size_t _n)
            // {
            //     if (_iter_dest == front)
            //         _upper_idx += _n;
            //     else
            //         _upper_idx -= _n;
            //     _ptr = &((*_upper_pointer)[_upper_idx]);
            //     return *this;
            // }

            bool operator==(myDS::linkedList<VALUE_TYPE>::_iterator _b)
            {
                if (&(*_b) == _ptr)
                    return 1;
                else
                    return 0;
            }

            bool operator!=(myDS::linkedList<VALUE_TYPE>::_iterator _b)
            {
                if (&(*_b) == &(_ptr->data))
                    return 0;
                else
                    return 1;
            }
        };

        linkedNode * head = new linkedNode();
        linkedNode * tail = new linkedNode();
        int cap = 0;

    public:
        linkedList(){
            head->linkNext(tail);
        }

        ~linkedList(){
            clear();
            delete head;
            delete tail;
        }

        void push_back(VALUE_TYPE t) {
            tail->data = t;
            tail->linkNext(new linkedNode());
            tail = tail->next;
            cap ++;
        }

        void push_frount(VALUE_TYPE t) {
            head->data = t;
            head = (head->linkPriv(new linkedNode()));
            cap ++;
        }

        void clear() {
            linkedNode * deletingObject;
            while(tail->priv != head) {
                deletingObject = tail;
                tail = tail->priv;
                delete deletingObject;
            }
            cap = 0;
            tail = new linkedNode();
            head = new linkedNode();
            head->linkNext(tail);
        }

        std::size_t erase(VALUE_TYPE p) {
            linkedNode * ptr = head;
            int ttl = 0;
            while(ptr->next != tail) {
                if(ptr->next->data == p){
                    ptr->deleteNext();
                    ttl ++;
                } else ptr = ptr->next;
            }
            cap -= ttl;
            return ttl;
        }

        std::size_t size() {return cap;}

        bool erase(linkedList<VALUE_TYPE>::_iterator p) {
            myDS::linkedList<VALUE_TYPE>::_iterator ptr = this->begin();
            linkedNode * cur = head;
            while(ptr != p) {
                cur = cur->next;
                ptr ++;
                if(cur == tail) return 0;
            }
            cur->deleteNext();
            cap --;
            return 1;
        }

        myDS::linkedList<VALUE_TYPE>::_iterator begin() {
            enum myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type _FRONT = myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type::front;
            return myDS::linkedList<VALUE_TYPE>::_iterator(head->next,_FRONT);
        }
        
        myDS::linkedList<VALUE_TYPE>::_iterator rbegin() {
            enum myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type _BACK = myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type::back;
            return myDS::linkedList<VALUE_TYPE>::_iterator(tail->priv,_BACK);
        }

        myDS::linkedList<VALUE_TYPE>::_iterator end() {
            enum myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type _FRONT = myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type::front;
            return myDS::linkedList<VALUE_TYPE>::_iterator(tail,_FRONT);
        }

        myDS::linkedList<VALUE_TYPE>::_iterator rend() {
            enum myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type _BACK = myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type::back;
            return myDS::linkedList<VALUE_TYPE>::_iterator(head,_BACK);
        }

        myDS::linkedList<VALUE_TYPE>::_iterator get(std::size_t p) {
            linkedNode * ptr = head->next;
            while(p --) ptr = ptr->next;
            enum myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type _FRONT = myDS::linkedList<VALUE_TYPE>::_iterator::__iter_dest_type::front;
            return myDS::linkedList<VALUE_TYPE>::_iterator(ptr,_FRONT);
        }

        VALUE_TYPE & operator[](std::size_t p) {
            linkedNode * ptr = head;
            while(p --) ptr = ptr->next;
            return ptr->next->data;
        }
 
#ifdef _PRIVATE_DEBUG
        void innerPrint()
        {
            std::cout << "--Header[" << head << "]: " << head->data << "\n";
            std::cout << "--Tail[" << tail << "]: " << tail->data << "\n";
            std::cout << "-----------\n";
            std::cout << "cur:" << cap<< "\n";
            auto ptr = head;
            do {
                std::cout << "[" << ptr << "] ->next:" << ptr->next << " ->priv:" << ptr->priv << " ||data:" << ptr->data << "\n";
                ptr = ptr->next;
            }while(ptr != nullptr);
        }
#endif
 
    };
}
#endif