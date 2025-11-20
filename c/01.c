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
add_input(Buffer *buffer, item item)
{
  buffer->items[buffer->len++] = item;
}

int
cmp_item(const void *a, const void *b)
{
  return *(item *)a - *(item *)b;
}

global Buffer LEFT = {0};
global Buffer RIGHT = {0};

u64
part_1(char file_path[])
{
  FILE *input = fopen(file_path, "r");
  item l, r;
  while(fscanf(input, "%d   %d\n", &l, &r) != EOF)
  {
    add_input(&LEFT, l);
    add_input(&RIGHT, r);
  }
  qsort(LEFT.items, LEFT.len, sizeof(item), cmp_item);
  qsort(RIGHT.items, RIGHT.len, sizeof(item), cmp_item);

  u64 result = 0;
  i32 diff = 0;
  for(u64 i = 0; i < LEFT.len; i++)
  {
    item l = LEFT.items[i];
    item r = RIGHT.items[i];
    diff = l - r;
    result += (u64)abs(diff);
  }

  LEFT.len = 0;
  RIGHT.len = 0;
  fclose(input);
  return result;
}

u64
part_2(char file_path[])
{
  FILE *input = fopen(file_path, "r");
  item l, r;
  while(fscanf(input, "%d   %d\n", &l, &r) != EOF)
  {
    add_input(&LEFT, l);
    add_input(&RIGHT, r);
  }

  u64 result = 0;

  LEFT.len = 0;
  RIGHT.len = 0;
  fclose(input);
  return result;
}

int
main(int argc, char *argv[])
{
  char sample_file[] = "../input/01.sample";
  char input_file[] = "../input/01.input";

  printf("part_1: %llu\n", part_1(input_file));
  assert(part_1(sample_file) == 11);

  printf("part_2: %llu\n", part_2(input_file));
  assert(part_2(sample_file) == 31);

  return 0;
}
