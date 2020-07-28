use <mayscadlib/positioning.scad>
use <mayscadlib/3d/screws.scad>
use <mayscadlib/3d/fillets.scad>


ps_width=53.2;
ps_height=40;

cable_flange_dia=28;

thickness=3;

overlap=12;

$fn=100;

module end_2d() {
    difference() {
        corner_rad = 1.5;
        translate([-ps_width/2-thickness, -ps_height/2])
        hull() {
            //place(rect_corners([ps_width+2*thickness-1, ps_height+thickness-1]))
            translate([0, ps_height+thickness-corner_rad]) {
                translate([corner_rad,0])
                circle(r=corner_rad);
                translate([ps_width+2*thickness-corner_rad,0])
                circle(r=corner_rad);
            }
            square([.1,.1]);
            translate([ps_width+2*thickness-.1,0])
            square([.1,.1]);
            //square([ps_width+2*thickness, ps_height+thickness]);
        }

        circle(r=cable_flange_dia/2);
        translate([0, -ps_height/2])
        square([cable_flange_dia, ps_height], center=true);
    }
}

module extr_2d() {
    difference() {
        end_2d();
        square([ps_width, ps_height], center=true);
    }
}

function mountpoint_screw_pos() = [5, 5];

module mountpoint_2d_base() {
    dia=10;
    hull() {
        square([.001, overlap+thickness]);
        translate([dia/2, dia/2])
        circle(r=dia/2);
    }
}

module mountpoint() {
    mp_thickness=5;

    
    rotate([90,0,180]) {
        difference() {
            linear_extrude(height=mp_thickness)
            mountpoint_2d_base();
            translate(concat(mountpoint_screw_pos(), [mp_thickness]))
            spax_3x12_z1(clearance=2);
        }
        lift(mp_thickness)
        fillet_line(overlap+thickness-.07, 1.5, slope=1.5);
    }
}

and_mirror([1,0,0])
translate([-ps_width/2-thickness,-ps_height/2,-thickness])
mountpoint();

linear_extrude(height=overlap)
extr_2d();

lift(-thickness)
linear_extrude(height=thickness)
end_2d();
