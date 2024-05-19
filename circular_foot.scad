$fn = 100;
outer_dia = 2*24.5;
foot_width = 2;
inner_dia = outer_dia - 2*foot_width;

cutout_width = 8;
cutout_count = 8;
height = 3;

linear_extrude(height)
difference()
{
    circle(inner_dia/2 + foot_width);
    circle(inner_dia/2);
    for(i=[1:cutout_count])
    {
	rotate([0,0,(i-1)*(360 / cutout_count)])
	translate([-cutout_width/2, inner_dia/2 - 1])
	square([cutout_width, foot_width*2]);
    }
}
