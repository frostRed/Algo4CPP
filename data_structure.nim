type
  LinkedList*[T] = ref Node[T]
  Node*[T] = object
    data*: T
    next*: ref Node[T]

proc newNode*[T](data: T): ref Node[T] = 
  new(result)
  result.data = data
  result.next = nil
proc newLinkedList*[T](): LinkedList[T] = 
  return nil

iterator items*[T](this: LinkedList[T]): T =
  var this = this
  while this != nil:
    yield this.data
    this = this.next
proc print*[T](this: LinkedList[T]) = 
  for i in this.items():
    stdout.write($i & " ")
  stdout.write("\n")
proc getTail*[T](this: LinkedList[T]): ref Node[T] =
  var tmp = this
  if this != nil:
    while tmp.next != nil:
      tmp = tmp.next
  return tmp

proc pushFront*[T](this: var LinkedList[T], data: T): ref Node[T] {.discardable} =
  result = newNode(data)
  result.next = this
  this = result
  return result
proc insertAfter*[T](this: var LinkedList[T], pos: ref Node[T], data: T): ref Node[T] {.discardable} =
  result = newNode(data)
  if this != nil:
    result.next = pos.next
    pos.next = result
  else:
    this = result
  return result
proc pushBack*[T](this: var LinkedList[T], data: T): ref Node[T] {.discardable} =
  return this.insertAfter(this.getTail(), data)

proc delNode*[T](this: var LinkedList[T], key: T) =
  if this == nil:
    raise newException(OSError, "Try to delete node in empty Linked  List")
  if this.data != key:
    var tmp = this
    while tmp.next != nil and tmp.next.data != key:
      tmp = tmp.next
    if tmp.next != nil:
      let new_next = tmp.next.next
      tmp.next.next = nil
      tmp.next = new_next
  else:
    this = this.next
proc delAt*[T](this: var LinkedList[T], pos: int) =
  assert pos >= 0
  if this == nil:
    raise newException(OSError, "Try to delete node in empty Linked  List")

  if pos == 0:
    this = this.next
  else:
    var tmp = this
    var pre: ref Node[T] = nil
    var cnt = 0
    while tmp.next != nil and cnt != pos:
      pre = tmp
      tmp = tmp.next
      inc cnt
    if tmp.next == nil and cnt != pos:
      raise newException(OSError, "Try to delete a node out range of Linked  List")
    else:
      let new_next = pre.next.next
      pre.next.next = nil
      pre.next = new_next

proc len*[T](this: LinkedList[T]): int =
  if this == nil:
    return 0
  else:
    return 1 + len(this.next)
    
proc swapNode*[T](this: var LinkedList[T], x, y: T) =
  if x == y:
    return

  var tmpx = this
  var tmpy = this

  # Todo: 将两个遍历循环优化为一个
  var preX: ref Node[T] = nil
  while tmpx != nil and tmpx.data != x:
    preX = tmpx
    tmpx = tmpx.next
  
  var preY: ref Node[T] = nil
  while tmpy != nil and tmpy.data != y:
    preY = tmpy
    tmpy = tmpy.next
  
  if tmpx == nil or tmpy == nil:
    raise newException(OSError, "can not find these value in LinkedList")
  
  # 先处理 pre.next 这个指针，分为 头节点 和 非头节点 2 中情况处理
  if preX == nil:
    this = tmpy
  else:
    preX.next = tmpy
  if preY == nil:
    this = tmpx
  else:
    preY.next = tmpx
  
  # 再 交换 curr.next 指针的值
  let tmp_ref = tmpx.next
  tmpx.next = tmpy.next
  tmpy.next = tmp_ref

proc reverseIte*[T](this: var LinkedList[T]) = 
  var pre: ref Node[T] = nil
  var curr = this
  var tmp_next: ref Node[T]
  while curr != nil:
    # 必须临时保存正向的下一个，因为等会改动了 curr.next
    tmp_next = curr.next
    # 反转指向
    curr.next = pre
    # 往前推进一个
    pre = curr
    curr = tmp_next
  # 更新 head
  this = pre

proc reverseRecUtil[T](curr, pre: ref Node[T], head: var ref Node[T]) =
  var curr = curr
  if curr.next == nil:
    curr.next = pre
    head = curr
  else:
    let tmp_next = curr.next
    curr.next = pre
    reverseRecUtil(tmp_next, curr, head)
proc reverseRec*[T](this: var LinkedList[T]) =
  if this != nil:
    reverseRecUtil(this, nil, this)

proc reverseIte*[T](this: var LinkedList[T], cnt: int) =
  ## 只反转链表中前 cnt 个元素
  let head = this
  var pre: ref Node[T] = nil
  var cur = this
  var tmp_next: ref Node[T]
  var count = 0
  while count != cnt and cur != nil:
    tmp_next = cur.next
    cur.next = pre
    pre = cur
    cur = tmp_next
    inc count
  if count != cnt:
    raise newException(OSError, "no enough elements in LinkedList to reverse")
  head.next = cur
  this = pre

proc detectLoopAndRemove*[T](this: var LinkedList[T]): bool {.discardable} =
  var slow = this
  var fast = this

  # 必然在环中相遇
  while slow != nil and fast != nil and fast.next != nil:
    slow = slow.next
    fast = fast.next.next
    if slow == fast:
      break

  if slow != fast:
    return false
    
  # 数一下环中有多少个元素
  fast = fast.next
  var loop_count = 1
  while fast != slow:
    fast = fast.next
    inc loop_count

  slow = this
  fast = this
  # fast 先在 loop_count 步
  for i in 0..<loop_count:
    fast = fast.next
  
  # 必然再环的起始位置相遇
  while slow != fast:
    slow = slow.next
    fast = fast.next
  # 找到环的末尾
  while fast.next != slow:
    fast = fast.next
  fast.next = nil
  return true

proc detectLoopAndRemove1*[T](this: var LinkedList[T]): bool {.discardable} =
  var slow = this
  var fast = this.next # 注意开始 fast 就比 slow 快 1 步
  # lower 走 1 步，fast 走 2 步，必然在环中相遇
  while fast != nil and fast.next != nil:
    slow = slow.next
    fast = fast.next.next
    if slow == fast:
      break

  if slow != fast:
    return false

  slow = this
  while slow != fast.next:
    # 必然 slow 在环的开始， fast 在环的末尾
    slow = slow.next
    fast = fast.next
  fast.next = nil
  return true

when isMainModule:
  var ll = newLinkedList[int]()
  ll.pushFront(1)
  ll.pushFront(2)
  ll.pushBack(3)
  ll.pushBack(4)
  ll.insertAfter(ll.next, 10)
  ll.insertAfter(ll.getTail(), 5)
  ll.print()
  ll.reverseIte(3)
  ll.print()
  ll.delNode(10)
  ll.delAt(0)
  ll.delAt(1)
  ll.print()
  ll.swapNode(2, 5)
  ll.print()
  ll.reverseIte()
  #ll.reverseRec()
  ll.print()
  ll.pushFront(4)
  ll.pushFront(3)
  ll.pushFront(2)
  ll.pushFront(1)
  ll.getTail().next = ll.next.next
  ll.detectLoopAndRemove()
  ll.print()
  
  