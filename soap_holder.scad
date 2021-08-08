use <mayscadlib/patterns.scad>
use <mayscadlib/2d/shapes.scad>
use <mayscadlib/positioning.scad>

use <dotSCAD/src/surface/sf_splines.scad>
use <dotSCAD/src/surface/sf_solidify.scad>
use <dotSCAD/src/curve.scad>

$fn=100;

hex_rad = 6;
strip = 2.1;
holder_dims = [120, 70];

corner_rad = 5;
tray_h = 3;

min_h = 2;
max_h = 8;

total_h = 19;
opening = 10;

holder_h = total_h - 10;

play = .2;

stem_spacing = 20;

module tray() {
  holder_dims = holder_dims - [2*play, 2*play];
  linear_extrude(height=tray_h) {
    intersection() {
      hex_grid(holder_dims, hex_rad, strip);
      rounded_square(size=holder_dims, corner_rad=corner_rad);
    }

    hollow(strip)
    rounded_square(size=holder_dims, corner_rad=corner_rad);
  }
}

module dish() {
  corner_rad = corner_rad + strip;

  function partway(p) = min_h + (max_h-min_h)*p;
  A = [
    [[0,0,partway(-.03)], [holder_dims[0]/2,0,partway(.2)], [holder_dims[0],0,partway(-.03)]],
    [[0,holder_dims[1],partway(.8)], [holder_dims[0]/2,holder_dims[1],partway(1)], [holder_dims[0],holder_dims[1],partway(.8)]],
  ];

  // First and last control point are not part of the curve, so we duplicate them
  mycurve = function(points) curve(.2, concat([points[0]],points,[points[len(points)-1]]), 0);
  
  surf = sf_splines(A, mycurve);
  zsurf = [for (r=surf) [for (p=r) [p[0],p[1],0]]];

  intersection() {
    sf_solidify(surf, zsurf);

    linear_extrude(height=max_h*2)
    translate(holder_dims/2)
    scale([xscale,yscale])
    rounded_square(size=holder_dims + [2*strip,2*strip], corner_rad=corner_rad, center=true);
  }
  //sf_thicken(sf_splines(A, mycurve), .1);
  
  xscale = holder_dims[0] / (holder_dims[0]+2*strip);
  yscale = holder_dims[1] / (holder_dims[1]+2*strip);

  translate(holder_dims/2)
  linear_extrude(height=min_h, scale=[xscale,yscale])
  rounded_square(size=holder_dims + [2*strip,2*strip], corner_rad=corner_rad, center=true);

  // front wall
  translate([opening,0,0])
  rotate([90,0,0])
  linear_extrude(height=strip)
  rounded_square(size=[holder_dims[0]-2*opening, total_h], corner_rad=corner_rad, corner_override=[0,0,-1,-1]);

  // Side wall front parts
  fpart_overlap = 2;
  translate([holder_dims[0]/2,opening])
  and_mirror([1,0,0])
  translate([holder_dims[0]/2,0])
  rotate([90,0,90])
  linear_extrude(height=strip)
  rounded_square(size=[corner_rad+fpart_overlap, total_h], corner_rad=corner_rad, corner_override=[0,0,0,-1]);
    
  linear_extrude(height=total_h)
  translate(.5*(holder_dims + [0,0]))
  difference() {
    hollow(strip)
    rounded_square(size=holder_dims + [2*strip,2*strip], corner_rad=corner_rad, corner_override=[0,0,-1,-1], center=true);
    //scale([xscale,yscale])
    //rounded_square(size=holder_dims + [2*strip,2*strip], corner_rad=corner_rad, center=true);
    translate([0,-holder_dims[1]/2 - strip + (opening+corner_rad+fpart_overlap)/2])
    square(size=[holder_dims[0] +2*strip+.1, opening+corner_rad+fpart_overlap+.1], center=true);
  }
  
  place([[0,0,0],[holder_dims[0]-strip,0,0]])
  for(i=[opening+corner_rad:stem_spacing:holder_dims[1]]) {
    translate([0,i,0])
    cube([strip,strip,holder_h]);
  }
  place([[0,0,0],[0,holder_dims[1]-strip,0]])
  for(i=[opening+corner_rad:stem_spacing:holder_dims[0]-opening-corner_rad]) {
    translate([i,0,0])
    cube([strip,strip,holder_h]);
  }
}

module assembly() {
  translate([play,play,holder_h])
  #tray();
  dish();
}

assembly();
