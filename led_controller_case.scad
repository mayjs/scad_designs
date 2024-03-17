use <mayscadlib/positioning.scad>

wall_thickness = 3;
first_layer = .3;

crease_width = 2*wall_thickness;

$fs = 0.5;

module make_crease(width) {
    rotate([90, 0, 90])
    linear_extrude(height=width)
    polygon([
        [-first_layer/2,first_layer],
        [first_layer/2,first_layer],
        [wall_thickness, wall_thickness+.1],
        [-wall_thickness, wall_thickness+.1]
    ]);
}

module foldable_box_bottom(inner_box_dims) {
    difference () {
        // Base geometry
        linear_extrude(wall_thickness) {
            square([inner_box_dims.x, inner_box_dims.y]);

            // Left and right side
            place([[-inner_box_dims.z - crease_width - wall_thickness, 0], [inner_box_dims.x, 0]])
            square([inner_box_dims.z + crease_width + wall_thickness, inner_box_dims.y]);
            // bottom side 
            translate([0, -inner_box_dims.z - crease_width - wall_thickness])
            square([inner_box_dims.x, inner_box_dims.z + crease_width + wall_thickness]);

            // Add "blocks" on the bottom where the creases meet
            bottom_block_size = crease_width/2 - first_layer/2;
            place([[-bottom_block_size, -bottom_block_size], [inner_box_dims.x, -bottom_block_size]])
            square([bottom_block_size, bottom_block_size]);

            // Add material to the folding part that will meet the bottom blocks
            place([[-crease_width/2, -inner_box_dims.z - crease_width - wall_thickness, 0], [inner_box_dims.x, -inner_box_dims.z - crease_width - wall_thickness, 0]])
            square([crease_width/2, inner_box_dims.z + wall_thickness]);
        }
        
        translate([0, -crease_width/2, 0])
        make_crease(inner_box_dims.x);

        translate([-crease_width/2, 0, 0])
        rotate([0, 0, 90])
        make_crease(inner_box_dims.y);

        translate([inner_box_dims.x + crease_width/2, 0, 0])
        rotate([0, 0, 90])
        make_crease(inner_box_dims.y);
    }
}

// Coordinates in KiCAD space - KiCAD X is our Y and KiCAD Y is our X

// PCB origin is on the corner between the encoder edge and the USB edge (Top Left in KiCAD)
kicad_pcb_origin = [53.35, 50.5];
kicad_pcb_end = [129.6, 111.7];

kicad_mounting_locations = [
    [124.95, 54.8],
    [112.3, 108.15],
    [67, 107.9],
    [67, 54.2]
];

kicad_encoder_y_locations = [58.5, 103.75];

kicad_usb_location_x = 83.74;

// From here on, all values are all in our coordinate space
pcb_size = [kicad_pcb_end.y - kicad_pcb_origin.y, kicad_pcb_end.x - kicad_pcb_origin.x];
mount_positions = [
    for (kicad_mount_pos = kicad_mounting_locations)
    [kicad_mount_pos.y - kicad_pcb_origin.y, kicad_mount_pos.x - kicad_pcb_origin.x]
];
encoder_x_positions = [
    for (kicad_encoder_y_pos = kicad_encoder_y_locations)
    kicad_encoder_y_pos - kicad_pcb_origin.y
];

usb_y_location = kicad_usb_location_x - kicad_pcb_origin.x;

mountpost_height = 4; // 4mm to accomodate the solder points
mountpost_drill = 4.15;
mountpost_wall = 2;

extra_space_around_pcb = 3;

encoder_screw_dia = 7;
encoder_top_height = 11;
encoder_central_height = encoder_top_height - encoder_screw_dia/2;
encoder_drill_size = 10;

inner_case_height = mountpost_height + 35;

total_inner_case_size = [pcb_size.x + 2*extra_space_around_pcb, pcb_size.y + 2*extra_space_around_pcb, inner_case_height];

lid_screw_locations_left_right_y = [for (i=[1,5,9]) i*.1*total_inner_case_size.y];
lid_screw_locations_front_x = [total_inner_case_size.x / 2];

usb_cutout_size = [9, 4];

module pcb_mountpost() {
    linear_extrude(mountpost_height)
    difference() {
        circle(mountpost_drill/2 + mountpost_wall);
        circle(mountpost_drill/2);
    }
}


case_mountpost_outer_dia = mountpost_drill + 2*mountpost_wall;
case_mountpost_height = mountpost_wall + mountpost_height;
module case_mountpost() {
    translate([case_mountpost_outer_dia/2, case_mountpost_outer_dia/2]) {
        linear_extrude(mountpost_wall)
        square([case_mountpost_outer_dia, case_mountpost_outer_dia], center=true);
        translate([0, 0, mountpost_wall])
        linear_extrude(mountpost_height)
        difference() {
            square([case_mountpost_outer_dia, case_mountpost_outer_dia], center=true);
            circle(mountpost_drill/2);
        }
    }
}

// TODO: Adjust USB cutout
// TODO: Move PCB a bit closer to the front

difference() {
    foldable_box_bottom(total_inner_case_size);
    translate([0,0,-.1])
    place([for (x = encoder_x_positions) [extra_space_around_pcb + x, -crease_width - encoder_central_height - mountpost_height]])
    cylinder(r = encoder_drill_size/2, h=wall_thickness * 2);

    translate([-crease_width - mountpost_height - usb_cutout_size.y, usb_y_location, -.1])
    translate([0, -usb_cutout_size.x/2])
    cube([usb_cutout_size.y, usb_cutout_size.x, 2*wall_thickness]);
}

translate([extra_space_around_pcb, extra_space_around_pcb, wall_thickness])
place(mount_positions)
pcb_mountpost();

place([for (y=lid_screw_locations_left_right_y) [-crease_width - total_inner_case_size.z, y]])
translate([case_mountpost_height, case_mountpost_outer_dia/2, wall_thickness])
rotate([90, 0, -90])
case_mountpost();

place([for (y=lid_screw_locations_left_right_y) [total_inner_case_size.x + crease_width + total_inner_case_size.z - case_mountpost_height, y]])
translate([0, -case_mountpost_outer_dia/2, wall_thickness])
rotate([90, 0, 90])
case_mountpost();

place([for (x=lid_screw_locations_front_x) [x, -crease_width - total_inner_case_size.z]])
translate([-case_mountpost_outer_dia/2, case_mountpost_height, wall_thickness])
rotate([90, 0, 0])
case_mountpost();

