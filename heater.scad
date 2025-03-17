$fn = 200;

r_in = 28;
fan_w = 30;
fan_h = 8;
h_h = 50;


module tube(){
	cylinder(h=h_h/4, d=r_in+2);
}

module fan_holder(){
	translate([-fan_w/2, -fan_w/2, -fan_h])
		cube([fan_w+2, fan_w+2, fan_h]);
}

module hole(){
	rotate([0, 90, 0])
	translate([0, 0, -50])
	cylinder(h=100, r=2);
}

difference(){
	hull(){
		translate([1, 1, 0])
		tube();
		fan_holder();
	}

	translate([-fan_w/2, -fan_w/2, -fan_h])
	translate([1, 1, -1])
	cube([fan_w, fan_w, fan_h+2]);
	
	
	translate([1, 1, -1])
		cylinder(h=h_h+20, d=r_in);
}


difference(){
	translate([1, 1, 2])
	cylinder(h=h_h-2, d=r_in+2);
	
	translate([1, 1, -1])
	cylinder(h=h_h+20, d=r_in);
	
	translate([0, 0, 20])
	hole();
	
	translate([0, 0, 20])
	rotate([0, 0, 90])
	hole();
}

	//translate([0, 0, -1])
		//cylinder(h=h_h+20, d=r_in);
//difference(){
		//cylinder(h=h_h/4, d=r_in+2);
		
		
	//}
//translate([0, 0, -1])
		//cylinder(h=h_h+2, d=r_in);