proc maxActivities(s: openArray[int], f: openArray[int]): seq[int] =
  ## 结束时间按升序排序
  ## 第一个活动必选，因为选其它的活动的话只可能变差，不可能更优
  ## 如果下一个活动的开始时间 >= 上一个活动的结束时间，选它
  assert s.len() == f.len()
  result = @[0]
  var pre_act = 0
  for i in 1..high(s):
    if s[i] >= f[pre_act]:
      result.add(i)
      pre_act = i

when isMainModule:
  let s = [1 , 3 , 0 , 5 , 8 , 5]
  let f = [2 , 4 , 6 , 7 , 9 , 9]
  for i in maxActivities(s, f).items(): echo i
