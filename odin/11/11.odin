package aoc

import "core:math"
// [base]
import "base:runtime"

// [core]
import "core:fmt"
import "core:os/os2"
import str "core:strings"

////////////////////////////////////////

part_1 :: proc(input: string) -> int
{
  context.allocator = context.temp_allocator
  lines := str.split_lines(str.trim(input, "\n"))
  devices := make(map[string][]string)
  for line in lines
  {
    s := str.split(line, ": ")
    id := s[0]
    devices[id] = str.fields(s[1])
  }
  solve :: proc(from, to: string, devices: map[string][]string, visits: ^map[string]int)
  {
    visits[from] += 1
    if from == to
    {
      return
    }
    for device in devices[from]
    {
      solve(device, to, devices, visits)
    }
  }
  visits := make(map[string]int)
  solve("you", "out", devices, &visits)
  result := visits["out"]
  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int
{
  context.allocator = context.temp_allocator
  lines := str.split_lines(str.trim(input, "\n"))
  devices := make(map[string][]string)
  for line in lines
  {
    s := str.split(line, ": ")
    id := s[0]
    devices[id] = str.fields(s[1])
  }
  solve :: proc(from, to: string, devices: map[string][]string, memo: ^map[[2]string]int) -> int
  {
    if from == to
    {
      return 1
    }
    path := [2]string{from, to}
    if path in memo
    {
      return memo[path]
    }
    results := make([dynamic]int, len(devices))
    for from_next in devices[from] {
      result := solve(from_next, to, devices, memo)
      memo[{from_next, to}] = result
      append(&results, result)
    }
    return math.sum(results[:])
  }
  memo := make(map[[2]string]int)
  a1 := solve("svr", "dac", devices, &memo)
  a2 := solve("dac", "fft", devices, &memo)
  a3 := solve("fft", "out", devices, &memo)

  b1 := solve("svr", "fft", devices, &memo)
  b2 := solve("fft", "dac", devices, &memo)
  b3 := solve("dac", "out", devices, &memo)

  return (a1 * a2 * a3) + (b1 * b2 * b3)
}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/11.input", string)
  sample :: #load("../../input/11.sample", string)
  sample_2 :: #load("../../input/11.2.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample)
  p1_sample_expected := 5
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
    p2_sample := part_2(sample_2)
    p2_sample_expected := 2
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
