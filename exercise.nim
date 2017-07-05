
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

when isMainModule:
  let arr1 = [10, 12, 20, 30, 25, 40, 32, 31, 35, 50, 60]
  let (b, e) = minLenUnsortedSubarray(arr1)
  echo b, e