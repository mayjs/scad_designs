$fn = 100;

function inset_dia(actual_hole_dia=115, overshoot_into_hole=2) = actual_hole_dia-(overshoot_into_hole*2);
function inset_height() = 10;
function inset_step() = 3;


module base_shape_2d(actual_hole_dia=115,
                     covering_dist=15,
                     step_width=3,
                     step_height=10,
                     overshoot_height=2,
                     wall_thick=20,
                     plateau_width=8,
                     overshoot_into_hole=2) {
    actual_hole_rad = actual_hole_dia / 2;
    translate([actual_hole_rad,0])
    polygon([
             // Initial slope up to plateau
             [covering_dist,0],
             [plateau_width-overshoot_into_hole, overshoot_height],
             // Plateau
             [-overshoot_into_hole,overshoot_height],
             // Step
             [-overshoot_into_hole,overshoot_height-step_height],
             [-step_width-overshoot_into_hole, overshoot_height-step_height],
             // Hole thingi
             [-step_width-overshoot_into_hole, -wall_thick],
             [0, -wall_thick],
             [0, 0],
            ]);
            
}

module shape(wall_thick=20, hole_dia=115, covering_dist=15) {
    rotate_extrude() base_shape_2d(wall_thick=wall_thick, actual_hole_dia=hole_dia, covering_dist=covering_dist, plateau_width=covering_dist/2);
}

// projection(cut=true)
// translate([0,0,1])
// shape();
// 
// translate([0, 160])
// projection(cut=true)
// shape();

//projection(cut=true)
//translate([0,0,20])
//shape();

shape(wall_thick=18, hole_dia=68, covering_dist=7);
