$fn = 200;
thickness = 10; // [0:100]
height = 9; // [0:100]

arc_radius = 90; //[0:250]

lip_height = 30; //[0:100]
lip_length = 35; //[0:100]
lip_depth = 50;  //[0:100]

foot_height = 50; //[0:100]
foot_length = 70; //[0:100]

module arc(r){
    difference(){
        cylinder(h=height, d=2*r);
        translate([0, 0, -1])
        cylinder(h=height+2, d=2*r - thickness);
        
        translate([0, 0, -1])
        cube([r+5, r+5, height+5]);
        translate([1, 0, -1])
        rotate([0, 0, 90])
        cube([r+5, r+5, height+5]);
        translate([0, 1, -1])
        rotate([0, 0, -90])
        cube([r+5, r+5, height+5]);
    }
}

module lip(h, length, depth){
    translate([0, -arc_radius, 0])
    union(){
        cube([h, thickness/2, height]);
        
        translate([h, 0, 0])
        cube([thickness/2, length, height]);

        translate([-(depth-h), length - thickness/2, 0])    
        cube([depth, thickness/2, height]);
    }
}

module foot(h, l){
    translate([-arc_radius, 0, 0])
    cube([thickness/2, l, height]);
    
    translate([-arc_radius, l, 0])
    cube([h, thickness/2, height]);
}

module holder(t){
    
    translate([0, -arc_radius - lip_length + thickness/2, 0])
    union(){
        translate([t, 0, 0])
        cube([30, thickness/2, height]);
        cube([t, 30, height]);
    }
}

module hook(tx, ty){ 
    
    difference(){
        cube([2*tx, ty*3, 20]);
        translate([tx/2, ty, -10])
        cube([tx, ty, 100]);
    }
}

module connector(l){

    translate([l, 0, 0])
    hook(tx=height, ty=thickness/2);
    hook(tx=height, ty=thickness/2);
    
    translate([thickness*2, 2.5, 0])
    cube([40, thickness, height*2]);
}

module AllSkyMount(){

arc(r=arc_radius);

lip(h=lip_height, length=lip_length, depth=lip_depth);

foot(h=foot_height, l=foot_length);

holder(t=15);

}

AllSkyMount();

//connector(l = 60);










