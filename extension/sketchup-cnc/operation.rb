module SNC

	class Operation

		def initialize(entity)
			@entity = entity
		end

		def index
			@entity.text[/^\d+/].to_i
		end

		def steps
			if vertex = find_vertex(@entity.point)
				steps = [{
					type: :toolPathStart,
					vertex: vertex
				}]
				find_all_steps(steps, @entity.vector.reverse)
				return steps
			else
				raise "No vertex found for #{@point}.  Holes are not yet suported"
			end
		end

		def params
			hash = {}
			@entity.text.split(":")[1].split(" ").each{|str|
				if str.length == 1
					hash[str[0].upcase] = nil
				elsif str.length > 1
					hash[str[0].upcase] = str[1..-1]
				end
			}
			hash
		end

		private

		def find_vertex(point)
			@entity.parent.entities.grep(Sketchup::Edge){|edge|
				if point == edge.start.position
					return edge.start
				elsif point == edge.end.position
					return edge.end
				end
			}
			raise "Could not find vertex for #{point}"
		end

		def find_all_steps(steps, last_vector)
			last_vertex = steps.last[:vertex]
			edges = last_vertex.edges
			vertices = edges.collect{|e| 
				e.other_vertex(last_vertex) if !e.soft? && !e.smooth? && !e.hidden?
			}.compact
			vertices.sort!{|vertex|
				vector = last_vertex.position.vector_to(vertex.position)
				vector.angle_between(last_vector)
			}
			vertices.each{|vertex|
				if !would_cause_loop?(steps, vertex)
					steps.push({
						type: :toolPathStep,
						vertex: vertex
					})
					vector = last_vertex.position.vector_to(vertex.position)
					find_all_steps(steps, last_vector)
					break
				end
			}
		end

		def would_cause_loop?(steps, vertex)
			last_vertex = steps.last[:vertex]
			if index = steps.find_index{|step|step[:vertex] == vertex}
				last_vertex == steps[index - 1][:vertex]
			else
				false
			end
		end

		def self.valid?(skp_text)
			skp_text.text[/^\d+:/] != nil
		end

	end

end