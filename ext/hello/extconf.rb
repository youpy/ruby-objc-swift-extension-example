require "mkmf"

$LDFLAGS << " -L/Library/Developer/CommandLineTools/usr/lib/swift_static/macosx -lswiftRuntime"
$objs = %w/hello.o hello_class.o/

create_makefile("hello/hello")
