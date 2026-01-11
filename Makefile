all:
	clean

bin/step0_repl.x86_64:
	godot --path . --export-release "Linux_step0" bin/step0_repl.x86_64 --headless
	
bin/step1_read_print.x86_64:
	godot --path . --export-release "step1_read_print" bin/step1_read_print.x86_64 --headless
	
clean:
	rm -r bin/*
