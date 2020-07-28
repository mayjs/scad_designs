
inner_dia = 60.4;
width = 12;
led_hole_dia = 5.1;
thickness = 2;
n_leds = 12;

$fn=100;

linear_extrude(height=thickness)
difference() {
    circle(r=inner_dia/2+width);
    for(i=[0:n_leds-1])  {
        rotate([0,0,360/n_leds * i])
        translate([inner_dia/2 + width/2,0])
        circle(r=led_hole_dia/2);
    }
    circle(r=inner_dia/2);
}

linear_extrude(height=thickness*3)
difference() {
    circle(r=inner_dia/2+1);
    
    circle(r=inner_dia/2);
}
