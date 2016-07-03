require "fileutils"
require "json"
require "set"
require_relative "helpers"
require_relative "commands"
require_relative "menu"
require_relative "workpiece"
require_relative "operation"
require_relative "project"
require_relative "cnc_machine"
require_relative "job"

module SNC

	CNC_MACHINE = CNCMachine.new("busellato.json")

end