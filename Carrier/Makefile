# Generate STL mesh output files from OpenSCAD source
# Brian K. White - b.kenyon.w@gmail.com

model = pcb2molex8878
variants = chamfer pin unpolarized legacy

openscad = openscad-nightly

.PHONY: all
all: $(variants)

$(variants): %: $(model)_%.stl

$(model)_%.stl: $(model).scad
	$(openscad) -D'variant="$(*)"' -o $(@) $(model).scad

clean:
	for i in $(variants) ;do rm -f $(model)_$${i}.stl ;done
