type
  CircularLinkedList*[T] = object
    last: ref Node[T]
  Node*[T] = object
    data*: T
    next*: ref Node[T]

proc newNode*[T](data: T): ref Node[T] = 
  new(result)
  result.data = data
  result.next = nil
proc newCircularLinkedList*[T](): CircularLinkedList[T] = 
  result.last = nil

iterator items*[T](this: CircularLinkedList[T]): T =
  if this.last != nil:
    let head = this.last.next
    yield head.data
    var tmp = head.next
    while tmp != head:
      yield tmp.data
      tmp = tmp.next
proc print*[T](this: CircularLinkedList[T]) = 
  for i in this.items():
    stdout.write($i & " ")
  stdout.write("\n")
proc getTail*[T](this: CircularLinkedList[T]): ref Node[T] =
  return this.last

proc pushFront*[T](this: var CircularLinkedList[T], data: T): ref Node[T] {.discardable} =
  result = newNode(data)
  if this.last != nil:
    result.next = this.last.next
    this.last.next = result
  else:
    result.next = result
    this.last = result
  return result
proc insertAfter*[T](this: var CircularLinkedList[T], pos: ref Node[T], data: T): ref Node[T] {.discardable} =
  result = newNode(data)
  if this.last != nil:
    result.next = pos.next
    pos.next = result
  else:
    result.next = result
    this.last = result
  return result
proc pushBack*[T](this: var CircularLinkedList[T], data: T): ref Node[T] {.discardable} =
  let tail = this.getTail()
  let n: ref Node[T] = insertAfter(this, tail, data)
  return n

proc delNode*[T](this: var CircularLinkedList[T], key: T) =
  if this.last == nil:
    raise newException(OSError, "Try to delete node in empty Linked  List")

  let head = this.last.next
  if head.data != key:
    var tmp = head.next
    var pre = head
    while tmp != head and tmp.data != key:
      pre = tmp
      tmp = tmp.next
    if tmp != head:
      let new_next = tmp.next
      tmp.next = nil
      pre.next = new_next
      if tmp == this.last:
        this.last = pre

  else:
    this.last.next = head.next
proc delAt*[T](this: var CircularLinkedList[T], pos: int) =
  assert pos >= 0
  if this.last == nil:
    raise newException(OSError, "Try to delete node in empty Linked  List")

  let head = this.last.next
  if head == this.last and pos == 0:
    this.last = nil
  elif head == this.last and pos > 0:
    raise newException(OSError, "Try to delete a node out range of Linked  List")
  elif head != this.last and pos == 0:
    # 删除 head
    this.last.next = head.next
  else:
    # 最起码有 2 个节点, 且 pos > 0
    var tmp = head.next
    var pre = head
    var cnt = 1
    while tmp.next != head and cnt != pos:
      inc cnt
      pre = tmp
      tmp = tmp.next
    if tmp.next == head and cnt != pos:
      raise newException(OSError, "Try to delete a node out range of Linked  List")
    else:
      let new_next = tmp.next
      tmp.next = nil
      pre.next = new_next
      if tmp == this.last:
        this.last = pre

proc len*[T](this: CircularLinkedList[T]): int =
  if this.last == nil:
    return 0
  else:
    let head = this.last.next
    var tmp = head
    result = 1
    while tmp != this.last:
      tmp = tmp.next
      inc result
    return result
    
proc splitCircularLinkedList*[T](this: var CircularLinkedList[T]): (CircularLinkedList[T], CircularLinkedList[T]) =
  if this.last == nil or this.last.next == this.last:
    return (this, this)
  let head = this.last.next
  var slow = head
  var fast = head
  while fast.next != head and fast.next.next != head:
    slow = slow.next
    fast = fast.next.next
  if fast.next.next == head:
    fast = fast.next
  let head2 = slow.next
  slow.next = head
  fast.next = head2

  var cll1 = newCircularLinkedList[T]()
  cll1.last = slow
  var cll2 = newCircularLinkedList[T]()
  cll2.last = fast
  return (cll1, cll2)

proc sortedInsert*[T](this: var CircularLinkedList[T], data: T) =
  var n = newNode(data)
  if this.last == nil:
    n.next = n
    this.last = newNode(data)
    return

  let head = this.last.next
  if data <= head.data:
    n.next = head
    this.last.next = n
  elif data >= this.last.data:
    n.next = head
    this.last.next = n
    this.last = n
  else:
    var tmp = head.next
    var pre = head
    while tmp.data < data:
      pre = tmp
      tmp = tmp.next
    n.next = tmp
    pre.next = n
    


  

when isMainModule:
  var ll = newCircularLinkedList[int]()
  ll.pushFront(1)
  ll.pushFront(2)
  ll.pushBack(3)
  ll.pushBack(4)
  ll.print()
  ll.insertAfter(ll.last.next.next, 10)
  ll.print()
  ll.insertAfter(ll.getTail(), 5)
  ll.print()
  ll.delNode(1)
  ll.print()
  ll.delAt(4)
  ll.print()
  ll.delAt(1)
  ll.print()
  #let (ll1, ll2) = ll.splitCircularLinkedList()
  ll.delAt(1)
  ll.print()
  ll.sortedInsert(2)
  ll.print()
  ll.sortedInsert(13)
  ll.print()
  ll.sortedInsert(11)
  ll.print()


  
  