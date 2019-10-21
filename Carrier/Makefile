# Generate STL and STEP mesh output files from OpenSCAD source
# Brian K. White - b.kenyon.w@gmail.com

model = pcb2molex8878
variants = max bump chamfer pin legacy
default = max

openscad = openscad-nightly
freecadcmd = freecadcmd-daily

pcb_3d = ../PCB/000_LOCAL.pretty/3d

.PHONY: default
default: mesh kicad

.PHONY: all
all: $(variants)

$(model).stl: $(default)
	ln -sf $(model)_$(default).stl $(model).stl

.PHONY: $(variants)
$(variants): %: $(model)_%.stl

$(model)_%.stl: $(model).scad
	$(openscad) -D'variant="$(*)"' -o $(@) $(model).scad

$(model).step: scad-to-step.py $(model).scad
	PYTHONDONTWRITEBYTECODE=1 $(freecadcmd) scad-to-step.py

.PHONY: kicad
kicad: step
	mv -f $(model).step $(pcb_3d)/$(model).step

.PHONY: stl mesh
stl mesh: $(model).stl

.PHONY: step
step: $(model).step

.PHONY: help list
help list:
	@echo "Targets: default all $(variants) mesh kicad step help list clean"
	@echo
	@echo "  default = \"default\" = \"mesh kicad\""
	@echo
	@echo "  all = generate .stl for every available variation: ($(variants))"
	@echo "  mesh = generate $(model)_$(default).stl and symlink to $(model).stl"
	@echo "  step = generate $(model).step ($(default) variant)"
	@echo "  kicad = generate step, and move it to $(pcb_3d)"
	@echo "  help or list: display this text"
	@echo "  clean: delete *.stl *.step"

.PHONY: clean
clean:
	rm -f *.stl *.step
