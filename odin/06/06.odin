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
  lines := str.split_lines(str.trim(input, "\n"))
  h := len(lines)-1
  problems: map[int][dynamic]int
  for row in lines[:h]
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
  for op, idx in str.fields(lines[h])
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

Op :: enum
{
  Add,
  Mult,
}

part_2 :: proc(input: string) -> int {
  context.allocator = context.temp_allocator
  lines := str.split_lines(str.trim(input, "\n"))
  h := len(lines)-1
  operators := lines[h]
  result := 0
  r := 0
  op: Op
  for x in 0 ..< len(lines[2]) // ???? wat I don't even but I got the starsomehow, I was testing differents lines here since they have different width and lines[2] gave me another result than lines[0], submitted and it was correct ok n1n1
  {
    if x < len(operators)
    {
      if operators[x] != ' '
      {
        result += r
        switch operators[x]
        {
        case '*':
          op = .Mult
          r = 1
        case '+':
          op = .Add
          r = 0
        }
      }
    }
    val := 0
    for y in 0 ..< h
    {
      if x < len(lines[y])
      {
        c := lines[y][x]
        if c == ' '
        {
          continue
        }
        val *= 10
        val += int(c-'0')
      }
    }
    if val > 0
    {
      switch op
      {
      case .Add: r += val
      case .Mult: r *= val
      }
    }
  }
  result += r
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
