use <mayscadlib/3d/screws.scad>;
use <mayscadlib/positioning.scad>;
use <mayscadlib/2d/shapes.scad>;
$fn = 100;

magnet_dia = 20;
magnet_height = 4;

spring_dia = 8.4;
spring_height = 35;
spring_wire_dia = .7;
spring_inner_dia = 7.7;

m4_nut_h = 3.05;
m4_nut_dia = 8;
inner_plate_thickness = 1;
wall_th = 1.6;

sleeve_height= spring_height * .7;
play = .15;
inner_tube_height = spring_height / 2;

module magnet() {
  difference() {
    cylinder(r=magnet_dia/2, h=magnet_height);
    mirror([0,0,1])
    make_screw(m4_counter_sunk(60));
  }
}

module mock_spring() {

  linear_extrude(height=spring_height)
  difference() {
    circle(r=spring_dia/2);
    circle(r=spring_inner_dia/2);
  }
}

module sleeve() {
  difference() {
    linear_extrude(height=inner_plate_thickness + m4_nut_h) {
      difference() {
        circle(r=magnet_dia/2);
        circle(r=4.2/2);
      }
    }
    lift(inner_plate_thickness)
    linear_extrude(height=m4_nut_h + play)
    circle(r=m4_nut_dia/2 + 1.5*play, $fn=6);
  }
  lift(inner_plate_thickness)
  linear_extrude(height=sleeve_height) {
    difference() {
      circle(r=magnet_dia/2);
      circle(r=magnet_dia/2 - wall_th);
    }
  }
}

module inner_tube() {
  sleeve_inner = magnet_dia - 2*wall_th;
  inner_tube_or = sleeve_inner/2 - 3*play;
  linear_extrude(height=inner_tube_height)
  ring(r=inner_tube_or, thickness=wall_th, inner=false); 
  nut_hole_h = m4_nut_h + play;

  lift(inner_tube_height)
  {
    difference() {
      union() {
        linear_extrude(height=inner_plate_thickness)
        difference() {
          circle(r=inner_tube_or);
          circle(r=4.2/2 + play);
        }
        lift(inner_plate_thickness)
        linear_extrude(height=wall_th)
        difference() {
          circle(r=magnet_dia/2 + .5);
          circle(r=4.2/2 + play);
        }
      }
    }
  }
}

module top_plate() {
  linear_extrude(height=m4_nut_h)
  difference() {
    circle(r=magnet_dia/2);
    circle(r=m4_nut_dia/2 + play, $fn=6);
  }
  lift(m4_nut_h)
  linear_extrude(height=inner_plate_thickness)
  difference() {
    circle(r=magnet_dia/2);
    circle(r=4.2/2 + play);
  }
}

// TODO: Sink screw in outer sleeve

module assembly() {
  //color("grey")
  //magnet();
  lift(magnet_height + inner_plate_thickness + m4_nut_h)
  mock_spring();
  mirror([0,0,1])
  make_screw(m4_counter_sunk(60));

  lift(magnet_height)
  sleeve();

  lift(magnet_height + inner_plate_thickness + m4_nut_h + inner_tube_height)
  inner_tube();

  lift(magnet_height + inner_plate_thickness + m4_nut_h + 2*inner_tube_height + 3*wall_th + 1.6)
  top_plate();
}

module showcase() {
  assembly();

  translate([100,0,0])
  difference() {
    assembly();
    translate([0,-500,0])
    cube([1000,1000,1000], center=true);
  }
}

//top_plate();
inner_tube();
//sleeve();

//showcase();
