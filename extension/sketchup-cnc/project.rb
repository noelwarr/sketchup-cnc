module SNC

	class Project

		def initialize(model)
			@workpieces = Hash.new
			model.definitions.each{|definition|
				if Workpiece.valid?(definition)
					workpiece = Workpiece.new(definition)
					@workpieces[workpiece] = CNC_MACHINE.generate_jobs(workpiece)
				end
			}
		end

		def save(path)
			FileUtils.rm_r(path) if File.exist?(path)
			FileUtils.mkdir(path)
			@workpieces.each{|workpiece, jobs|
				jobs.each{|job|
					workpiece_path = File.join(path, workpiece.name)
					job.save(workpiece_path)
				}
			}
		end

	end

end