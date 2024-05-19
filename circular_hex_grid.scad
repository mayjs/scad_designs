use <mayscadlib/patterns.scad>

$fn = 100;

outer_dia = 2*23.464;
rim = 2;
hex_dia = 6.928;

total_rad = outer_dia/2 - rim;

linear_extrude(10)
intersection()
{
    hex_grid([2*outer_dia,2*outer_dia],hex_dia/2,4, negative=false);
    translate([total_rad, total_rad])
    circle(r=total_rad);
}

