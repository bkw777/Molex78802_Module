# Generate STL mesh output files from OpenSCAD source
# Brian K. White - b.kenyon.w@gmail.com

model = pcb2molex8878
variants = chamfer pin unpolarized legacy

openscad = openscad-nightly

.PHONY: all
all: $(model).stl

$(model).stl: $(variants)
	ln -sf $(model)_chamfer.stl $(model).stl

$(variants): %: $(model)_%.stl

$(model)_%.stl: $(model).scad
	$(openscad) -D'variant="$(*)"' -o $(@) $(model).scad

clean:
	rm -f $(model)_*.stl
