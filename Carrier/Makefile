# Generate STL and STEP mesh output files from OpenSCAD source
# Brian K. White - b.kenyon.w@gmail.com

model = Molex78802
# PCB DIP maxpcb
variants = PCB DIP
# 24 28 32
pins = 28

#openscad = openscad-nightly
#freecadcmd = freecadcmd-daily
openscad = openscad
freecadcmd = freecadcmd

.PHONY: all
all: $(variants)

.PHONY: $(variants)
$(variants): %: $(model)_%_$(pins).stl $(model)_%_$(pins).png $(model)_%_$(pins).step

# Generate .stl for 3d printing
$(model)_%_$(pins).stl: $(model).scad
	$(openscad) -D'variant="$(*)"' -D'pins=$(pins)' -o $(@) $(model).scad

# Generate .png for README.md
$(model)_%_$(pins).png: $(model).scad
	$(openscad) -D'variant="$(*)"' -D'pins=$(pins)' -D'carrier_color="lightgrey"' --colorscheme DeepOcean --imgsize 1024,768 --viewall -o $(@) $(model).scad
#	$(openscad) -D'variant="$(*)"' -D'pcb_move_y=20' --colorscheme DeepOcean --imgsize 1024,768 --camera=0,0,0,0,0,90,0 --viewall --autocenter -o $(model)_$(*)_02.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_03.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,90,0,0,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_04.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,-60,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_05.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,0,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_06.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,60,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_07.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,120,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_08.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,120,0,-60,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_09.png $(model).scad

# Generate .step for KiCAD, from foo.scad
# Slower and more brittle, but best output
# ... broke again
# "Exception while processing file: scad-to-step.py [module 'Part' has no attribute 'getShape']"
#
#$(model)_%.step: scad-to-step.py $(model).scad
#	cp -f $(model).scad $(model)_$(*)_$(pins).scad
#	echo "variant=\"$(*)\";" >> $(model)_$(*)_$(pins).scad
#	PYTHONDONTWRITEBYTECODE=1 MODEL=$(model)_$(*)_$(pins) $(freecadcmd) scad-to-step.py
#	rm -f $(model)_$(*)_$(pins).scad

# Generate .step for KiCAD, from foo.stl
# Faster and more robust, but not as good output
$(model)_%_$(pins).step: stl-to-step.py $(model)_%_$(pins).stl
	PYTHONDONTWRITEBYTECODE=1 MODEL=$(model)_$(*)_$(pins) $(freecadcmd) stl-to-step.py

# Produces bad output
#$(model)_%.step: $(model)_%.stl
#	stltostp $(model)_$(*).stl $(@)

.PHONY: help list
help list:
	@echo "Targets: all $(variants) help list clean"
	@echo
	@echo "  all = generate $(pins)-pin .stl, .step, and .png for all variants: ($(variants))"
	@echo "  $(variants) = generate .stl, .step, and .png for the specified variation"
	@echo "  help or list: display this text"
	@echo "  clean: delete *.stl *.step"

.PHONY: clean
clean:
	rm -f *.stl *.step *.png
