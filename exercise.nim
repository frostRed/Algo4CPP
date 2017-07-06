
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
type  
  LinkedList[T] = ref Node[T]
  Node[T] = object
    value: T
    next: ref Node[T]
    
proc newNode[T](value: T): ref Node[T] =
  new(result)
  result.value = value
proc newLinkedList[T](): LinkedList[T] =
  return nil

proc push[T](this: var LinkedList[T], value: T) =
  let old = this
  this = newNode[T](value)
  this.next = old

iterator items[T](this: LinkedList[T]): T =
  var this = this
  if this != nil:
    while this != nil:
      yield this.value
      this = this.next
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
proc sortedMerge[T](left: LinkedList[T], right: LinkedList[T]): LinkedList[T] =
  # 链表递归合并，只需改变指针的指向
  new(result)
  if left == nil:
    return right
  if right == nil:
    return left
  if left.value <= right.value:
    result = left
    result.next = sortedMerge(left.next, right)
  else:
    result = right
    result.next = sortedMerge(left, right.next)
proc mergeSort[T](this: LinkedList[T]): LinkedList[T] =
  if this != nil and this.next != nil:
    let mid = this.getMid()
    let mid_next = mid.next
    mid.next = nil

    let left = mergeSort(this)
    let right = mergeSort(mid_next)
    return sortedMerge(left, right)
  else:
    return this

when isMainModule:
  let arr1 = [10, 12, 20, 30, 25, 40, 32, 31, 35, 50, 60]
  let (b, e) = minLenUnsortedSubarray(arr1)

  var ll = newLinkedList[int]()
  assert ll == nil
  ll.push(15)
  ll.push(10)
  ll.push(5)
  ll.push(20)
  ll.push(3)
  ll.push(2)
  ll = ll.mergeSort()
  for i in ll.items(): echo i