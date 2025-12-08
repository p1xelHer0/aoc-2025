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

Box :: struct
{
  dist: f64,
  p1: [3]int,
  p2: [3]int,
}

distance :: proc(point: [3]int) -> f64
{
  return math.sqrt(f64(point.x * point.x + point.y * point.y + point.z * point.z))
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
  box_pairs: [dynamic]Box
  for p1, i in points
  {
    for p2, j in points
    {
      if p1 == p2 do continue
      dist := distance(p2-p1)
      append(&box_pairs, Box{dist, p1, p2})
    }
  }
  slice.sort_by(box_pairs[:], proc(b1, b2: Box) -> bool { return b1.dist < b2.dist })
  result := 0
  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int
{
  return 0
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
    p2_sample_expected := 1337
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
