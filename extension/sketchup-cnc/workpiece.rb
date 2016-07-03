module SNC

	class Workpiece

		def initialize(definition)
			@definition = definition
		end

		def dimensions
			bb = Geom::BoundingBox.new
			@definition.entities.each{|ent| bb.add ent.bounds }
			{
				x: bb.width,
				y: bb.height,
				z: bb.depth
			}
		end

		def name
			@definition.name.split(":").last
		end

		def operations
			find_operations_recursively(@definition.entities)
		end

		private

		def find_operations_recursively(entities, xform = Geom::Transformation.new, operations = Set.new)
			entities.grep(Sketchup::Text){|text|
				operations.add(Operation.new(text))
			}
			entities.grep(Container){|container|
				next_xform = container.transformation
				entities = container.definition.entities
				find_operations_recursively(container.definition.entities, xform * container.transformation, operations)
			}
			operations
		end

		def self.valid?(definition)
			definition.name[/^\d+:/] != nil
		end

	end

end