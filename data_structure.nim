type
  LinkList*[T] = ref Node[T]
  Node[T] = ref object
    data: T
    next: ref object

proc newNode*[T](data: T): ref Node[T] = 
  new(result)
  result.data = data
  result.next = nil
proc newLinkList*[T](): LinkList[T] = 
  new(result)

iterator items*[T](this: LinkList[T]): T =
  var this = this
  while this != nil:
    yield this.data
    this = this.next
proc print*[T](this: LinkList[T]) = 
  for i in this.items():
    stdout.write($i & " ")
proc getTail*[T](this: LinkList[T]): ref Node[T] =
  var tmp = this
  if this != nil:
    while tmp.next != nil:
      tmp = tmp.next
  return tmp

proc pushFront*[T](head: ref Node[T], data: T): ref Node[T] =
  result = newNode(data)
  result.next = head
  return result
proc insertAfter*[T](pos: ref Node[T], data: T): ref Node[T] =
  result = newNode(data)
  if pos != nil:
    result.next = pos.next
    pos.next = result
  return result
proc pushBack*[T](head: ref Node[T], data: T): ref Node[T] =
  return insertAfter[T](getTail(), data)

proc delNode*[T](this: var LinkList[T], key: T) =
  if this == nil:
    raise newException(OSError, "empty Linked  List can not delete")
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
  
  