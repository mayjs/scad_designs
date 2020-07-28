use <mayscadlib/positioning.scad>
use <mayscadlib/3d/fillets.scad>

pipe_od = 12;
pipe_id = 10;
wall_screw_dia=4.5;
wall_screw_head_dia=9;
wall_screw_head_h=4;
pipe_screw_dia=3;

screw_dist = 6;
wall_thickness = 3;

screw_play = .2;

$fn = 100;

plate_thickness = 10;

holder_thickness = 10;
solid_holder_part = 6;
fillet_r = 5;
manifold_modifier=0.001;

module at_base_screw_holes() {
    and_mirror([1,0,0])
    translate([screw_dist + pipe_od/2 + pipe_screw_dia/2 + 2*wall_thickness, 0])
    children();
}

module base_plate_2d() {
    difference() {
        hull() {
            at_base_screw_holes()
            circle(r=wall_screw_dia/2 + wall_thickness);

            circle(r=pipe_od/2 + wall_thickness + fillet_r);
        }
        at_base_screw_holes()
        circle(r=wall_screw_dia/2 + screw_play);
    }
}

module base_screw_head_holes() {
    at_base_screw_holes()
    //circle(r=wall_screw_head_dia/2 + screw_play);

    rotate_extrude()
    polygon([
            [0,0],
            [wall_screw_dia/2+screw_play, 0],
            [wall_screw_head_dia/2+screw_play, wall_screw_head_h],
            [0,wall_screw_head_h],
            ]);
}

// module fillet_ring(ring_rad, fillet_rad, angle=360, inner=false, slope=0, slope_slices_per_deg=5) {

module holder_cyl_2d() {
    difference() {
        circle(r=pipe_od/2+wall_thickness);
        circle(r=pipe_od/2 + 1.5*screw_play);
    }
    circle(r=pipe_id/2 - screw_play);
}

module solid_holder_2d() {
    circle(r=pipe_od/2+wall_thickness);
}

spax_dia = 3;
spax_head_dia = 6;
spax_head_h = 3;
spax_clearance = 10;
spax_screw_only_h = 11;

module spax_hole() {
    screw_only_h = max(spax_screw_only_h, pipe_od/2+wall_thickness - spax_head_h);
    lift(pipe_od/2+wall_thickness - spax_head_h - spax_screw_only_h) {
        cylinder(r=spax_dia/2, h=screw_only_h);
        lift(screw_only_h)
        rotate_extrude()
        polygon([
                [0,0],
                [spax_dia/2+screw_play, 0],
                [spax_head_dia/2+screw_play, spax_head_h],
                [spax_head_dia/2+screw_play, spax_head_h+spax_clearance],
                [0, spax_head_h+spax_clearance],
                [0,spax_head_h],
                ]);
    }
}

difference() {
    union() {
        fillet_ring(pipe_od/2 + wall_thickness - manifold_modifier, fillet_r);
        linear_extrude(height=holder_thickness+solid_holder_part)
        holder_cyl_2d();
    }
    lift(holder_thickness/2 + solid_holder_part)
    rotate([-90,0,0])
    spax_hole();
}

linear_extrude(height=solid_holder_part)
solid_holder_2d();

difference() {
    lift(-plate_thickness)
    linear_extrude(height=plate_thickness)
    base_plate_2d();

    lift(-wall_screw_head_h)
    base_screw_head_holes();
}

