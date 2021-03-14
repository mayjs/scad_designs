use <mayscadlib/2d/shapes.scad>;
use <mayscadlib/positioning.scad>;
use <mayscadlib/math.scad>;

$fs=.1;

glass_size = [95, 55];
offset = 0;
wall_sz = 3;
strip_w = 6;
plate_thickness = 2;
top_overlap = 2.5;
outer_wall = 1;
rad = 1;

radio_pcb_sz = [85, 36];
radio_hole_dia = 2.7;
box_inner_h = 20;
lip_h = 3;

play = .2;

radio_pcb_base = [-34.87, -108.03];
radio_hole_locations = [
        radio_pcb_base + [48.514, 111.252],
        radio_pcb_base + [116.332, 114.808],
        radio_pcb_base + [116.332, 137.668],
];

box_cut_dims = [35, 10];


module radio_mock() {
  color("green")
  linear_extrude(height=2)
  translate(-radio_pcb_sz/2)
  difference() {
    square(size=radio_pcb_sz, center=false);
    place(radio_hole_locations)
    circle(radio_hole_dia/2);
  }
}

module lid() {
  linear_extrude(height=plate_thickness)
  difference() {
    square(size=glass_size - [play*2,play*2], center=true); 
    square(size=[glass_size[0]-wall_sz*2-10, strip_w], center=true);
  }
}


radio_post_standoff = 5;
module radio_post() {
  stack_extrude([radio_post_standoff, 3]) {
    circle((radio_hole_dia + play) / 2);
    circle((radio_hole_dia - play*2) / 2);
  }
}

module box() {
  total_size = glass_size + [2*outer_wall,2*outer_wall];
  module base2d() {
    rounded_square(size=total_size, corner_rad=rad, center=true);
  }

  difference() {
    offsets = [plate_thickness, box_inner_h, lip_h+plate_thickness];
    stack_extrude(offsets) {
      base2d();
      difference() {
        base2d();
        square(size=glass_size-[2*top_overlap, 2*top_overlap], center=true);
      }
      difference() {
        base2d();
        square(size=glass_size, center=true);
      }
    }
    translate([radio_pcb_sz.x/2, total_size.y/2, plate_thickness + radio_post_standoff])
    translate([-box_cut_dims.x, 0])
    rotate([90,0,0])
    linear_extrude(height=outer_wall+top_overlap)
    rounded_square(size=box_cut_dims, corner_rad=rad*2);
  }
  translate(-radio_pcb_sz/2)
  lift(plate_thickness)
  place(radio_hole_locations)
  radio_post();
}

//lift(plate_thickness + box_inner_h)
//lid();
//color("red")
box();

// lift(plate_thickness + radio_post_standoff)
// radio_mock();
