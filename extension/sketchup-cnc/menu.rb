module SNC

	MENU = UI.menu("Extensions").add_submenu("SketchUp CNC")

	COMMANDS.each{|command_name, command|
		MENU.add_item(command)
	}

end