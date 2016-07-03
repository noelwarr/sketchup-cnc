module SNC

	class PostProcessor

		def initialize(config)
			@config = config
		end

		def generate_header()
			header = @config[:jobHeader].join("\n")
			dimensions = workpiece.dimensions
			header.gsub("${WORKPIECE_NAME}", workpiece.name)
			header.gsub("${WORKPIECE_X}", dimensions[:x])
			header.gsub("${WORKPIECE_Y}", dimensions[:y])
			header.gsub("${WORKPIECE_Z}", dimensions[:z])