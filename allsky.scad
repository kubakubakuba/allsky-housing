use <PiHoles.scad>
include <BOSL/constants.scad>
use <BOSL/threading.scad>

$fn=200;

//parameters
cylinder_height = 12;
cylinder_diameter = 135;
center_hole_diameter = 37;
mounting_hole_diameter = 3;
mounting_hole_distance = 30;
camera_slot_width = 25;
camera_slot_height = 12;
camera_slot_length = 60;
camera_slot_offset = 27;

//screws to screw in the acrylic dome
num_screws = 6;
screw_diameter = 4;
screw_distance = 57;

fan_w = 31; //fan width
fan_h = 8;  //fan height

b_h = 10; //bottom lip height
enclosure_height = 150; //bottom casing height

module mount(){
    translate([-mounting_hole_distance/2, -mounting_hole_distance/2, 5])
    cylinder(h=cylinder_height + 2, d=mounting_hole_diameter, center=true);
    
    translate([-mounting_hole_distance/2, mounting_hole_distance/2, 5])
    cylinder(h=cylinder_height + 2, d=mounting_hole_diameter, center=true);
    
    translate([mounting_hole_distance/2, -mounting_hole_distance/2, 5])
    cylinder(h=cylinder_height + 2, d=mounting_hole_diameter, center=true);
    
    translate([mounting_hole_distance/2, mounting_hole_distance/2, 5])
    cylinder(h=cylinder_height + 2, d=mounting_hole_diameter, center=true);
}

module screws(){
    for (i = [0:num_screws]) {
        rotate([0, 0, i * 360/num_screws])
        translate([screw_distance / sqrt(2), screw_distance / sqrt(2), 0])
        cylinder(h=cylinder_height + 2, d=screw_diameter, center=true);
    }
}

module top(){
    lip_h = 5;
    
    color("#ffffff")
    translate([0, 0, lip_h/2])
    difference(){
        cylinder(h=cylinder_height+lip_h, r1=cylinder_diameter/2,
                r2=cylinder_diameter/2+4, center=true);
        
        cylinder(h=cylinder_height+10, d=cylinder_diameter, center=true);
    }

    difference() {
        cylinder(h=cylinder_height, d=cylinder_diameter, center=true);
        
        cylinder(h=cylinder_height + 2, d=center_hole_diameter, center=true);
               
        mount();
        
        screws();
        
    }

}

module rpi_holder(){
    
    rotate([0, 90, 0])
    translate([-80, -30, 30])
    
    difference(){
        piBoard("3B");
        //translate([-1, -1, -1])
        //cube([25, 100, 10]);
    }
    
    difference(){
        translate([30, -21, 0])
        cube([20, 40, 60]);
    
        translate([25, -50, 80])
        rotate([0, 80, 0])
        cube([200, 200, 200]);  
    }
}


//projection()

module top_part(){
    difference() {
        top();
    
        rotate([0, 180, 0])
        translate([- camera_slot_width / 2, -camera_slot_offset, -cylinder_height/2 - 1])
        cube([camera_slot_width, camera_slot_length, camera_slot_height]);
    }

}

t_id = 130;
t_h = 35;
t_pitch = 8;
t_angle = 30;
t_starts = 3;


module casingThread(){
    translate([0, 0, cylinder_height])
    difference(){
        trapezoidal_threaded_rod(d=t_id, l=t_h, pitch=t_pitch, thread_angle=t_angle,
                                 starts=t_starts, bevel=true);
        
        cylinder(h=cylinder_height+100, d=t_id-10, center=true);
    }
}

module enclosure() {
    difference(){
        union(){
            translate([0, 0, -20])
            difference(){
                cylinder(h=enclosure_height, d=t_id+5);
                translate([0, 0, -1])
                cylinder(h=enclosure_height + 5, d=t_id+1);
                
            }
            
            difference(){ //the inner thread
                trapezoidal_threaded_nut(od=t_id + 2,
                                         id=t_id + 1,
                                         h=t_h,
                                         pitch=t_pitch,
                                         thread_angle=t_angle,
                                         starts=t_starts,
                                         $fa=1,
                                         $fs=1);
                
                translate([0, 0, -25])
                difference(){
                    cylinder(h=100, d=t_id + 50);
                    translate([0, 0, -5])
                    cylinder(h=120, d=t_id + 2);
                }
            }
            
            translate([0, 0, enclosure_height-1.5*b_h])
            difference(){
                bottom();
                translate([0, 0, -99])
                cylinder(h=100, r2=5, r1=750);
            }
        }
    
        translate([0, 0, -17])
        difference(){
            cylinder(h=7, d=t_id+10, center=true);
            cylinder(h=12, d=t_id+3, center=true);
        
        }
    }
    
}

module bottom(){
    center_offset = 25;
    
    difference(){
        cylinder(h=b_h, d=t_id+5, center=true);
        
        translate([-fan_w/2+center_offset, -fan_w/2+center_offset, -20])
        cube([fan_w, fan_w, 100]);
       
        translate([-fan_w/2-center_offset, -fan_w/2-center_offset, -20])
        cube([fan_w, fan_w, 100]);
      
        cylinder(h=50, d=17, center=true); //power cable hole (or PoE)
    }

    translate([center_offset, center_offset, b_h/2 - 1])
    difference(){
        cylinder(h=b_h-fan_h, d=fan_w+20, center=true);
        cylinder(h=b_h-fan_h+100, d=fan_w-2, center=true);
    }
    
    translate([-center_offset, -center_offset, b_h/2 - 1])
    difference(){
        cylinder(h=b_h-fan_h, d=fan_w+20, center=true);
        cylinder(h=b_h-fan_h+100, d=fan_w-2, center=true);
    }
}

module AllSkyHousing(){
    top_part();
    color("#00ffff")
    casingThread();
    color("#ff0000")
    translate([0, 10, 0])
    rpi_holder();
}

   
AllSkyHousing();

translate([0, 0, 150])
enclosure();

//standoffs
/*difference(){
    cylinder(h=10, d=6, center=true);
    cylinder(h=12, d=3, center=true);
}*/

/*

//this is a code to export a DXF sketch of the top part

projection()
difference(){    
    AllSkyHousing();

    difference(){
        cylinder(h=100, d=100.5, center=true);
        cylinder(h=120, d=99.5, center=true);
    }
}

*/


//this is a code for the holder ring adapter

/*

lip_h = 5;

module ring(h){
    holder_height = h;

    difference(){

        union(){

            difference(){
                union(){
                    translate([0, 0, -20])
                    difference(){
                        cylinder(h=holder_height, d=t_id+5);
                        translate([0, 0, -1])
                        cylinder(h=holder_height + 5, d=t_id+1);
                        
                    }

                    difference(){ //the inner thread
                        trapezoidal_threaded_nut(od=t_id + 2,
                                                 id=t_id + 1,
                                                 h=t_h,
                                                 pitch=t_pitch,
                                                 thread_angle=t_angle,
                                                 starts=t_starts,
                                                 $fa=1,
                                                 $fs=1);
                        
                        translate([0, 0, -25])
                        difference(){
                            cylinder(h=100, d=t_id + 50);
                            translate([0, 0, -5])
                            cylinder(h=120, d=t_id + 2);
                        }
                    }
                }
                
                translate([-250, -250, -10])
                cube([500, 500, 500]);
            }
                
            color("#ffffff")
            translate([0, 0, -10])
            difference(){
                cylinder(h=cylinder_height+lip_h, r1=cylinder_diameter/2,
                        r2=cylinder_diameter/2+4, center=true);
                
                cylinder(h=cylinder_height+10, d=cylinder_diameter, center=true);
            }
                
        }
                
        translate([0, 0, -17])
        difference(){
            cylinder(h=7, d=t_id+10, center=true);
            cylinder(h=12, d=t_id+3, center=true); 
        }

    }
}

module hook(tx, ty){ 
    
    difference(){
        cube([2*tx, ty*3, 20]);
        translate([tx/2, ty, -10])
        cube([tx, ty, 100]);
    }
}

module mountpoint(dx, dz){
    translate([dx, cylinder_diameter/2 - 40, dz])
    cube([20, 50, 10]);
    translate([dx, cylinder_diameter/2 + 10, dz])
    hook(10, 5);
}

module hooks(){

    translate([0, -1, 0])
    difference(){
        translate([30, 0, 0])
        union(){
            mountpoint(-10, -12);
            mountpoint(-70, -12);
        }
        
        translate([0, 0, -10])
        cylinder(h=cylinder_height+lip_h, r1=cylinder_diameter/2,
        r2=cylinder_diameter/2+4, center=true);
    }

}

hooks();
    
ring(50);

*/









