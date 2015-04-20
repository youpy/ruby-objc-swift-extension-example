require "hello/version"
require "hello/hello"

module Hello
  # Your code goes here...
end

class SwiftObject
  def method_missing(name, *args, &block)
    m = '__swift_' + name.to_s

    if self.methods(true).include?(m.to_sym)
      args.unshift(nil)
      self.__send__(m, *args, &block)
    else
      super
    end
  end
end
