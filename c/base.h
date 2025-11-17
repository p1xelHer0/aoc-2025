#ifndef BASE_H
#define BASE_H

#include <stdint.h>

////////////////////////////////////////

#define internal static
#define global static

////////////////////////////////////////

// Clang
#if defined(__clang__)

#  define COMPILER_CLANG 1

#  if defined(_WIN32)
#    define OS_WINDOWS 1
#  elif defined(__gnu_linux__) || defined(__linux__)
#    define OS_LINUX 1
#  elif defined(__APPLE__) && defined(__MACH__)
#    define OS_MAC 1
#  else
#    error Compiler/OS comobo not supported
#endif

// MSVC
#elif defined(_MSC_VER)

#  define COMPILER_MSVC 1

#  if defined(_WIN32)
#    define OS_WINDOWS 1
#  else
#    error Compiler/OS comobo not supported
#endif

// GCC
#elif defined(__GNUC__) || defined(__GNUG__)

#  define COMPILER_GCC 1

#  if defined(__gnu_linux__) || defined(__linux__)
#    define OS_LINUX 1
#  else
#    error Compiler/OS comobo not supported
#  endif
#endif

////////////////////////////////////////

#define Min(a, b) (((a) < (b)) ? (a) : (b))
#define Max(a, b) (((a) > (b)) ? (a) : (b))
#define ClampTop(a, X) Min(a, X)
#define ClampBot(X, b) Max(X, b)
#define Clamp(a, X, b) (((X) < (a)) ? (a) : ((X) > (b)) ? (b) : (X))

////////////////////////////////////////

#define AlignPow2(x, b) (((x) + (b) - 1) & (~((b) - 1)))

////////////////////////////////////////

#if COMPILER_MSVC
# define AlignOf(T) __alignof(T)
#elif COMPILER_CLANG
#  define AlignOf(T) __alignof(T)
#elif COMPILER_GCC
#  define AlignOf(T) __alignof__(T)
#endif

////////////////////////////////////////

#define KB(n) (((U64)(n)) << 10)
#define MB(n) (((U64)(n)) << 20)
#define GB(n) (((U64)(n)) << 30)
#define TB(n) (((U64)(n)) << 40)
#define Thousand(n) ((n) * 1000)
#define Million(n)  ((n) * 1_000_000)
#define Billion(n)  ((n) * 1_000_000_000)

////////////////////////////////////////

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
typedef int8_t   i8;
typedef int16_t  i16;
typedef int32_t  i32;
typedef int64_t  i64;
typedef i8       b8;
typedef i16      b16;
typedef i32      b32;
typedef i64      b64;
typedef float    f32;
typedef double   f64;

#endif // BASE_H
