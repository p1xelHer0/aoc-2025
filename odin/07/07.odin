package aoc

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
  beams: map[int]bool
  for c, idx in lines[0]
  {
    if c == 'S'
    {
      beams[idx] = true
      break
    }
  }
  result := 0
  for line in lines[1:len(lines)-1]
  {
    for c, idx in line
    {
      if c == '^'
      {
        if beams[idx]
        {
          result += 1
          beams[idx] = false
          beams[idx+1] = true
          beams[idx-1] = true
        }
      }
    }
  }
  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int {
  return 0
}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/07.input", string)
  sample :: #load("../../input/07.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample)
  p1_sample_expected := 21
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
    p2_sample_expected := 14
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
