#include "hello.h"

char *__rbString2CString(VALUE rbStr)
{
  return StringValuePtr(rbStr);
}

void __rbInspect(VALUE rbVal)
{
  VALUE ins = rb_inspect(rbVal);
  printf("%lu\t%s\n", rbVal, StringValuePtr(ins));
}

void Init_hello(void)
{
  [RbInternal initRb];
}
