$fn=200;

cylinder_height = 12;
cylinder_diameter = 135;
center_hole_diameter = 37;

//screws to screw in the acrylic dome
num_screws = 6;
screw_diameter = 4;
screw_distance = 57;

module screws(){
    for (i = [0:num_screws]) {
        rotate([0, 0, i * 360/num_screws])
        translate([screw_distance / sqrt(2), screw_distance / sqrt(2), 0])
        cylinder(h=cylinder_height + 2, d=screw_diameter, center=true);
    }
}

module top(){
    difference() {
        cylinder(h=cylinder_height, d=cylinder_diameter, center=true);
        
        cylinder(h=cylinder_height + 2, d=center_hole_diameter, center=true);
        
        screws();
        
    }
}

gasket_thickness = 2;
gasket_din = 100;
gasket_dout = 130;

//translate([0, 0, -cylinder_height/2 - gasket_thickness/2])
//top();

module gasket(din, dout, thickness){
	
	difference(){
		cylinder(h=thickness, d=dout, center=true);
		cylinder(h=thickness+2, d=din, center=true);
		screws();
	}
}

gasket(gasket_din, gasket_dout, gasket_thickness);



