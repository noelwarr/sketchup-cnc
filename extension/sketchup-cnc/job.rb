module SNC

	class Job < String

		def initialize(name)
			@name = name
		end

		def save(path)
			FileUtils.mkdir_p(path)
			File.open(File.join(path, @name), "w"){|file|
				file.write self
			}
		end

	end

end