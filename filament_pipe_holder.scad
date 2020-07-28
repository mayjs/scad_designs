use <mayscadlib/3d/screws.scad>;
use <mayscadlib/3d/fillets.scad>;
use <mayscadlib/positioning.scad>;

$fn=100;

m5_screw = m5_pan_head(8);

pipe_dia = 40;
pipe_holder_walls = 4;
screw_head_walls = 2;

screw_hole_dia = screw_head_dia(m5_screw) + 2*screw_head_walls;

tri_width = pipe_dia + 2*pipe_holder_walls + screw_hole_dia;

screw_mat = 2;
backplate_h = screw_mat + screw_head_h(m5_screw);

screw_positions = translate_points([-tri_width/2,0], isosceles_triangle(tri_width, pipe_dia/2+screw_hole_dia/2));
holder_h = 20;


module backplate2d() {
    offset(r=screw_head_walls)
    hull() {
        place(screw_positions) circle(r=screw_hole_dia/2 - screw_head_walls);
        circle(r=pipe_dia/2 + pipe_holder_walls);
    }
}

module backplate() {
    difference() {
        linear_extrude(height=backplate_h)
        backplate2d();

        // TODO: Lifting by head height seems unergonomic here, we might want to add alignment modes to the make_screw module
        lift(screw_head_h(m5_screw) + screw_mat)
        place(screw_positions) make_screw(m5_screw, head_clearance=5);
    }
}

module holder_part_2d() {
    difference() {
        circle(r=pipe_dia/2 + pipe_holder_walls);
        circle(r=pipe_dia/2);
        translate([-pipe_dia/2 - pipe_holder_walls, 0])
        square(size=[pipe_dia+2*pipe_holder_walls, pipe_dia+2*pipe_holder_walls]);
    }
}

module holder_part() {
    linear_extrude(height=holder_h)
    holder_part_2d();
    rotate([0,0,180])
    fillet_ring(pipe_dia/2 + pipe_holder_walls, screw_head_walls-.2, angle=180);
    
    //module fillet_ring(ring_rad, fillet_rad, angle=360, inner=false, slope=0, slope_slices_per_deg=5) {
}

lift(-backplate_h) 
backplate();

holder_part();


