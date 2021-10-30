use <mayscadlib/positioning.scad>
use <mayscadlib/3d/screws.scad>

$fn = 100;

module round_2d(r=1) {
    offset(r=r)
    offset(r=-r)
    children();
}

module catch(handle_height=20, catch_height=20, plate_width=10, screw=spax_3x12_z1(), mount_right=false) {
    mount_plate_width = 1.5 * screw_head_dia(screw);
    plate_thickness = screw_head_h(screw);

    module catch_core() {
        lift(plate_thickness)
        linear_extrude(catch_height) {
            catch_shape();
        }

        baseplate();

        module baseplate() {
            difference () {
                linear_extrude(plate_thickness)
                round_2d() {
                    translate([-plate_width - 1, -mount_plate_width])
                    square([plate_width + handle_height, mount_plate_width]);
                    catch_shape(round=false);
                }

                lift(plate_thickness)
                translate([-plate_width, -mount_plate_width/2])
                place([
                    [1*screw_head_dia(screw),0],
                    [plate_width + handle_height - 1.25 * screw_head_dia(screw), 0]
                ])
                make_screw(screw, head_clearance=2);
            }
        }

        // Old vertical baseplate
        /*
        module baseplate() {
            difference() {
                linear_extrude(plate_thickness) {
                    baseplate_shape();
                }
                lift(plate_thickness)
                place([
                    [0, -mount_plate_width/2],
                    [0, mount_plate_width/2 + handle_height]
                ])
                make_screw(screw, head_clearance=2);
            }
        }

        module baseplate_shape() {
            hull() catch_shape();
            translate([-mount_plate_width/2, - mount_plate_width])
            round_2d() {
                square([mount_plate_width, handle_height + 2 * mount_plate_width]);
                // square([handle_height - 2 + mount_plate_width/2, mount_plate_width]);
            }
        }
        */

        // The actual "catching part", simply a rounded triangle with a 
        // plate to prevent the handle from going back over on the inside
        module catch_shape(round=true) {
            if(round) {
                round_2d() catch_shape(round=false);
            } else {
                translate([-1,0,0]) {            
                    polygon([[0,0], [handle_height,0], [0, handle_height]]);
                    translate([-plate_width, 0])
                    square([plate_width, plate_thickness]);
                }        
            }
        }
    } 
    
    if(mount_right) {
        rotate([180,0,0])
        mirror([0,0,1])
        catch(handle_height=handle_height, catch_height=catch_height, plate_width=plate_width, screw=screw, mount_right=false);
    } else {
        catch_core();
    }
}

catch(mount_right=true);