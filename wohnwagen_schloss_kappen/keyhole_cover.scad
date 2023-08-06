/* MEASUREMENTS
 * 
 * Outer Diameter (Both sides): 29mm
 * Inner Diameter (cover): 26mm
 * Inner Diameter (Mounting Cutout): 21mm
 * Connecting Part length: 10mm
 * Connecting Part width: 10mm
 *
 */

outer_diameter = 30;
cover_inner_diameter = 26;
mount_inner_diameter = 22;
connector_size = [10, 10];
lid_overlap = .5;
cover_total_height = 9;
clip_ring_inner_dia = 24.5;
clip_ring_offset = 2.2;
pulltab_stickout = 10;
pulltab_height = cover_total_height + 5;
pulltab_width = 10;
pulltab_thickness = 2;

$fn = 100;

module mount() {
    linear_extrude(1.7)
    difference() {
	circle(r=outer_diameter / 2);
	circle(r=mount_inner_diameter / 2);
    }
}

module connector() {
    cover_overlap = (outer_diameter - cover_inner_diameter) / 2;
    linear_extrude(1)
    translate([-connector_size.x/2, -cover_overlap])
    difference() {
	square([connector_size.x, connector_size.y + (outer_diameter - mount_inner_diameter) / 2 + cover_overlap]);
    }
}

module cover() {
    wall_thickness = (outer_diameter - 1 - cover_inner_diameter)/2;
    linear_extrude(cover_total_height - wall_thickness + lid_overlap)
    difference() {
	circle(r=outer_diameter / 2);
	circle(r=cover_inner_diameter / 2);
    }

/*
    translate([0,0,cover_total_height - wall_thickness])
    linear_extrude(wall_thickness)
    circle(r=outer_diameter/2);
*/

    clip_size = (cover_inner_diameter - clip_ring_inner_dia) / 2;
    translate([0,0,clip_ring_offset])
    rotate_extrude()
    translate([cover_inner_diameter/2,0])
    rotate([0,0,90])
    polygon([[0,0],
	     [clip_size*2, 0],
	     [clip_size, clip_size],
    ]);
}

module pulltab() {
    cover_overlap = (outer_diameter - cover_inner_diameter) / 2;

    linear_extrude(pulltab_thickness)
    translate([-pulltab_width/2, -pulltab_stickout])
    square([pulltab_width, pulltab_stickout + cover_overlap]);

    top_rad = pulltab_width / 2;
    
    translate([0,-pulltab_stickout])
    rotate([90,0,0])
    linear_extrude(pulltab_thickness) {
	translate([-pulltab_width/2, 0])
	square([pulltab_width, pulltab_height - top_rad]);
	translate([0,pulltab_height - top_rad])
	circle(top_rad);
    }

    translate([pulltab_width/2, -pulltab_stickout + pulltab_thickness, pulltab_thickness*2])
    rotate([0,90,180])
    linear_extrude(pulltab_width)
    difference() {
	square([pulltab_thickness, pulltab_thickness]);
	circle(pulltab_thickness);

    }
}

module assembly_cap() {
    translate([0,outer_diameter + connector_size.y])
    mount();

    translate([0, outer_diameter/2])
    connector();

    cover();

    translate([0, -outer_diameter/2])
    pulltab();
}

module lid() {
    wall_thickness = (outer_diameter - 1 - cover_inner_diameter)/2;

    linear_extrude(wall_thickness - lid_overlap)
    circle(r=outer_diameter/2);
    translate([0,0,wall_thickness - lid_overlap])
    linear_extrude(lid_overlap)
    circle(r=cover_inner_diameter/2 - .1);
}

//assembly_cap();
lid();
