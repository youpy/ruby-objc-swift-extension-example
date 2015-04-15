@objc class Hello: NSObject {
    func greeting() -> VALUE {
        return rb_str_new_cstr("hello from Swift")
    }
}
