#import sequtils
proc isSorted*[T](arr: openArray[T]): bool =
  result = true
  for i in low(arr)..<high(arr):
    if arr[i] > arr[i + 1]:
      return false

proc selectionSort*[T](arr: var openArray[T]) =
  ## 找出未排序部分的最小值添加到已排序部分的末尾
  ## 时间O(n^2)，辅助空间O(1)，交换次数O(n)
  for i in low(arr)..high(arr):
    var min_index = i
    var min_val = arr[min_index]
    for j in i+1..high(arr):
      if arr[j] < min_val:
        min_index = j
        min_val = arr[j]
    swap(arr[i], arr[min_index])

proc bubbleSort*[T](arr: var openArray[T]) =
  ## 如果某一轮没有交换，则已有序
  ## 在最好情况（输入有序）下，时间为O(n)
  ## 最坏和平均情况下，时间为O(n^2)
  ## 辅助空间为O(1)
  ## 稳定排序
  for i in low(arr)..high(arr):
    var swaped = false
    for j in 0 ..< high(arr)-i:
      if arr[j] > arr[j+1]:
        swap(arr[j], arr[j+1])
        swaped = true
    if not swaped:
      break

proc insertionSort*[T](arr: var openArray[T]) =
  ## 将未排序部分的首元素往前插入到已排序部分中合适的位置
  ## 往前选位置时，已排序的元素往后挪一个空位
  ## 时间O(n^2)，辅助空间O(1)
  ## 稳定排序
  ## 可用二分搜索确定插入的位置
  if arr.len() >= 2:
    for i in 1..high(arr):
      let val = arr[i]
      var index = i - 1
      while index >= 0 and val < arr[index]:
        arr[index+1] = arr[index]
        dec index
      arr[index + 1] = val

proc merge[T](arr: var openArray[T], left, mid, right: int) =
  ## 先复制两个区间出来，在归并放回去
  var arr1 = newSeq[T]() 
  var arr2 = newSeq[T]() 
  for i in left..right:
    if i <= mid:
      arr1.add(arr[i])
    else:
      arr2.add(arr[i])

  var index = left 
  var pos1 = low(arr1)
  var pos2 = low(arr2)
  while pos1 <= high(arr1) and pos2 <= high(arr2):
    if arr1[pos1] <= arr2[pos2]:
      arr[index] = arr1[pos1]
      inc pos1
    else:
      arr[index] = arr2[pos2]
      inc pos2
    inc index

  while pos1 <= high(arr1):
    arr[index] = arr1[pos1]
    inc pos1
    inc index
  while pos2 <= high(arr2):
    arr[index] = arr2[pos2]
    inc pos2
    inc index
proc mergeSort*[T](arr: var openArray[T], left, right: int) =
  ## 最差，最好，平均时间都是nlog(n)
  ## 辅助空间O(n)
  ## 稳定排序
  if left < right:
    let mid: int = left + (right - left) div 2
    mergeSort(arr, 0, mid)
    mergeSort(arr, mid+1, right)
    merge(arr, 0, mid, right)

proc heapify*[T](arr: var openArray[T], largest_index, pos: int) =
  ## 最大堆堆化，指定pos尝试下沉
  ## 堆化操作时间O(log n)
  let left_son = pos * 2 + 1
  let right_son = pos * 2 + 2
  var larger_pos = pos
  if left_son <= largest_index and arr[left_son] > arr[pos]:
    larger_pos = left_son
  if right_son <= largest_index and arr[right_son] > arr[larger_pos]:
    larger_pos = right_son
  
  if larger_pos != pos:
    swap(arr[pos], arr[larger_pos])
    heapify(arr, largest_index, larger_pos)
proc heapSort*[T](arr: var openArray[T]) =
  ## 首先从底下第2层元素开始堆化一遍
  ## 时间O(nlog n)
  for i in countdown(high(arr) div 2, 0):
    heapify(arr, high(arr), i)
  
  ## 取出最大元素，换上尾元素值，然后再堆化，取出里面的最大元素
  for i in countdown(high(arr), 1):
    swap(arr[0], arr[i])
    heapify(arr, i-1, 0)

proc partition*[T](arr: var openArray[T], left, right: int): int =
  ## 选取一个枢纽值，确定某个位置，使这个位置左边的都 <= 这个值，右边的都 > 这个值
  ## less_index 右边的都 > val
  var less_index = left - 1
  let val = arr[right]

  for j in (left..<right):
    ## <=的元素都交换到 less_index
    if arr[j] <= val:
      inc less_index
      swap(arr[less_index], arr[j])
  
  swap(arr[less_index + 1], arr[right])
  return less_index + 1

proc quickSort*[T](arr: var openArray[T], left, right: int) =
  ## 最差时间O(n^2)
  ## 平均时间O(nlog n)
  if left < right:
    let pos = partition(arr, left, right)
    quickSort(arr, left, pos - 1)
    quickSort(arr, pos + 1, right)

proc countSort[T](arr: var openArray[T], exp: int) =
  var count: array[0..9, int] 
  # 记录出现个数
  for i in arr.items():
    count[(i div exp) mod 10] += 1
  # 记录应该把值放在哪个索引位置，注意个数和索引差了一个 1
  for i in 1..high(count):
    count[i] += count[i - 1]
  
  var output = newSeq[int](arr.len())
  for i in countdown(high(arr), low(arr)):
    ## 必须从后往前才能保持稳定，因为索引是递减的
    output[ count[(arr[i] div exp) mod 10]  - 1 ] = arr[i]
    dec count[(arr[i] div exp) mod 10]
  
  for i in low(arr)..high(arr):
    arr[i] = output[i]
proc radixSort*[T](arr: var openArray[T]) =
  ## 先对最低位进行计数排序，再对倒数第二位计数排序
  let max_val = max(arr)
  var exp = 1
  while max_val div exp > 0:
    countSort(arr, exp)
    exp *= 10

proc bucketSort[T](arr: var openArray[T]) =
  ## 桶排序适合元素在某个范围内均匀分布的数据
  ## 实际上是将所有元素平均放在每个桶里，对每个桶排序，在综合起来
  var buckets = newSeq[seq[T]]()
  for i in low(arr)..high(arr):
    buckets.add(@[])
  for i in arr.items():
    buckets[(i * high(arr).float).int].add(i)
  
  for i in buckets.mitems():
    # 对每个桶排序
    insertionSort(i)

  var index = 0
  for i in buckets.items():
    for j in i.items():
      arr[index] = j
      inc index

proc shellSort*[T](arr: var openArray[T]) =
  ## 希尔排序是插入排序扩展，隔某个间隔从后往前插入排序，下一轮缩小间隔，直至间隔为1
  ## 时间和序列的选择相关，下面这种减半的序列时间为 n^2
  var gap = high(arr) div 2
  while gap >= 1:
    for i in gap+1 .. high(arr):
      let val = arr[i]
      var pre_pos = i - gap
      while pre_pos >= low(arr) and arr[pre_pos] > val:
        # 插入排序，如果前面元素值大，将它往后移一个
        arr[pre_pos + gap] = arr[pre_pos]
        pre_pos -= gap
      # 插入到找到的合适的位置
      arr[pre_pos + gap] = val
    
    gap = gap div 2

proc combSort*[T](arr: var openArray[T]) =
  ## 冒泡排序的改进，跟希尔排序一样，间隔从大到小直至 1
  ## 最差还是 O(n^2)
  var gap = high(arr) * 10 div 13
  var swaped = false
  while gap != 1 or swaped:
    swaped = false
    for i in low(arr) .. high(arr)-gap+1:
      var next_pos = i + gap
      while next_pos <= high(arr) and arr[next_pos - gap] > arr[next_pos]:
        ## 冒泡排序
        swap(arr[next_pos - gap], arr[next_pos])
        swaped = true
        next_pos += gap

    gap = gap * 10 div 13
    if gap < 1:
      gap = 1

proc pigeonholeSort*[T](arr: var openArray[T]) =
  ## 类似于计数排序和桶排序,但并不记录个数，而是在每个桶存放相同的值，这个值有几个放几个
  let min_val = min(arr)
  let max_val = max(arr)
  let rang: int = max_val - min_val + 1

  var buckets = newSeq[seq[int]]()
  for i in 0..<rang:
    buckets.add(@[])
  
  for i in arr.items():
    buckets[i - min_val].add(i)

  var index = 0
  for i in buckets.items():
    for j in i.items():
      arr[index] = j
      inc index
  
when isMainModule:
  var arr = [64, 25, 12, 22, 11]
  #selectionSort(arr)
  #bubbleSort(arr)
  #insertionSort(arr)
  #mergeSort(arr, 0, 4)
  #heapSort(arr)
  #quickSort(arr, 0, 4)
  #radixSort(arr)
  #var arr_float = [0.897, 0.565, 0.656, 0.1234, 0.665, 0.3434]
  #bucketSort(arr_float)
  #shellSort(arr)
  #combSort(arr)
  pigeonholeSort(arr)
  assert isSorted(arr) == true