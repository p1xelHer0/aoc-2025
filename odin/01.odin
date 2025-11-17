package aoc

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:testing"

////////////////////////////////////////

parse_line :: proc(line: string) -> (int, int)
{
  strs := strings.split(line, "  ", context.temp_allocator)
  left, _ := strconv.parse_int(strs[0])
  right, _ := strconv.parse_int(strs[1])
  return left, right
}

////////////////////////////////////////

part_1 :: proc(input: string) -> int
{
  left := make([dynamic]int, 0, context.temp_allocator)
  right := make([dynamic]int, 0, context.temp_allocator)

  it := input
  for line in strings.split_lines_iterator(&it)
  {
    r1, r2 := parse_line(line)
    append(&left, r1)
    append(&right, r2)
  }
  slice.sort(left[:])
  slice.sort(right[:])

  result := 0
  for _, idx in left
  {
    result += abs(left[idx] - right[idx])
  }

  return result
}

////////////////////////////////////////

part_2 :: proc(input: string) -> int
{
  left := make([dynamic]int, 0, context.temp_allocator)
  right := make([dynamic]int, 0, context.temp_allocator)

  it := input
  for line in strings.split_lines_iterator(&it)
  {
    r1, r2 := parse_line(line)
    append(&left, r1)
    append(&right, r2)
  }

  similarity_lookup := make(map[int]int, context.temp_allocator)
  for loc_id in right
  {
    similarity := similarity_lookup[loc_id] or_else 0
    similarity_lookup[loc_id] = similarity + 1
  }

  result := 0
  for loc_id in left
  {
    similarity := similarity_lookup[loc_id] or_else 0
    result += similarity * loc_id
  }

  return result
}

////////////////////////////////////////

@(test)
test :: proc(t: ^testing.T)
{
  sample :: #load("../input/01.sample", string)

  testing.expect_value(t, part_1(sample), 11)
  testing.expect_value(t, part_2(sample), 31)
}

main :: proc()
{
  input :: #load("../input/01.input", string)

  fmt.printfln("Part 1: %d", part_1(input))
  fmt.printfln("Part 2: %d", part_2(input))
}
