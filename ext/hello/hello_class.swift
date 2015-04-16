typealias RbMethod = @objc_block (Int32, UnsafeMutablePointer<VALUE>, VALUE) -> VALUE
typealias RbMethodPointer = CFunctionPointer<(() -> VALUE)>

class RbInternal: NSObject {
    static func initRb() {
        var rb_mHello = rb_define_module("Hello")
        var rb_cWorld = rb_define_class_under(rb_mHello, "World", rb_cObject)

        self.defineMethodWithVariableArguments(
            rb_cWorld, name:"greeting", block:{
                (argc, argv, _self) in
                return Hello().greeting()
            }
        )
    }

    static func defineMethodWithVariableArguments(klass: VALUE, name: String, block: RbMethod) {
        rb_define_method(klass, name, self.convertBlock2RbMethodPointer(block), -1)
    }

    // http://stackoverflow.com/a/29375116
    static func convertBlock2RbMethodPointer(block: RbMethod) -> RbMethodPointer {
        var imp: COpaquePointer = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
        var callback: RbMethodPointer = unsafeBitCast(imp, RbMethodPointer.self)

        return callback
    }
}

class Hello: NSObject {
    func greeting() -> VALUE {
        return rb_str_new_cstr("hello from Swift")
    }
}
