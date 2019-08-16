// OpenSCAD model for pcb2molex8878
// Mates with pcb2molex8878.kicad_pcb

// Carrier to hold a pcb in place of a DIP28
// to fit into Molex 8878 socket found in some vintage computers.
// Ex: Tandy Model 100, 102, 200, 600
//       Epson PX-4, PX-8

// Brian K. White - b.kenyon.w@gmail.com
// http://tandy.wiki/pcb2molex8878
// http://www.github.com/aljex/pcb2molex8878

// -------------------------------------------------------------------------
// globals

// main outside box
main_x=39.74;
main_y=16.7;
main_z=7.48;

// clearance around socket contacts
contacts_x=34.8;
contacts_y=2.6;

// pcb
pcb_x=37.6;
pcb_y=15.2;
pcb_z=1.6;
pcb_elev=2.2;

// cavity in bottom tray for backside components and through-hole legs 
pocket_x=36;
pocket_y=12.5;
pocket_z=1.2;

// box corner posts
bc_x=2.2; // X len of 1 post
bc_y=1.8; // Y width of 1 post
bc_xe=0.3; // X extend past main_x
bc_yo=19.75;  // total Y outside end to end both posts

// wedge corner posts
wc_x1=1.6; // thick end of wedge
wc_x2=1; // thin end of wedge
wc_y=21; // total Y outside end to end both posts

// socket polarity blades
blade_z=5; // height
blade_x1=2.5; // wide legnth
blade_x2=1.25; // narrow length 
bt_thickness=1.25; // blade & tab thickness
tab_y=8.9; // width of top tabs
tab_x=3.5; // tab X extend past main_x

// pcb polarity pin
pp_x=14.53;  // center X
pp_y=3.4;  // center Y
pp_z=pcb_elev+pcb_z-0.2;  // pin height less than wedge bottom
pp_d=2.6; // diameter


// pcb retainer wedges
w_x=1;  // thick end
w_y=10;  // width
w_z=2;  // height


module mirror_copy(vector){
    children();
    mirror(vector) children();
}

module blade(){
    rotate([90,0,0]) translate([0,-blade_z+main_z/2,0]) linear_extrude(bt_thickness) polygon([ [0,0],[0,blade_z],[blade_x1,blade_z],[blade_x1,blade_z-bt_thickness],[blade_x2,blade_z-bt_thickness*2],[blade_x2,0] ]);
}

module wing(){
    cube([tab_x,tab_y,bt_thickness],center=true);
}

module wedge(){
   rotate([90,0,0]) linear_extrude(w_y) polygon([ [0,0],[0,w_z],[w_x,0] ]);
}

module complexObject(){
    difference(){

        // === ADDITIVE ===
        union(){
            // main outer box
            cube([main_x,main_y,main_z],center=true);

            // wedge corner posts  - pin 1 end
            mirror_copy([0,1,0]) translate([main_x/2,main_y/2,-main_z/2]) linear_extrude(main_z) polygon([ [0,0],[0,wc_y/2-main_y/2],[-wc_x2,wc_y/2-main_y/2],[-wc_x1,0] ]);
            
            // box corner posts
            mirror_copy([0,1,0]) translate([-(main_x/2+bc_xe),bc_yo/2-bc_y,-main_z/2]) cube([bc_x,bc_y,main_z]);
            
            // tabs
            translate([main_x/2+tab_x/2,0,main_z/2-bt_thickness/2]) wing();
            translate([-(main_x/2+tab_x/2),0,main_z/2-bt_thickness/2]) wing();

            // socket polarity blades
            translate([main_x/2,bt_thickness/2,0]) blade(); // pin 1 end
            mirror_copy([0,1,0]) translate([-main_x/2,tab_y/2-bt_thickness,0]) rotate([0,0,180]) blade();
        }

        // === SUBTRACTIVE ===
        union(){
            // main cavity for pcb
            translate([0,0,pcb_elev]) cube([pcb_x,pcb_y,main_z],center=true);
            
            // pocket for backside components
            translate([0,0,pcb_elev-pocket_z]) cube([pocket_x,pocket_y,main_z],center=true);
            
            // clearance for socket contacts
            mirror_copy([0,1,0]) translate([0,-main_y/2,0]) cube([contacts_x,contacts_y,main_z+1],center=true);
            
            // notch in wing 1
            translate([main_x/2+blade_x1,-bt_thickness/2,main_z/2-bt_thickness-0.5]) cube([tab_x-blade_x1+1,bt_thickness,bt_thickness+1]);
        }
        
    }
}

// most of the body
complexObject();

// pcb retainer wedges
mirror_copy([1,0,0]) translate([-pcb_x/2,w_y/2,-main_z/2+pcb_elev+pcb_z]) wedge();

// pcb polarity pin
translate([pp_x,pp_y,-main_z/2+pp_z/2]) cylinder(h=pp_z, d=pp_d,center=true,$fn=32);
