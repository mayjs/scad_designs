use <mayscadlib/positioning.scad>
use <mayscadlib/vec.scad>

$fn = 100;
hole_dists = [58, 49];
spax_pos = vec_cont(hole_dists, 21);
pi_dims = [85, 56];
spax_dia = 3;

plate_h = 4;
arm_w = 7;

module mount_hole(inner=2.5, outer=arm_w, height=4, hull=false) {
    linear_extrude(height=height)
    difference() {
        circle(r=outer/2);
        if(!hull) {
            circle(r=inner/2);
        }
    }
}

module backplate() {
    lift(plate_h)
    place(rect_corners(hole_dists, center=true))
    mount_hole();

    // Arms
    linear_extrude(height=plate_h)
    difference() {
        and_mirror([1,0,0])
        hull()
        plus_minus(spax_pos/2)
        circle(r=arm_w/2);

        place(rect_corners(spax_pos, center=true))
        circle(r=spax_dia/2);
    }

    linear_extrude(height=plate_h)
    difference() {
        outer = min(hole_dists)/2;
        circle(r=outer);
        circle(r=outer-arm_w);
    }
}

module topplate() {
    mount_pin_h = 4 + 1.6;
    clear_h = 15;

    place(rect_corners(hole_dists, center=true)) {
        lift(plate_h)
        cylinder(r=2.4/2, h=mount_pin_h);
        lift(plate_h + mount_pin_h)
        cylinder(r=6/2, h=clear_h);
    }

    lift(plate_h + mount_pin_h + clear_h)
    linear_extrude(height=plate_h) {
        and_mirror([1,0,0])
        hull()
        plus_minus(hole_dists/2)
        circle(r=arm_w/2);
        
        difference() {
            outer = min(hole_dists)/2.6;
            circle(r=outer);
            circle(r=outer-arm_w);
        }
    }
}

module dummy_pi() {
    color("green", 0.7)
    lift(plate_h + 4)
    linear_extrude(height=16)
    translate(-[3.5, 3.5])
    translate(-hole_dists/2)
    difference() {
        square(size=pi_dims);
        translate([3.5, 3.5])
        place(rect_corners(hole_dists))
        circle(r=2.7/2);
    }
}

backplate();
topplate();
dummy_pi();
