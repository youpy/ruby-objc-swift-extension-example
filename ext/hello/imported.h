#ifndef IMPORTED_H
#define IMPORTED_H

#include "ruby.h"
#import <Foundation/Foundation.h>

char *__rbString2CString(VALUE);
void __rbInspect(VALUE rbVal);
VALUE __Data_Wrap_Struct(VALUE klass, const char *description, RUBY_DATA_FUNC free);
const char *__Data_Get_Struct(VALUE obj);

struct mytype {
  const char *description;
};

#endif
