package aoc

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

part_1 :: proc(input: string) -> i64
{
  result: i64
  it := input[:len(input) - 1] // fml holy shit strconv fails parse trailing \n :)
  for line in strings.split(it, sep = ",")
  {
    splitted, splitted_err := strings.split(line, sep = "-"); if splitted_err != nil do fmt.printfln("split failed: %v", splitted_err)
    l, l_ok := strconv.parse_i64_of_base(splitted[0], base = 10); if !l_ok do fmt.printfln("l parse failed: `%v`", splitted[0])
    r, r_ok := strconv.parse_i64_of_base(splitted[1], base = 10); if !r_ok do fmt.printfln("r parse failed: `%v`", splitted[1])
    for n in l ..= r
    {
      n_str := fmt.tprint(n)
      n_str_len := len(n_str)
      half := n_str_len / 2
      if n_str_len %% 2 == 0 && n_str[:half] == n_str[half:]
      {
        result += n
      }
    }
  }

  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> i64
{
  result: i64
  it := input[:len(input) - 1] // again
  for line in strings.split(it, sep = ",")
  {
    splitted, splitted_err := strings.split(line, sep = "-"); if splitted_err != nil do fmt.printfln("split failed: %v", splitted_err)
    l, l_ok := strconv.parse_i64_of_base(splitted[0], base = 10); if !l_ok do fmt.printfln("l parse failed: `%v`", splitted[0])
    r, r_ok := strconv.parse_i64_of_base(splitted[1], base = 10); if !r_ok do fmt.printfln("r parse failed: `%v`", splitted[1])
    for n in l ..= r
    {
      n_str := fmt.tprint(n)
      n_str_len := len(n_str)
    }
  }

  return result
}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/02.input", string)
  sample :: #load("../../input/02.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample)
  p1_sample_expected: i64 = 1227775554
  fmt.printf("\033[34;1;1m// p1\033[0m -> %v == %v", p1_sample, p1_sample_expected)
  if p1_sample == p1_sample_expected
  {
    part_1_result := part_1(input)
    fmt.printfln(" -> \033[34;1;4m%v\033[0m", part_1_result)
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
    p2_sample_expected: i64 = 4174379265
    fmt.printf("\n\033[31;1;1m// p2\033[0m -> %v == %v", p2_sample, p2_sample_expected)
    if p2_sample == p2_sample_expected
    {
      part_2_result := part_2(input)
      fmt.printf(" -> \033[31;1;4m%v\033[0m\n", part_2_result)
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
