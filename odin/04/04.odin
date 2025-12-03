package aoc

// [core]
import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:slice"
import "core:strings"



part_1 :: proc(input: string) -> u64
{
  context.allocator = context.temp_allocator
  result: u64
  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> u64
{
  context.allocator = context.temp_allocator
  result: u64
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
  p1_sample_expected: u64 = 357
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
    p2_sample_expected: u64 = 3121910778619
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

p :: fmt.printfln
