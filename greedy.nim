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
    result.parent[i] = i # 形成森林，初始时只有自身一个节点
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
      this.union(ed.src, ed.des) # 2 棵树合并为 1 棵
      inc cnt

type
  Node = object
    ch: char
    freq: int
    left: ref Node
    right: ref Node
  Heap = ref object
    size: int
    cap: int
    arr: seq[ref Node]
proc newNode(ch: char, freq: int): ref Node =
  new(result)
  result.ch = ch
  result.freq = freq

proc minHeapify(this: var Heap, pos: int) =
  let left = 2 * pos + 1
  let right = 2 * pos + 2
  var less_pos = pos

  if left < this.size and this.arr[left].freq < this.arr[less_pos].freq:
    less_pos = left
  if right < this.size and this.arr[right].freq < this.arr[less_pos].freq:
    less_pos = right
  if less_pos != pos:
    swap(this.arr[pos], this.arr[less_pos])
    this.minHeapify(less_pos)

proc newHeap(chs: openArray[char], freqs: openArray[int]): Heap =
  new(result)
  result.cap = chs.len()
  result.size = chs.len()
  result.arr = newSeq[ref Node](chs.len())
  for i in low(chs)..high(chs):
    result.arr[i] = newNode(chs[i], freqs[i])
  for i in countdown(high(result.arr), low(result.arr)):
    result.minHeapify(i)
  return result

proc extracMin(this: var Heap): ref Node =
  result = this.arr[0]
  this.arr[0] = this.arr[this.size - 1]
  dec this.size
  this.minHeapify(0)

proc insert(this: var Heap, n: ref Node) =
  inc this.size
  var pos = this.size - 1 # 新增一个位置
  while pos >= 0 and this.arr[(pos - 1) div 2] > this.arr[pos]:
    this.arr[pos] = this.arr[(pos - 1) div 2]
  this.arr[pos] = n
  
proc buildHuffmanTree(chs: openArray[char], freqs: openArray[int]): ref Node =
  assert chs.len() == freqs.len()

  # 将字符和频数作为节点信息，根据频数构造优先队列
  var minHeap: Heap = newHeap(chs, freqs)
  
  
  # 从优先队列中取出两个节点，把它们的频数相加构造出它们的父节点，最终得到 root 节点，形成一棵树
  # 编码规则是左子树为 0，右子树为 1，直至叶子节点，也有是含有字符信息的节点
  while minHeap.size != 1:
    let n1: ref Node = minHeap.extracMin()
    let n2: ref Node = minHeap.extracMin()
    var n3: ref Node = newNode('$', n1.freq + n2.freq)
    n3.left = n1
    n3.right = n2
    minHeap.insert(n3)

  return minHeap.extracMin

proc print(n: ref Node, str: string) =
  if n.ch != '$':
    echo n.ch & " " & str
  else:
    print(n.left, str & "0")
    print(n.right, str & "1")

proc HuffmanCode(chs: openArray[char], freqs: openArray[int]) =
  let root: ref Node = buildHuffmanTree(chs, freqs)
  print(root, "")

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

  let chs = ['a', 'b', 'c', 'd', 'e', 'f'];
  let freqs = [5, 9, 12, 13, 16, 45];
  HuffmanCode(chs, freqs)