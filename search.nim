import Math
proc linearSearch(arr: openArray[int], x: int): int =
  for index, val in arr.pairs():
    if val == x:
      return index
  return -1

proc binarySearchRec(arr: openArray[int], left: int, right: int, x: int): int =
  if left <= right:
    let mid: int = (left + right) div 2
    if arr[mid] == x:
      return mid
    elif arr[mid] > x:
      return binarySearchRec(arr, left, mid-1, x)
    else:
      return binarySearchRec(arr, mid+1, right, x)
  else:
    return -1;

proc binarySearchIte(arr: openArray[int], left: int, right: int, x: int): int =
  var right = right
  var left = left
  while left <= right:
    let mid = (left + right) div 2
    if arr[mid] == x:
      return mid
    elif arr[mid] > x:
      right = mid - 1
    else:
      left = mid + 1
  return -1

proc jumpSearch(arr: openArray[int], x: int): int =
  # 虽然时间复杂度是根号级别，它只需回退1次
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

proc interpolationSearch(arr: openArray[int], x: int): int =
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

proc exponentialSearch(arr: openArray[int], x:int): int =
  let arr_len = arr.len()
  if arr[0] == x:
    return 0
  var index = 1
  while index < arr_len and arr[index] <= x:
    index *= 2
  return binarySearchIte(arr, index div 2, min(index, arr_len-1), x)

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