module SNC

	class CNCMachine

		attr_accessor :config

		def initialize(config_file)
			load_config(config_file)
		end

		def load_config(config_file)
			path = File.join(__dir__, "machines", config_file)
			@config = JSON.parse(File.read(path), symbolize_names: true)
		end

		def generate_jobs(workpiece)
			job = Job.new("job01_01")
			job << generate_header(workpiece) << "\n"
			workpiece.operations.each{|operation|				
				params = operation.params
				operation.steps.each{|step|
					job << generate_step(step, operation.params) << "\n"
				}
			}
			job << generate_footer(workpiece)
			[job]
		end

		private

		def generate_header(workpiece)
			header = config[:postProcessor][:jobHeader].join("\n")
			dimensions = workpiece.dimensions
			header.gsub!("<WORKPIECE_NAME>", workpiece.name)
			header.gsub!("<WORKPIECE_X>", dimensions[:x].to_mm.round(2).to_s)
			header.gsub!("<WORKPIECE_Y>", dimensions[:y].to_mm.round(2).to_s)
			header.gsub!("<WORKPIECE_Z>", dimensions[:z].to_mm.round(2).to_s)
			cleanup_variables(header)
		end

		def generate_footer(workpiece)
			footer = config[:postProcessor][:jobFooter].join("\n")
			cleanup_variables(footer)
		end

		def generate_step(step, params)
			gcode = config[:postProcessor][step[:type]].join("\n")
			x, y, z = step[:vertex].position.to_a
			gcode.gsub!("<X>", x.to_mm.round(2).to_s)
			gcode.gsub!("<Y>", y.to_mm.round(2).to_s)
			gcode.gsub!("<Z>", z.to_mm.round(2).to_s)
			params.each{|k,v|
				v ||= config[:postProcessor][:flags][k.to_sym]
				gcode.gsub!("<USERDATA_#{k}>", v)
			}
			cleanup_variables(gcode)
		end

		def cleanup_variables(gcode)
			gcode.gsub!( /<(.*?)>/, "")
			gcode
		end

	end

end