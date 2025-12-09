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

part_1 :: proc(input: string, limit: int) -> int
{
  context.allocator = context.temp_allocator
  lines := str.split_lines(str.trim(input, "\n"))
  points: [dynamic][2]int
  for line in lines
  {
    point: [2]int
    for s, idx in str.split(line, sep = ",")
    {
      val, val_ok := strconv.parse_int(s); if !val_ok do _epf("failed to parse_int %v in line %v", s, line)
      point[idx] = val
    }
    append(&points, point)
  }
  result := 0
  for p1 in points
  {
    for p2 in points
    {
      if p1 == p2
      {
        continue
      }
      dist := p2 - p1
      area := (abs(dist.x) + 1) * (abs(dist.y) + 1)
      result = max(result, area)
    }
  }
  return result
}

////////////////////////////////////////

Node :: struct
{
  dist: [2]int,
  p1_idx: int,
  p2_idx: int,
}

part_2 :: proc(input: string) -> int
{
  context.allocator = context.temp_allocator
  lines := str.split_lines(str.trim(input, "\n"))
  points: [dynamic][2]int
  for line in lines
  {
    point: [2]int
    for s, idx in str.split(line, sep = ",")
    {
      val, val_ok := strconv.parse_int(s); if !val_ok do _epf("failed to parse_int %v in line %v", s, line)
      point[idx] = val
    }
    append(&points, point)
  }
  distances: [dynamic]Node
  for p1, i in points
  {
    for p2, j in points
    {
      if p1 == p2
      {
        continue
      }
      dist := p2 - p1
      x := abs(dist.x) + 1
      y := abs(dist.y) + 1
      node := Node {
        dist = [2]int{x, y},
        p1_idx = i,
        p2_idx = j,
      }
      append_elem(&distances, node)
    }
  }
  // largest area first
  slice.sort_by(distances[:], proc(a, b: Node) -> bool { return a.dist.x * a.dist.y > b.dist.x * b.dist.y })
  result := (distances[0].dist.x) * (distances[0].dist.y)
  return result

}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/09.input", string)
  sample :: #load("../../input/09.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample, 10)
  p1_sample_expected := 50
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
    p2_sample_expected := 24
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
