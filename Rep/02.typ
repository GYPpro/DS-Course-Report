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
// #set raw(align: center)
#show raw: set text(
    font: ("consolas", "Source Han Serif SC")
  )
#set page(
  // flipped: true,
  paper: "a4",
//   background: [#image("background.png")]
)
#set text(
    font:("Times New Roman","Source Han Serif SC"),
    style:"normal",
    weight: "regular",
    size: 13pt,
)

#let nxtIdx(name) = box[ #counter(name).step()#counter(name).display()]

// Display block code in a larger block
// // with more padding.
// #show raw.where(block: true): block.with(
//   fill: luma(230),
//   inset: 7pt,
//   radius: 4pt,
// )
#set par(
  // first-line-indent: 1cm
)
#set math.equation(numbering: "(1)")



// Display block code in a larger block
// with more padding.
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

= 基于增长数组的`vector`
\
#text(
  font:"KaiTi",
  size: 15pt
)[
课程名称#underline[#text("      数据结构      ")]成绩评定#underline[#text("       ")]\
实验项目名称#underline[#text(" ") 基于增长数组的`vector` #text(" ")]指导老师#underline[#text("   干晓聪   ")]\
实验项目编号#underline[#text("  02  ")]实验项目类型#underline[#text("  设计性  ")]实验地点#underline[#text(" 数学系机房 ")]\
学生姓名#underline[#text("   郭彦培   ")]学号#underline[#text("   2022101149   ")]\
学院#underline[#text(" 信息科学技术学院 ")]系#underline[#text(" 数学系 ")]专业#underline[#text(" 信息管理与信息系统 ")]\
实验时间#underline[#text(" 2024年6月13日上午 ")]#text("~")#underline[#text("  2024年7月13日中午  ")]\
]
#set heading(
  numbering: "1.1."
  )
  

= 实验目的
\
#h(1.8em)

实现基于增长数组的类STL `vector`类，提供尾端插入与随机访问和迭代器。

= 实验环境
\
#h(1.8em)计算机：PC X64

操作系统：Windows + Ubuntu20.0LTS

编程语言：C++：GCC std20

IDE：Visual Studio Code


= 程序原理

增长数组会周期性的申请连续的内存，并将以往的数据移动到新申请的内存中。其倍增的特性保证了其均摊的插入复杂度在$OO(1)$，其连续的性质保证了随机访问的速度。

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


```
== `myVector.h`
```cpp


#ifndef PRVLIBCPP_VECTOR_HPP
#define PRVLIBCPP_VECTOR_HPP

#include <new>
#include <cstddef>
#include <type_traits>
#include <string.h>

namespace myDS
{

    const size_t _EXPENSION_RATIO = 2;
    const size_t _INITIAL_SIZE = 16;

    template <typename TYPE_NAME>
    class vector
    {
    private:
        std::size_t _size;
        std::size_t _max_cap;
        TYPE_NAME *_begin = nullptr;
        TYPE_NAME *_push_back_idx = _begin;

        class _iterator
        {
        private:
            TYPE_NAME *_ptr;
             myDS::vector<TYPE_NAME> * _upper_pointer;
            size_t _upper_idx;

        public:
            enum __iter_dest_type
            {
                front,
                back
            };
            __iter_dest_type _iter_dest;
            
            _iterator( myDS::vector<TYPE_NAME> *_upper, size_t _n, __iter_dest_type _d)
            {
                _upper_idx = _n;
                _upper_pointer = _upper;
                _ptr = &(*_upper_pointer)[_n];        
                _iter_dest = _d;      
            }

            TYPE_NAME & operator*()
            {
                return (*_ptr);
            }

            TYPE_NAME *operator->()
            {
                return _ptr;
            }

             myDS::vector<TYPE_NAME>::_iterator operator++()
            {
                if (_iter_dest == front)
                    _upper_idx++;
                else
                    _upper_idx--;
                _ptr = &((*_upper_pointer)[_upper_idx]);
                return *this;
            }

             myDS::vector<TYPE_NAME>::_iterator operator++(int)
            {
                 myDS::vector<TYPE_NAME>::_iterator old = *this;
                if (_iter_dest == front)
                    _upper_idx++;
                else
                    _upper_idx--;
                _ptr = &((*_upper_pointer)[_upper_idx]);
                return old;
            }

             myDS::vector<TYPE_NAME>::_iterator operator+(size_t _n)
            {
                if (_iter_dest == front)
                    _upper_idx += _n;
                else
                    _upper_idx -= _n;
                _ptr = &((*_upper_pointer)[_upper_idx]);
                return *this;
            }

            bool operator==( myDS::vector<TYPE_NAME>::_iterator _b)
            {
                if (&(*_b) == _ptr)
                    return 1;
                else
                    return 0;
            }

            bool operator!=( myDS::vector<TYPE_NAME>::_iterator _b)
            {
                if (&(*_b) == _ptr)
                    return 0;
                else
                    return 1;
            }
        };

    private:
        void _expension()
        {
            if (_max_cap == 0)
            {
                if(_begin)
                    ::operator delete[](_begin);
                _begin = new TYPE_NAME[_INITIAL_SIZE];
                _max_cap = _INITIAL_SIZE;
            }
            else
            {
                TYPE_NAME *_next_begin = new TYPE_NAME[_EXPENSION_RATIO * (std::size_t)_max_cap];
                // for (std::size_t i = 0; i < _size; i++)
                //     _next_begin[i] = _begin[i];
                memcpy(_next_begin,_begin,_size*sizeof(TYPE_NAME));
                // for(TYPE_NAME * __ptr = _begin;__ptr != _begin + _max_cap;__ptr ++)
                    // __ptr->~TYPE_NAME();
                delete[] _begin;
                _max_cap *= _EXPENSION_RATIO;
                _begin = _next_begin;
            }
            _push_back_idx = _begin + _size;
        }

    public:
        vector() {
            _size = 0;
            _max_cap = 0;
            _push_back_idx = _begin + _size;
        }

        vector(std::size_t _n) 
        {
            _size = 0;
            _max_cap = 0;
            resize(_n);
            _push_back_idx = _begin + _size;
        }

        // FIXME:
        vector(std::size_t _n, TYPE_NAME _init_value)
        {
            _begin = new TYPE_NAME[_n];
            _size = _n;
            _max_cap = _n;
            _push_back_idx = _n;
            for (std::size_t i = 0; i < _push_back_idx; i++)
                _begin[i] = _init_value;
        }

        vector( myDS::vector<TYPE_NAME> &_b)
        {
            for (auto x : _b)
                this->push_back(x);
        }

        void resize(size_t _n)
        {
            if(_n > _size)
                for(int __i = 0;__i < _n;__i++)
                {
                    if(_size + 1 >= _max_cap)
                        _expension();
                    _size ++;
                    _push_back_idx ++;
                }
            _size = _n;
            _push_back_idx = _begin + _size;
        }

        void push_back(const TYPE_NAME &__tmp)
        {
            if(_size + 1 >= _max_cap)
                _expension();   
            memcpy(_push_back_idx,&__tmp,sizeof(TYPE_NAME));
            _push_back_idx++;
            _size++;
        }

        void clear()
        {
            this->resize(0);
        }

        vector<TYPE_NAME>::_iterator begin()
        {
            enum  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s =  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::front;
            return  myDS::vector<TYPE_NAME>::_iterator(this, 0,s);
        }

         myDS::vector<TYPE_NAME>::_iterator rbegin()
        {
            enum  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s =  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::back;
            return  myDS::vector<TYPE_NAME>::_iterator(this, _size - 1,s);
        }

         myDS::vector<TYPE_NAME>::_iterator end()
        {
            enum  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s =  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::front;
            return  myDS::vector<TYPE_NAME>::_iterator(this,_size,s);
        }

         myDS::vector<TYPE_NAME>::_iterator rend()
        {
            enum  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type s =  myDS::vector<TYPE_NAME>::_iterator::__iter_dest_type::back;
            return  myDS::vector<TYPE_NAME>::_iterator(this, 0, s);
        }

        TYPE_NAME at(std::size_t _n)
        {
            return _begin[_n];
        }

        std::size_t size()
        {
            return _size;
        }

        bool equal( myDS::vector<TYPE_NAME> _b)
        {
            for (int i = 0; i < _size; i++)
                if (_b[i] != _begin[i])
                    return false;
            return true;
        }

        TYPE_NAME &operator[](std::size_t _n)
        {
            return _begin[_n];
        }

         myDS::vector<TYPE_NAME> &operator=( myDS::vector<TYPE_NAME> _b)
        {
            this->resize(0);
            for(auto __x:_b) this->push_back(__x);
            
        }

         myDS::vector<TYPE_NAME> &operator+( myDS::vector<TYPE_NAME> _b)
        {
            for (auto x : _b)
                this->push_back(x);
        }

        ~vector()
        {
            if(_begin)
                delete[] _begin;
        }
    };
} // namespace myDS

#endif

```]
== `_PRIV_TEST.cpp`
#sourcecode[```cpp
#define DS_TOBE_TEST vector

#define _PRIVATE_DEBUG

#include "Dev\02\myVector.h"

#include <iostream>
#include <math.h>
#include <vector>

using namespace std;

using TBT =  myDS::DS_TOBE_TEST<int>;

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
        // } else if(op == "pf")//push_frount
        // {
        //     int c;
        //     cin >> c;
        //     tc.push_frount(c);
        } else if(op == "at")//随机访问
        {
            int p;
            cin >> p;
            cout << tc[p] << "\n";
        // } else if(op == "delEL")//删除所有等于某值元素
        // {
        //     int p;
        //     cin >> p;
        //     cout << tc.erase(p) << "\n";
        // } else if(op == "delPS")//删除某位置上的元素
        // {
        //     int p;
        //     cin >> p;
        //     cout << tc.erase(tc.get(p)) << "\n";
        } else if(op == "iterF") //正序遍历
        {
            // tc.innerPrint();
            cout << "Iter with index:\n";
            for(int i = 0;i < tc.size();i ++) cout << tc[i] << " ";cout << "\n";
            cout << "Iter with begin end\n";
            for(auto x = tc.begin();x != tc.end();x ++) cout << (*x) << " ";cout << "\n";
            cout << "Iter with AUTO&&\n";
            for(auto x:tc) cout << x << " ";cout << "\n";  
        } else if(op == "iterB") //正序遍历
        {
            // tc.innerPrint();
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
    accuracyTest();
    // memLeakTest();
}
```]



= 测试数据与运行结果

运行上述`_PRIV_TEST.cpp`测试代码中的正确性测试模块，得到以下内容：

```
*
 * @file myVector.h
 * @brief A Memory-contiguous, variable-length array
 * @details
 * 不知道该写什么，反正就是vector，正常用就行了
 * @author github.com/GYPpro
 * @version 0.2.0
 
```
```

  pb 1
  pb 2
  pb 3
  pb 4
  iterF
  pb 9
  iterB
  clr
  iterF
  pb 1
  iterF

  pb 1
  pb 2
  pb 3
  pb 4
  iterF
Iter with index:
1 2 3 4
Iter with begin end
1 2 3 4
Iter with AUTO&&
1 2 3 4
  pb 9
  iterB
Iter with index:
9 4 3 2 1
Iter with begin end
9 4 3 2
  clr
  iterF
Iter with index:

Iter with begin end

Iter with AUTO&&

  pb 1
  iterF
Iter with index:
1
Iter with begin end
1
Iter with AUTO&&
1

 
```


可以看出，代码运行结果与预期相符，可以认为代码正确性无误。

#image("1.png")

运行`_PRIV_TEST.cpp`中的内存测试模块，在保持CPU高占用率运行一段时间后内存变化符合预期，可以认为代码内存安全性良好。