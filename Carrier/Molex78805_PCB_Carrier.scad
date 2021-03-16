// OpenSCAD model of Molex78805_PCB_Carrier
// for Molex78805_PCB.kicad_pcb

// Carrier to hold a PCB in place of a DIP28 chip
// in the Molex 78805 socket found in some vintage computers.
// Examples: Tandy Model 100, 102, 200, 600
//     Epson PX-4, PX-8

// Brian K. White - b.kenyon.w@gmail.com
// http://tandy.wiki/Molex78805_PCB_Module
// https://github.com/aljex/Molex78805_PCB_Module/

// -------------------------------------------------------------------------
// UNITS: mm
// VARIANTS: chamfer pin unpolarized legacy

// Which version of the carrier to produce:
// "legacy" - fits REX_bkw_c8 and original Teeprom
// "pin" - fits REX_bkw_c9
// "chamfer" - fits REX_bkw_c11 and current Teeprom - *current default*
// "bump" - carrier wall has a hole for a male polarity bump on a pcb edge
// "max" - maximum usable pcb real-estate
variant = "chamfer"; // Just the default. Makefile overrides this via "-D ..."

// Original REX1 can use the "bump" version, if you are willing to sand the pcb edges down a little.

// PCB dimensions are derived from a mix of constraints.

// PCB main outside X,Y dimensions are ultimately derived from the inside of the Molex 78805 socket.
// Socket interior, minus fitment clearance, minus carrier body, minus fitment clearace = PCB X,Y
// Then the chamfer on the PCB is derived from the PCB X dim and the edge of the pin1 contact.
// Then the chamfer in the carrier is derived from the chamfer on the PCB, minus clearance.


_fc = 0.1;  // fitment clearance

// main box-shaped cavity inside socket
// not counting polarity features or contacts
main_x = 39.6;    // 050395288_sd.pdf 50-39-5288 DIM. F: 39.8 / 015299282_sd.pdf: 40.01
main_y = 16.6;    // 050395288_sd.pdf: 16.64 / 015299282_sd.pdf: 16.89
main_z = 7.48;    // neither datasheet shows the carrier height nor the socket depth

// pcb thickness - nominal 1.6
_pz = 1.7; // realistic pcb thickness nominal + 0.1
// pcb thickness - nominal 0.8
//_pz = 0.9; // realistic pcb thickness nominal + 0.1

_mr = 0.836; // pcb edge cut mill radius (0.034")

// pcb cavity (pcb will be smaller)
pcb_x = (variant=="legacy") ? 37.5 : main_x-1.5;     // leave walls >= 0.7  ( (main_x-pcb_x)/2 >= 0.7 )
pcb_y = (variant=="legacy") ? 15.3 : (variant=="max") ? main_y+0.002 : 16.1;
pcb_z = _pz+_fc;

// 1.6mm pcb
pcb_elev = 2.2;   // bottom of pcb above socket floor. Min 1.9 - Max 2.4
// 0.8mm pcb
//pcb_elev = 2.6;   // bottom of pcb above socket floor.

// Derived/calculated dimensions for the actual PCB
_px = pcb_x - _fc;
_py = pcb_y - _fc;
_pe = pcb_elev + _fc/2;

// cavity in bottom tray for backside components and through-hole legs
perimeter_ledge = (variant=="max")?0:0.8;
pocket_x = pcb_x-perimeter_ledge*2;
pocket_y = pcb_y-perimeter_ledge*2;
if(pcb_x-pocket_x < 1 && pcb_y-pocket_y < 1 && variant != "max") echo("ERROR: Unsupported PCB! Reduce pocket_x or pocket_y, or increase perimeter_ledge");
pocket_floor = 0.8; // floor thickness. fab limit 0.7 min
pocket_z = pcb_elev - pocket_floor;

// wedge-shaped corner posts at pin1 & pin28
cpwedge_xwide = 1.6;    // thick end of wedge
cpwedge_xnarrow = 1;    // thin end of wedge
cpwedge_y = 21;         // total Y outside end to end both posts

// box-shaped corner posts at pin14 & pin15
cpbox_x = 2;    // X len of 1 post
cpbox_y = 1.75;    // Y width of 1 post
cpbox_xe = 0.3;   // X extends past main_x
cpbox_yo = 19.6;  // total Y outside end to end both posts

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
// narrow wedge
//ret_y = 2;       // length
//ret_z = main_z - pcb_elev - pcb_z; // height
// with daughterboard
//ret_z = main_z - pcb_elev - pcb_z - pcb_z; // height

// castellated edge contacts
// get the drill size & position values from the footprint in KiCAD
// PCB/000_LOCAL.pretty/Molex78805_PCB.kicad_mod
// drill size and position for castellated edge contacts
c_drill_diameter = 1.6;
c_drill_y = 8.6; // pcb center to drill center
c_spacing = 2.54; // edge contact spacing
c_number = 28; // number of edge contacts
c_width = 1.6; // width of space to cut away from the carrier body around each contact
c_y = 14.1; // distance between opposing contacts in empty socket
c_positions = c_number/2;
c_x_full = c_positions * c_spacing;
c_diff = c_spacing - c_width;
c_x_min = c_x_full - c_diff;

/////////////////////////////////////////////////////
// pcb polarity - polarity of the pcb in the carrier
// (not polarity of the carrier in the socket)

// pcb polarity chamfer
// derived from contacts & clearance - rounded to 0.1 precision
pcb_polarity_chamfer = (variant=="chamfer") ? round((pcb_x/2-c_x_min/2-_fc/2)*10)/10 : 0; // pin 1 corner polarity chamfer
// hard-coded
//pcb_polarity_chamfer = (variant=="chamfer") ? 1.8 : 0; // pin 1 corner polarity chamfer

// pcb polarity pin
pin_x = 14.53;                    // location center X
pin_y = 3.4;                      // location center Y
pin_z = pcb_elev+pcb_z-0.2;       // top of pin, 0.2 below top of pcb
pin_d = (variant=="legacy") ? 2.6 : 2;       // diameter of PIN. hole in pcb is 2*_fc larger
pcb_polarity_hole_d = pin_d + 2*_fc;         // diameter of HOLE

// pcb polarity bump
pcb_polarity_bump_width = (variant=="max") ? 4 : 2;     // bump width - actual size of pcb shape, not including _fc padding
_pbw = (variant=="bump"||variant=="max") ? pcb_polarity_bump_width : 0;
_pbh = (variant=="bump"||variant=="max") ? main_x/2-pcb_x/2+_fc/2 : 0;  // bump height = end wall thickness

// corner prongs
prong_w = (variant=="max") ? 2 : 0;
prong_cyl = (main_x-pcb_x)/2;  // aka _pbh - _fc/2

o = 0.1;  // overcut - extend cut shapes beyond the outside surfaces they cut from, to prevent zero-thickness planes in previews, renders, & mesh outputs
legacy_side_wall_chamfer = 0.5; // size of chamfers on inside side walls for the legacy variant - acommodate mill radius in pcb edge cuts

$fn=18; // arc smoothness

hide_pcb = false;  // overridden by Makefile, hide %pcb() so that scad-to-step.py only sees the carrier object

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
if(variant=="max"){
  echo("# Prongs: Width,Height",prong_w,_pbh);
  echo("# Backside Pocket: Length,Width,Depth", _px, round(_py*10)/10, (pocket_z>pcb_elev)?pcb_elev:pocket_z );
}else{
  echo("# Backside Pocket: Length,Width,Depth", (pocket_x>_px)?_px-_fc:pocket_x-_fc , (pocket_y>_py)?round((_py-_fc)*10)/10:pocket_y-_fc , (pocket_z>pcb_elev)?pcb_elev:pocket_z );
}
//echo("#");
//echo("# Daughterboard backside components:", main_z - _pe - _pz - _pz);
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

module daughterboard () {
  translate([0,0,_pz/2+main_z/2-_pz]) cube([_px,_py,_pz],center=true);
}

module pcb () {
  _lpy = 16.5; // dumb hack for legacy version
  _bw = (variant=="bump") ? _pbw+_mr : _pbw;
  difference(){
    group(){ // ADD
      if (variant!="legacy")
        translate([-_px/2,-_py/2,-main_z/2+_pe])
          linear_extrude(_pz)
            polygon([
              // begin pin1/pin28 end - pin1 corner
              [0,0],
              [-_pbh,0],
              [-_pbh,_bw],
              [0,_bw],
              //  middle prong on pin1/pin28 end
              //[0,_py-prong_w*3],
              //[-_pbh,_py-prong_w*3],
              //[-_pbh,_py-prong_w*2],
              //[0,_py-prong_w*2],
              [0,_py-prong_w],
              [-_pbh,_py-prong_w],
              [-_pbh,_py],
              [0,_py],
              // begin pin14/pin15 end - pin15 corner
              [_px,_py],
              [_px+_pbh,_py],
              [_px+_pbh,_py-prong_w],
              [_px,_py-prong_w],
              // middle prong on pin14/pin15 end
              //[_px,_py/2+prong_w/2],
              //[_px+_pbh,_py/2+prong_w/2],
              //[_px+_pbh,_py/2-prong_w/2],
              //[_px,_py/2-prong_w/2],
              [_px,prong_w],
              [_px+_pbh,prong_w],
              [_px+_pbh,0],
              [_px,0]
            ]);
      if(variant=="legacy")
        translate([-_px/2,-_lpy/2,-main_z/2+_pe])
          cube([_px,_lpy,_pz]);
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
      if (variant=="legacy")
        mirror_copy([1,0,0])
          mirror_copy([0,1,0])
            hull(){
              translate([-_px/2,-_py/2-_mr,-main_z/2+pcb_elev])
                cylinder(h=pcb_z,r=_mr);
              translate([-c_x_min/2-_mr,-_py/2-_mr,-main_z/2+pcb_elev])
                cylinder(h=pcb_z,r=_mr);
            }
      // half-holes drilled in the inner sides of the prongs
      if (variant=="max"){
        translate([-_px/2-_pbh/2,-_py/2,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
        translate([-_px/2-_pbh/2,-_py/2+_pbw,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
  
        // middle prong on pin1/pin28 end
        //translate([-_px/2-_pbh/2,_py/2-prong_w*3,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
        //translate([-_px/2-_pbh/2,_py/2-prong_w*2,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);

        translate([-_px/2-_pbh/2,_py/2-prong_w,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
        translate([-_px/2-_pbh/2,_py/2,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);

        translate([_px/2+_pbh/2,_py/2,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
        translate([_px/2+_pbh/2,_py/2-prong_w,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);

        // middle prong on pin14/pin15 end
        //translate([_px/2+_pbh/2,prong_w/2,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
        //translate([_px/2+_pbh/2,-prong_w/2,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);

        translate([_px/2+_pbh/2,-_py/2+prong_w,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
        translate([_px/2+_pbh/2,-_py/2,-main_z/2+pcb_elev]) cylinder(h=_pz+o , d=_pbh);
      }
      // mill radius
      if (variant=="bump")
        translate([-_px/2-_mr,-_py/2+_bw,-main_z/2+pcb_elev])
          cylinder(h=pcb_z,r=_mr);
    }
  }
}

module carrier () {
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

    if(variant=="max"){
      translate([-main_x/2-o,-pcb_y/2,-main_z/2+pcb_elev]) cube([o+_pbh+o,_pbw,pcb_z]);
      // middle prong - pin1/pin28 end
      //translate([-main_x/2-o,pcb_y/2-prong_w*3,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
      translate([-main_x/2-o,pcb_y/2-prong_w,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
      translate([pcb_x/2-o,pcb_y/2-prong_w,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
      // middle prong - pin14/pin15 end
      //translate([pcb_x/2-o,-prong_w/2,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
      translate([pcb_x/2-o,-pcb_y/2,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
    }

   if(variant=="bump"){
     // the basic hole for the bump
     translate([-pcb_x/2-_pbh-o/2,-pcb_y/2,-main_z/2+pcb_elev]) cube([_pbh+o,_pbw+_fc,pcb_z]);
     // mill radius - pcb edge cut router leaves a fillet on inside corners
     translate([-pcb_x/2-_mr+0.001,-pcb_y/2+_pbw+_fc+_mr-0.001,-main_z/2+pcb_elev]) rotate([0,0,270]) difference(){
        cube([_mr,_mr,pcb_z]);
        translate([0,0,-o/2]) cylinder(h=pcb_z+o,r=_mr);
      }
    }

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
        [0,pcb_polarity_chamfer+_fc/2],
        [pcb_polarity_chamfer+_fc/2,0],
        [pcb_polarity_chamfer+_fc/2,-(main_y/2-pcb_y/2)],
        [0,-(main_y/2-pcb_y/2)],
      ]);
if(variant=="pin" || variant=="legacy")
  translate([-pin_x,-pin_y,-main_z/2+pocket_floor]){
    cylinder(h=pin_z-pocket_floor,d=pin_d); // pin
    cylinder(h=0.2,d1=pin_d+2,d2=pin_d); // fillet
}
if(variant=="max"){
  // Intentionally using _py (pcb edge) instead of pcb_y (carrier edge) here to make the fit tight
  translate([-pcb_x/2-prong_cyl/2,-_py/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  translate([-pcb_x/2-prong_cyl/2,-_py/2+_pbw,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

  //translate([-pcb_x/2-prong_cyl/2,_py/2-prong_w*3,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  //translate([-pcb_x/2-prong_cyl/2,_py/2-prong_w*2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

  translate([-pcb_x/2-prong_cyl/2,_py/2-prong_w,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  translate([-pcb_x/2-prong_cyl/2,_py/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

  translate([pcb_x/2+prong_cyl/2,_py/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  translate([pcb_x/2+prong_cyl/2,_py/2-prong_w,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

  //translate([pcb_x/2+prong_cyl/2,prong_w/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  //translate([pcb_x/2+prong_cyl/2,-prong_w/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

  translate([pcb_x/2+prong_cyl/2,-_py/2+prong_w,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  translate([pcb_x/2+prong_cyl/2,-_py/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
}
}  // union
}  // carrier

////////////////////////////////////////////////////////////////////////////////

// Makefile overrides hide_pcb, and pcb_move_* to generate pngs for README.md
pcb_move_x = 0;
pcb_move_y = 0;
pcb_move_z = 0;
pcb_color = "none";
if(!hide_pcb){
  translate([pcb_move_x,pcb_move_y,pcb_move_z]){
    if(pcb_color!="none") color(pcb_color) pcb();
    else %pcb();
  }
}

// Makefile overrides carrier_color to generate pngs for README.md
carrier_color = "none";
if(carrier_color!="none") color(carrier_color) carrier();
else carrier();

//color(pcb_color)
//daughterboard();
