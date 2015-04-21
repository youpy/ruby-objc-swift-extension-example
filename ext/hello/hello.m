#include "hello.h"
#include "imported.h"

VALUE __Data_Wrap_Struct(VALUE klass, const char *description, RUBY_DATA_FUNC free)
{
  struct mytype *m = malloc(sizeof(struct mytype));
  m->description = description;
  return Data_Wrap_Struct(klass, 0, free, m);
}

const char *__Data_Get_Struct(VALUE obj)
{
  struct mytype *m;
  Data_Get_Struct(obj, struct mytype, m);

  return m->description;
}

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
