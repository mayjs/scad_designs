use <mayscadlib/3d/screws.scad>
use <mayscadlib/3d/fillets.scad>
use <mayscadlib/positioning.scad>
use <mayscadlib/2d/shapes.scad>

$fn = 100;

height=25;

bracket_w=12;
bottom_w=20;
bottom_h=4;
other_thick=3;
screw_loc = 5+4.5/2;

echo(screw_loc);

//module fillet_line(line_length, fillet_rad, slope=0, slope_slices_per_mm=10, center=false) {

translate([other_thick, 0, bottom_h])
fillet_line(bracket_w, fillet_rad=other_thick/2, center=true, negative=false);

difference() {
    translate([-screw_loc+other_thick/2, 0, height])
    difference() {
        linear_extrude(height=other_thick)
        rounded_square(size=[2*screw_loc+other_thick, bracket_w], corner_rad=other_thick/2, corner_override=[-1,0,0,-1], center=true);

        lift(other_thick)
        translate([-.5,0,0])
        rotate([0,0,90])
        make_screw(fan_screw(), head_clearance=1, hole_length=12);
    }
    translate([other_thick,0,height+other_thick])
    rotate([0,180,0])
    fillet_line(bracket_w, fillet_rad=other_thick/2, center=true, negative=false);
}


translate([0,-bracket_w/2,0])
cube(size=[other_thick, bracket_w,height]);

translate([bottom_w/2, 0,0])
difference() {
    linear_extrude(height=bottom_h)
    rounded_square(size=[bottom_w, bracket_w], corner_rad=other_thick/2, corner_override=[0,-1,-1,0], center=true);

    translate([other_thick/2,0,0])
    lift(bottom_h)
    spax_3x12_z1();
}
