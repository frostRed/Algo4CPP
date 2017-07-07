import algorithm
import future
proc maxActivities(s: openArray[int], f: openArray[int]): seq[int] =
  ## 结束时间按升序排序
  ## 第一个活动必选，因为选其它的活动的话只可能变差，不可能更优
  ## 如果下一个活动的开始时间 >= 上一个活动的结束时间，选它
  assert s.len() == f.len()
  result = @[0]
  var pre_act = 0
  for i in 1..high(s):
    if s[i] >= f[pre_act]:
      result.add(i)
      pre_act = i

type
  Graph = object
    E: int
    V: int
    edge: seq[Edge]
    parent: seq[int]
    rank: seq[int]
  Edge = object
    src: int
    des: int
    weight: int
proc initEdge(s, d, w: int): Edge = 
  result.src = s
  result.des = d
  result.weight = w
proc initGraph(v, e: int): Graph = 
  result.V = v
  result.E = e
  result.edge = @[]
  result.parent = newSeq[int](v)
  result.rank = newSeq[int](v)
  for i in 0..<v:
    result.parent[i] = i
    result.rank[i] = 0

proc addEdge(this: var Graph, src, des, wei: int) = 
  this.edge.add(initEdge(src, des, wei))

proc find(this: Graph, i: int): int =
  if this.parent[i] != i:
    return find(this, this.parent[i])
  return this.parent[i]

proc union(this: var Graph, i, j: int) =
  var root_i = this.find(i)
  var root_j = this.find(j)

  if this.rank[root_i] < this.rank[root_j]:
    this.parent[root_i] = root_j
  elif this.rank[root_i] > this.rank[root_j]:
    this.parent[root_j] = root_i
  else:
    this.parent[root_i] = root_j
    inc this.rank[root_j]
proc edgeCmp(a: Edge, b: Edge): int =  cmp(a.weight, b.weight)
#proc isCycle(this: Graph): bool =
proc KruskalMST(this: var Graph): seq[Edge] = 
  ## 最小生成树，边先按权重升序排序
  ## 按顺序选择边，如果新加入的边不会生成环的话
  ## 用 Union-Find 算法来检测是否存在环
  result = @[]
  sort(this.edge, edgeCmp)
  var index = 0
  var cnt = 0
  while cnt < this.V - 1:
    var ed = this.edge[index]
    inc index

    let set_src = this.find(ed.src)
    let set_des = this.find(ed.des)
    if set_src != set_des:
      result.add(ed)
      this.union(ed.src, ed.des)
      inc cnt

when isMainModule:
  let s = [1 , 3 , 0 , 5 , 8 , 5]
  let f = [2 , 4 , 6 , 7 , 9 , 9]
  for i in maxActivities(s, f).items(): echo i

  var g = initGraph(4, 5)
  g.addEdge(0, 1, 10)
  g.addEdge(0, 2, 6)
  g.addEdge(0, 3, 5)
  g.addEdge(1, 3, 15)
  g.addEdge(2, 3, 4)
  
  let mst = g.KruskalMST()
  for i in mst.items(): echo i.src, i.des, i.weight