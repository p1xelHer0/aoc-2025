// [stdlib]
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// [h]
#include "base.h"

enum {BUDGET_INPUT = 10000};

typedef i32 item;
typedef struct Buffer Buffer;
struct Buffer
{
  item items[BUDGET_INPUT];
  u64 len;
};

void
add_input(Buffer *inputs, u64 item)
{
  inputs->items[inputs->len++] = item;
}

int
cmp(const void *a, const void *b)
{
  return *(item *)a - *(item *)b;
}

global Buffer LEFT = {0};
global Buffer RIGHT = {0};

u64
part_1(FILE *input)
{
  u32 l, r;
  while(fscanf(input, "%d   %d\n", &l, &r) != EOF)
  {
    add_input(&LEFT, l);
    add_input(&RIGHT, r);
  }
  assert(LEFT.len == RIGHT.len);

  qsort(LEFT.items, LEFT.len, sizeof(u32), cmp);
  qsort(RIGHT.items, RIGHT.len, sizeof(u32), cmp);

  u64 result = 0;
  i32 diff = 0;
  for(int i = 0; i < LEFT.len; i++)
  {
    u32 l = LEFT.items[i];
    u32 r = RIGHT.items[i];
    diff = l - r;
    result += abs(diff);
  }

  return result;
}

u64
part_2(FILE *input)
{
  u64 result = 0;
  return result;
}

int
main(int argc, char *argv[])
{
  char sample_file[] = "../input/01.sample";
  char input_file[] = "../input/01.input";

  FILE *sample_input = fopen(sample_file, "r");
  FILE *input = fopen(input_file, "r");

  assert(part_1(sample_input) == 11);
  printf("part_1: %llu\n", part_1(input));

  assert(part_2(sample_input) == 31);
  printf("part_2: %llu\n", part_2(input));

  return 0;
}
