package aoc

// [base]
import "base:runtime"

// [core]
import "core:fmt"
import "core:math"
import "core:os/os2"
import "core:slice"
import "core:strconv"
import str "core:strings"

////////////////////////////////////////

Union_Find :: struct
{
  parent, set_len: []int,
  len:             int,
}

uf_init :: proc(uf: ^$U/Union_Find, size: int, allocator := context.allocator, loc := #caller_location)
{
  uf.parent = make([]int, size, allocator)
  uf.set_len = make([]int, size, allocator)
  for i in 0 ..< size
  {
    uf.parent[i] = i
    uf.set_len[i] = 1
  }
  uf.len = size
}

uf_find :: proc(uf: ^$U/Union_Find, i: int) -> int
{
  if i == uf.parent[i]
  {
    return i
  }
  uf.parent[i] = uf_find(uf, uf.parent[i])
  return uf.parent[i]
}

uf_same_set :: proc(uf: ^$U/Union_Find, i, j: int) -> bool
{
  return uf_find(uf, i) == uf_find(uf, j)
}

uf_union :: proc(uf: ^$U/Union_Find, i, j: int) -> bool
{
  if uf_same_set(uf, i, j) do return false
  i := uf_find(uf, i)
  j := uf_find(uf, j)
  if uf.set_len[i] < uf.set_len[j]
  {
    uf.set_len[j] += uf.set_len[i]
    uf.parent[i] = j
    uf.set_len[i] = 0
  }
  else
  {
    uf.set_len[i] += uf.set_len[j]
    uf.parent[j] = i
    uf.set_len[j] = 0
  }
  uf.len -= 1
  return true
}

////////////////////////////////////////

Distance :: struct
{
  dist:   f32,
  p1, p2: int,
}

distance :: proc(point: [3]int) -> f32
{
  return math.sqrt(f32(point.x * point.x + point.y * point.y + point.z * point.z))
}

part_1 :: proc(input: string, limit: int) -> int
{
  context.allocator = context.temp_allocator
  lines := str.split_lines(str.trim(input, "\n"))
  points: [dynamic][3]int
  for line in lines
  {
    point: [3]int
    for s, idx in str.split(line, sep = ",")
    {
      val, val_ok := strconv.parse_int(s); if !val_ok do _epf("failed to parse_int %v in line %v", s, line)
      point[idx] = val
    }
    append(&points, point)
  }
  distances: [dynamic]Distance
  for p1, i in points
  {
    // skip "mirrored" pair
    for p2, j in points[i+1:]
    {
      if p1 == p2 do continue
      dist := distance(p2-p1)
      append(&distances, Distance{dist, i, j+i+1})
    }
  }
  slice.sort_by(distances[:], proc(i, j: Distance) -> bool { return i.dist < j.dist })
  uf: Union_Find
  uf_init(&uf, len(points))
  for idx in 0..<limit
  {
    d := distances[idx]
    uf_union(&uf, d.p1, d.p2) or_continue
  }
  lens := slice.clone(uf.set_len[:])
  slice.sort_by(lens, proc(i, j: int) -> bool { return i > j })
  result := math.prod(lens[:3])
  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int
{
  context.allocator = context.temp_allocator
  lines := str.split_lines(str.trim(input, "\n"))
  points: [dynamic][3]int
  for line in lines
  {
    point: [3]int
    for s, idx in str.split(line, sep = ",")
    {
      val, val_ok := strconv.parse_int(s); if !val_ok do _epf("failed to parse_int %v in line %v", s, line)
      point[idx] = val
    }
    append(&points, point)
  }
  distances: [dynamic]Distance
  for p1, i in points
  {
    // skip "mirrored" pair
    for p2, j in points[i+1:]
    {
      if p1 == p2 do continue
      dist := distance(p2-p1)
      append(&distances, Distance{dist, i, j+i+1})
    }
  }
  slice.sort_by(distances[:], proc(i, j: Distance) -> bool { return i.dist < j.dist })
  uf: Union_Find
  uf_init(&uf, len(points))
  idx := 0
  d: Distance
  for uf.len > 1
  {
    defer idx += 1
    d = distances[idx]
    uf_union(&uf, d.p1, d.p2) or_continue
  }
  result := points[d.p1].x * points[d.p2].x
  return result

}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/08.input", string)
  sample :: #load("../../input/08.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample, 10)
  p1_sample_expected := 40
  fmt.printf("\033[34;1;1m// p1\033[0m -> %v\n      == %v", p1_sample, p1_sample_expected)
  if p1_sample == p1_sample_expected
  {
    part_1_result := part_1(input, 1000)
    fmt.printfln("\n      -> \033[34;1;4m%v\033[0m", part_1_result)
    copy_to_clipboard(part_1_result)
  }
  else
  {
    fmt.print("\n")
  }

  ////////////////////////////////////////

  if p1_sample == p1_sample_expected
  {
    p2_sample := part_2(sample)
    p2_sample_expected := 25272
    fmt.printf("\n\033[31;1;1m// p2\033[0m -> %v\n      == %v", p2_sample, p2_sample_expected)
    if p2_sample == p2_sample_expected
    {
      part_2_result := part_2(input)
      fmt.printf("\n      -> \033[31;1;4m%v\033[0m", part_2_result)
      copy_to_clipboard(part_2_result)
    }
    else
    {
      fmt.print("\n")
    }
  }
}

////////////////////////////////////////

// lmao
copy_to_clipboard :: proc(value: any)
{
  r, w, err := os2.pipe()
  pbcopy_process_desc := os2.Process_Desc {
    command = { "pbcopy" },
    stdin = r,
  }
  echo_process_desc := os2.Process_Desc {
    command = { "echo", fmt.tprint(value) },
    stdout = w,
  }

  echo_process, pbcopy_process: os2.Process
  state: os2.Process_State

  echo_process, err = os2.process_start(echo_process_desc)
  pbcopy_process, err = os2.process_start(pbcopy_process_desc)

  state, err = os2.process_wait(echo_process)
  os2.close(w)
  state, err = os2.process_wait(pbcopy_process)
  os2.close(r)

  err = os2.process_close(echo_process)
  err = os2.process_close(pbcopy_process)
}

_p :: fmt.println
_pf :: fmt.printfln
_epf :: fmt.eprintfln
