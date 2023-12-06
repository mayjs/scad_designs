grip_outer_dia = 50;
grip_protrusion_size = 6;
number_of_protrusions = 7;
smootheness = 3;
grip_height = 18;

$fn=100;

use <dotSCAD/src/rounded_extrude.scad>

module profile_2d(center_drill=0) {
    difference() {
	offset(r=smootheness)
	offset(r=-smootheness)
	difference() {
	    circle(r=grip_outer_dia/2);
	    for(i = [0:number_of_protrusions]) {
		rotate([0,0,i * (360 / (number_of_protrusions))])
		translate([grip_outer_dia/2,0,0])
		circle(r=grip_protrusion_size);
	    }
	}
	if(center_drill > 0) {
	    circle(r=center_drill/2);
	}
    }
}

rounded_extrude(grip_outer_dia, smootheness, $fn=50)
scale(grip_outer_dia / (grip_outer_dia + smootheness*2))
profile_2d();
translate([0,0,smootheness])
linear_extrude(grip_height - smootheness * 2)
profile_2d();

translate([0,0,grip_height])
mirror([0,0,1])
rounded_extrude(grip_outer_dia, smootheness, $fn=50)
scale(grip_outer_dia / (grip_outer_dia + smootheness*2))
profile_2d();
