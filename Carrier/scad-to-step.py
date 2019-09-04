# -*- coding: utf-8 -*-
# scad-to-step.py
# FreeCAD macro to import pcb2molex8878.scad and export pcb2molex8878.step
# Brian K. White - b.kenyon.w@gmail.com
# Requires:
# * pcb2molex8878.scad in current directory
# * freecad with openscad workbench installed and configured:
#    * path to openscad binary
#    * use view provider in tree view
#    * use multimatrix feature
# * make sure pcb2molex8878.scad has only a single union() which contains the entire model
#   everywhere else you would normally use union(), use group() instead
#   otherwise we won't know the name of the object for getObject() addObject() below.

import FreeCAD
import importCSG
import Part

# open the scad source
importCSG.open("pcb2molex8878.scad")

# hope that the object named "union" is the top-level outer-most object containing the entire model
__shape = Part.getShape(App.getDocument('pcb2molex8878').getObject('union'),'',needSubElement=False,refine=True)
App.ActiveDocument.addObject('Part::Feature','union').Shape=__shape
App.ActiveDocument.ActiveObject.Label=App.getDocument('pcb2molex8878').getObject('union').Label

# refine shape - creates a new object with junk details removed
App.ActiveDocument.recompute()

# hope that recompute() already automatically switched "ActiveObject" to it's product
# export as STEP
App.ActiveDocument.ActiveObject.Shape.exportStep("pcb2molex8878.step")
