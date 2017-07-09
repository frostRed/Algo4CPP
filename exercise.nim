import data_structure
# Find the Minimum length Unsorted Subarray, sorting which makes the complete array sorted
proc minLenUnsortedSubarray*[T](arr: openArray[T]): (int, int) =
  assert arr.len() >= 2

  var left = low(arr)
  var right = high(arr)

  # 从左往右搜，找到第一个违反排序的位置
  for i in low(arr)+1..high(arr):
    if arr[i] < arr[i - 1]:
      left = i
      break
  # 从右往左搜，找到第一个违反排序的位置
  for i in countdown(high(arr), low(arr)+1):
    if arr[i] < arr[i - 1]:
      right = i
      break
  
  # 找出中间乱序区间的最大值和最小值
  var max_val = arr[left]
  var min_val = arr[left]
  for i in left..right:
    if arr[i] < min_val:
      min_val = arr[i]
    if arr[i] > max_val:
      max_val = arr[i]
  
  # 看乱序区间是否要向两边扩展
  # 找到最左侧第一个 > 区间最小值的位置，这种情况说明要尽可能往左扩展到这个位置
  for i in low(arr)..left:
    if arr[i] > min_val:
      left = i
      break
  # 找到最右侧第一个 < 区间最大值的位置，这种情况说明要尽可能往右扩展到这个位置
  for i in countdown(high(arr), right):
    if arr[i] < max_val:
      right = i
      break

  return (left, right)
#####################################################
####################################################
 # Merge Sort for Linked Lists

proc getMid[T](this: LinkedList[T]): LinkedList[T] =
  ## faster 往前走 2 步，lower 往前只走 1 步
  var lower = this
  var faster = this.next
  while faster.next != nil:
    faster = faster.next
    if faster.next != nil:
      faster = faster.next
      lower = lower.next
  return lower
proc sortedMerge1[T](left: LinkedList[T], right: LinkedList[T]): LinkedList[T] =
  var left = left
  var right = right
  var dummy: Node[T]
  # 不能对 dummy 直接取引用得到 tail
  var tail: ref Node[T]
  if left == nil:
    dummy.next = right
    return
  if right == nil:
    dummy.next = left
    return
  if left.data <= right.data:
    dummy.next = left
    left = left.next
  else:
    dummy.next = right
    right = right.next
  tail = dummy.next
  while true:
    if left == nil:
      tail.next = right
      break
    if right == nil:
      tail.next = left
      break
    if left.data <= right.data:
      tail.next = left
      left = left.next
    else:
      tail.next = right
      right = right.next
    tail = tail.next
  return dummy.next
proc sortedMerge2[T](left: LinkedList[T], right: LinkedList[T]): LinkedList[T] =
  var left = left
  var right = right
  var dummy: ref Node[T]
  new(dummy)
  var tail: ref Node[T]  = dummy
  while true:
    if left == nil:
      tail.next = right
      break
    if right == nil:
      tail.next = left
      break
    if left.data <= right.data:
      tail.next = left
      left = left.next
    else:
      tail.next = right
      right = right.next
    tail = tail.next
  return dummy.next
proc sortedMergeRec[T](left: LinkedList[T], right: LinkedList[T]): LinkedList[T] =
  # 链表递归合并，只需改变指针的指向
  new(result)
  if left == nil:
    return right
  if right == nil:
    return left
  if left.data <= right.data:
    result = left
    result.next = sortedMergeRec(left.next, right)
  else:
    result = right
    result.next = sortedMergeRec(left, right.next)
proc mergeSort[T](this: LinkedList[T]): LinkedList[T] =
  if this != nil and this.next != nil:
    let mid = this.getMid()
    let mid_next = mid.next
    mid.next = nil

    let left = mergeSort(this)
    let right = mergeSort(mid_next)
    #return sortedMergeRec(left, right)
    return sortedMerge1(left, right)
  else:
    return this
############################################
############################################
#Sort a nearly sorted (or K sorted) array, in O(n log k) time. 
# 数组中任一个元素的正确位置一定在往左或往右 K 个范围内
# K+1 大小的堆排序
proc minHeapfy(arr: var openArray[int], pos: int) =
  let left_son = pos * 2 + 1
  let right_son = pos * 2 + 2
  var less_pos = pos

  if left_son <= high(arr) and arr[left_son] < arr[less_pos]:
    less_pos = left_son
  if right_son <= high(arr) and arr[right_son] < arr[less_pos]:
    less_pos = right_son
  if less_pos != pos:
    swap(arr[pos], arr[less_pos])
    minHeapfy(arr, less_pos)

proc sortK(arr: var openArray[int], k: int) =
  var heap = newSeq[int](k + 1)
  for i in 0..k :
    heap[i] = arr[i]
  for i in countdown(high(heap) div 2, 0):
    minHeapfy(heap, i)

  var index = 0
  for i in k+1 .. high(arr):
    arr[index] = heap[0]
    inc index
    heap[0] = arr[i]
    minHeapfy(heap, 0)
  
  # 此时 heap 已堆化，arr 中除 heap 中的元素外，其它都已放回
  while heap.len() >= 1:
    arr[index] = heap[0]
    inc index
    heap[0] = heap[high(heap)]
    heap.delete(high(heap))
    minHeapfy(heap, 0)

##############################
##############################
# QuickSort on Singly Linked List
proc partition[T](head: ref Node[T], tail: ref Node[T]): (ref Node[T], ref Node[T], ref Node[T]) =
  ## 比中枢值大的都将节点转移到尾节点之后，所以头和尾都改变了
  let data = tail.data
  var newHead: ref Node[T] = nil
  var newTail = tail
  
  var pre_cur: ref Node[T] = nil
  var cur = head
  while cur != tail:
    if cur.data > data:
      # 大的节点换到末尾
      if pre_cur != nil:
        pre_cur.next= cur.next

      newTail.next = cur
      cur = newTail.next.next

      newTail.next.next = nil
      newTail = newTail.next
    else:
      if newHead == nil:
        newHead = cur
      # 小的节点跳过
      pre_cur = cur
      cur = cur.next
  if newHead == nil:
    # 若中枢值是最小值
    newHead = tail

  return (newHead, tail, newTail)

proc quickSortLinkedList[T](head: ref Node[T], tail: ref Node[T]): ref Node[T] =
  if head != nil and head != tail:
    var (newHead, pos, newTail) = partition(head, tail)
    if newHead != pos:
      var tmp = newHead
      while tmp.next != pos:
        tmp = tmp.next
      # 在 pos 前断开
      tmp.next = nil

      # 更新 newHead
      newHead = quickSortLinkedList(newHead, tmp)
      
      # 再重新链接到 pos
      tmp = newHead.getTail()
      tmp.next = pos

    # 2 个链表重新连接
    pos.next = quickSortLinkedList(pos.next, newTail)
    return newHead
  else:
    return head

when isMainModule:
  let arr1 = [10, 12, 20, 30, 25, 40, 32, 31, 35, 50, 60]
  let (b, e) = minLenUnsortedSubarray(arr1)

  var ll = newLinkedList[int]()
  ll.pushBack(15)
  ll.pushBack(10)
  ll.pushBack(5)
  ll.pushBack(20)
  ll.pushBack(3)
  ll.pushBack(2)
  ll.print()
  ll = ll.mergeSort()
  #ll= quickSortLinkedList(ll, ll.getTail())
  ll.print()

  var arr2 = [2, 6, 3, 12, 56, 8]
  sortK(arr2, 3)