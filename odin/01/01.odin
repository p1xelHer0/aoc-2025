package aoc

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

part_1 :: proc(input: string) -> int
{
  result := 0
  dial := 50
  it := input
  for line in strings.split_lines_iterator(&it)
  {
    dir := utf8.string_to_runes(line)[0]
    rot, _ := strconv.parse_int(line[1:])
    if dir == 'L' do rot = -rot
    dial = (dial + rot) %% 100
    if dial == 0 do result += 1
  }

  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int
{
  result := 0
  dial := 50
  it := input
  for line in strings.split_lines_iterator(&it)
  {
    dir := utf8.string_to_runes(line)[0]
    rot, _ := strconv.parse_int(line[1:])
    // we rotated 1 lap or more - add them
    result += rot / 100
    /**/ if dir == 'L'
    {
      next_dial := (dial - rot) %% 100
      // we rotated backwards but next_dial > dial - we passed 0 + handle 0 later
      if next_dial > dial && dial != 0 do result += 1
      dial = next_dial
    }
    else if dir == 'R'
    {
      next_dial := (dial + rot) %% 100
      // we rotated forwards but next_dial < dial - we passed 0 + handle 0 later
      if next_dial < dial && next_dial != 0 do result += 1
      dial = next_dial
    }
    // handle 0
    if dial == 0 do result += 1
  }

  return result
}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/01.input", string)
  sample :: #load("../../input/01.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample)
  p1_sample_expected := 3
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

  p2_sample := part_2(sample)
  p2_sample_expected := 6
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

////////////////////////////////////////

// lmao
copy_to_clipboard :: proc(result: int)
{
  r, w, err := os2.pipe()
  pbcopy_process_desc := os2.Process_Desc {
    command = { "pbcopy" },
    stdin = r,
  }
  echo_process_desc := os2.Process_Desc {
    command = { "echo", fmt.tprintf("%v", result) },
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
