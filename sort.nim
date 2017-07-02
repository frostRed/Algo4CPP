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
  if left < right:
    let mid: int = left + (right - left) div 2
    mergeSort(arr, 0, mid)
    mergeSort(arr, mid+1, right)
    merge(arr, 0, mid, right)

when isMainModule:
  var arr = [64, 25, 12, 22, 11]
  #selectionSort(arr)
  #bubbleSort(arr)
  #insertionSort(arr)
  mergeSort(arr, 0, 4)
  assert isSorted(arr) == true
