package aoc

// [base]
import "base:runtime"

// [core]
import "core:fmt"
import "core:os/os2"
import "core:slice"
import "core:strconv"
import str "core:strings"
import "core:math"

////////////////////////////////////////

Range :: struct
{
  min: int,
  max: int,
}

////////////////////////////////////////

part_1 :: proc(input: string) -> int
{
  context.allocator = context.temp_allocator
  it := str.split_lines(str.trim(input, "\n"))
  w := len(it) - 1 // each line has the amount of fields
  problems: map[int][dynamic]int
  for row in it[:w]
  {
    for field, idx in str.fields(row)
    {
      val, val_ok := strconv.parse_int(field); if !val_ok do fmt.eprintfln("Failed to parse_int val %v in row %v", val, row)
      p := problems[idx] or_else {}
      append(&p, val)
      problems[idx] = p
    }
  }
  result := 0
  for op, idx in str.fields(it[w])
  {
    r := 0
    p := problems[idx][:]
    switch op {
    case "*":
      r = math.prod(p)
    case "+":
      r = math.sum(p)
    }
    result += r
  }

  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int {
  context.allocator = context.temp_allocator
  it := str.split_lines(str.trim(input, "\n"))
  w := len(it) - 1 // each line has the amount of fields
  problems: map[int][dynamic]int
  for r in it[:w]
  {
    for field, idx in str.fields(r)
    {
      val, val_ok := strconv.parse_int(field); if !val_ok do fmt.eprintfln("Failed to parse_int val %v in row %v", val, r)
      p := problems[idx] or_else {}
      append(&p, val)
      problems[idx] = p
    }
  }
  result := 0
  for op, idx in str.fields(it[w])
  {
    r := 0
    p := problems[idx][:]
    _pf("%v: %v", p, op)
    switch op {
    case "*":
      r = math.prod(p)
    case "+":
      r = math.sum(p)
    }
    result += r
  }

  return result

}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/06.input", string)
  sample :: #load("../../input/06.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample)
  p1_sample_expected := 4277556
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
    p2_sample_expected := 3263827
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
