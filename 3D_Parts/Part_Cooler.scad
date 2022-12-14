/* [Model] */
//Model
model="Integrated"; //[Integrated, Adapter, Airguide, Airflow,AirflowAdapted,NAirflow,NAirflowAdapted,AGOuter]
include_far_screw=true;
flowshape = "v3"; //[v2,v3,v4]
/* [Display] */
show_fan=false;
show_hotend=false;


/* [Fan] */
//Angle to place fan at
fanangle=75; // [0:90]
//Automatically flip the fan if less than 45 from vertical
autofan=true;
//invert the fan
invertfan=false;
flipfan = autofan?(fanangle<45):invertfan;
//Distance for corner of fan from mounting frame
fandist=12; //[7:40]

//Fan height offset from bottom of plate
fanh=2; //[-5:10]

/* [Airguide] */
//Airguide thickness
agt=1.5; //[0.5:0.1:3]

airguide_style="Single"; //[Single,Triple]

/* [Adapter] */
//Thickness of adapter brackets
adapter_thick=3.0;
//width of each adapter bracket
adapter_w=4.6;
//height of each adapter bracket
adapter_h=6;
//inset of adapter bracket from edge
adapter_i=0.2;
//width of cooler rectangle inserting into adapter
adapt_in_w=28;
//depth of cooler rectangle inserting into adapter
adapt_in_d=8.4;
//height that cooler will insert into adapter (needs implementation)
adapt_in_h=1;
//minimum thickness of walls of insert into adapter
adapt_in_t=0.5;

/* [Plate] */
width=42.4;
height=42.1;
thickness=7;
//Diameter of screws
screw_dia=2;
//Screw hole centre distance from edges
screw_off=3.7;
//Diameter of mounting posts
inset_dia=4.4;
//Depth to cut in for mounting posts
inset_depth=4.2;

module dummy(){}

overlap=0.01;
//$fn=16;
$fs=0.2;

module plate(x,y,h,ro,ri,e,i,ap=0){
    translate([-x/2,0,0 ])rotate([90,0,0]) difference(){
        union(){
            cube([x,y,h]);
            if(ap>0) {
                for(p=[e,x-e]) translate([p,e,0]) cylinder(r=ro,h=h+ap);
            }
        }
        for(a=[e,x-e]) for (b=[e,y-e])
        translate([a,b,-overlap]) {
            cylinder(r=ro,h=i+overlap);
            cylinder(r=ri,h=h+ap+overlap*2);
        }
        for(a=[-overlap,x-e]) for(b=[-overlap,y-e-ro])
            translate([a,b,-overlap])
cube([e+overlap,e+ro+overlap,i+overlap]);
        for(a=[-overlap,x-e-ro]) for(b=[-overlap,y-e])
            translate([a,b,-overlap])
cube([e+ro+overlap,e+overlap,i+overlap]);
    }
}

function cornerpoints(fd,fh,fa,inc=true,flip=false) = [
//dist form plate, height from base, radius
[3,min(fh,2),2], //underside by plate
[fd,fh,2.5],
[fd+cos(90-fa)*28,fh+sin(90-fa)*28,2], //cornerpoint of fan, limited to base of adapter
if (inc) [fd+cos(90-fa)*45.5-sin(90-fa)*4,fh+sin(90-fa)*45.5+cos(90-fa)*4,5],
//
[fd+cos(90-fa)*7-sin(90-fa)*47,fh+sin(90-fa)*7+cos(90-fa)*47,5],
[3,height-3,3],
];

module add_airguide(integrated=true,outer=0.75){
    difference(){
        union(){
            children();
            newflow3(integrated,h=0.01,outer=outer);
            //newflow3(integrated,h=0.1,outer=0);
        }
        newflow3(integrated,h=0.1,outer=0);
    }
}

module holder(style="Integrated"){
    corners=cornerpoints(fandist,fanh,fanangle,include_far_screw);
    add_airguide(style=="Integrated") difference(){
        union(){
            translate([0,overlap,0]) plate(width,height,thickness,inset_dia/2,screw_dia/2,screw_off,inset_depth,style=="Integrated"?adapter_thick:0);
            hull() for (p=corners) translate([-10,-p[0],p[1]])
rotate([0,90,0]) cylinder(r=p[2],h=20);
            if(style=="Adapter") hull(){
                translate([-15,-15,0])cube([30,10,3]);
                translate([-8,-4,0])cube([16,1,25]);
            }
            //airguide(2,agt,style=="Integrated");
        }
        //clear through to back of adapter above the opening for airflow
        translate([-8,-70,fanh+cos(90-fanangle)*20]) cube([16,70-fandist+sin(90-fanangle)*50,70]); //notch to allow insertion of fan at closer screw, (translate z adjusted from 40 to include curve of fan
        if(include_far_screw) translate([-8,-(20+fandist+30*cos(90-fanangle)),0]) cube([16,20,70]); //notch to allow insertion of fan at far screw
        translate([0,-fandist,fanh]) rotate([fanangle,0,0]) fan5015(true);
        //color("blue") newflow(2,model=="Integrated");
        //color("blue") newflow3(model=="Integrated",h=0.1,outer=0);
    }

}

module fan5015holes(){
    translate([27.4,25.5,-5]) color("red") cylinder(r=16,h=25);//intake 16mm radius
    translate([4.25,45.5,-15]) color("red") cylinder(r=2.25,h=30);
    translate([47,7,-15]) color("red") cylinder(r=2.25,h=30);
}

module fan5015(clearance=false){
    rotate([90,0,90]) {
        difference(){
        union() {
            translate([0,0,-8]) cube([20,28,16]);
            translate([27.5,27.4,-8]) cylinder(r=24.5,h=16);
            intersection(){
                translate([25.5,25.5,-8]) cylinder(r=25.5,h=16);
                translate([0,25.5,-8]) cube([51,25.5,16]);
            }
            hull() for(p=[[4.25,45.5,-8],[47,7,-8]]) translate(p) cylinder(r=1.5+2.25,h=16);
            }
            fan5015holes();
        }
        if (clearance){
            translate([-1.5,11,-3]) color("red") cube([2,20,6]);
            fan5015holes();
        }
        translate([-1.5,0,-3]) cube([2,12,6]);
        translate([21,1.5,-3]) cube([12,5,6]);
    }
}

module hotend(){
    translate([-17,7,-3.5]) cube([22,21,10]);
    translate([0,18,-10]) cylinder(r=4,h=20);
    translate([0,18,-12])cylinder(h=2,r1=0.5,r2=2);
}

module flowpane(w,h,rnd){
    for(xp = [rnd-w/2,w/2-rnd], yp = [rnd-h/2,h/2-rnd])
        translate([xp,0,yp]) rotate([90,0,0]) cylinder(r=rnd,h=0.01);
}

module flowguide(x,y,r,w,h,rnd){
    rad=((rnd*2)>min(h,w))?min(h,w)/2:rnd;
    translate([0,-x,y]) rotate([-r,0,0]) flowpane(w,h,rad);
}

function flowpoints(integrated=true) = [
    //side_view_x,side_view_y,rot_angle,width_in_plane,height_in_plane
    [fandist-9.5*sin(90-fanangle),fanh+9.5*cos(90-fanangle),90-fanangle,14,19],
    if (!integrated) [5,adapt_in_h,90,adapt_in_w-adapt_in_t*2,adapt_in_d-adapt_in_t*2],
    if (!integrated) [5,-adapt_in_h,90,adapt_in_w-adapt_in_t*2,adapt_in_d-adapt_in_t*2],
    [1,-6,0,25,4],
    [-2,-6.5,15,23,3],
    [-10,-8,30,20,2.5],
    [-11,-9,45,14,2]
    ];

function indices(flow,integrated=true) = [
    for(a=[0:len(flow)-1]) if (flow[a[0]]!=0 || integrated) a,
];

module newflow3(integrated=true,h=0.1,outer=0){
    shape=(flowshape=="v4")?flowpoints_shape_new(integrated):((flowshape=="v3")?flowpoints_shape(integrated):flowpoints_shape_old(integrated));
    union()
    for (comp=[0:len(shape)-1]){
        flow=shape[comp];
        //echo(flow);
        points = indices(flow,integrated);
        echo(points);
        for (item = [0:len(points)-2]){
            //echo(item,item+1);
            hull(){
                fg_block(flow[points[item]][1],flow[points[item]][2],h,outer);
                fg_block(flow[points[item+1]][1],flow[points[item+1]][2],h,outer);
            }
        }
    }
}

module fg_block(plane_pos,shape,h=0.1,outer=0) {
    //echo(plane_pos);
    //echo(shape);
    translate([0,-plane_pos[0],plane_pos[1]]) rotate([90-plane_pos[2],0,plane_pos[3]]) hull(){
        for(x=[shape[4]-shape[0]/2,shape[0]/2-shape[4]],y=[shape[4]-shape[1]/2,shape[1]/2-shape[4]]) {
            translate([shape[2]+x,shape[3]+y,-h/2]) cylinder(r=shape[4]+outer,h=h);
        }
    }
}

function flowpoints_shape_old(integrated=false) = [
    //inc,plane_def,shape_def    //inclusion,(elev_x,elev_y,elev_rot),(plane_w,plane_h,plane_cx,plane_cy,plane_rnd)
    [
        [-1,[fandist-9.5*sin(90-fanangle),fanh+9.5*cos(90-fanangle),90-fanangle,0],[14,19,0,0,1]], //fan interface position
        if (!integrated) [0,[5, adapt_in_h,90,0],[adapt_in_w-2*adapt_in_t,adapt_in_d-2*adapt_in_t,0,0,0.5]],  //adapter intermediate flow
        if (!integrated) [0,[5,-adapt_in_h,90,0],[adapt_in_w-2*adapt_in_t,adapt_in_d-2*adapt_in_t,0,0,0.5]],  //adapter intermediate flow
        [1,[1,-4,30,0],[25,4,0,0,1]]
    ],[
        [1,[1,-4,30,0],[25,4,0,0,1]],
        [1,[-5,-6.5,15,0],[23,3,0,0,1]],
        [1,[-10,-8,30,0],[20,2.5,0,0,1]],
        [1,[-11,-9,45,0],[14,2,0,0,1]]
    ]
];

function flowpoints_shape(integrated=true) = [
    //inc,plane_def,shape_def    //inclusion,(elev_x,elev_y,elev_rot),(plane_w,plane_h,plane_cx,plane_cy,plane_rnd)
    [
        [-1,[fandist-9.5*sin(90-fanangle),fanh+9.5*cos(90-fanangle),90-fanangle,0],[14,19,0,0,1]], //fan interface position
        if (!integrated) [0,[5, adapt_in_h,90,0],[adapt_in_w-2*adapt_in_t,adapt_in_d-2*adapt_in_t,0,0,0.5]],  //adapter intermediate flow
        if (!integrated) [0,[5,-adapt_in_h,90,0],[adapt_in_w-2*adapt_in_t,adapt_in_d-2*adapt_in_t,0,0,0.5]],  //adapter intermediate flow
        [1,[1,-4,30,0],[25,4,0,0,1]]
    ],[
        [1,[1,-4,30,0],[13,4,-6,0,1]],
        [1,[-4,-6.5,15,0],[10,3,-9,0,1]],
        [1,[-6,-7,30,-30],[8,3.5,-9,0,1]],
        [1,[-6,-8,30,-45],[8,3.5,-9,0,1]],
        [1,[-7.75,-9,45,-45],[7,2.5,-8,0,0.25]],
        [1,[-8.75,-10,65,-45],[7,2.5,-7.5,0,0.25]]
    ],[
        [1,[1,-4,30,0],[13,4,6,0,1]],
        [1,[-4,-6.5,15,0],[10,3,9,0,1]],
        [1,[-5,-7,30,30],[8,3.5,9,0,1]],
        [1,[-6,-8,30,45],[8,3.5,9,0,1]],
        [1,[-7.75,-9,45,45],[7,2.5,8,0,0.25]],
        [1,[-8.75,-10,65,45],[7,2.5,7.5,0,0.25]]
        
    ]
];
        
function flowpoints_shape_new(integrated=true) = [
    //inc,plane_def,shape_def    //inclusion,(elev_x,elev_y,elev_rot),(plane_w,plane_h,plane_cx,plane_cy,plane_rnd)
    [
        [-1,[fandist-9.5*sin(90-fanangle),fanh+9.5*cos(90-fanangle),90-fanangle,0],[14,19,0,0,1]], //fan interface position
        if (!integrated) [0,[5, adapt_in_h,90,0],[adapt_in_w-2*adapt_in_t,adapt_in_d-2*adapt_in_t,0,0,0.5]],  //adapter intermediate flow
        if (!integrated) [0,[5,-adapt_in_h,90,0],[adapt_in_w-2*adapt_in_t,adapt_in_d-2*adapt_in_t,0,0,0.5]],  //adapter intermediate flow
        [1,[1,-4,30,0],[25,4,0,0,1]]
    ],[
        [1,[1,-4,30,0],[13,4,-6,0,1]],
        [1,[-4,-6.5,15,0],[10,3,-9,0,1]],
        [1,[-6,-7,30,-30],[8,3.5,-9,0,1]],
        [1,[-6,-7.5,30,-45],[8,3,-9,0,1]],
        [1,[-7.75,-8,45,-45],[7,2,-8,0,0.25]],
        [1,[-8.75,-9,65,-45],[7,2,-7.5,0,0.25]]
    ],[
        [1,[1,-4,30,0],[13,4,6,0,1]],
        [1,[-4,-6.5,15,0],[10,3,9,0,1]],
        [1,[-5,-7,30,30],[8,3.5,9,0,1]],
        [1,[-6,-7.5,30,45],[8,3,9,0,1]],
        [1,[-7.75,-8,45,45],[7,2,8,0,0.25]],
        [1,[-8.75,-9,65,45],[7,2,7.5,0,0.25]]
        
    ]
];

module newflow(rnd=2,integrated=true){
    flows=flowpoints(integrated);

    union()
    for(item=[0:len(flows)-2])
        hull(){
            flowguide(flows[item][0], flows[item][1],flows[item][2],flows[item][3],flows[item][4],rnd);
            flowguide(flows[item+1][0], flows[item+1][1],flows[item+1][2],flows[item+1][3],flows[item+1][4],rnd);
        }
}

module airguide(rounding=2,thickness=1,integrated=false) {
    difference() {
        //minkowski() {
            //newflow(rounding, integrated);
            newflow3(integrated,h=0.01,outer=2);
            //sphere(r=thickness);
        //}
        newflow3(integrated,h=0.1,outer=0);
        //color("blue") newflow(rounding,integrated);
        //c=flowpoints(integrated);
        //p=c[len(c)-1];
        //translate([0,-p[0],p[1]]) rotate([180+p[2],0,0])
//translate([-20,-2.5,-overlap]) cube([40,5,6]);
    }
}

module airguide_attachment(rounding=2,g_thick=1){
    difference(){
        union(){
            intersection(){
                //airguide(2,g_thick,false);
                add_airguide(false) translate([0,0,100]) cube(10);
                union(){
                    translate([-40,-70,-40]) cube([80,140,40]);
                    translate([-adapt_in_w/2,-(10+adapt_in_d)/2,0]) intersection(){
                        cube([adapt_in_w,adapt_in_d,adapt_in_h]);
                        rotate([-70,0,0]) cube(500);
                    }
                }
            }
            translate([-20,-10,-2]) cube([40,10,2]);

            for (p=[adapter_i-20,20-adapter_i-adapter_w]) {
               translate([p,-thickness-3/*adapter_thick*/,-overlap]) cube([adapter_w,adapter_thick,adapter_h+overlap]);
            }
        }
    //color("blue") newflow(2,false);
    color("blue") newflow3(false,h=0.1,outer=0);
    //screwholes
    for(p=[screw_off-width/2,width/2-screw_off]) translate([p,-15,screw_off]) rotate([-90,0,0]) cylinder(r=screw_dia/2,h=20);
    }
}

module adapter(model){
    difference() {
        intersection(){
            difference(){
                union(){
                    holder(model);
                    //translate([-adapt_in_w/2-1,-(10+adapt_in_d+2)/2,0]) cube([adapt_in_w+2,adapt_in_d+2,2+overlap]);
                }
                translate([-14,-9.2,-overlap]) cube([28,8.4,1+overlap]);
            }
            translate([-width,-(fandist+55),0]) cube([2*width,fandist+55,fanh+55]);
        }
        newflow(2,false);
    }
}

if (model=="Integrated") holder(model);
if (model=="Adapter") adapter(model);
if (model=="Airflow") newflow(2, true);
if (model=="AirflowAdapted") newflow(2, false);
if (model=="NAirflow") newflow3(true);
if (model=="NAirflowAdapted") newflow3(false);
if (model=="Airguide") airguide_attachment(2,agt);
if (model=="AGOuter") add_airguide(true) cube(1);
if (show_fan) translate([0,-fandist,fanh]) rotate([fanangle,0,0]) fan5015();
if (show_hotend) color("red") hotend();
