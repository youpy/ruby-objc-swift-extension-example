#ifndef IMPORTED_H
#define IMPORTED_H

#include "ruby.h"
#import <Foundation/Foundation.h>

char *__rbString2CString(VALUE);
void __rbInspect(VALUE rbVal);

#endif
