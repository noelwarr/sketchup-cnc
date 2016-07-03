# Create an entry in the Extension list that loads a script called
# main.rb.
require "sketchup.rb"
require "extensions.rb"

extension = SketchupExtension.new("SketchUp CNC", "sketchup-cnc/main.rb")
extension.version = "1.0"
extension.description = "SketchUp toolpath generation for use with CNC machines"
extension.copyright = "fdas"
extension.creator = "fdsa"
Sketchup.register_extension(extension, true)