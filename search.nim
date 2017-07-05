import Math
proc linearSearch*[T](arr: openArray[T], x: T): int =
  ## 一个个比较
  for index, val in arr.pairs():
    if val == x:
      return index
  return -1

proc binarySearchRec*[T](arr: openArray[T], left: int, right: int, x: T): int =
  ## 已排序，比较中间位置，减少一半
  if left <= right:
    let mid: int = left + (right - left) div 2
    if arr[mid] == x:
      return mid
    elif arr[mid] > x:
      return binarySearchRec(arr, left, mid-1, x)
    else:
      return binarySearchRec(arr, mid+1, right, x)
  else:
    return -1;

proc binarySearchIte*[T](arr: openArray[T], left: int, right: int, x: T): int =
  ## 已排序，比较中间位置，减少一半
  var right = right
  var left = left
  while left <= right:
    let mid: int = left + (right - left) div 2
    if arr[mid] == x:
      return mid
    elif arr[mid] > x:
      right = mid - 1
    else:
      left = mid + 1
  return -1

proc jumpSearch*[T](arr: openArray[T], x: T): int =
  ## 已排序，均匀划分成区间，确定在某个区间后线性搜索
  ## 虽然时间复杂度是根号级别，它只需回退1次
  let arr_len: int = arr.len()
  let step: int  = sqrt(arrLen.float64).int
  var index = step 
  var pre_index = 0

  while arr[index - 1] < x:
    pre_index = index
    index = min(index + step, arr_len)
    if pre_index == arr_len:
      return -1


  while  arr[pre_index] < x:
    inc pre_index
    if pre_index == index:
      return -1
  
  if arr[pre_index] == x:
    return pre_index
  else:
    return -1

proc interpolationSearch*[T](arr: openArray[T], x: T): int =
  ## 二分的改进，每次不是中点，而是看搜索的值离两端的值哪个近
  ## 适合均匀分布
  var left = 0
  var right = arr.len() - 1
  while left <= right:
    let pos: int = left + (x - arr[left]) * (right - left) div (arr[right] - arr[left])
    if arr[pos] == x:
      return pos
    elif arr[pos] > x:
      right = pos - 1
    else:
      left = pos + 1
  return -1

proc exponentialSearch*[T](arr: openArray[T], x: T): int =
  ## 已排序，区间大小不均匀，1，2，4，8划分，找到区间后二分搜索
  let arr_len = arr.len()
  if arr[0] == x:
    return 0
  var index = 1
  while index < arr_len and arr[index] <= x:
    index *= 2
  return binarySearchIte(arr, index div 2, min(index, arr_len-1), x)

proc ternarySearch*[T](arr: openArray[T], left, right:int , x: T): int =
  ## 已排序，类似二分搜索，分成三个区间，比较中间两个点
  if left > right:
    return -1

  let step = (right - left) div 3
  let mid1 = left + step;
  let mid2 = mid1 + step;
  if arr[mid1] == x:
    return mid1
  elif arr[mid2] == x:
    return mid2

  if arr[mid1] > x:
    return ternarySearch(arr, left, mid1-1, x)
  elif arr[mid2] < x:
    return ternarySearch(arr, mid2+1, right, x)
  else:
    return ternarySearch(arr, mid1, mid2, x)

when isMainModule:
  assert linearSearch([1, 2, 3], 4) == -1
  assert linearSearch([1, 2, 3], 2) == 1

  assert binarySearchRec([1, 2, 3], 0, 2, 4) == -1
  assert binarySearchRec([1, 2, 3], 0, 2, 2) == 1
  assert binarySearchIte([1, 2, 3], 0, 2, 4) == -1
  assert binarySearchIte([1, 2, 3], 0, 2, 2) == 1

  assert jumpSearch([1, 2, 3], 4) == -1
  assert jumpSearch([0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610],
        55) == 10

  assert interpolationSearch([0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
      55, 89, 144, 233, 377, 610], 55) == 10

  assert exponentialSearch([1, 2, 3], 4) == -1
  assert exponentialSearch([1, 2, 3], 2) == 1

  assert ternarySearch([1, 2, 3], 0, 2, 4) == -1
  assert ternarySearch([1, 2, 3], 0, 2, 2) == 1