$fn = 100;

module regular_polygon(order = 4, r=1){
    angles=[ for (i = [0:order-1]) i*(360/order) ];
    coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
    polygon(coords);
}

order=3;
module outer() {
    linear_extrude(height=100, twist=60, slices=1000)
    offset(r=5)
    offset(r=-5)
    regular_polygon(order=order, r=50);
}

outer();
rotate([0,0,360/(3*order)])
outer();
rotate([0,0,2*360/(3*order)])
outer();
