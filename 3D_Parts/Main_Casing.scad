/* [Component] */
component="Left Box"; //[Left Box, Right Box, Left Lid, Right Lid, Holder Lid, TestPow, TestPi, TestDcDc, TestChain, RailModel,DispFront,DispMount]
//Include mounts for a Raspberry Pi
inc_pi=true;
//Include a notch for an XT60 power connector
inc_power=true;
//Include a mounting for a voltage converter
inc_dcdc=true;
//Include a connector space for Y motor (easier to rotate motor)
inc_y_motor_notch=true;
//Include a fan in the lid of the right hand box
inc_r_fan=true;

/* [Display] */
show_pi=false;
show_xt60=false;
show_skr=true;

/* [Box] */
width=250;
centre=125;//width/2;

rail_tol=0.2; //[0:0.01:0.5]
tol=0.2; //[0:0.01:0.5]
ovha=45; //[30:5:60]

depth = 125;
//height of box without lid
height = 32;
//height including lid
total_height=33.5;
//Thickness of base plate
plate_thick=1.3; //[0.3:0.1:2]
//Thickness of walls
wall_thick=2;
//size of lip to hold lid
lid_lip=3;
//Height of start of angle into base
angle_height=6;
//Distance to push edge into base
angle_sz=6;
//left wall style
wall_left="Rail"; //[Nil,Angle,Rail,Hollow,Complete]
//rear wall style
wall_rear="Angle"; //[Nil,Angle,Hollow,Complete]
//right wall style
wall_right="Rail"; //[Nil,Angle,Rail,Hollow,Complete]
//Clear a notch in front wall for allow Y motor notch
rail_inset=10;
Y_motor_notch=false;
gap_right_rear_x=55;

/* [Screws] */
//Diameter of screws used for box lid
screw_dia=2.5;//[2:0.5:4]
//Style of screwhead
screw_head_style="Flat"; //[Countersunk,Pan]
//Diameter of hole above countersink
screw_head_dia=4; //[3:0.5:6]
//depth to insert screw to (excl countersink)
screw_head_depth=0; //[0:0.25:4]
/* [Connection] */
//Thickness of central wall
centre_thick=8;
//Distance from front and back to hold central join
join_l=16;
//size of sloped internal side of central join connectors
join_base=12;
//Diameter of hole in central join 
hole_dia=3;
//Diameter of screw head for central join
hole_outer_dia=5;
//Depth for screw head
hole_outer_insert=2;
//Screw head style for central join
hole_outer_style="Countersunk"; //[Countersunk,Flat,Nil]
/* [Fan] */
fan_centre_x=50;
fan_centre_y=100;
/* [SKR Board mounting] */
//left edge of skr from centre line
skr_x=4.0; //[0:0.1:115]
//distance from wall to SKR board
skr_y=0.5; //[0:0.1:125]
//height of SKR board from baseplate
skr_h=5.0; //[2.2:0.1:12]
//orientation of SKR (degrees clockwise)
skr_orient=0; //[0,90,180,270]
//leave opening for the USB port on the SKR
expose_skr_usb_port=true;
/* [Externals] */
//Type of chain to connect to heated bed
bed_chain_type="1815"; //["1815","2415","Printed"]
//Position of chain connection
bed_chain_x_offset=38.5; //[15:0.5:50]
//Offset from rear wall to edge of next chain link
bed_chain_y_offset=1;
//clear wall above chain point
bed_chain_no_top=true;
//cable port right edge (inset from right) 
cable_port_right=14.5;
//cable port left edge (inset from right) 
cable_port_left=54;
//cable_port_height (from baseplate)
cable_port_height=19.5;
//depth to extend cableport into frame
cable_port_depth=6;
/* [Pi] */
//Model of Pi (Model 1/2/3B are consistent)
pi_model="3B"; //["3A","3B","4B","0"]
//Offset for Pi from left edge
pix=50; //[3:1:65]
//inset from inside of wall
piy=3.4; //[0:0.1:5]
//height from baseplate
pi_height=4;//[2.3:0.1:11]
//Distance from left edge for the power connector
/* [XT60 power input] */
power_connector_x = 25; //[10:1:115]
/* [DCDC Convertor] */
//Depth for voltage converter
dcdc_depth=40;
//Horizontal position of voltage converter
dcdc_x=25; //[15:1:110]
//Orientation of voltage converter module
dcdc_rotate=90; //[0,90]
//width of converter
dcdc_w=23.5;
//depth of converter
dcdc_d=17;
//height of the converter board and components
dcdc_b=4.8;
//height at which to mount the dc converter
dcdc_h=4;
//screw diameter for holding dcdc converter
dcdc_scr_d=2.5;
//screw diameter for holding dcdc converter
dcdc_scr_id=2.5; //[1.5:0.1:4.9]
//location of adjustment screw from board centre
dcdc_adj_x=5.5;
//location of adjustment screw from board centre
dcdc_adj_y=6.5;
//size of hole for adjustment screw (diameter)
dcdc_adj_d=3.5;
//thickness of walls on dc adaptor lid
dcdc_t=1.2;

module dummy(){};
hole_r = min(hole_dia,centre_thick-2)/2;
corner_screws=[[5,5],[5,depth-5]];

overlap=0.1;

//$fn=64;
$fs=$preview?0.5:0.1;
$fa=$preview?30:5;

module hole(r=-1,r1=2,r2=1,h=1,td_ang=-1){
    ct=($fn>0.0?max(3,$fn):ceil(max(min(360/$fn,max(r,r1,r2)*2*PI/$fs),5)));
    ang=360/ct;
    e=cos(ang/2);
    a1=(td_ang<=0 || td_ang>=90)?ang:ang*ceil(((90-td_ang)/ang)-0.5);
    d0m=max(1,cos(a1)+(sin(a1)/tan(td_ang)));
    angs=[0,for(a=[a1:ang:360-a1]) a];
    ctm=len(angs);
    polyhedron(
        points=[
            for(p=angs, th=[0,h]) [
                sin(p)*(((r==-1)?(th==0?r1:r2):r)/e)*(p==0?d0m:1),
                cos(p)*(((r==-1)?(th==0?r1:r2):r)/e)*(p==0?d0m:1),
                th
            ]
        ],
        faces=[
            for(a=[1:ctm-2]) [0,(a+1)*2,a*2],
            for(a=[0:ctm-2]) [a*2,a*2+2,a*2+3,a*2+1],
            [2*ctm-2,0,1,2*ctm-1],
            for(a=[1:ctm-2]) [1,a*2+1,(a+1)*2+1]
        ]
    );
}

module shear(zx=0,zy=0,yx=0,xy=0,yz=0,xz=0){ multmatrix([
[1,xy,xz,0],
[yx,1,yz,0],
[zx,zy,1,0]
]) children();
}

module mirrorcopy(v){
    children();
    mirror(v) children();
}

module roundedrectangle(x,y,z,r,centre=false){
    act_r=min(min(x,y)/2,r);
    off_x=centre?0:x/2;
    off_y=centre?0:y/2;
    pz=centre?-z/2:0;
    hull() for(px=[act_r-x/2,x/2-act_r],py=[act_r-y/2,y/2-act_r]) translate([off_x+px,off_y+py,pz]) cylinder(r=act_r, h=z);
}

function skr14screws(orient=0)=[
for(x=[-51,51], y=[-38,38]) if ((orient%180)==0)[x,y,3.5] else [y,x,3.5]
];

function piscrews(model="3B",orient=0)=[
  if (model=="3B") for(a=[[3.5,23.5],[52.5,23,5],[3.5,81.5],[52.5,81.5]]) a,
];

function chainsize(chain)=[
    // width,height,plate_thick,plate_rad,link_inner_rad,link_outer_rad
    if(chain=="Printed")
        for (a=[20.5,12.5,1.6,6.25,4/2,2/2]) a,
    if(chain=="1815")
        for (a=[14,15,2,7.5,6/2,6/2]) a,
    if (chain=="2415")
        for (a=[24,15,2,7.5,6/2,6/2]) a,
];

module skr14(clearance=false, populated=4){
    ports=[for (a =[
    [43.1,-11.7,0.6,11,10.0,1.5,"red",true], //MicroSD clearance cube
    [43.1,-11.7,0.6,11,10.5,1.2,"red",true], //MicroSD clearance cube
    [42.5,-1.7,0,14.9,14.5,2,"silver",true], //MicroSD
    [24,-0.2,0,12.3,16.35,10.9,"silver",true], //USB B

    [24.4,-0.7,0.4,11.5,0.51,9.1,"red",false], //USB B clear1
    [23,-20.7,-1,14.3,20.1,12.9,"red",false], //USB B clear2 (external to board)
    for(b=[0:4]) [1.25+b*(110-1.25*2-20.3)/4,61.6,0,20.3,15.2,6,"black",true],//Pololu ports
    for(b=[0:populated-1]) [1.25+b*(110-1.25*2-20.3)/4,61.6,6,20.3,15.2,4,"green",true],//pololu boards
    for(b=[0:populated-1]) [5.2+1.25+b*(110-1.25*2-20.3)/4,3.1+61.6,10,9,9,12,"blue",true],//pololu heatsinks
    
    ]) if (a[7] || clearance) a];  //Only include elements if req or clearance desired
     
    difference(){
        translate([-55,-42.25,0]){
            color("green") roundedrectangle(110,84.5,1.65,1);
            translate([0,0,1.65]) for(c=ports) {
                translate([c[0],c[1],c[2]]) color(c[6]) cube([c[3],c[4],c[5]]);
            }
            if (clearance) translate([ports[0][0]+ports[0][3]/2,ports[0][1],ports[0][2]+ports[0][5]]) sphere(r=ports[0][4]);
            }

        for(s=skr14screws()) {
            translate([s[0],s[1],-0.5]) hole(r=s[2]/2,h=3);
        }
    }
}

module powerconn(clearance=true){
    union(){
        //internal connection    
        translate([0,7.5/2+8+1+tol*4,0]) {
            hull(){
                translate([0,0,-13/2-tol]) cube([8+tol*2,7.5+tol*2,13+tol*2],center=true);
                translate([0,0,-15.7/2-tol]) cube([2.7+tol*2,7.5+tol*2,15.7+tol*2],center=true);
            }
            //area for embossed text
            translate([8/2,-7.5/2-tol+0.5,-13-tol+0.5]) cube([0.5+tol*2,6.5+tol*2,13+tol*2]);
        }
        //pin size/holds
        translate([0,15-1,0]) hull(){
            translate([0,0,-tol-11.5/2]) cube([6.5+tol*2,30,11.5+tol*2],center=true);
            translate([0,0,-tol-14/2]) cube([2+tol*2,30,14+tol*2],center=true);
        }
        if(clearance){
            color("red"){
                translate([0,8/2,0]) hull(){
                    translate([0,0,-13/2-tol]) cube([8+tol*2,8+tol*2,13+tol*2],center=true);
                    translate([0,0,-15.7/2-tol]) cube([2.7+tol*2,8+tol*2,15.7+tol*2],center=true);
                }
            }
        }
    }
}

module standoff(x, y, z=0, screw_d=2.5, h=4) {
    translate([x,y,z-overlap]) hull(){
        cylinder(r=screw_d/2+1.5,h=h+overlap);
        cylinder(r=screw_d/2+2.5,h=overlap);
    }
}

module holder(w,d,h,t,b){
    difference(){
        union(){
            translate([0,0,h/2-overlap]) cube([w+t*2,d/3,h+overlap],center=true);
            translate([0,0,h/2-overlap]) cube([4*w/6,d+t*2,h+overlap],center=true);

            for (x=[-1,1]) translate([x*(w+t)/2,0,(h+t)/2]) cube([t,d/3,h+t],center=true);
            for (y=[-1,1]) translate([0,y*(d+t)/2,(h+t)/2]) cube([w/3,t,h+t],center=true);
        }
        //screw mounts

    }
    for(p=[-1,1]) translate([0,p*(d/2+t*2+dcdc_scr_d),-overlap]) {
        difference(){
            cylinder(r=dcdc_scr_d-tol,h=h);
            translate([0,0,-overlap]) hole(r=dcdc_scr_id/2,h=h+overlap*2);
        }
    }
}

module holder_lid(w,d,h,t,b){
    difference(){
        translate([0,0,-t*1.5]) hull() {
            translate([0,0,(b+h)/2+t]) cube([w+t*4,d+dcdc_scr_d*4+t*6,b+h+t],center=true);
            translate([0,0,(b+h)/2+t/2]) cube([w+t*2,d+dcdc_scr_d*4+t*4,t*2+b+h], center=true);
        }
        translate([0,0,(b+h)/2+tol]) cube([w+t*2+tol,d+t*2+tol,b+h+tol*2],center=true);
        for (r=[-1,1]) {
            translate([0,r*(d/2+dcdc_scr_d+t*2),0]) {
                translate([0,0,b]) hole(r=tol+dcdc_scr_d,h=h+overlap);
                translate([0,0,-t*3]) hole(r=tol+dcdc_scr_d/2,h=b+h+overlap+t*3);
            }
            translate([0,r*d/3,(b+h+overlap+t)/2]) cube([w*2+t*4,d/3,b+h+overlap-t],center=true);
        }
        translate([dcdc_adj_x,dcdc_adj_y,-t*3]) hole(r=dcdc_adj_d/2+tol,h=b+h+t*3);
    }
}

module pib(model="3B", clearance=true, insert=-1, tol=0.4){
    //bx,by,bz,w,d,h
    //centre_x,width,base_y,depth,centre_z,height
    ports=[
    if(model=="3B") for (a=[
    [10.25,16,-2.1,21.5,6.75,13.5], //ethernet
    if(clearance) [10.25,8,-17,15.1,-0.1,4.4], //eth clip
    if(clearance) [10.25,16,-17,15.1,6.8,14.2], //ethernet

    [29,13.2,-2.4,17.9,8.4,14.3], //central usb
    [29,11,-2.4,0.5,8.4,15.8], //central usb
    [29,15.1,-2.4,0.5,8.4,12.1], //central usb
    if(clearance) [29,12.6,-3.5,1.5,8.4,13], //central usb
    if(clearance) [29,15.4,-18.6,15,8.4,16.5], //central usb

    [47,11,-2.4,0.5,8.4,15.8], //outer usb
    [47,13.2,-2.4,17.9,8.4,14.3], //central usb
    [47,11,-2.4,0.5,8.4,15.8], //outer usb
    [47,15.1,-2.4,0.5,8.4,12.1], //outer usb
    if(clearance) [47,12.6,-3.5,1.5,8.4,13], //outer usb
    if(clearance) [47,15.4,-18.6,15,8.4,16.5], //outer usb
    
    [51.5,5,85-32.5-51/2,51,1.2,2.4], //pin base
    [51.5,3.5,85-32.5-49/2,49,4.25,8.5], //pin base
    if(clearance) [51.5,5,85-32.5-51/2,51,5,10], //pin surround clearance
    
    [28,22.1,85-2.8-2.6/2,2.6,5.4/2,5.4], //display
    
    [-1.4+6.5/2,6.5,85-10.6-8/2,8,3/2,3], //usb power
    
    [-1.4+12.1/2,12.1,85-32-15/2,15,6.1/2,6.1], //hdmi

    [11.5,22.1,85-45-2.5/2,2.5,5.4/2,5.4], //camera - potential y offset

    [12.6/2,12.6,85-53.5-7.2/2,7.2,5.8/2,5.8], //a/v jack
    [-2.4+3/2,3,85-53.5-5.8/2,5.8,5.8/2,5.8], //a/v jack
    ]) a
    ];
    if (insert==-1){
        //board has fixed additional vertical tolerance of 0.1
        color("green") translate([-tol,-tol,-1.4]) difference(){
            roundedrectangle(56+2*tol,85+2*tol,1.5,3+tol);
            if(!clearance) for (scr=piscrews()) {
                translate([scr[0],scr[1],-1]) cylinder(r=2.75/2,h=10);
                translate([scr[0],scr[1],1.3]) cylinder(r=3.1,h=2);
            }
        }
        for(c=ports) {
            translate([c[0],c[2]+c[3]/2,c[4]]) color("silver") cube([c[1]+tol*2,c[3],c[5]+tol*2],center=true);
        }
    } else {
        minkowski(){
            union(){
                color("green") translate([0,0,-1.4]) roundedrectangle(56,85,1.5,3);
                for(c=ports) {
                    translate([c[0],c[2]+c[3]/2,c[4]]) color("silver") cube([c[1],c[3],c[5]],center=true);
                }
            }
            hull(){
                sphere(r=tol);
                translate(insert) sphere(r=tol);
            }
        }
    }
}

module box_l(){
    difference(){
        union(){
            //base plate
            cube([centre-centre_thick/2,depth,plate_thick]);

            //rear wall
            if(wall_rear!="Nil"){
                if (wall_rear=="Angle"){
                    translate([0,depth-wall_thick,0]) cube([centre-centre_thick/2, wall_thick,angle_height+overlap]);
                    intersection(){
                        translate([0,depth-wall_thick,0]) cube([centre-centre_thick/2,wall_thick+angle_sz,angle_sz+angle_height]);
                        translate([0,depth-angle_sz,angle_height]) shear(yz=1) cube([centre-centre_thick/2,angle_sz,angle_sz]);
                    }
                }
                if (wall_rear=="Complete") translate([0,depth-angle_sz,0]) cube([centre,angle_sz,height]);
            }
            //left wall
            if(wall_left!="Nil"){
                if(wall_left=="Angle"){
                    cube([wall_thick,depth,angle_height+overlap]);
                    intersection(){
                        translate([-angle_sz,angle_height]) cube([angle_sz+wall_thick,depth,height]);
                        translate([0,0,angle_height]) shear(xz=-1) cube([angle_sz,depth,angle_sz]);
                    }
                }
                if(wall_left=="Complete"||wall_left=="Rail") cube([wall_thick,depth,height]);
                if(wall_left=="Rail"){
                    translate([0,rail_inset,10]) rotate([-90,90,0]) rail(depth-rail_inset*2,tol_s=tol+0.1,tol_e=tol+0.1,tol_t=tol+0.3,len_t=10);
                }
            }
            
            //front wall
            cube([centre-tol,wall_thick,height]);
            
            //centre join end mounts
            for (pos=[0,depth-join_l+tol])
            translate([centre,pos,0]) hull(){
                translate([centre_thick/2-join_base,0,0]) cube([join_base-tol,join_l-tol,plate_thick]);
                translate([0,0,centre_thick/2]) rotate([-90,0,0]) cylinder(r=centre_thick/2-tol,h=join_l-tol);
            }
            
            //right wall
            translate([centre,wall_thick,0]) difference(){
                translate([-centre_thick/2,0,0]) cube([centre_thick-tol,depth-wall_thick,height]);
                translate([-overlap,centre_thick,-centre_thick/2]) 
                mirrorcopy([1,0,0]) shear(zx=1) hull(){
                    translate([-overlap,0,0]) cube([centre_thick/2+overlap*3,depth-wall_thick-centre_thick*2,height-centre_thick-wall_thick]);
                    translate([-overlap,centre_thick,0]) cube([centre_thick/2+overlap*3,depth-wall_thick-centre_thick*4,height-wall_thick]);
                }
            }
            //screwmounts
            for (scr=piscrews(pi_model)) standoff(pix+scr[0],piy+scr[1],plate_thick,2.5,pi_height);
            //front left pillar
            translate([0,wall_thick,0]) hull(){
                cube([angle_sz,angle_sz,height]);
                translate([angle_sz,0,0]) shear(xy=-1) cube([angle_sz,angle_sz,height]);
            }
            //rear left pillar
            hull(){
                translate([0,depth-5,0]) cube([10,5,height]);
                translate([0,depth-10,0]) cube([5,10,height]);
            };
            //cable tie points
            for(pos=[[25,depth-20],[centre/2,depth-20],[centre-25,depth-20]]) cable_clip(pos[0],pos[1]);
            if(inc_power) translate([power_connector_x-6,0,0]) cube([12,20,height]);
        }
        
        //join centre hole
        translate([centre,-overlap,centre_thick/2]) rotate([-90,180,0]) hole(r=hole_r+tol,h=depth+overlap*2,td_ang=ovha);
        //rl screw hole
        for(scr=corner_screws)
        translate([scr[0],scr[1],plate_thick]) cylinder(r=1.25,h=height);
        //translate([corner_screws[0],corner_screws[1],total_height-screw_head_depth])
        //cutouts for raspberry pi
        translate([pix,piy,pi_height+1.3+plate_thick]) pib(pi_model, false, insert=[0,10,0],tol=tol+0.2);
        translate([pix,piy,pi_height+1.3+plate_thick]) pib(pi_model, true,tol=tol+0.2);
        //for (x=screwsx) for (y=screwsy) translate([pix+x,piy+y,-1]) cylinder(r=1.25, h=10);
        for (scr=piscrews(pi_model)) translate([pix+scr[0],piy+scr[1],-overlap]) hole(r=1.25, h=10);
        //translate([pix+7.5,-1,4]) cube([6.5,wall_thick+2,3.5]);
        if(inc_power) translate([power_connector_x,0,height]) powerconn();
    }
    if(inc_dcdc) translate([power_connector_x,50,plate_thick]) rotate([0,0,dcdc_rotate]) holder(dcdc_w,dcdc_d,dcdc_h,dcdc_t,dcdc_b);
    //%translate([25.5,48.5,plate_thick+dcdc_h+dcdc_b]) rotate([180,0,90]) holder_lid(dcdc_w,dcdc_d,dcdc_h,1,dcdc_b);
}

module lid_l(w,d,h) {
    difference(){
        union(){
            cube([w,d,h]);
            //centre wall
            translate([w-centre_thick/2-lid_lip,wall_thick,0]) intersection(){
                translate([0,0,-lid_lip]) cube([lid_lip,d-wall_thick-((wall_rear=="Nil"||wall_rear=="Angle")?0:angle_sz),lid_lip]);
                shear(zx=-1) cube([lid_lip,d,lid_lip]);
            }
            if(wall_thick<6){
                translate([12,wall_thick,-lid_lip]) intersection(){
                    shear(zx=1) cube([lid_lip,6-wall_thick,lid_lip]);
                    cube([lid_lip,6,lid_lip]);
                }
            }
            translate([12,wall_thick,-lid_lip]) intersection() {
                shear(zy=1) cube([w,lid_lip,lid_lip]);
                cube([w-12-centre_thick/2,lid_lip,lid_lip]);
            }
            if(wall_left=="Nil"|| wall_left=="Angle") {
                translate([0,12,-lid_lip])
                intersection() {
                    shear(zy=1) cube([6,lid_lip,lid_lip]);
                    cube([6,lid_lip,lid_lip]);
                }
                translate([0,d-12-lid_lip,0]) intersection(){
                    shear(zy=-1) cube([6,lid_lip,lid_lip]);
                    translate([0,0,-lid_lip]) cube([6,lid_lip,lid_lip]);
                }
            } else{
                translate([angle_sz,12,-lid_lip]) intersection() {
                    shear(zx=1) cube([lid_lip,d-24,lid_lip]);
                    cube([lid_lip,d,lid_lip]);
                }
            }
            if(wall_rear=="Complete"||wall_rear=="Hollow") {
                translate([12,d-angle_sz-lid_lip,0]) intersection() {
                    shear(zy=-1) cube([w-12-centre_thick/2,lid_lip,lid_lip]);
                    translate([0,0,-lid_lip]) cube([w,lid_lip,lid_lip]);
                }
            } else {
                translate([12,d-angle_sz,-lid_lip]) intersection(){
                    shear(zx=1) cube([lid_lip,6,lid_lip]);
                    cube([lid_lip,6,lid_lip]);
                }
            }
            //front left corner lip
            translate([6,6,-lid_lip]) intersection(){
                cube([12,12,lid_lip+h]);
                translate([6,0,0]) rotate([0,0,45]) translate([0,-5,0])shear(zx=1.41) cube([lid_lip,20,lid_lip]);
            }
            //rear left corner lip
            translate([6,d-lid_lip-12,-lid_lip]) intersection(){
                cube([12,6+lid_lip,lid_lip+h]);
                translate([0,lid_lip,0]) rotate([0,0,-45]) translate([0,-5,0]) shear(zx=1.41) cube([lid_lip,20,lid_lip]);
            }

        }
        translate([power_connector_x-4,wall_thick,-lid_lip]) cube([8,lid_lip,lid_lip]);
        for(screw=corner_screws) translate([screw[0],screw[1],0]) {
           hole(r1=screw_dia/2,r2=screw_dia/2+((screw_head_style=="Countersunk")?h:0),h=h);
            translate([0,0,h-screw_head_depth]) hole(r=screw_head_dia/2,h=screw_head_depth+0.1);
        }
        }
}

module lid_r(w,d,h) {
    difference(){
        union() {
            cube([w,d,h]);
            if($preview){
            color("red") translate([w-6,d-12,0])cube([6,12,1]);
            color("red") translate([w-12,d-6,0])cube([12,6,1]);
            color("red") translate([w-6,0,0])cube([6,12,1]);
            color("red") translate([w-12,0,0])cube([12,6,1]);
            }
            //centre wall
            translate([centre_thick/2,wall_thick,-lid_lip]) intersection(){
                cube([lid_lip,d-wall_thick-((wall_rear=="Nil"||wall_rear=="Angle")?0:angle_sz),lid_lip]);
                shear(zx=1) cube([lid_lip,d,lid_lip]);
            }
            //front wall
            translate([centre_thick/2,wall_thick,-lid_lip]) intersection() {
                shear(zy=1) cube([w,lid_lip,lid_lip]);
                cube([w-12-centre_thick/2,lid_lip,lid_lip]);
            }
            //front left corner lip
            translate([w-12-lid_lip,6,-lid_lip]) intersection(){
                cube([6+lid_lip,lid_lip+12-wall_thick,lid_lip]);
                translate([lid_lip,0,0]) rotate([0,0,-45]) translate([-lid_lip,-5,1.41*lid_lip]) shear(zx=-1.41) cube([lid_lip,20,lid_lip]);
            }
            if(wall_thick<6){
                translate([w-12-lid_lip,wall_thick,0]) intersection(){
                    shear(zx=-1) cube([lid_lip,6-wall_thick,lid_lip]);
                    translate([0,0,-lid_lip]) cube([lid_lip,6,lid_lip]);
                }
            }
            //rear left corner lip
            translate([w-12-lid_lip,d-12-lid_lip,0]) intersection(){
                translate([0,0,-lid_lip])cube([12+lid_lip-angle_sz,12+lid_lip-angle_sz,lid_lip]);
                translate([6,2*lid_lip,-lid_lip]) rotate([0,0,-135]) shear(zx=1.41) translate([0,-10,0]) cube([lid_lip,20,lid_lip]);
            }
            if(wall_right=="Nil"|| wall_right=="Angle") {
                translate([w-angle_sz,12,-lid_lip])
                intersection() {
                    shear(zy=1) cube([angle_sz,lid_lip,lid_lip]);
                    cube([angle_sz,lid_lip,lid_lip]);
                }
                translate([w-angle_sz,d-12-lid_lip,0]) intersection(){
                    shear(zy=-1) cube([angle_sz,lid_lip,lid_lip]);
                    translate([0,0,-lid_lip]) cube([angle_sz,lid_lip,lid_lip]);
                }
            } else{
                translate([w-angle_sz-lid_lip,12,-lid_lip]) intersection() {
                    shear(zx=-1) translate([0,0,lid_lip]) cube([lid_lip,d-24,lid_lip]);
                    cube([lid_lip,d,lid_lip]);
                }
            }
            if(wall_rear=="Complete"||wall_rear=="Hollow") {
                translate([centre_thick/2,d-angle_sz-lid_lip,0]) intersection() {
                    shear(zy=-1) cube([w-12-centre_thick/2,lid_lip,lid_lip]);
                    translate([0,0,-lid_lip]) cube([w,lid_lip,lid_lip]);
                }
            } else {
                translate([w-12-lid_lip,d-angle_sz,0]) intersection(){
                    shear(zx=-1) cube([lid_lip,6,lid_lip]);
                    translate([0,0,-lid_lip]) cube([lid_lip,6,lid_lip]);
                }
            }
            if(inc_r_fan) {
                for(x=[-1,1],y=[-1,1]) translate([fan_centre_x+x*17,fan_centre_y+y*17,-3.4]) cylinder(r=1.5,h=3.4);
            }
        }
        for(screw=corner_screws) translate([w-screw[0],screw[1],0]) {
           hole(r1=screw_dia/2,r2=screw_dia/2+((screw_head_style=="Countersunk")?h:0),h=h);
            translate([0,0,h-screw_head_depth]) hole(r=screw_head_dia/2,h=screw_head_depth+0.1);
        }
            if(inc_r_fan) {
                for(x=[-1,1],y=[-1,1]) translate([fan_centre_x+x*17,fan_centre_y+y*17,-3.4]) hole(r=1.25,h=3.4+h+1);
            }    }
}

module add_screws(screwlist, dia, tgt, base, headstyle="Flat", head_dia=0, head_h=0){
    difference(){
        union(){
            children();
            for (scr=screwlist) standoff(scr[0]+tgt[0], scr[1]+tgt[1], base, dia, tgt[2]);
        }
        for (scr=screwlist) translate([scr[0]+tgt[0], scr[1]+tgt[1], -overlap]) cylinder(r=dia/2,h=tgt[2]+base+overlap*2);
    }
}

module box_r(){
    echo("Here");
    difference(){
        union(){
            cube([width-centre,depth,plate_thick]);
            //centre join piece
            hull(){
                translate([0,join_l+tol,centre_thick/2])rotate([-90,0,0])cylinder(r=centre_thick/2,h=depth-2*(join_l+tol));
                translate([-centre_thick/2,join_l+tol,0]) cube([join_base,depth-(join_l+tol)*2,plate_thick]);
            }
            //rear wall
            if(wall_rear!="Nil"){
                translate([0,depth-wall_thick,0]) {
                    cube([width-centre,wall_thick,angle_height]);
                    intersection(){
                        translate([0,wall_thick-angle_sz,angle_height]) shear(yz=1) cube([width-centre,angle_sz,angle_sz]);
                        cube([width-centre,angle_sz*2,angle_sz*2]);
                    }
                }
                if (wall_rear=="Complete") translate([centre_thick/2,depth-angle_sz,0]) cube([width-centre-centre_thick/2,angle_sz,height]);
            }
            //right wall
            if(wall_right!="Nil") {
                translate([width-centre-wall_thick,0,0]) {
                    if(wall_right=="Angle"){
                        cube([wall_thick,depth,angle_height]);
                        translate([0,0,angle_height]) intersection(){
                            cube([angle_sz+wall_thick,depth,angle_sz]);
                            translate([wall_thick-angle_sz,0,0]) shear(xz=1) cube([angle_sz,depth,angle_sz]);
                        }
                    }
                    if(wall_right=="Complete" || wall_right=="Rail") cube([wall_thick,depth,height]);
                        if(wall_right=="Rail"){
                            translate([wall_thick,rail_inset,10])rotate([0,-90,-90]) rail(depth-rail_inset*2, tol_s=rail_tol, tol_e=rail_tol, tol_t=rail_tol*3, len_t=5);
                        }
                }
            }
            //front wall
            cube([width-centre,wall_thick,height]);
            //corner pillars
            hull(){
                translate([width-centre-10,depth-3,0]) cube([10,3,height]);
                translate([width-centre-3,depth-10,0]) cube([3,10,height]);
            };
            hull(){
                translate([width-centre-10,0,0]) cube([10,3,height]);
                translate([width-centre-3,0,0]) cube([3,10,height]);
            };
        }
        //clear centre join ends
        for (y=[0,depth-join_l]) hull(){
            translate([0,y-tol,centre_thick/2]) rotate([-90,0,0]) hole(r=centre_thick/2+tol,h=join_l+tol*2);
            translate([-centre_thick/2,y-tol,0]) cube([centre_thick+tol,join_l+tol*2,1]);
        }
        //clear centre join cable space
        translate([-centre_thick/2,wall_thick+overlap,centre_thick]) cube([centre_thick,depth-overlap*2-wall_thick,height-centre_thick]);
        //clear centre rear pillar
        translate([-centre_thick/2,depth-angle_sz-tol,-overlap]) cube([centre_thick+tol,(tol+angle_sz)*2,height+overlap]);
        //clear centre join screw/rod hole
        translate([0,0,centre_thick/2]) rotate([-90,180,0]) hole(r=hole_dia/2+tol, h=depth, td_ang=45);
        //screw holes right hand wall - poss replace
        for(d=[4,depth-4]) translate([width-centre-4,d,height-15]) hole(r=1.25,h=16);
        //clearance for Y motor connector
        if (Y_motor_notch) {
            translate([39,-1,height-8]) cube([12,8,11]);
        }

    }
    // add cable clips
    if (skr_orient%180==0) {
        for(d=[1:3]) cable_clip(centre_thick/2+(width-centre-angle_sz)*d/4,85+wall_thick+(depth-wall_thick-angle_sz-85)/2);
    } else {
        for(d=[1:3]) cable_clip(skr_x+(85)+(width-centre-angle_sz-skr_x-(85))/2,(depth-wall_thick-angle_sz)*d/4);
    }
}

module add_skr(x,y,z,o,r,s) {
    xo=x+((o%180)==0?55:42.5);
    yo=y+((o%180)==0?42.5:55);
    difference() {
        union() {
            add_screws(skr14screws(skr_orient),3,[xo,yo,skr_h],plate_thick) children();
            if (s) translate([xo,yo,z]) rotate([0,0,-o]) skr14(false);
        }
        translate([xo,yo,z]) rotate([0,0,-o]) skr14(r);
    }
}

module add_lower_cable_port(x,y,w,h,depth,wthick=2,pthick=2) {
    offset=0.1;
    difference(){
        union(){
            children();
            translate([x+tol,y,0]) cube([w-tol*2,depth,h-tol]);
        }
        translate([x+wthick+tol,y-overlap,plate_thick]) cube([w-(wthick+tol)*2,depth+2*overlap,h-wthick-pthick]);
    }
}

module add_chain_attach(x,h,d=1,chaintype="Printed",clearup=false){
    ch_w = chainsize(chaintype)[0];
    ch_t = chainsize(chaintype)[2];
    ch_r = chainsize(chaintype)[3];
    ch_ri= chainsize(chaintype)[4];
    ch_ro= chainsize(chaintype)[5];
    difference(){
        union(){
            children();
            hull(){
                translate([x-ch_w/2+tol,0,h-(ch_r+d)*3.41]) cube([ch_w-tol*2,overlap,(ch_r+d)*2.82]);
                translate([x-ch_w/2+tol,-ch_r-d,h-ch_r]) rotate([0,90,0]) cylinder(r=ch_r,h=ch_w-tol*2);
            }
            for(pos=[-1,1]) translate([x+pos*(ch_w/2-overlap-tol),-ch_r-d,h-ch_r]) rotate([0,pos*90,0]) intersection(){
                cylinder(h=ch_t,r1=ch_ri,r2=ch_ro);
                shear(xz=pos) cube([ch_ri*2,ch_ri*2,ch_t*2],center=true);
            }
        }
        translate([x-ch_w/2+ch_t,-d-ch_r*2-overlap,h-ch_r*2-overlap]) cube([ch_w-ch_t*2,ch_r*2+overlap+d,(ch_r+overlap)*2]);
        hull(){
            translate([x-ch_w/2+ch_t,-d-ch_r,h-ch_r]) rotate([0,90,0]) cylinder(r=ch_r-ch_t,h=ch_w-ch_t*2);
            translate([x-ch_w/2+ch_t,ch_r,h-ch_r*3-d]) rotate([0,90,0]) cylinder(r=ch_r-ch_t,h=ch_w-ch_t*2);
            if(clearup){translate([x-ch_w/2+ch_t,ch_r,h+ch_r*3-d]) rotate([0,90,0]) cylinder(r=ch_r-ch_t,h=ch_w-ch_t*2);}
        }
    }
}

module cable_clip(x,y,h=4,base=plate_thick){
    echo(x,y)
    translate([x,y,base]) {
        difference(){
            translate([0,0,-overlap]) cylinder(r1=6,r2=5,h=h+overlap);
            translate([-6,-2,0]) cube([12,4,h-2]);
            translate([-2,-6,0]) cube([4,12,h-2]);
        }
    }
}

function rail_points(tol=0,ovl=0.1)=[
    [4.58-tol*2,0],
    [3.125-tol,1.455-tol],
    [3.125-tol,1.8+tol],
    [5.5-tol,1.8+tol],
    [5.5-tol,3.725-tol],
    [3.125-tol,6.1-tol],
    [-3.125+tol,6.1-tol],
    [-5.5+tol,3.725-tol],
    [-5.5+tol,1.8+tol],
    [-3.125+tol,1.8+tol],
    [-3.125+tol,1.455-tol],
    [-4.58+tol*2,0],
    [-4.58+tol*2,-ovl],
    [4.58-tol*2,-ovl]
];

function rail_end_paths()=[
    [5,2,3],
    [5,3,4],
    [5,6,7],
    [5,7,8],
    [5,8,9],
    [5,9,2],
    [2,9,10],
    [2,10,1],
    [0,1,10],
    [0,10,11],
    [0,11,12],
    [0,12,13]
    ];

function edge_seq(s_cnt)=[
    for (a=[0:s_cnt-1]) a,
    0
];

module rail_shape(tol) {
    polygon(rail_points(tol),
    paths=rail_end_paths());
}

function add_z(points,z)=[
    for (pt=points) [pt[0],pt[1],z]
];

function flatten(list) = [
    for (i = list, v = i) v
];

module rail(length, tol_s=0, tol_e=0,tol_t=0,len_t=0){
    elems=(len_t==0)?[[0,tol_s],[length,tol_e]]:[[0,tol_s],[length-len_t,tol_e],[length,tol_t]];
    vertices=[for (elem=elems) add_z(rail_points(elem[1]),elem[0])];
    pt_count=len(rail_points());
    es=edge_seq(pt_count);
    edge_paths=[
        /*for (base=[0:len(elems)-2],point=[0:pt_count-1])
            [((base+0)*pt_count)+es[point+0],((base+0)*pt_count)+es[point+1],((base+1)*pt_count)+es[point+0]],*/
        for (base=[0:len(elems)-2],point=[0:pt_count-1])
            [((base+0)*pt_count)+es[point+0],((base+1)*pt_count)+es[point+0],((base+1)*pt_count)+es[point+1],((base+0)*pt_count)+es[point+1]]
    ];
    //echo(concat(add_z(rail_points(0),1),add_z(rail_points(0.25),100)));
    end_base=(len(elems)-1)*pt_count;
    paths=concat(rail_end_paths(),edge_paths,
        [for (pt=rail_end_paths()) [end_base+pt[0],end_base+pt[2],end_base+pt[1]]]
            );
    polyhedron(points=flatten(vertices),faces=paths);
}

disp_ang=25;
disp_sw_rad=16.25;
disp_sw_h_off=5;
disp_sw_h_sur=3;
disp_sw_b_w=36;
disp_sw_b_l=39;
disp_sw_b_t=1.6;
disp_sw_b_l_c=18.5;
disp_scr_w=33;
disp_scr_l=42;
disp_scr_l_off=10.5;
disp_scr_b_l=60;
disp_scr_b_w=36;
disp_scr_h_off=4;
disp_scr_b_t=1.6;
disp_sep=1;
disp_sur=2;

disp_f_l=disp_sur*2+disp_sep+disp_scr_b_l+disp_sw_b_l;
disp_f_w=40;
disp_f_t=5.9;

disp_scr_pos = [
    [20-((disp_sw_b_w/2)-2.5),disp_sur+disp_sw_b_l-5,12,2.5,4],
    [20+((disp_sw_b_w/2)-2.5),disp_sur+disp_sw_b_l-5,12,2.5,4],
    [20-((disp_scr_b_w/2)-2.5),disp_sur+disp_sw_b_l+disp_sep+disp_scr_b_l-2.5,12,2.5,4],
    [20+((disp_scr_b_w/2)-2.5),disp_sur+disp_sw_b_l+disp_sep+disp_scr_b_l-2.5,12,2.5,4],
    [20-((disp_sw_b_w/2)-2.5),disp_sur+2,6,0,4],
    [20+((disp_sw_b_w/2)-2.5),disp_sur+2,6,0,4],
    [20-((disp_scr_b_w/2)-1.5),disp_sur+disp_sw_b_l+disp_sep+2.5,6,0,3],
    [20+((disp_scr_b_w/2)-1.5),disp_sur+disp_sw_b_l+disp_sep+2.5,6,0,3]
];

module add_idc(pos,rot,s_depth=5,tol=0.2,surround=1,mounted=true){
    difference(){
        union(){
            children();
            translate(pos) rotate(rot) if (mounted){
                translate([0,0,-s_depth/2]) cube([24+tol,10+tol,s_depth],center=true);
            } else {
                translate([0,0,-s_depth/2]) cube([18+tol+surround*2,6+tol+surround*2,s_depth],center=true);
                translate([0,-2,-s_depth/2]) cube([4+tol+surround*2,6+tol+surround*2,s_depth],center=true);
            }
        }
        translate(pos) rotate(rot) {
            cube([18+tol,6+tol,20],center=true);
            translate([0,-1,0]) cube([4,6+tol,20],center=true);
            if(mounted){translate([0,0,-s_depth/2-1]) cube([22+tol,8+tol,s_depth+2],center=true);}
        }
    }
}

module add_piezo(pos,rot,s_depth=5,dia=9.1,tol=0.2){
    difference(){
        union(){
            children();
            translate(pos) rotate(rot) translate([0,0,-s_depth]) cylinder(r=dia/2+tol+1.2,h=s_depth);
        }
        translate(pos) rotate(rot) translate([0,0,-s_depth-1]) hole(r=dia/2+tol,h=s_depth+1);
        translate(pos) rotate(rot) translate([0,0,-s_depth-1]) hole(r=1+tol,h=s_depth+20);
    }
}

module dispfront(){
    difference(){
        hull(){
            translate([1,1,1]) cube([disp_f_w-2,disp_f_l-2,disp_f_t-1]);
            cube([disp_f_w,disp_f_l,disp_f_t-1]);
        }
        //switch surface
        translate([20,disp_sur+disp_sw_b_l_c,disp_sw_h_off]) hole(r1=disp_sw_rad,r2=disp_sw_rad+disp_sw_h_sur,h=disp_sw_h_sur);
        //switch module
        difference(){
            translate([20-disp_sw_b_w/2,disp_sur,-0.01]) cube([disp_sw_b_w,disp_sw_b_l,disp_sw_h_off+0.02]);
            for (a=disp_scr_pos) {
                translate([a[0],a[1],disp_sw_b_t]) cylinder(r=a[4]/2,h=10);
            }
        }
        //screen base
        difference(){
            translate([20-disp_scr_b_w/2,disp_sur+disp_sep+disp_sw_b_l,-0.01]) cube([disp_scr_b_w,disp_scr_b_l,disp_scr_h_off+0.02]);
            for(a=disp_scr_pos) {
                translate([a[0],a[1],disp_scr_b_t]) cylinder(r=a[4]/2,h=10);
            }
        }
        //screen view
        translate([20-disp_scr_w/2,disp_sur+disp_sw_b_l+disp_sep+disp_scr_l_off,disp_scr_h_off]) hull(){
            cube([disp_scr_w,disp_scr_l,7]);
            translate([-disp_sur,-disp_sur,disp_sur]) cube([disp_scr_w+disp_sur*2,disp_scr_l+disp_sur*2,7]);
        }
        //screws
        for(a=disp_scr_pos){
            if(a[4]>0) {
                translate([a[0],a[1],-0.01]) hole(r=a[3]/2,h=disp_f_t+1);
                
                //translate([a[0],a[1],disp_f_t-0.5]) hole(r=2.5,h=3);
            }
        }
    }
}

module dispbase(){
    brd_scr_pos=[[38,18],[48,5],[4,28]];
    mount_depth=disp_f_l*cos(disp_ang);
/*    add_idc([8,mount_depth-1,12],[90,-90,180],mounted=false)
    add_idc([17,mount_depth-1,12],[90,-90,180],mounted=false)
    add_piezo([26,mount_depth-1,8],[90,-90,180])*/
    add_idc([1,mount_depth-disp_sur-12,disp_sur+8],[90,180,-90],mounted=false)
    add_idc([1,mount_depth-disp_sur-36,disp_sur+8],[90,180,-90],mounted=false)
    add_piezo([1,mount_depth-disp_sur-8,disp_sur+21],[90,180,-90])
    difference(){
        union(){
        difference(){
            hull(){
                cube([40,mount_depth,1]);
                /*translate([0,0,1])*/ rotate([disp_ang,0,0]) /*translate([0,0,-1])*/ cube([40,disp_f_l,1]);
            }
                    //interior space
            difference(){
                translate([disp_sur,disp_sur,disp_sur]) cube([40-disp_sur*2,mount_depth-disp_sur*2,disp_f_l]);
                //screw mounts
                for(a=disp_scr_pos){
                    rotate([disp_ang,0,0]) hull(){
                        translate([a[0],a[1],disp_f_t-a[2]]) cylinder(r=2,h=a[2]+5);
                        translate([20+21*(a[0]<20?-1:1),a[1],disp_f_t-2-a[2]]) cube([2,15,a[2]*2],center=true);
                    }
                }
                //board mounts
                for(a=brd_scr_pos){
                    translate([6,mount_depth-a[0],a[1]]) rotate([0,-90,0]) hole(r1=2.25,r2=4,h=6,td_ang=50);
                }
            }
        }
            for(a=[0.5,1.5]) translate([a*20,5,0]) rotate([-90,0,0]) rail(mount_depth-5,0.2,0.3,1,10);
        }
        // microsd card slot
        rotate([disp_ang,0,0]) translate([20,disp_f_l,0]) cube([15,20,2.01],center=true);
        //screw holes
        for(a=disp_scr_pos) if(a[3]>0) {
            rotate([disp_ang,0,0]) translate([a[0],a[1],1+disp_f_t-a[2]]) hole(r=1,h=a[2]+1);
        }
        //reset button hole
        translate([8,mount_depth-disp_sur-25,disp_sur+18]) rotate([0,-90,0]) hole(r=1.75,h=10);
        //board mount screws
        for(a=brd_scr_pos){
            translate([7,mount_depth-a[0],a[1]]) rotate([0,-90,0]) hole(r=1.25,h=6);
        }
        //markers
        translate([0.7,mount_depth-0.7,0]) rotate([90,0,-90]) linear_extrude(1) {
            translate([3,12,0]) text("E1",size=3);
            translate([26,12,0]) text("E2",size=3);
            translate([27,17,0]) text("Rst",size=3);
        }
    }
}

// Primary selection mechanics

{ //component choice
    if (component=="Left Box") {
        box_l();
        if (show_pi && $preview) translate([pix,piy,pi_height+1.3+plate_thick]) pib(pi_model,false);
        if (show_xt60 && $preview) translate([power_connector_x,0,height]) color("green") powerconn(false);
    }

    if(component=="Right Box") {
        add_skr(skr_x, skr_y+wall_thick, skr_h+plate_thick, skr_orient, expose_skr_usb_port && skr_orient==0, show_skr && $preview)
        add_lower_cable_port(width-centre-cable_port_left,depth-wall_thick,cable_port_left-cable_port_right,cable_port_height,cable_port_depth+wall_thick,wall_thick,plate_thick)
        add_chain_attach(width-centre-bed_chain_x_offset,height,bed_chain_y_offset,bed_chain_type,bed_chain_no_top)
        box_r();
    }

    if (component=="TestPi"){
        /*rotate([90,0,0])*/ difference(){
            union(){
                cube([64,4,23]);
                //cube([5.5,8,8]);
                //translate([58.5,0,0]) cube([5.5,8,8]);
            }
            translate([4,piy,4]) color("red") pib(pi_model, true, tol=tol+0.2);
            translate([4,piy,4]) color("red") pib(pi_model, false,insert=[0,20,0], tol=tol+0.2);
        }
        if(show_pi && $preview) {
            translate(/*[4,-4,piy]*/[4,piy,4]) /*rotate([90,0,0])*/ pib(pi_model, false,tol=0);
            //#translate([4,piy,4]) /*[4,-4,35]) rotate([90,0,0])*/ pib(pi_model, true);
        }
    }

    if (component=="Holder Lid"){
        holder_lid(dcdc_w,dcdc_d,dcdc_h,dcdc_t,dcdc_b);
    }

    if (component=="TestPow"){
        difference(){
            cube([15,20,20]);
            translate([7.5,0,20]) powerconn();
        }
    }

    if (component=="TestChain"){
        add_chain_attach(15,2,7,15) cube([30,2,20]);
    }
    if(component=="Left Lid"){
        rotate([180,0,0])
        lid_l(w=centre,d=depth,h=total_height-height);
    }
    if(component=="Right Lid"){
        rotate([0,0,0])
        lid_r(w=centre,d=depth,h=total_height-height);
    }
    if (component=="RailModel"){
        difference(){
            union(){
                hull(){
                    translate([-2,0,0]) cube([2,60,20]);
                    translate([-7,0,0]) cube([1,50,1]);
                }
                translate([0,0,10]) rotate([-90,-90,0]) rail(56,tol_s=0,tol_e=0.55,len_t=1,tol_t=0.9);
            }
            for(d=[0:10:50]){
                translate([6,d,10]) cube([2,0.4,3],center=true);
            }
            for(d=[0:1:50]){
                translate([6,d,10]) cube([2,0.2,1.5],center=true);
            }
        }
    }
    if(component=="TestDcDc"){
        holder(dcdc_w,dcdc_d,dcdc_h,dcdc_t,dcdc_b);
        %translate([0,0,dcdc_b+dcdc_h]) rotate([180,0,0]) holder_lid(dcdc_w,dcdc_d,dcdc_h,dcdc_t,dcdc_b);
    }
    if(component=="DispFront"){
        dispfront();
    }
    if(component=="DispMount"){
        dispbase();
    }
}  


