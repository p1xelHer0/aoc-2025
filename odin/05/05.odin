package aoc

// [base]
import "base:runtime"

// [core]
import "core:fmt"
import "core:os/os2"
import "core:slice"
import "core:strconv"
import "core:strings"

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
  fresh_ids: [dynamic]Range
  ids: [dynamic]int
  fresh: map[int]bool
  splitted := strings.split(strings.trim(input, "\n"), "\n\n")
  fresh_ranges := strings.trim(splitted[0], "\n")
  for line in strings.split_iterator(&fresh_ranges, "\n")
  {
    split_line, split_line_err := strings.split(line, sep = "-"); if split_line_err != nil do fmt.printfln("split failed: %v", split_line_err)
    min, min_ok := strconv.parse_int(split_line[0]); if !min_ok do fmt.printfln("min parse failed for line: `%v`", line)
    max, max_ok := strconv.parse_int(split_line[1]); if !max_ok do fmt.printfln("max parse failed for line: `%v`", line)
    append(&fresh_ids, Range{min, max})
  }
  ingredients := strings.trim(splitted[1], "\n")
  for line in strings.split_iterator(&ingredients, "\n")
  {
    id, id_ok := strconv.parse_int(line); if !id_ok do fmt.printfln("id parse failed for line: `%v`", line)
    for f in fresh_ids
    {
      if id >= f.min && id <= f.max // read: inclusive
      {
        fresh[id] = true
      }
    }
  }
  return len(fresh)
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int {
  context.allocator = context.temp_allocator
  fresh_ids: [dynamic]Range
  splitted := strings.split(strings.trim(input, "\n"), "\n\n")
  fresh_ranges := strings.trim(splitted[0], "\n")
  for line in strings.split_iterator(&fresh_ranges, "\n")
  {
    split_line, split_line_err := strings.split(line, sep = "-"); if split_line_err != nil do fmt.printfln("split failed: %v", split_line_err)
    min, min_ok := strconv.parse_int(split_line[0]); if !min_ok do fmt.printfln("min parse failed for line: `%v`", line)
    max, max_ok := strconv.parse_int(split_line[1]); if !max_ok do fmt.printfln("max parse failed for line: `%v`", line)
    append(&fresh_ids, Range{min, max})
  }
  // sort ranges by minimum value, this way we can check overlaps without multiple loops
  slice.sort_by(fresh_ids[:], proc(a, b: Range) -> bool { return a.min < b.min })
  unique_ranges: [dynamic]Range
  range := fresh_ids[0]
  for i := 1; i < len(fresh_ids); i += 1
  {
    next_range := fresh_ids[i]
    if range.max >= next_range.min
    {
      // {1, 4} {2, 7} -> {1, 7}
      // {1, 4} {2, 3} -> {1, 4}
      // discard next_range and update range's new max, "connect" the ranges
      range.max = max(next_range.max, range.max)
    }
    else
    {
      // no overlap, it's unique
      // {1, 4} {5, 7} -> {1, 4}
      append(&unique_ranges, range)
      // continue with {5, 7}
      range = next_range
    }
  }
  // don't forget the last one :)
  append(&unique_ranges, range)
  result := 0
  for id in unique_ranges
  {
    result += id.max - id.min + 1 // read, again: inclusive
  }
  return result
}

////////////////////////////////////////

main :: proc()
{
  input :: #load("../../input/05.input", string)
  sample :: #load("../../input/05.sample", string)

  ////////////////////////////////////////

  // very cute we'll see how long this lasts...
  fmt.println("\033[2J")
  p1_sample := part_1(sample)
  p1_sample_expected := 3
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
