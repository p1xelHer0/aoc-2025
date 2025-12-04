package aoc

// [base]
import "base:runtime"

// [core]
import "core:fmt"
import "core:os/os2"
import "core:strings"

////////////////////////////////////////

neighbours := [8][2]int {
  {-1, -1}, {0, -1}, {1, -1},
  {-1,  0},          {1,  0},
  {-1,  1}, {0,  1}, {1,  1},
}

////////////////////////////////////////

part_1 :: proc(input: string) -> int
{
  context.allocator = context.temp_allocator
  result := 0
  lines := strings.split_lines(strings.trim(input, "\n"))
  w := len(lines[0]) // all lines are the same width
  h := len(lines)
  paper := make(map[[2]int]bool, w * h)
  for x in 0 ..< w
  {
    for y in 0 ..< h
    {
      if lines[y][x] == '@'
      {
        paper[{x, y}] = true
      }
    }
  }
  for p in paper
  {
    roll := 0
    for n in neighbours
    {
      if paper[p+n]
      {
        roll += 1
      }
    }
    if roll < 4
    {
      result += 1
    }
  }
  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int
{
  context.allocator = context.temp_allocator
  result := 0
  lines := strings.split_lines(strings.trim(input, "\n"))
  w := len(lines[0]) // all lines are the same width
  h := len(lines)
  paper := make(map[[2]int]bool, w * h)
  for x in 0 ..< w
  {
    for y in 0 ..< h
    {
      if lines[y][x] == '@'
      {
        paper[{x, y}] = true
      }
    }
  }
  kinda_part_1 :: proc(paper: ^map[[2]int]bool) -> int
  {
    result := 0
    removed := make([dynamic][2]int)
    for p in paper
    {
      roll := 0
      for n in neighbours
      {
        if paper[p+n]
        {
          roll += 1
        }
      }
      if roll < 4
      {
        result += 1
        append(&removed, p)
      }
    }
    for r in removed
    {
      paper[r] = false
    }
    return result
  }
  for
  {
    current_result := kinda_part_1(&paper)
    if current_result == result do break
    result = current_result
  }
  return result
}


////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/04.input", string)
  sample :: #load("../../input/04.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample)
  p1_sample_expected := 13
  fmt.printf("\033[34;1;1m// p1\033[0m -> %v\n      == %v", p1_sample, p1_sample_expected)
  if p1_sample == p1_sample_expected
  {
    part_1_result := part_1(input)
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
    p2_sample_expected := 43
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
