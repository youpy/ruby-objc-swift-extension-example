typealias RbMethodPointer = CFunctionPointer<(() -> VALUE)>
typealias RbFreePointer = CFunctionPointer<((UnsafeMutablePointer<Void>) -> Void)>

typealias RbMethod0 = @objc_block (VALUE) -> VALUE
typealias RbMethod1 = @objc_block (VALUE, VALUE) -> VALUE
typealias RbMethod2 = @objc_block (VALUE, VALUE, VALUE) -> VALUE
// RbMethod3, RbMethod4...

typealias RbFree = @objc_block (UnsafePointer<mytype>) -> Void

class RbInternal: NSObject {
    static func initRb() {
        let rb_mHello = rb_define_module("Hello")
        let rb_cSwiftObject = rb_define_class("SwiftObject", rb_cObject)
        let rb_cWorld = rb_define_class_under(rb_mHello, "World", rb_cSwiftObject)

        var pool = [String: Hello]()

        let rb_free: RbFree = {
            (mytype) in
            let description = String.fromCString(mytype.memory.description)

            free(unsafeBitCast(mytype, UnsafeMutablePointer<Void>.self))
            pool.removeValueForKey(description!)

            NSLog("rb_free(): pool count: %d", pool.count)
        }

        let greeting: RbMethod1 = {
            (_self, name) in
            let description = String.fromCString(__Data_Get_Struct(_self))
            let hello: Hello = pool[description!]!

            return self.string2RbString(
                       hello.greeting(self.rbString2String(name)!)
                   )
        }

        let new: RbMethod0 = {
            (_self) in
            var hello = Hello()
            var val:VALUE = __Data_Wrap_Struct(rb_cWorld, (hello.description as NSString).UTF8String, self.convertBlock2RbMethodPointer(rb_free))

            pool[hello.description] = hello

            return val
        }

        self.defineMethod(rb_cWorld, name:"greeting", block:greeting)

        // TODO: fix arguments
        self.defineSingletonMethod(rb_cWorld, name:"new", block:new)
    }

    static func defineMethod<T>(klass: VALUE, name: String, block: T) {
        rb_define_method(klass, "__swift_\(name)", self.convertBlock2RbMethodPointer(block), self.getArgc(block))
    }

    static func defineSingletonMethod<T>(klass: VALUE, name: String, block: T) {
        rb_define_singleton_method(klass, name, self.convertBlock2RbMethodPointer(block), self.getArgc(block))
    }

    // http://stackoverflow.com/a/29375116
    static func convertBlock2RbMethodPointer<T, R>(block: T) -> R {
        let imp: COpaquePointer = imp_implementationWithBlock(unsafeBitCast(block, AnyObject.self))
        let callback: R = unsafeBitCast(imp, R.self)

        return callback
    }

    static func rbString2String(rbStr: VALUE) -> String? {
        return String.fromCString(__rbString2CString(rbStr))
    }

    static func string2RbString(str: String) -> VALUE {
        return rb_str_new_cstr(str)
    }

    static func getArgc<T>(block: T) -> Int32 {
        let argc: Int32

        switch block {
        case is RbMethod0:
            argc = 1
            break
        case is RbMethod1:
            argc = 2
            break
        case is RbMethod2:
            argc = 3
            break
        default:
            argc = 0
        }

        return argc
    }
}

class Hello: NSObject {
    func greeting(name: String?) -> String {
        return "hello, \(name!)!"
    }
}
