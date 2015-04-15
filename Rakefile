require "bundler/gem_tasks"

require "rake/extensiontask"

ENV['SDKROOT']=`xcodebuild -version -sdk macosx | sed -n '/^Path: /s///p'`.chomp

Rake::ExtensionTask.new("hello") do |ext|
  ext.lib_dir = "lib/hello"
end
