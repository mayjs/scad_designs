use <mayscadlib/2d/bezier.scad>;
use <mayscadlib/2d/shapes.scad>;
use <mayscadlib/2d/plot.scad>;
use <mayscadlib/positioning.scad>;
use <mayscadlib/3d/screws.scad>;

$fn = 100;

// The dimensions of a single "tooth"
tooth_dims = [15, 12];
// Corner radius on the bottom of the teeth
tooth_radius = tooth_dims[0]/2;
// Spacing between the teeth
tooth_spacing = 1.5;
// Number of teeth
num_teeth = 9;
// thickness at the bottom of the teeth
tooth_thickness = 2;
// thickness at the top of the teeth
tooth_top_thickness = 1;
// Reserved space for the bezier curve
curve_spacing = 10;
// Distance between holders and wall
spacing = 15;
// Screw descriptor for mounting screws
screw_type = spax_3x12_z1();
// Thickness of the base part
base_thickness = tooth_thickness;
// Material on every side of the screw
screw_mat = 2;
// force the diagonal teeth cut in preview
heavy_preview = false;

function teeth_dimensions(num_teeth, spacing) = [num_teeth*tooth_dims[0] + (num_teeth-1)*spacing, tooth_dims[1]];

module tooth_2d() {
  rounded_square(size=tooth_dims, corner_rad=tooth_radius, corner_override=[0,0,-1,-1]);
}

module teeth_2d(num_teeth=num_teeth, spacing=tooth_spacing) {
  for(i=[0:num_teeth-1]) {
    translate([i*(spacing + tooth_dims[0]),0])
    tooth_2d();
  }
}

module teeth_3d(num_teeth=num_teeth, spacing=tooth_spacing) {
  dims = teeth_dimensions(num_teeth, spacing);
  angle = atan((tooth_thickness - tooth_top_thickness) / dims[1]);

  mirror([0,1,0])
  rotate([90,0,0])
  intersection() {
    linear_extrude(tooth_thickness)
    teeth_2d(num_teeth=num_teeth, spacing=tooth_spacing);
    if(!$preview || heavy_preview) {
      h = sin(angle)*dims[1]*2;
      translate([0, dims[1]*2 * cos(angle), h])
      rotate([angle,0,0])
      translate([0,-dims[1]*2, 0])
      cube(size=[dims[0], dims[1]*2, 100]);
    }
  }
}
screw_part_w = screw_head_dia(screw_type) + screw_mat*2;
function base_curve() = bezier_curve(0.01, [0,0], [curve_spacing,0], [0, spacing], [curve_spacing, spacing]);
module base_curve() {
  translate([-curve_spacing,0]) {
    polyline(base_curve(), base_thickness); 
    line_segment([0,0], [-screw_part_w, 0], base_thickness);
  }
}

module base() {
  w = teeth_dimensions(num_teeth, tooth_spacing)[0];
  h = teeth_dimensions(num_teeth, tooth_spacing)[1];

  head = screw_head_dia(screw_type)/2;
  module raw_base() {
    translate([0,-spacing+base_thickness/2,0]) {
      difference() {
        linear_extrude(screw_part_w) {
          base_curve();
          translate([w, 0])
          mirror([1,0,0])
          base_curve();
          translate([0, spacing])
          line_segment([0,0], [w,0], base_thickness);
        }
        place([[-curve_spacing-screw_mat-head,base_thickness,screw_mat],
        [w+curve_spacing+screw_mat+head,base_thickness,screw_mat]]) {
          translate([0,0,head])
          rotate([-90,0,0])
          make_screw(screw_type);
        }
      }
    }
  }
  
  difference() {
    raw_base();
    translate([1,-.1,base_thickness+1])
    cube([w-2,base_thickness+.1,h]);
  }
}

translate([curve_spacing + screw_part_w,0,0]) {
  lift(-base_thickness-1)
  base();
  translate([0, base_thickness-tooth_thickness,0])
  teeth_3d();
}
