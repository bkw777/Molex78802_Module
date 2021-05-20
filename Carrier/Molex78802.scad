// OpenSCAD model of a DIP or PCB Molex 78802 carrier to fit a Molex 78805 socket.
// for Molex78802_PCB.kicad_pcb

// Produces 9 possible versions
// There are 3 variants: "DIP", "PCB", and "maxpcb"
// And each variant may be generated with any even number of pins,
// and the original Molex 78802/78805 came in 3 pin counts: 24, 28, and 32. 

// Typical uses:
// 28-pin "PCB" version fits REX#, REXCPM, REX_Classic_BKW, Teeprom, Meeprom
// 28-pin "DIP" version fits a DIP-28 chip, and replaces an original Molex78802

// Brian K. White - b.kenyon.w@gmail.com
// http://tandy.wiki/Molex78805_PCB_Module
// https://github.com/aljex/Molex78805_PCB_Module/

// -------------------------------------------------------------------------
// UNITS: mm

// Which version of the carrier to produce:
// "DIP" - fits a standard DIP chip, not a PCB
// "PCB" - 28-pin version of this fits REX#, REXCPM, REX_Classic_BKW, Teeprom, Meeprom - *default*
// "maxpcb" - maximum possible usable pcb real-estate, difficult to use
variant = "PCB"; // Makefile overrides this via "-D ..."

// Number of pins:
// Molex 78802 datasheet shows 24, 28, and 32-pin versions
pins = 28;
assert(pins>=2 && pins%2==0);

// PCB dimensions are derived from a mix of constraints.
//
// PCB main outside X,Y dimensions are ultimately derived from the inside of the Molex 78805 socket.
// Socket interior, minus fitment clearance, minus carrier body, minus fitment clearace = PCB X,Y
// Then the chamfer on the PCB is derived from the PCB X dim and the edge of the pin1 contact.
// Then the chamfer in the carrier is derived from the chamfer on the PCB, minus clearance.
//
// Remember that we are also dealing with the accuracy of SLS printing.
// Some dimensions here are slightly off from the datasheets intentionally.

_fc = 0.1;  // fitment clearance
min_wall = 0.7; // minimum allowed wall thickness, Shapeways & Sculpteo both say 0.7mm for SLS

pitch = 2.54; // pin pitch 0.1"

// for the DIP version, the "PCB" dims are actually a ceramic dip body
cerdip_body_y = 14.8;
cerdip_body_x_extra = 2;  // added to pins/2*pitch to get body length
cerdip_body_z = 4.5;

// main box-shaped cavity inside socket
// not counting polarity features or contacts
//main_x = 39.6;    // 050395288_sd.pdf 50-39-5288 DIM. F: 39.8 / 015299282_sd.pdf: 40.01
main_x = ((pins/2)*pitch)+4.04; // 4.04 is back-derived from the 39.6 value for 28-pin version
main_y = 16.6;    // 050395288_sd.pdf: 16.64 / 015299282_sd.pdf: 16.89
main_z = 7.6;    // neither datasheet shows the carrier height nor the socket depth

// pcb thickness
pcb_thickness = (variant=="DIP") ? cerdip_body_z : 1.6;

_mr = 0.836; // pcb edge cut mill radius (0.034")

// pcb cavity (pcb will be smaller)
//pcb_x = (variant=="DIP") ? 37.5 : main_x-1.5;     // leave walls >= 0.7  ( (main_x-pcb_x)/2 >= 0.7 )
pcb_x = (variant=="DIP") ? ((pins/2)*pitch)+cerdip_body_x_extra : main_x-min_wall*2;     // leave walls >= 0.7  ( (main_x-pcb_x)/2 >= 0.7 )
pcb_y = (variant=="DIP") ? 15.3 : (variant=="maxpcb") ? main_y+0.002 : 16.1;
pcb_z = _fc+pcb_thickness+_fc;

// pcb elevation - bottom of pcb above socket floor
pcb_elev = (variant=="DIP") ? 3 : 2.2;  // min 1.9 - max 2.4

// Derived/calculated dimensions for the actual PCB
// for dip version, really derive from datasheet
_px = (variant=="DIP") ? ((pins/2)*pitch)+1 : pcb_x-_fc;
_py = (variant=="DIP") ? cerdip_body_y : pcb_y-_fc;
_pe = pcb_elev + _fc/2;

// cavity in bottom tray for backside components and through-hole legs
perimeter_ledge = (variant=="maxpcb")?0:0.8;
pocket_x = pcb_x-perimeter_ledge*2;
pocket_y = pcb_y-perimeter_ledge*2;
if(pcb_x-pocket_x < 1 && pcb_y-pocket_y < 1 && variant != "maxpcb") echo("ERROR: Unsupported PCB! Reduce pocket_x or pocket_y, or increase perimeter_ledge");
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

// castellated edge contacts
// get the drill size & position values from the footprint in KiCAD
// PCB/000_LOCAL.pretty/Molex78805_PCB.kicad_mod
// drill size and position for castellated edge contacts
c_drill_diameter = 1.6;
c_drill_y = 8.6; // pcb center to drill center
c_width = 1.6; // width of space to cut away from the carrier body around each contact
c_y = 14.1; // shortest distance between opposing contacts in empty socket
c_positions = pins/2;
c_x_full = c_positions * pitch;
c_diff = pitch - c_width;
c_x_min = c_x_full - c_diff;

/////////////////////////////////////////////////////
// pcb polarity - polarity of the pcb in the carrier
// (not polarity of the carrier in the socket)

// pcb polarity chamfer
// derived from contacts & clearance - rounded to 0.1 precision
pcb_polarity_chamfer = (variant=="PCB") ? round((pcb_x/2-c_x_min/2-_fc/2)*10)/10 : 0; // pin 1 corner polarity chamfer

// pcb prongs for "maxpcb" variant
// corner prongs
prong_w = (variant=="maxpcb") ? 2 : 0;
prong_cyl = (main_x-pcb_x)/2;  // aka _pbh - _fc/2
_pbw = prong_w * 2;     // one prong double width for polarity
_pbh = (variant=="maxpcb") ? main_x/2-pcb_x/2+_fc/2 : 0;  // bump height = end wall thickness

o = 0.1;  // overcut - extend cut shapes beyond the outside surfaces they cut from, to prevent zero-thickness planes in previews, renders, & mesh outputs
legacy_side_wall_chamfer = 0.5; // size of chamfers on inside side walls for the legacy variant - acommodate mill radius in pcb edge cuts

$fn=18; // arc smoothness

hide_pcb = true;  // overridden by Makefile, hide %pcb() so that scad-to-step.py only sees the carrier object

// Display some calculated values in the console,
// so that it's easy to copy them to KiCAD,
if(variant!="DIP"){
echo("###################################################################");
echo("#");
echo("### Use the following dimensions in KiCAD");
echo("### Carrier Variant",variant);
echo("#");
echo("# PCB: Length,Width",_px,round(_py*10)/10);
if(variant=="PCB"){
  echo("# Polarity Chamfer:",pcb_polarity_chamfer);
  echo("# Backside Pocket: Length,Width,Depth", (pocket_x>_px)?_px-_fc:pocket_x-_fc , (pocket_y>_py)?round((_py-_fc)*10)/10:pocket_y-_fc , (pocket_z>pcb_elev)?pcb_elev:pocket_z );
}
if(variant=="maxpcb"){
  echo("# Polarity Bump: Width,Height",_pbw,_pbh);
  echo("# Prongs: Width,Height",prong_w,_pbh);
  echo("# Backside Pocket: Length,Width,Depth", _px, round(_py*10)/10, (pocket_z>pcb_elev)?pcb_elev:pocket_z );
}
echo("#");
echo("###################################################################");
}
// debugging
//echo("### main_x ###",main_x);

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
      if (variant!="DIP")
        translate([-_px/2,-_py/2,-main_z/2+_pe])
          linear_extrude(pcb_thickness)
            polygon([
              // begin pin1/pin28 end - pin1 corner
              [0,0],
              [-_pbh,0],
              [-_pbh,_pbw],
              [0,_pbw],
              [0,_py-prong_w],
              [-_pbh,_py-prong_w],
              [-_pbh,_py],
              [0,_py],
              // begin pin14/pin15 end - pin15 corner
              [_px,_py],
              [_px+_pbh,_py],
              [_px+_pbh,_py-prong_w],
              [_px,_py-prong_w],
              [_px,prong_w],
              [_px+_pbh,prong_w],
              [_px+_pbh,0],
              [_px,0]
            ]);
      if(variant=="DIP")
        translate([-_px/2,-_py/2,-main_z/2+_pe])
          cube([_px,_py,pcb_thickness]);
    }

    group(){ //REMOVE
      // castellated edge contacts
      mirror_copy([0,1,0])
        for (i=[0:c_positions-1])
          translate([-(c_x_full/2)+(pitch/2)+(i*pitch),c_drill_y,-main_z/2-o])
            cylinder(h=main_z+2*o,d=c_drill_diameter);
      // polarity chamfer
      if(variant=="PCB")
        translate([-_px/2,-_py/2,-main_z/2+pcb_elev-o])
          linear_extrude(pcb_thickness+2*o)
            polygon([
              [pcb_polarity_chamfer+o,-o],
              [-o,-o],
              [-o,pcb_polarity_chamfer+o],
            ]);
      
      // half-holes drilled in the inner sides of the prongs
      if (variant=="maxpcb"){
        translate([-_px/2-_pbh/2,-_py/2,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);
        translate([-_px/2-_pbh/2,-_py/2+_pbw,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);
  
        translate([-_px/2-_pbh/2,_py/2-prong_w,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);
        translate([-_px/2-_pbh/2,_py/2,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);

        translate([_px/2+_pbh/2,_py/2,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);
        translate([_px/2+_pbh/2,_py/2-prong_w,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);

        translate([_px/2+_pbh/2,-_py/2+prong_w,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);
        translate([_px/2+_pbh/2,-_py/2,-main_z/2+pcb_elev]) cylinder(h=pcb_thickness+o , d=_pbh);
      }
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

    if(variant=="DIP"){
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
    } else if (variant=="maxpcb") {

    } else {
      // 3d-print services can't print walls thinner than 0.7mm,
      // so here we shave them off the corner posts, mostly.
      // We leave a small triangular wall in the corner which
      // gets past the validity checkers and creates a small
      // bit of material in the corner like a finger web,
      // which does improve how well the pcb is held in place,
      // especially at the pin28 corner.

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

    if(variant!="DIP"){
    // pocket for backside components
    translate([0,0,pcb_elev-pocket_z])
      cube([pocket_x,pocket_y,main_z],center=true);

    // clearance for socket contacts
    mirror_copy([0,1,0])
      for (i=[0:c_positions-1])
        translate([-(c_x_full/2)+(pitch/2)+(i*pitch),c_y/2+c_width/2,-main_z/2-o])
          hull(){
            cylinder(h=main_z+o*2,d=c_width);
            translate([0,main_y/2-c_y/2,0]) cylinder(h=main_z+o*2,d=c_width);
          }
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
    if(variant=="maxpcb"){
      translate([-main_x/2-o,-pcb_y/2,-main_z/2+pcb_elev]) cube([o+_pbh+o,_pbw,pcb_z]);
      translate([-main_x/2-o,pcb_y/2-prong_w,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
      translate([pcb_x/2-o,pcb_y/2-prong_w,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
      translate([pcb_x/2-o,-pcb_y/2,-main_z/2+pcb_elev]) cube([o+_pbh+o,prong_w,pcb_z]);
    }
    
    // The DIP variant is totally different
    if(variant=="DIP"){
    // main chamfer on the pin dividers
    mirror_copy([0,1,0])
     translate([-c_x_min/2,-main_y/2+1,-main_z/2-o])
      rotate([135,0,0])
       cube([c_x_min,2,1]);
    // cut out the pin pockets
    pin_pocket_width = pitch-min_wall;
    pin_pocket_len = 5;
    pin_bend_wall_width = 1.5;
    pin_bend_wall_inset = 1;
    mirror_copy([0,1,0])
      for (i=[0:c_positions-1]){
        // main pocket
        translate([-(c_x_full/2)+pitch/2-pin_pocket_width/2+(i*pitch),main_y/2-pin_bend_wall_inset-pin_bend_wall_width,-main_z/2+pcb_elev-min_wall])
         rotate([180,0,0])
          cube([pin_pocket_width,pin_pocket_len,3]);
        // bend wall bottom clearance
        translate([-(c_x_full/2)+pitch/2-pin_pocket_width/2+(i*pitch),main_y/2+o,-main_z/2+1])
         rotate([180,0,0])
          cube([pin_pocket_width,pin_pocket_len,3]);
        // bend wall outside clearance
        translate([-(c_x_full/2)+pitch/2-pin_pocket_width/2+(i*pitch),main_y/2-pin_bend_wall_inset,-main_z/2-o])
         rotate([0,0,0])
          cube([pin_pocket_width,pin_bend_wall_inset+1,o+main_z+o]);
      }
    }
  }
}

// pcb retainer snap wedges
if (variant!="maxpcb" && variant!="DIP") mirror_copy([1,0,0]) // pin 14/15 end
  translate([-pcb_x/2,ret_y/2,-main_z/2+pcb_elev+pcb_z]) // pin 1/28 end
    rotate([90,0,0])
      linear_extrude(ret_y)
        polygon([
          [0,0],
          [0,ret_z],
          [ret_x,0]
        ]);

// pcb polarity
if(variant=="PCB")
  translate([-pcb_x/2,-pcb_y/2,-main_z/2])
    linear_extrude(pcb_elev+pcb_z)
      polygon([
        [0,0],
        [0,pcb_polarity_chamfer+_fc/2],
        [pcb_polarity_chamfer+_fc/2,0],
        [pcb_polarity_chamfer+_fc/2,-(main_y/2-pcb_y/2)],
        [0,-(main_y/2-pcb_y/2)],
      ]);
if(variant=="maxpcb"){
  // Intentionally using _py (pcb edge) instead of pcb_y (carrier edge) here to make the fit tight
  translate([-pcb_x/2-prong_cyl/2,-_py/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  translate([-pcb_x/2-prong_cyl/2,-_py/2+_pbw,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

  translate([-pcb_x/2-prong_cyl/2,_py/2-prong_w,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  translate([-pcb_x/2-prong_cyl/2,_py/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

  translate([pcb_x/2+prong_cyl/2,_py/2,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);
  translate([pcb_x/2+prong_cyl/2,_py/2-prong_w,-main_z/2+pcb_elev-o/2]) cylinder(h=pcb_z+o,d=prong_cyl);

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
