#include <iostream>
#include <vector>
#include <stdlib.h>
#include <map>
#include <set>
#include <algorithm>
#include <queue>

using namespace std;
using pii = pair<int, int>;

#define int long long
#define pb push_back
#define F first
#define S second
#define all(x) x.begin(), x.end()
#define loop(i, n) for (int i = 0; i < n; i++)

const int mod = 1e9 + 7;
const int INF = 1e18;

// 优先队列队列BFS求最短路
//
void solve()
{
    int n, m;
    cin >> n >> m;
    vector<vector<pii>> cnj(n + 1);
    vector<int> rcnj(n+1);
    loop(i, m)
    {
        int u, v, w;
        cin >> u >> v >> w;
        cnj[u].pb({v, w});
    }
     priority_queue<pii,vector<pii>,greater<pii>> dfsOrder;
    set<int> unReached;
    loop(i, n) unReached.insert(i + 1);
    vector<int> dis(n+1,INF);
    vector<int> locked(n+1,0);
    int ori, tar;
    cin >> ori >> tar;
    dis[ori] = 0;
    dfsOrder.push({0, ori});

    auto release = [&](int _n) -> void
    {
        for (auto x : cnj[_n])
        {
            // dis[x.first] = min(dis[x.first], dis[_n] + x.second);
            // dfsOrder.push({dis[x.first], x.first});
            if(locked[x.first]) continue;
            if(dis[x.first] > dis[_n] + x.second) {
                dis[x.first] = dis[_n] + x.second;
                rcnj[x.first] = _n;
            } dfsOrder.push({dis[x.first], x.first});
        }
    };

    while (unReached.size())
    {
        auto u = dfsOrder.top();
        dfsOrder.pop();
        release(u.second);
        unReached.erase(u.second);
        locked[u.second] = 1;
    }

    vector<int> path;

    int ptt = tar;
    while(ptt != ori) {
        path.pb(ptt);
        ptt = rcnj[ptt];
    } path.pb(ori);

    loop(i,path.size()) cout << path[path.size()-1-i] <<( i != path.size()-1?" -> ":"\n");
    
}

signed main()
{
    // std::ios::sync_with_stdio(false);
    // std::cin.tie(nullptr);
    // std::cout.tie(nullptr);

    int T = 1;
    cin >> T;
    while (T--)
        solve();
    system("pause");
    return 0;
}

/*
1
8 13
1 2 2
1 3 14
1 4 15
2 3 2
3 4 3
2 5 15
3 5 15
4 6 1
6 5 3
5 6 3
5 7 2
5 8 14
8 7 3
1 7
1 -> 2 -> 3 -> 4 -> 6 -> 5 -> 7

*/