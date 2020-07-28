use <fan_hole_cover.scad>
use <mayscadlib/2d/shapes.scad>

$fn = 100;

module hull_2d() {
    outer_rad = inset_dia() / 2;
    wall_thick = inset_step();
    play = .3;

    translate([outer_rad - play,0]) {
        translate([0, inset_height()])
        translate([-wall_thick*2+play, -wall_thick])
        square([wall_thick*2-play, wall_thick]);
        
        translate([-wall_thick+play, 0])
        square([wall_thick-play, inset_height()-wall_thick]);
    }
}


module outer_hull() {
    rotate_extrude()
    hull_2d();
}

module tensioner() {
    outer_rad = inset_dia() / 2;
    wall_thick = inset_step();
    
    play = .4;
    max_x = outer_rad-wall_thick-play;
    module tensioner_2d() {
        points =  [
            [max_x, inset_height()-wall_thick],
            [max_x-wall_thick, inset_height()-wall_thick],
            [max_x-wall_thick, inset_height()],
            [max_x-2*wall_thick, inset_height()],
            [max_x-2*wall_thick, inset_height()-2*wall_thick],
            [max_x, inset_height()-2*wall_thick],
        ];
        polygon(points);
    }
    module grid() {
        up_to = (max_x-wall_thick)*2;
            translate([0,0,inset_height()-2*wall_thick])
            linear_extrude(height=2*wall_thick)
            intersection() {
                rotate([0,0,45])
                grid_2d(up_to,up_to, 8, 8, 2, center=true);

                circle(r=up_to/2);
            }
    }
    
    rotate_extrude()
    tensioner_2d();
    grid();    
}

module demo() {
    color("gray", 0.5)shape();
    translate([0,0,-inset_height()+2]) {
        outer_hull();
        color("red") tensioner();
    }
}

//demo();
//outer_hull();

tensioner();

