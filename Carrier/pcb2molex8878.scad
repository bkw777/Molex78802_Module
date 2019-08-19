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

// main outside box
main_x=39.7;    // 050395288_sd.pdf DIM. F
main_y=16.7;
main_z=7.48;

// cut-away clearance around socket contacts
// so that empty carrier can not get trapped
contacts_x=34.8;
contacts_y=2.6; // cuts inwards from main_y

// pcb
pcb_x=38.1;     // leave walls > 0.7  ( (main_x-pcb_x)/2 >= 0.7 )
pcb_y=16.3;
pcb_z=1.8;      // thickness of pcb (nominal 1.6, plus 0.2)
pcb_elev=2.0;   // bottom of pcb above socket floor
pcb_cham=1.6;   // pin 1 corner polarity chamfer

// cavity in bottom tray for backside components and through-hole legs 
pocket_x=36;
pocket_y=12.5;  // allow tsop48, leave walls >= 0.7
pocket_z=1.2;   // allow tsop48, leave floor >= 0.7
pocket_floor=pcb_elev-pocket_z;

// wedge corner posts - pins 1/28 end
cpwedge_xwide=1.6;      // thick end of wedge
cpwedge_xnarrow=1;      // thin end of wedge
cpwedge_y=21.1;         // total Y outside end to end both posts

// box corner posts - pins 14/15 end
cpbox_x=2.2;    // X len of 1 post
cpbox_y=1.8;    // Y width of 1 post
cpbox_xe=0.3;   // X extends past main_x
cpbox_yo=19.8;  // total Y outside end to end both posts

// socket polarity blades
blade_z=5.2;            // height from top of main_z to bottom of blade
blade_xwide=2.5;        // wide part extend past main_x
blade_xnarrow=1.4;      // narrow part extend past main_x
blade_thickness=1.4;

// finger pull wings
wing_y=8.95;
wing_x=3.2;             // extend past main_x
wing_thickness=1.2;

// pcb retainer wedges
ret_x=1;        // thick end
ret_y=10;       // length
ret_z=2;        // height

// label text
text_z=0.1;             // depth into surface
text_v="pcb2molex8878"; // value

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

// most of the body
difference(){

  // === ADD Shapes ===
  union(){

    // main outer box
    cube([main_x,main_y,main_z],center=true);

    // wedge corner posts
    mirror_copy([0,1,0]) // pin 28
      translate([main_x/2,main_y/2,-main_z/2]) // pin 1
        linear_extrude(main_z)
          polygon([
            [0,0],
            [0,cpwedge_y/2-main_y/2],
            [-cpwedge_xnarrow,cpwedge_y/2-main_y/2],
            [-cpwedge_xwide,0]
          ]);
    
    // box corner posts
    mirror_copy([0,1,0]) // pin 15
      translate([-(main_x/2+cpbox_xe),cpbox_yo/2-cpbox_y,-main_z/2]) // pin 14
        cube([cpbox_x,cpbox_y,main_z]);
    
    // finger pull wings
    mirror_copy([1,0,0]) // pin 14/15 end
      translate([main_x/2+wing_x/2,0,main_z/2-wing_thickness/2]) // pin 1/28 end
        cube([wing_x,wing_y,wing_thickness],center=true);

    // socket polarity blades
    translate([main_x/2,blade_thickness/2,0]) // pin 1/28 end
      blade();
    mirror_copy([0,1,0]) // pin 15
      translate([-main_x/2,wing_y/2-blade_thickness,0]) // pin 14
        rotate([0,0,180])
          blade();
  }

  // === SUBTRACT Shapes ===
  union(){
    // main cavity for pcb
    translate([0,0,pcb_elev])
      cube([pcb_x,pcb_y,main_z],center=true);
    
    // pocket for backside components
    translate([0,0,pcb_elev-pocket_z])
      cube([pocket_x,pocket_y,main_z],center=true);
    
    // clearance for socket contacts
    mirror_copy([0,1,0])
      translate([0,-main_y/2,0])
        cube([contacts_x,contacts_y,main_z+1],center=true);
    
    // remove walls extending from corner posts - too thin for 3d-printing
    translate([main_x/2-cpwedge_xwide-2,pcb_y/2-1,-main_z/2+pcb_elev+pcb_z]) // pin 1 wedge corner post
      cube([2,2,main_z]);
    translate([main_x/2-cpwedge_xwide-2,-pcb_y/2-1,-main_z/2+pcb_elev]) // pin 28 wedge corner post
      cube([2,2,main_z]);
    mirror_copy ([0,1,0]) // pin 14 box corner post
      translate([-main_x/2-cpbox_xe+cpbox_x,-pcb_y/2-1,-main_z/2+pcb_elev]) // pin 15 box corner post
        cube([2,2,main_z]);
    
    // notch in wing 1 / pin 1/28 end
    translate([main_x/2+blade_xwide,-blade_thickness/2,main_z/2-blade_thickness-0.5])
      cube([wing_x-blade_xwide+1,blade_thickness,wing_thickness+1]);

    // engrave label into floor
    translate([0,0,-main_z/2+pocket_floor-text_z])
      rotate([0,0,180])
        linear_extrude(text_z+0.01)
          text(text_v,size=3,halign="center");

  }
}

// pcb retainer snap wedges
mirror_copy([1,0,0]) // pin 1/28 end
  translate([-pcb_x/2,ret_y/2,-main_z/2+pcb_elev+pcb_z]) // pin 14/15 end
    rotate([90,0,0])
      linear_extrude(ret_y)
        polygon([
          [0,0],
          [0,ret_z],
          [ret_x,0]
        ]);

// pcb polarity chamfer
translate([pcb_x/2,pcb_y/2,-main_z/2+pcb_elev])
  linear_extrude(pcb_z)
    polygon([
      [-pcb_cham,0],
      [0,0],
      [0,-pcb_cham]
    ]);
