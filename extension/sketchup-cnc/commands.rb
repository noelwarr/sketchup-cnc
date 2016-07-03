module SNC

	COMMANDS = {
		# "Make Workpiece" => {
		# 	proc: proc{
		# 		SNC.operation("Make Workpiece"){
		# 			Workpiece.new(Sketchup.active_model.selection[0])
		# 		}
		# 	},
		# 	validation: proc{
		# 		selection = Sketchup.active_model.selection
		# 		if selection.length == 1 && Workpiece.candidate?(selection[0])
		# 			MF_ENABLED
		# 		else
		# 			MF_GRAYED
		# 		end
		# 	}
		# },
		"Generate Project" => {
			proc: proc{
				project = Project.new(Sketchup.active_model)
				if (skp_path = Sketchup.active_model.path) && !skp_path.empty?
					project.save(skp_path[0..-5])	
				else
					UI.messagebox("Sketchup model must be saved before generating project")
				end
			}
		}
	}

	COMMANDS.each{|command_name,command_data|
		cmd = UI::Command.new(command_name, &command_data[:proc])
		cmd.menu_text = command_name
		cmd.set_validation_proc(&command_data[:validation]) if command_data[:validation]
		COMMANDS[command_name] = cmd
	}

end