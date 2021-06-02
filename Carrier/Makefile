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
#$(variants): %: $(model)_%_$(pins).stl $(model)_%_$(pins).png $(model)_%_$(pins).step
$(variants): %: $(model)_%_$(pins).stl $(model)_%_$(pins).step

# Generate .stl for 3d printing
$(model)_%_$(pins).stl: $(model).scad
	$(openscad) -D'variant="$(*)"' -D'pins=$(pins)' -D'$$fn=18' -o $(@) $(model).scad

# Generate .png for README.md
$(model)_%_$(pins).png: $(model).scad
	$(openscad) -D'variant="$(*)"' -D'pins=$(pins)' -D'carrier_color="lightgrey"' --colorscheme DeepOcean --imgsize 1024,768 --viewall -o $(@) $(model).scad

# Generate .step for KiCAD, from foo.stl
$(model)_%_$(pins).step: stl-to-step.py $(model)_%_$(pins).stl
	PYTHONDONTWRITEBYTECODE=1 MODEL=$(model)_$(*)_$(pins) $(freecadcmd) stl-to-step.py

.PHONY: help list
help list:
	@echo "Targets: all $(variants) help list clean"
	@echo
#	@echo "  all = generate $(pins)-pin .stl, .step, and .png for all variants: ($(variants))"
	@echo "  all = generate $(pins)-pin .stl and .step for all variants: ($(variants))"
#	@echo "  $(variants) = generate .stl, .step, and .png for the specified variation"
	@echo "  $(variants) = generate .stl and .step, for the specified variation"
	@echo "  help or list: display this text"
	@echo "  clean: delete *.stl *.step"

.PHONY: clean
clean:
	rm -f *.stl *.step *.png
