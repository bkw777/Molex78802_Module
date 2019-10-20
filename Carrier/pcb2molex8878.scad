// OpenSCAD model of pcb2molex8878 carrier
// for pcb2molex8878.kicad_pcb

// Carrier to hold a pcb in place of a DIP28 chip
// in the Molex 8878 socket found in some vintage computers.
// Ex: Tandy Model 100, 102, 200, 600
//     Epson PX-4, PX-8

// Brian K. White - b.kenyon.w@gmail.com
// http://tandy.wiki/pcb2molex8878
// https://github.com/aljex/pcb2molex8878/

// -------------------------------------------------------------------------
// UNITS: mm
// VARIANTS: chamfer pin unpolarized legacy

// Which version of the carrier to produce:
// "legacy" - fits REX_bkw_c8 and original Teeprom
// "pin" - fits REX_bkw_c9
// "chamfer" - fits REX_bkw_c11 and current Teeprom - *current default*
// "unpolarized" - fits original REX1 & FigTroniX with ends sanded down
// "bump" - carrier wall has a hole for a male polarity bump on a pcb edge
// "max" - maximum usable pcb real-estate
variant = "max"; // Just the default. Makefile overrides this with -D and generates all variants.

// PCB dimensions are derived from a mix of constraints.

// PCB main outside X,Y dimensions are ultimately derived from the inside of the Molex 8878 socket.
// Socket minus carrier body minus clearace = PCB X,Y
// Then the chamfer on the PCB is derived from the PCB X dim and the edge of the pin1 contact.
// Then the chamfer in the carrier is derived from the chamfer on the PCB, minus clearance.

// main outside box
// This is a mostly imaginary construction dimension.
// All key dimensions are derived from these, but very little of the model outside shape lands on these dimensions.
main_x = 39.8;    // 050395288_sd.pdf 50-39-5288 DIM. F: 39.8 / 015299282_sd.pdf: 40.01
main_y = 16.8;    // 050395288_sd.pdf: 16.64 / 015299282_sd.pdf: 16.89 (PDF says 19.90 in error. 0.665" = 16.891mm)
main_z = 7.48;    // neither pdf shows the carrier height nor the socket depth

// pcb
pcb_x = (variant=="legacy") ? 37.5 : main_x-1.5;     // leave walls >= 0.7  ( (main_x-pcb_x)/2 >= 0.7 )
pcb_y = (variant=="legacy") ? 15.3 : (variant=="max") ? main_y+0.002 : 16.1;
pcb_z = 1.8;      // thickness of pcb (nominal 1.6 plus 0.2)
pcb_elev = 2.4;   // bottom of pcb above socket floor, can go as low as 1.9

pcb_clearance = 0.1;  // pcb should be this much smaller than model

// Derived/calculated dimensions for the actual PCB
_px = pcb_x - pcb_clearance;
_py = pcb_y - pcb_clearance;
_pz = 1.6; // use standard/nominal pcb thickness instead of pcb_z (which is padded for fitment clearance), to avoid confusion when taking dims to plug in to pcb editors.
_pe = pcb_elev + pcb_clearance/2;

// cavity in bottom tray for backside components and through-hole legs
perimeter_ledge = (variant=="max")?0:0.8;

pocket_x = pcb_x-perimeter_ledge*2;
//pocket_x = pcb_x;
pocket_y = pcb_y-perimeter_ledge*2;
//pocket_y = pcb_y;
pocket_z = 1.5;
if(pcb_x-pocket_x < 1 && pcb_y-pocket_y < 1 && variant != "max") echo("ERROR: Unsupported PCB! Look at pocket_x or pocket_y");
pocket_floor = pcb_elev-pocket_z;

// wedge-shaped corner posts at pin1 & pin28
cpwedge_xwide = 1.7;      // thick end of wedge
cpwedge_xnarrow = 1.1;    // thin end of wedge
cpwedge_y = 21.2;         // total Y outside end to end both posts

// box-shaped corner posts at pin14 & pin15
cpbox_x = 2.1;    // X len of 1 post
cpbox_y = 1.8;    // Y width of 1 post
cpbox_xe = 0.3;   // X extends past main_x
cpbox_yo = 19.8;  // total Y outside end to end both posts

// socket polarity blades
blade_z = 5.2;            // height from top of main_z to bottom of blade
blade_xwide = 2.5;        // wide part extend past main_x
blade_xnarrow = 1.4;      // narrow part extend past main_x
blade_thickness = 1.4;

// finger pull wings
wing_y = 8.95;
wing_x = 3.2;             // extend past main_x
wing_thickness = 1.2;

// pcb retainer wedges
ret_x = 1;        // overhang
ret_y = 10;       // length
ret_z = 2;        // height

// castellated edge contacts
// get the two drill values from the footprint in KiCAD
// PCB/000_LOCAL.pretty/pcb2molex8878.kicad_mod
// drill size and position for castellated edge contacts
c_drill_diameter = 1.6;
c_drill_offset = 0.6; // pcb edge to drill center
c_drill_y = 8.6; // pcb center to drill center
c_spacing = 2.54; // edge contact spacing
c_number = 28; // number of edge contacts
c_width = 1.6; // width of space to cut away around each contact
c_y = 14.1; // distance between opposing contacts in empty socket
c_positions = c_number/2;
c_x_full = c_positions * c_spacing;
c_diff = c_spacing - c_width;
c_x_min = c_x_full - c_diff;

/////////////////////////////////////////////////////
// pcb polarity - polarity of the pcb in the carrier
// (vs polarity of the carrier in the socket)

// pcb polarity chamfer
// derived from contacts & clearance - rounded to 0.1 precision
pcb_polarity_chamfer = (variant=="chamfer") ? round((pcb_x/2-c_x_min/2-pcb_clearance/2)*10)/10 : 0; // pin 1 corner polarity chamfer
// hard-coded
//pcb_polarity_chamfer = (variant=="chamfer") ? 1.8 : 0; // pin 1 corner polarity chamfer

// pcb polarity pin
pin_x = 14.53;                    // location center X
pin_y = 3.4;                      // location center Y
pin_z = pcb_elev+pcb_z-0.2;       // top of pin, 0.2 below top of pcb
pin_d = (variant=="legacy") ? 2.6 : 2;       // diameter of PIN. hole in pcb is 2*pcb_clearance larger
pcb_polarity_hole_d = pin_d + 2*pcb_clearance;

// pcb polarity bump
pcb_polarity_bump_width = 4;     // bump width - actual size of pcb shape, not including pcb_clearance padding
_pbw = (variant=="bump"||variant=="max") ? pcb_polarity_bump_width : 0;
_pbh = (variant=="bump"||variant=="max") ? main_x/2-pcb_x/2+pcb_clearance/2 : 0;  // bump height = end wall thickness

// corner prongs
prong_w = (variant=="max") ? 2 : 0;

o = 0.1;  // overcut - extend cut shapes beyond the outside surfaces they cut from, to prevent zero-thickness planes in previews, renders, & mesh outputs
legacy_side_wall_chamfer = 0.5; // size of chamfers on inside side walls for the legacy variant - acommodate mill radius in pcb edge cuts

$fn=18; // arc smoothness


// Display some calculated values in the console,
// so that it's easy to copy them to KiCAD,
echo("###################################################################");
echo("#");
echo("### Use the following dimensions in KiCAD");
echo("### Carrier Variant",variant);
echo("#");
echo("# PCB: Length,Width",_px,round(_py*10)/10);
if(variant=="chamfer")
  echo("# Polarity Chamfer:",pcb_polarity_chamfer);
if(variant=="bump"||variant=="max")
  echo("# Polarity Bump: Width,Height",_pbw,_pbh);
if(variant=="pin" || variant=="legacy")
  echo("# Polarity Hole: X,Y,Diameter",pin_x,pin_y,pcb_polarity_hole_d);
if(variant=="max")
  echo("# Prongs: Width,Height",prong_w,_pbh);
echo("# Backside Pocket: Length,Width,Depth", (pocket_x>_px)?_px:pocket_x , (pocket_y>_py)?round(_py*10)/10:pocket_y , (pocket_z>pcb_elev)?pcb_elev:pocket_z );
echo("#");
echo("###################################################################");

// ===============================================================

module mirror_copy(vector){
  children();
  mirror(vector) children();
}

// socket polarity blade
module blade(){
  rotate([90,0,0])
    translate([0,-blade_z+main_z/2,0])
      linear_extrude(blade_thickness)
        polygon([
          [0,0],
          [0,blade_z],
          [blade_xwide,blade_z],
          [blade_xwide,blade_z-wing_thickness],
          [blade_xnarrow,blade_z-wing_thickness*2],
          [blade_xnarrow,0]
        ]);
}

module pcb () {
  difference(){
    group(){ // ADD
      translate([-_px/2,-_py/2,-main_z/2+_pe])
        linear_extrude(_pz)
          polygon([
            [0,0],
            [-_pbh,0],
            [-_pbh,_pbw],
            [0,_pbw],
            [0,_py-prong_w],
            [-_pbh,_py-prong_w],
            [-_pbh,_py],
            [0,_py],
            [_px,_py],
            [_px+_pbh,_py],
            [_px+_pbh,_py-prong_w],
            [_px,_py-prong_w],
            [_px,prong_w],
            [_px+_pbh,prong_w],
            [_px+_pbh,0],
            [_px,0]
          ]);
    }
    
    group(){ //REMOVE
      // castellated edge contacts
      mirror_copy([0,1,0])
        for (i=[0:c_positions-1])
          translate([-(c_x_full/2)+(c_spacing/2)+(i*c_spacing),c_drill_y,-main_z/2-o])
            cylinder(h=main_z+2*o,d=c_drill_diameter);
      // polarity chamfer
      if(variant=="chamfer")
        translate([-_px/2,-_py/2,-main_z/2+pcb_elev-o])
          linear_extrude(_pz+2*o)
            polygon([
              [pcb_polarity_chamfer+o,-o],
              [-o,-o],
              [-o,pcb_polarity_chamfer+o],
            ]);
      // polarity pin hole
      if (variant=="legacy" || variant=="pin")
        translate([-pin_x,-pin_y,-main_z/2+_pe-o])
          cylinder(h=_pz+2*o,d=pcb_polarity_hole_d);
    }
  }
}

// entire model
// collect everything into a union just so it forms a single object,
// so that it can be selected for conversion and export in FreeCAD.
//
// Dirty hack trick here....
//
// Currently in OpenSCAD, group() is just an undocumented alias for union(), used internally by some other commands.
// You are really supposed to use union() not group().
//
// We are intentionally using group() everywhere in this file,
// except this one union() here for the top-level outer-most object.
// This ends up having the result that when the .scad file is imported into FreeCAD,
// there are many "Group###" objects, but only a single "union" object.
// This way when the .scad file is imported into FreeCAD,
// the top-level object will get a predictable label ("union"),
// which makes it possible for scad-to-step.py to generate a STEP file for KiCAD non-interactively from the Makefile.
union () {

// most of the body
difference(){

  // === ADD Shapes ===
  group(){

    // main outer box
    cube([main_x,main_y,main_z],center=true);

    // wedge-shaped corner posts at pin1 & pin28
    mirror_copy([0,1,0]) // pin1
      translate([-main_x/2,main_y/2,-main_z/2]) // pin 28
        linear_extrude(main_z)
          polygon([
            [0,0],
            [0,cpwedge_y/2-main_y/2],
            [cpwedge_xnarrow,cpwedge_y/2-main_y/2],
            [cpwedge_xwide,0]
          ]);

    // box-shaped corner posts at pin14 & pin15
    mirror_copy([0,1,0]) // pin 14
      translate([main_x/2-cpbox_x+cpbox_xe,cpbox_yo/2-cpbox_y,-main_z/2]) // pin 15
        cube([cpbox_x,cpbox_y,main_z]);

    // finger pull wings
    mirror_copy([1,0,0]) // wing 1 / pin 1/28 end
      translate([main_x/2+wing_x/2,0,main_z/2-wing_thickness/2]) // wing 2 / pin 14/15 end
        cube([wing_x,wing_y,wing_thickness],center=true);

    // socket polarity blades
    translate([-main_x/2,-blade_thickness/2,0]) // pin 1/28 end
      rotate([0,0,180])
        blade();
    mirror_copy([0,1,0]) // pin 14
      translate([main_x/2,wing_y/2,0]) // pin 15
          blade();
  }

  // === SUBTRACT Shapes ===
  group(){
    // main cavity for pcb
    translate([0,0,pcb_elev])
      cube([pcb_x,pcb_y,main_z],center=true);

    if(variant=="legacy"){
      // chamfer inside edge of original style thick side walls 
      lswcs = legacy_side_wall_chamfer+o*2;
      mirror_copy([1,0,0]) // pins 1 & 28
        mirror_copy([0,1,0]) // pin 14
          translate([c_x_min/2-o,pcb_y/2-o,-main_z/2+pcb_elev]) // pin 15
            linear_extrude(main_z-pcb_elev+o)
              polygon([
                [0,0],
                [lswcs,0],
                [0,lswcs]
              ]);
    } else if (variant=="max") {
      
    } else {
      // 3d-print services can't print walls thinner than 0.7mm,
      // so here we shave them off the corner posts, mostly.

      // corners 1 & 28
      _iwx1 = main_x/2-c_x_min/2-cpwedge_xwide;
      mirror_copy([0,1,0])
        translate([-main_x/2+cpwedge_xwide,main_y/2+o,-main_z/2+pcb_elev])
          rotate([90,0,0])
            linear_extrude(main_y/2-pcb_y/2+o*2)
              polygon([
                [_iwx1,0],
                [_iwx1+o,0],
                [_iwx1+o,main_z-pcb_elev+o],
                [0,main_z-pcb_elev+o],
                [0,pcb_z]
              ]);

      // corners 14 & 15
      _iwx2 = (main_x/2+cpbox_xe-cpbox_x)-c_x_min/2;
      mirror_copy([0,1,0])
        translate([c_x_min/2,main_y/2+o,-main_z/2+pcb_elev]) 
          rotate([90,0,0])
            linear_extrude(main_y/2-pcb_y/2+o*2)
              polygon([
                [-o,0],
                [-o,main_z-pcb_elev+o],
                [_iwx2,main_z-pcb_elev+o],
                [_iwx2,pcb_z],
                [0,0,]
              ]);


    }

    // pocket for backside components
    translate([0,0,pcb_elev-pocket_z])
      cube([pocket_x,pocket_y,main_z],center=true);

    // clearance for socket contacts
    mirror_copy([0,1,0])
      for (i=[0:c_number/2-1])
        translate([-(c_x_full/2)+(c_spacing/2)+(i*c_spacing),c_y/2+c_width/2,-main_z/2-o])
          hull(){
            cylinder(h=main_z+o*2,d=c_width);
            translate([0,main_y/2-c_y/2,0]) cylinder(h=main_z+o*2,d=c_width);
          }

    // Cut the fingers down to either pcb_elev or pocket_floor.
    //
    // If there isn't going to be at least 0.5 ledge to rest on,
    // then don't bother having any posts at all, just cut
    // the fingers down level with the pocket floor.
    //
    // Otherwise, cut the fingers to leave posts up to pcb_elev for the pcb to rest on.
    finger_z = (pcb_y-pocket_y<1) ? pocket_floor : pcb_elev;
    translate([-c_x_min/2,-(main_y+o)/2,-main_z/2+finger_z])
    cube([c_x_min,main_y+o,main_z]);

    // notch in wing 1 / pin 1/28 end
    translate([-main_x/2-wing_x-o,-blade_thickness/2,main_z/2-blade_thickness+o])
      cube([wing_x-blade_xwide+o,blade_thickness,wing_thickness+o*2]);

    // holes in end-walls
    // traces outline of pcb, but slightly larger,
    // and with allowance for the pcb fab edge cut mill
    // inside corner radius
    if(variant=="bump" || variant=="max") translate([-_px/2,-pcb_y/2,-main_z/2+pcb_elev])
      linear_extrude(pcb_z)
        polygon([
          [0,0],             // pin1 inside corner
          [-_pbh-o,0],       // pin1 prong end
          [-_pbh-o,_pbw],
          // start pin1 prong detent
          [-_pbh+0.1,_pbw],
          [-_pbh+0.3,_pbw-0.3],
          [-_pbh+0.6,_pbw-0.3],
          [0,_pbw],
          [-0.2,_pbw+0.3],
          // end
          [0,_pbw+_pbh+o],
          [0,pcb_y-prong_w-_pbh-o],
          // start pin28 prong detent
          [-0.2,pcb_y-prong_w-0.3],
          [0,pcb_y-prong_w],
          [-_pbh+0.6,pcb_y-prong_w+0.3],
          [-_pbh+0.3,pcb_y-prong_w+0.3],
          [-_pbh+0.1,pcb_y-prong_w],
          // end
          [-_pbh-o,pcb_y-prong_w],
          [-_pbh-o,pcb_y],         // pin28 prong end
          [0,pcb_y],               // pin28 inside corner
          [_px,pcb_y],             // pin15 inside corner
          [_px+_pbh+o,pcb_y],      // pin15 prong edge
          [_px+_pbh+o,pcb_y-prong_w],
          // start pin15 prong detent
          [_px+_pbh-0.1,pcb_y-prong_w],
          [_px+_pbh-0.3,pcb_y-prong_w+0.3],
          [_px+_pbh-0.6,pcb_y-prong_w+0.3],
          [_px,pcb_y-prong_w],
          [_px+0.2,pcb_y-prong_w-0.3],
          // end
          [_px,pcb_y-prong_w-_pbh-o],
          [_px,prong_w+_pbh+o],
          // start pin14 prong detent
          [_px+0.2,prong_w+0.3],
          [_px,prong_w],
          [_px+_pbh-0.6,prong_w-0.3],
          [_px+_pbh-0.3,prong_w-0.3],
          [_px+_pbh-0.1,prong_w],
          // end
          [_px+_pbh+o,prong_w],
          [_px+_pbh+o,0],          // pin14 prong end
          [_px,0]                  // pin14 inside corner
        ]);

  }
}

// pcb retainer snap wedges
if (variant!="max") mirror_copy([1,0,0]) // pin 14/15 end
  translate([-pcb_x/2,ret_y/2,-main_z/2+pcb_elev+pcb_z]) // pin 1/28 end
    rotate([90,0,0])
      linear_extrude(ret_y)
        polygon([
          [0,0],
          [0,ret_z],
          [ret_x,0]
        ]);

// pcb polarity
if(variant=="chamfer")
  translate([-pcb_x/2,-pcb_y/2,-main_z/2])
    linear_extrude(pcb_elev+pcb_z)
      polygon([
        [0,0],
        [0,pcb_polarity_chamfer+pcb_clearance/2],
        [pcb_polarity_chamfer+pcb_clearance/2,0],
        [pcb_polarity_chamfer+pcb_clearance/2,-(main_y/2-pcb_y/2)],
        [0,-(main_y/2-pcb_y/2)],
      ]);
if(variant=="pin" || variant=="legacy")
  translate([-pin_x,-pin_y,-main_z/2+pocket_floor]){
    cylinder(h=pin_z-pocket_floor,d=pin_d); // pin
    cylinder(h=0.2,d1=pin_d+2,d2=pin_d); // fillet
}

}  // union

// pcb
//translate([0,10,10])
//color("green")
//%pcb();
