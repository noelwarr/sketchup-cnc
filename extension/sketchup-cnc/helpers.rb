module SNC

	def self.operation(name)
		begin
			Sketchup.active_model.start_operation(name, true, false, false)
			yield
			Sketchup.active_model.commit_operation
		rescue StandardError => e
			puts e
			Sketchup.active_model.abort_operation
		end
	end

	class Container
		def self.===(obj)
			return (obj.is_a?(Sketchup::ComponentInstance) || obj.is_a?(Sketchup::Group))
		end
	end
end
