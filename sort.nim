proc isSorted(arr: openArray[int]): bool =
  result = true
  for i in low(arr)..<high(arr):
    if arr[i] > arr[i + 1]:
      return false

proc selectionSort(arr: var openArray[int]) =
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

proc bubbleSort(arr: var openArray[int]) =
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

proc insertionSort(arr: var openArray[int]) =
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

proc merge(arr: var openArray[int], left, mid, right: int) =
  ## 先复制两个区间出来，在归并放回去
  var arr1 = newSeq[int]() 
  var arr2 = newSeq[int]() 
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
proc mergeSort(arr: var openArray[int], left, right: int) =
  ## 最差，最好，平均时间都是nlog(n)
  ## 辅助空间O(n)
  ## 稳定排序
  if left < right:
    let mid: int = left + (right - left) div 2
    mergeSort(arr, 0, mid)
    mergeSort(arr, mid+1, right)
    merge(arr, 0, mid, right)

proc heapify(arr: var openArray[int], largest_index, pos: int) =
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
proc heapSort(arr: var openArray[int]) =
  ## 首先从底下第2层元素开始堆化一遍
  ## 时间O(nlog n)
  for i in countdown(high(arr) div 2, 0):
    heapify(arr, high(arr), i)
  
  ## 取出最大元素，换上尾元素值，然后再堆化，取出里面的最大元素
  for i in countdown(high(arr), 1):
    swap(arr[0], arr[i])
    heapify(arr, i-1, 0)

proc partition(arr: var openArray[int], left, right: int): int =
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

proc quickSort(arr: var openArray[int], left, right: int) =
  ## 最差时间O(n^2)
  ## 平均时间O(nlog n)
  if left < right:
    let pos = partition(arr, left, right)
    quickSort(arr, left, pos - 1)
    quickSort(arr, pos + 1, right)

proc countSort(arr: var openArray[int], exp: int) =
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

proc radixSort(arr: var openArray[int]) =
  ## 先对最低位进行计数排序，再对倒数第二位计数排序
  let max_val = max(arr)
  var exp = 1
  while max_val div exp > 0:
    countSort(arr, exp)
    exp *= 10

when isMainModule:
  var arr = [64, 25, 12, 22, 11]
  #selectionSort(arr)
  #bubbleSort(arr)
  #insertionSort(arr)
  #mergeSort(arr, 0, 4)
  #heapSort(arr)
  #quickSort(arr, 0, 4)
  radixSort(arr)
  assert isSorted(arr) == true

