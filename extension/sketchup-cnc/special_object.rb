module SNC

	DICTIONARY_NAME = "SketchUp CNC"

	class SpecialObject

		attr_accessor :entity, :dictionary

		def initialize(entity)
			@entity = SpecialObject.resolve_entity(entity)
			@dictionary = @entity.attribute_dictionary(DICTIONARY_NAME, true)
			@dictionary["class"] = self.class.to_s.split("::").last
		end

		def self.resolve_entity(entity)
			entity.respond_to?(:definition) ? entity.definition : entity
		end

		def self.valid?(entity)
			entity = SpecialObject.resolve_entity(entity)
			if dictionary = entity.attribute_dictionary(DICTIONARY_NAME, false)
				dictionary["class"] == self.to_s.split("::").last
			else
				false
			end
		end

		def self.load(entity)
			entity = SpecialObject.resolve_entity(entity)
			dictionary = entity.attribute_dictionary(DICTIONARY_NAME, false)
			if dictionary["class"] == self.to_s.split("::").last
				instance = self.allocate
				instance.instance_variable_set(:@entity, entity)
				instance.instance_variable_set(:@dictionary, dictionary)
				instance
			else
				raise StandardError, "Class mismatch: #{dictionary["class"].inspect}, #{self.class}"
			end
		end

	end

end
__END__
SNC::Workpiece.load(Sketchup.active_model.selection[0])