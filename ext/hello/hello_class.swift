typealias RbMethodPointer = CFunctionPointer<(() -> VALUE)>
typealias RbMethod0 = @objc_block (VALUE) -> VALUE
typealias RbMethod1 = @objc_block (VALUE, VALUE) -> VALUE
typealias RbMethod2 = @objc_block (VALUE, VALUE, VALUE) -> VALUE
// RbMethod3, RbMethod4...

class RbInternal: NSObject {
    static func initRb() {
        let rb_mHello = rb_define_module("Hello")
        let rb_cSwiftObject = rb_define_class("SwiftObject", rb_cObject)
        let rb_cWorld = rb_define_class_under(rb_mHello, "World", rb_cSwiftObject)

        let block: RbMethod1 = {
            (_self, name) in
            return self.string2RbString(
                       Hello().greeting(self.rbString2String(name)!)
                   )
        }
        self.defineMethod(rb_cWorld, name:"greeting", block:block)
    }

    static func defineMethod<T>(klass: VALUE, name: String, block: T) {
        let argc: Int32

        switch block {
        case is RbMethod0:
            argc = 1
        case is RbMethod1:
            argc = 2
        case is RbMethod2:
            argc = 3
        default:
            argc = 0
        }

        rb_define_method(klass, "__swift_\(name)", self.convertBlock2RbMethodPointer(block), argc)
    }

    // http://stackoverflow.com/a/29375116
    static func convertBlock2RbMethodPointer<T>(block: T) -> RbMethodPointer {
        let imp: COpaquePointer = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
        let callback: RbMethodPointer = unsafeBitCast(imp, RbMethodPointer.self)

        return callback
    }

    static func rbString2String(rbStr: VALUE) -> String? {
        return String.fromCString(__rbString2CString(rbStr))
    }

    static func string2RbString(str: String) -> VALUE {
        return rb_str_new_cstr(str)
    }
}

class Hello: NSObject {
    func greeting(name: String?) -> String {
        return "hello, \(name!)!"
    }
}
