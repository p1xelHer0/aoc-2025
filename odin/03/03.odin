package aoc

// [core]
import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

// find the earliest largest number
// lmao `slice.max_index` exists :) TIL
find_max :: proc(line: string) -> (int, int)
{
  max, idx: int
  for c, c_idx in line
  {
    n, n_ok := strconv.digit_to_int(c)
    if !n_ok
    {
      fmt.eprintfln("Failed to convert digit `%v` in string `%v` to int", c, line)
    }
    if n > max
    {
      max = n
      idx = c_idx
    }
  }
  return max, idx
}

part_1 :: proc(input: string) -> u64
{
  context.allocator = context.temp_allocator
  result: u64
  trimmed_input := strings.trim(input, "\n")
  for line in strings.split_lines(trimmed_input)
  {
    // skip the last number
    j1, j1_idx := find_max(line[:len(line)-1])
    // continue right after the first max value
    j2, _ := find_max(line[j1_idx+1:])
    result += u64(j1) * 10 + u64(j2)
  }
  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> u64
{
  context.allocator = context.temp_allocator
  result: u64
  trimmed_input := strings.trim(input, "\n")
  for line in strings.split_lines(trimmed_input)
  {
    val, idx := find_max(line[:len(line)-(12-1)])
    for i in 1 ..< 12
    {
      // don't look for the same digit again
      idx += 1
      // continue right after the first max value
      // but make sure we can fit at least 11 more digits
      val_next, idx_next := find_max(line[idx:len(line)-(11-i)])
      // contines next loop searching efter the newly found digit
      idx = idx + idx_next
      val = val * 10 + val_next
    }
    result += u64(val)
  }
  return result
}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/03.input", string)
  sample :: #load("../../input/03.sample", string)

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
