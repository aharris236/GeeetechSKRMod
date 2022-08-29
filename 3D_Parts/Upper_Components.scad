tol=0.2;
ovhl=50;

component="holder"; //[holder,ymax,zchain,zmax,swcover,swbase]
/* [Holder] */
h_off=10.5;
upper=2.5;
shroud_h=16;

mount_nut_cover=13;
mount_nut_scr=3;
mount_nut_head=5;
mount_scr_sep=18;
mount_scr_sur_d=4.5;
mount_scr_sur_h=2;

touch_scr=3;
touch_nut=6.1;
touch_nut_dist=8;
touch_scr_sep=18;
touch_scr_sur=2.5;

/* [switch] */
sw_sc_id=2.9;
sw_sc_od=3.2;
sw_sc_sep=19;
sw_sc_sur=1;
sw_sc_ins=2.6;
//offset from edge of board to switch trigger distance
sw_trig_dist=2.4;
//vertical offset from board to centre of switch surface
sens_vert_pos=2.9;
//targe distance from rail surface to centre of plate to be sensed
vert_mount_c=6.5;
//offset from rail mounting edge to trigger
horiz_mount_c=0;
//offset mounting from centre of rail (to permit avoiding motor etc)
lr_offset=0;
//outer diameter of screws used to mount onto rail with T-nut
rl_scr_od=2.9;
//belt clearance width
belt_w=12;
//belt clearance height
belt_h=5;
//max width of centre join element
join_w=40;
//provide a cover over the connector
con_cover=true;
    board_w=25;
    board_d=16;
    hold_c=1.5;
    hold_h=6;
    hold_t=1.2;
    hold_t_u=2.9;
    sw_mi_w=13;
    sw_mi_d=11;
    holder_ext=14.5;
    
/* [zmount] */
z_scr_id=2.9;
z_scr_od=3.2;
z_scr_sep=10;
z_scr_ins=4;
z_trig_h=25;
z_trig_x_off=10;
z_trig_y_off=9;
r_z_scr_d=28;
r_z_scr_x=22;
fil_mnt_thick=5;
fil_mnt_d_off=-8;
fil_mnt_scr_id=4.1;
fil_mnt_scr_h=9;
fil_mnt_scr_w=8;

zchain="2415";//["1815","2415","Printed"]
z_chain_centre_z=13;
z_chain_centre_inset_y=8;
z_chain_centre_offset_x=4;
z_chain_screw_d=5;
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

module roundedrectangle(x,y,z,r,centre=false){
    act_r=min(min(x,y)/2,r);
    off_x=centre?0:x/2;
    off_y=centre?0:y/2;
    pz=centre?-z/2:0;
    hull() for(px=[act_r-x/2,x/2-act_r],py=[act_r-y/2,y/2-act_r]) translate([off_x+px,off_y+py,pz]) cylinder(r=act_r, h=z);
}
module roundedcube(x,y,z,r,centre=false){
    act_r=min(min(x,y,z)/2,r);
    off_x=centre?0:x/2;
    off_y=centre?0:y/2;
    off_z=centre?0:z/2;
    pz=centre?-z/2:0;
    hull() for(px=[act_r-x/2,x/2-act_r],py=[act_r-y/2,y/2-act_r], pz=[act_r-z/2,z/2-act_r])
        translate([off_x+px,off_y+py,off_z+pz]) sphere(r=act_r);
}

ovl=0.1;
overlap=0.1;
//$fn=$preview?24:48;
$fs=$preview?0.5:0.2;
$fa=$preview?30:10;
function chainsize(chain)=[
    if(chain=="Printed")
        for (a=[20.5,12.5,1.6,6.25,4/2,2/2]) a,
    if(chain=="1815")
        for (a=[14,15,2,7.5,6/2,6/2]) a,
    if (chain=="2415")
        for (a=[24,15,2,7.5,6/2,6/2]) a,
];
        
module touchsens(clear=true){
    hull(){
        translate([-6.75-(clear?tol:0),1-(clear?tol:0),-30]) cube([13.5+(clear?2*tol:0),12+(clear?2*tol:0),23+ovl*2+(clear?9.5:0)]);
        translate([-4.5-(clear?tol:0),0-(clear?tol:0),-30]) cube([9+(clear?2*tol:0),14+(clear?2*tol:0),23+ovl*2+(clear?9.5:0)]);
    }
    translate([0,6,-8]) cylinder(r=6,h=8+ovl);
    hull(){
        for(mul=[-0.5,0.5]){
            translate([mul*touch_scr_sep,6,0]) cylinder(h=2.5+ovl,r=touch_scr/2+touch_scr_sur+(clear?tol:0));
        }
        translate([-4,0,0]) cube([8,12,2.5+ovl]);//11.4?
    }
    if(clear){
        for (mul=[-0.5,0.5]){
            translate([touch_scr_sep*mul,6,-18-ovl]) color("red") hole(r=touch_scr/2,h=20+ovl*2);
        }
    }
}

module holder(outer=true){
    difference(){
        union(){
            if(outer){
                //surround for probe
                translate([-8,0,-shroud_h]) cube([16,15,shroud_h]);
            }
            hull(){
                //mount plate
                translate([-13,0,-max(h_off+5,shroud_h)]) cube([26,3,max(10,shroud_h)]);
                for(mul=[-1,1]){
                    translate([mul*8.75,0,-h_off]) rotate([-90,0,0]) cylinder(r=mount_nut_head/2,h=2+mount_nut_cover);
                }
                
                //upper edge of outer (for lack of outer)
                translate([-8,0,-max(5,shroud_h)]) cube([16,15,max(5,shroud_h)+upper]);
                //outer hold for top
                translate([0,0,-max(5,shroud_h)]) hull()
                {
                    for(mul=[-0.5,0.5]){
                        translate([mul*touch_scr_sep,6,0]) cylinder(h=max(5,shroud_h)+upper,r=touch_scr/2+touch_scr_sur+1);
                    }
                    translate([-4,0,0]) cube([8,13,max(5,shroud_h)+upper]);
                }
            }
        }
        //nuts for screws on BLTouch
        for(mul=[-0.5,0.5]){
            translate([mul*touch_scr_sep,6,-(touch_nut_dist-2.5)]) rotate([0,180,90]) cylinder(h=max(12,shroud_h)+ovl,r=touch_nut/2+tol,$fn=6);
        }
        //Mount points on frame
        for(mul=[-0.5,0.5]){
            translate([mount_scr_sep*mul,-ovl,-h_off]) rotate([-90,0,0]) {
                rotate([0,0,180]) hole(r=2.25,h=2+ovl,td_ang=ovhl);
                rotate([0,0,180]) hole(r=mount_nut_scr/2,h=2+mount_nut_cover+ovl,td_ang=ovhl);
                translate([0,0,2+mount_nut_cover]) rotate([0,0,180]) hole(r=mount_nut_head/2,h=15,td_ang=ovhl);
            }
        }
        touchsens(true);
    }
}

module sw_lower(inv_scr=false,orient=-1,extend_cover=true){
    ext_w=extend_cover?holder_ext:0;
    translate([0,-(board_d/2+sw_trig_dist),sens_vert_pos/*hold_h/2*/]) difference(){
        hull(){
            translate([-board_w/2,-board_d/2,-hold_t]) roundedrectangle(board_w+ext_w,board_d,hold_t,hold_c,centre=false);
            translate([-board_w/2,-board_d/2,-(hold_h+hold_t)]) roundedcube(board_w+ext_w,board_d,hold_h,hold_c,centre=false);
        }
        for (p=[-0.5,0.5])
            translate([p*sw_sc_sep,board_d/2-sw_sc_ins,-hold_h*2]) rotate([0,0,(orient==-1?0:orient)]) hole(r=(inv_scr?sw_sc_od:sw_sc_id)/2,h=hold_h*3,td_ang=(orient==-1?-1:ovhl));
        translate([0,(board_d-sw_mi_d)/2,-(hold_h-overlap)/2]) cube([sw_mi_w+tol*2,sw_mi_d+overlap,hold_h+overlap],center=true);
        //led gap
        translate([-10.25,-2,-0.75+overlap/2]) cube([5,5,1.5+overlap],center=true);
        //resistor gap 6.5-11
        translate([9.5,0,-0.5+overlap/2]) cube([4.5,5,1+overlap],center=true);
        //connector hole
        translate([board_w/2+5.5+4.5,0,-overlap/2-3]) cube([18,12.5+tol*2,6+overlap*2],center=true);
        
    }
}

module sw_upper(inv_scr=false,orient=-1,extend_cover=true){
    ext_w=extend_cover?holder_ext:0;
    /*translate([0,-(board_d/2+sw_trig_dist),sens_vert_pos])*/ 
    rotate([0,180,0]) difference(){
        hull(){
            translate([-board_w/2,-board_d/2,0]) roundedrectangle(board_w+ext_w,board_d,hold_c*2,hold_c,centre=false);
            translate([-board_w/2,-board_d/2,0]) roundedcube(board_w+ext_w,board_d,hold_t_u,hold_c,centre=false);
        }
        for (p=[-0.5,0.5])
            translate([p*sw_sc_sep,board_d/2-sw_sc_ins,-overlap]) rotate([0,0,(orient==-1?0:orient)]) hole(r=(inv_scr?sw_sc_id:sw_sc_od)/2,h=hold_h*3,td_ang=(orient==-1?-1:ovhl));
        //switch legs
        translate([-0,-1,1.1-overlap/2]) cube([13,5,2.2+overlap],center=true);
        //connector legs
        translate([15,0,1.1-overlap/2]) cube([4.5,10,2.2+overlap],center=true);
    }
}

module rail_link(length=20,c_off=5,height=2.5,disp=true){
    difference(){
        union(){
            translate([0,length/2,height/2]) cube([40,length,height], center=true);
            for(s=[-10,10]){
                for(a=[-1,1]) translate([s+a*(4.58-tol*2)-(a>0?1.45-tol:0),0,(a<0?0:-1.45+tol)]) shear(zx=a) cube([1.45-tol,length,1.45-tol]);
                translate([tol-3.125+s,0,tol-5]) cube([6.25-tol*2,length,5-tol]);
            }
        }
        for(s=[-10,10]) translate([s,c_off,-overlap-5]) hole(r=rl_scr_od/2+tol,h=height+2*overlap+5,td_ang=ovhl);
        for(s=[-10,10]) translate([s,c_off,0]) color("red") tnut(disp=false);
    }
    if(disp) for(s=[-10,10]) translate([s,c_off,-0.8]) color("red") rotate([0,0,90]) tnut(disp=true);
}

module tnut(disp=false){

    if (disp) {
        color("red") {
            for(a=[-1,1]) translate([1.5*a,1.5*a,-1]) cube([3,3,2],center=true);
            translate([0,0,-2]) cylinder(r=3,h=2);
            translate([0,0,-1.5-1.75]) cube([6,10,3.5],center=true);
        }
    } else{
        translate([0,0,-1-4.5]) cylinder(r=5.83+tol,h=4.5);
        translate([0,0,-1]) cube([6,6,2],center=true);
    }
}

if(component=="holder"){
    holder();
}
if (component=="ymax"){
    difference(){
        union(){
            //translate([lr_offset,horiz_mount_c-trig_dist,vert_mount_c+sens_vert_pos]) sw_base();
            translate([0,0,vert_mount_c]) sw_lower(orient=0);
            translate([0,0,0]) rail_link(length=13,c_off=8,disp=$preview);
            //join between two...
            hull(){
                translate([0,-overlap/2,2.5/2]) cube([40,overlap,2.5],center=true);
                //translate([0,-board_d/2-sw_trig_dist,vert_mount_c+sens_vert_pos-hold_h/*+hold_c/2*/]) cube([board_w-hold_c*2,board_d-hold_c*2,overlap], center=true);
               translate([0,-board_d/2-sw_trig_dist,(vert_mount_c-sens_vert_pos+overlap)/2]) roundedrectangle(board_w,board_d,vert_mount_c-sens_vert_pos+overlap,hold_c, centre=true);
            }
            //translate([-join_w/2,horiz_mount_c-trig_dist-sw_sc_od/2-sw_sc_sur,0]) cube([join_w,trig_dist-horiz_mount_c+sw_sc_od+sw_sc_sur,2.5]);
        }
        //clearance for belt
        hull(){
            translate([0,10,belt_h/2-overlap]) cube([belt_w,60,belt_h+overlap],center=true);
            translate([0,-10,0.5-overlap]) cube([belt_w,30,belt_h+overlap],center=true);
        }
        //angle edge of rail insets to avoid overhangs
        translate([-20,0,-5]) shear(yz=-1) cube([40,5,5]);
        //notch at planned trigger point
        translate([0,0.5,2.5]) shear(zy=1) cube([20,1,1],center=true);
        
    }
    //translate([0,0,20]) rotate([0,180,0]) sw_upper();
}
if(component=="swcover"){
    sw_upper(extend_cover=con_cover);
}
if(component=="swbase"){
    sw_lower(extend_cover=con_cover);
}

if(component=="zchain"){
        difference(){
        union(){
            hull(){
                translate([-11,0,-overlap]) roundedrectangle(max(20,11+r_z_scr_x+z_scr_ins),17,overlap,1.5);
                translate([r_z_scr_x-z_scr_ins,0,-overlap]) roundedrectangle(2*z_scr_ins,r_z_scr_d+z_scr_ins,overlap,1.5);
                translate([-11,0,-2.5]) roundedcube(11+r_z_scr_x+z_scr_ins,17,2.5,1.5);
                translate([r_z_scr_x-z_scr_ins,0,-2.5]) roundedcube(2*z_scr_ins,r_z_scr_d+z_scr_ins,2.5,1.5);
            }
            /*translate([z_trig_x_off,z_trig_y_off,z_trig_h]) rotate([-90,180,-90]) sw_upper(orient=0);
            hull(){
                intersection(){
                    cube([100,100,2*z_trig_h-11],center=true);
                    translate([z_trig_x_off,z_trig_y_off,z_trig_h]) rotate([-90,180,-90]) sw_upper(orient=0);
                }
                translate([z_trig_x_off-2.5,0,0]) cube([2.5,z_trig_y_off*2-1,1]);
            }*/
            for(s=[-1,1]){
                translate([z_chain_centre_offset_x,z_chain_centre_inset_y,-z_chain_centre_z]) rotate([0,s*90,0]) translate([0,0,chainsize(zchain)[0]/2+tol]) cylinder(r=chainsize(zchain)[3], h=chainsize(zchain)[2]);
                translate([z_chain_centre_offset_x,z_chain_centre_inset_y,-z_chain_centre_z/2]) rotate([0,0,s*90]) translate([0,chainsize(zchain)[0]/2+tol+chainsize(zchain)[2]/2]) cube([2*chainsize(zchain)[3],chainsize(zchain)[2],z_chain_centre_z], center=true);
            }
            //screw mounts
            for(p=[-0.5,0.5]) {
                translate([p*z_scr_sep,z_scr_ins,-z_chain_screw_d]) hole(r=z_scr_id,h=z_chain_screw_d);
            }
            translate([r_z_scr_x,r_z_scr_d,-z_chain_screw_d]) hole(r=z_scr_id,h=z_chain_screw_d);
            //mock chain connection
            //color("red") translate([z_chain_centre_offset_x,z_chain_centre_inset_y,-z_chain_centre_z]) rotate([0,90,0]) translate([0,0,-12]) cylinder(r=7.5,h=24);
            //outer hooks for chain insertion
        }
        //chain connection
        color("red") translate([z_chain_centre_offset_x,z_chain_centre_inset_y,-z_chain_centre_z]) rotate([0,90,0]) translate([0,0,-chainsize(zchain)[0]/2-tol]) cylinder(r=7.5,h=chainsize(zchain)[0]+tol*2);
        for(s=[-1,1]){
            translate([z_chain_centre_offset_x,z_chain_centre_inset_y,-z_chain_centre_z]) rotate([0,s*90,0]) translate([0,0,chainsize(zchain)[0]/2]) rotate([0,0,-s*90]) hole(r1=chainsize(zchain)[4]+tol, r2=chainsize(zchain)[5]+tol, h=chainsize(zchain)[2]+tol*2, td_ang=ovhl);
        }
        for(p=[-0.5,0.5]) {
            translate([p*z_scr_sep,z_scr_ins,-10]) hole(r=z_scr_id/2,h=10+overlap);
        }
        translate([r_z_scr_x,r_z_scr_d,-10]) hole(r=z_scr_id/2,h=10+overlap);
    }
}
if(component=="zmax"){
    difference(){
        union(){
            hull(){
                translate([-10,0,0]) roundedrectangle(max(20,10+r_z_scr_x+z_scr_ins),10,overlap,1.5);
                translate([r_z_scr_x-z_scr_ins,0,0]) roundedrectangle(2*z_scr_ins,r_z_scr_d+z_scr_ins,overlap,1.5);
                translate([-10,0,0]) roundedcube(10+r_z_scr_x+z_scr_ins,10,2.5,1.5);
                translate([r_z_scr_x-z_scr_ins,0,0]) roundedcube(2*z_scr_ins,r_z_scr_d+z_scr_ins,2.5,1.5);
            }
            translate([z_trig_x_off,z_trig_y_off,z_trig_h]) rotate([-90,180,-90]) sw_upper(orient=0);
            hull(){
                intersection(){
                    cube([100,100,2*z_trig_h-11],center=true);
                    translate([z_trig_x_off,z_trig_y_off,z_trig_h]) rotate([-90,180,-90]) sw_upper(orient=0);
                }
                translate([z_trig_x_off-2.5,0,0]) cube([2.5,10+((r_z_scr_d+z_scr_ins)-10)*((z_trig_x_off+z_scr_ins/2)/r_z_scr_x),1]);
            }
            //mount for filament detector
            translate([r_z_scr_x-fil_mnt_scr_w/2,r_z_scr_d+fil_mnt_d_off-fil_mnt_thick,0]) roundedcube(fil_mnt_scr_w,fil_mnt_thick,fil_mnt_scr_h+fil_mnt_scr_id*1.25+2.5,1.5);
        }
        for(p=[-0.5,0.5]) {
            translate([p*z_scr_sep,z_scr_ins,0]) hole(r=tol+z_scr_od/2,h=3);
            translate([p*z_scr_sep,z_scr_ins,2.5]) hole(r=tol+(z_scr_od+z_scr_id)/2,h=15);
        }
        translate([r_z_scr_x,r_z_scr_d,-overlap]) hole(r=tol+z_scr_od/2,h=3);
        //mount for filament detector
        translate([r_z_scr_x,r_z_scr_d+fil_mnt_d_off+overlap,2.5+fil_mnt_scr_h]) rotate([90,0,0]) hole(r=tol+fil_mnt_scr_id/2, h=fil_mnt_thick+overlap*2, td_ang=ovhl);
        //hole for interim attachment of cabling
        translate([r_z_scr_x-2,5,-overlap]) hole(r=tol+3,h=2.5+overlap*2);
    }
}