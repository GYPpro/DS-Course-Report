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

