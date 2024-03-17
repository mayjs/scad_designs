
wall_thickness = 3;

part_size = [100,50];

first_layer = .3;

difference() {
    translate([-part_size.x/2,0,0])
    cube([part_size.x, part_size.y, wall_thickness]);

    translate([0,part_size.y,0])
    rotate([90,0,0])
    linear_extrude(height=part_size.y)
    polygon([
        [-first_layer/2,first_layer],
        [first_layer/2,first_layer],
        [wall_thickness, wall_thickness],
        [-wall_thickness, wall_thickness]
    ]);
}
