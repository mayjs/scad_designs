use <mayscadlib/2d/shapes.scad>;
use <mayscadlib/positioning.scad>;
use <mayscadlib/3d/screws.scad>;
general_wall_thickness = 2;
$fn=100;

screw_type = spax_2_5x10_z1();
bph=max(general_wall_thickness, screw_head_h(screw_type)+1);

module universal_top_holder(stem_width, head_length, head_width, stack_height) {
    module bs2d() {
        difference() {
            //translate(-[head_width+2*general_wall_thickness,0]/2)
            //hollow_rect(size=[head_width, head_length], thickness=general_wall_thickness);
            translate([0,head_length+2*general_wall_thickness]/2)
            difference() {
                //rounded_square(size=[head_width, head_length] + 2*[general_wall_thickness, general_wall_thickness], corner_rad=3, center=true);
                offset(r=general_wall_thickness)
                rounded_square(size=[head_width, head_length], corner_rad=3, center=true);
                rounded_square(size=[head_width, head_length], corner_rad=3, center=true);
            }
            square(size=[stem_width, general_wall_thickness*2], center=true);
        }
    }
    linear_extrude(height=stack_height)
    bs2d();
        difference() {
            lift(-bph)
            linear_extrude(height=bph)
            hull()
            bs2d(); 
            
            translate([0, .8*head_length/2+.1*head_length+general_wall_thickness])
            plus_minus([0, .8*head_length/2])
            lift(-.5)
            make_screw(screw_type, head_clearance=.5);
        }
    
}

module fork_top() {
    stem_width=10;
    head_length=82;
    head_width=29;
    stack_height=58;
    universal_top_holder(stem_width, head_length, head_width, stack_height);
}

module tablespoon_top() {
    universal_top_holder(9, 80, 45, 58); 
}

module cake_fork_top() {
    universal_top_holder(6, 55, 22, 42); 
}

module teaspoon_top() {
    universal_top_holder(6, 50, 33, 42); 
}

module serving_spoon_top() {
    universal_top_holder(9, 88, 50, 42); 
}

module knive_holder(num_knives=6, preview=false) {
    blade_thickness = 1.6 + .7;
    holder_length = 50;
    spacing = 10;
    total_width = (num_knives*blade_thickness) + ((num_knives-1) * spacing) + 2*general_wall_thickness;
    holder_h = 10;
    module slits() {
        translate([total_width-general_wall_thickness, 0]) {
            square(size=[general_wall_thickness, holder_length]);
        }
        square(size=[general_wall_thickness, holder_length]);
        translate([general_wall_thickness + blade_thickness, 0])
        for(i=[0:num_knives-2]) {
            translate([i*(blade_thickness+spacing), 0]) {
                square(size=[spacing, holder_length]);
            }
        }
    }
    module screw_mount() {
        screw_dist = 10;
        difference() {
            linear_extrude(height=bph) 
            hull() {
                square(size=[.01, holder_length]);
                translate([screw_dist, holder_length/2]) {
                    circle(r=screw_head_dia(screw_type)/2 + general_wall_thickness);
                }
            }
            translate([screw_dist, holder_length/2])
            lift(bph)
            make_screw(screw_type);
        }
    }
    // Bottom plate 
    cube(size=[total_width, holder_length, general_wall_thickness]);
    if(!preview) {
        translate([total_width,0])
        screw_mount();
        mirror([1,0,0])
        screw_mount();
    }
    
    lift(general_wall_thickness)
    linear_extrude(height=holder_h)
    slits();
    
    cube(size=[total_width, general_wall_thickness, general_wall_thickness+holder_h]);
}

// projection(cut=true)
// lift(-5) {
//     cake_fork_top();
//     translate([100, 0])
//     teaspoon_top();
// }
//cake_fork_top();
//serving_spoon_top();

knive_holder(num_knives=12);