#include "hello.h"

VALUE rb_mHello;
VALUE rb_cWorld;

VALUE cWorld_greeting(int argc, VALUE *argv, VALUE self)
{
  return [[[Hello alloc] init] greeting];
}

void Init_hello(void)
{
  rb_mHello = rb_define_module("Hello");
  rb_cWorld = rb_define_class_under(rb_mHello, "World", rb_cObject);
  rb_define_method(rb_cWorld, "greeting", cWorld_greeting, -1);
}
