# Generate STL and STEP mesh output files from OpenSCAD source
# Brian K. White - b.kenyon.w@gmail.com

model = pcb2molex8878
#variants = chamfer bump max pin legacy
variants = chamfer bump max pin # legacy

openscad = openscad-nightly
freecadcmd = freecadcmd-daily

.PHONY: all
all: $(variants)

.PHONY: $(variants)
$(variants): %: $(model)_%.stl $(model)_%.png $(model)_%.step

# Generate .stl for 3d printing
$(model)_%.stl: $(model).scad
	$(openscad) -D'variant="$(*)"' -o $(@) $(model).scad

# Generate .png for README.md
$(model)_%.png: $(model).scad
	$(openscad) -D'variant="$(*)"' -D'hide_pcb=false' -D'pcb_move_z=20' -D'pcb_color="green"' -D'carrier_color="lightgrey"' --colorscheme DeepOcean --imgsize 1024,768 --viewall -o $(@) $(model).scad
#	$(openscad) -D'variant="$(*)"' -D'pcb_move_y=20' --colorscheme DeepOcean --imgsize 1024,768 --camera=0,0,0,0,0,90,0 --viewall --autocenter -o $(model)_$(*)_02.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_03.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,90,0,0,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_04.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,-60,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_05.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,0,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_06.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,60,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_07.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,66,0,120,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_08.png $(model).scad
#	$(openscad) -D'variant="$(*)"' --camera=0,0,0,120,0,-60,0 --viewall --colorscheme DeepOcean --imgsize 1024,768 -o $(model)_$(*)_09.png $(model).scad

# Generate .step for KiCAD  (from .scad)
# Slower and more brittle, but best output
$(model)_%.step: scad-to-step.py $(model).scad
	cp -f $(model).scad $(model)_$(*).scad
	echo "variant=\"$(*)\";" >> $(model)_$(*).scad
	echo "hide_pcb=true;" >> $(model)_$(*).scad
	PYTHONDONTWRITEBYTECODE=1 MODEL=$(model)_$(*) $(freecadcmd) scad-to-step.py
	rm -f $(model)_$(*).scad

# Generate .step for KiCAD  (from .stl)
# Faster and more robust, but not as good output
#$(model)_%.step: stl-to-step.py $(model)_%.stl
#	PYTHONDONTWRITEBYTECODE=1 MODEL=$(model)_$(*) $(freecadcmd) stl-to-step.py

# Produces bad output
#$(model)_%.step: $(model)_%.stl
#	stltostp $(model)_$(*).stl $(@)

.PHONY: help list
help list:
	@echo "Targets: all $(variants) help list clean"
	@echo
	@echo "  all = generate .stl, .step, and .png for every available variation: ($(variants))"
	@echo "  $(variants) = generate .stl, .step, and .png for the specified variation"
	@echo "  help or list: display this text"
	@echo "  clean: delete *.stl *.step"

.PHONY: clean
clean:
	rm -f *.stl *.step *.png
