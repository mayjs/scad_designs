use <mayscadlib/positioning.scad>

$fn = 100;

eyelet_outer_r=4;
eyelet_w=2;
pin_w=3;
pin_l=30;
tip_h=2;

linear_extrude(height=pin_w) {
    translate([-eyelet_outer_r,0])
    square([eyelet_outer_r*2, eyelet_w]);
    translate([0, eyelet_w])
    difference() {
        circle(r=eyelet_outer_r);
        circle(r=eyelet_outer_r-eyelet_w);
        translate([0,-eyelet_outer_r])
        square(eyelet_outer_r*2, center=true);
    }

    difference() {
        polygon([
            [-pin_w/2,0],
            [-pin_w/2,-pin_l+tip_h],
            [0, -pin_l],
            [pin_w/2, -pin_l+tip_h],
            [pin_w/2, 0],
        ]);

        and_mirror([1,0,0])
        for(i=[1:15]) {
            translate([pin_w/2-.5,-5-i*2,0])
            rotate([0,0,-30])
            square([2,5]);
        }
    }
}
