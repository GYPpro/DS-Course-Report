#include <iostream>
#include <vector>
#include <stdlib.h>
#include <map>
#include <algorithm>

using namespace std;
using pii = pair<int,int>;

#define int long long
#define pb push_back
#define F first
#define S second
#define all(x) x.begin(),x.end()
#define loop(i,n) for(int i = 0; i < n; i++)

const int mod = 1e9 + 7;
const int INF = 1e18;

// 子树大小 节点深度 子树节点值和
void solve()
{
    int n;
    cin >> n;
    vector<vector<int>> cnj(n+1);
    vector<int> wei(n+1);
    vector<int> subTreeSize(n+1),depth(n+1),subTreeSum(n+1);
    loop(i,n-1)
    {
        int u,v;
        cin >> u >> v;
        cnj[u].pb(v);
        cnj[v].pb(u);
    }
    loop(i,n) cin >> wei[i+1];
    auto dfs = [&](auto self,int p,int f) -> pii {
        int size = 1;
        int sum = wei[p];
        depth[p] = depth[f] + 1;
        for(auto &x : cnj[p])
        {
            if(x == f) continue;
            auto [subSize,subSum] = self(self,x,p);
            size += subSize;
            sum += subSum;
        }
        subTreeSize[p] = size;
        subTreeSum[p] = sum;
        return {size,sum};
    };
    dfs(dfs,1,0);
    cout << "subTreeSize \n";
    loop(i,n) cout << subTreeSize[i+1] << " ";
    cout << "\n";
    cout << "depth \n";
    loop(i,n) cout << depth[i+1] << " ";
    cout << "\n";
    cout << "subTreeSum \n";
    loop(i,n) cout << subTreeSum[i+1] << " ";
    cout << "\n";
}

signed main()
{
    // std::ios::sync_with_stdio(false);
    // std::cin.tie(nullptr);
    // std::cout.tie(nullptr);

    int T = 1;
    cin >> T;
    while(T--)
        solve();
    return 0;
}

/*
2
8
1 2
1 3
1 4
3 5
3 6
6 7
6 8
9 4 3 1 15 7 3 7
subTreeSize
8 1 5 1 1 3 1 1
depth
1 2 2 2 3 3 4 4
subTreeSum
49 4 35 1 15 17 3 7
6
1 2
2 3
3 4
4 5
5 6
1 1 4 5 1 4
subTreeSize
6 5 4 3 2 1
depth
1 2 3 4 5 6
subTreeSum
16 15 14 10 5 4
*/