.PHONY: clean

bin/step0_repl.x86_64:
	godot --path . --export-release "Linux_step0" bin/step0_repl.x86_64 --headless
	
bin/step1_read_print.x86_64:
	godot --headless --path . --export-release "step1_read_print" bin/step1_read_print.x86_64
	
bin/step2_eval.x86_64:
	godot --headless --path . --export-release "step2_eval" bin/step2_eval.x86_64

bin/step3_env.x86_64:
	godot --headless --path . --export-release "step3_env" bin/step3_env.x86_64
	
clean:
	rm -r bin/*
