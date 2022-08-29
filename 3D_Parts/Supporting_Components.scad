width=240;
ovl=6;
height=20;
thick=3;

model="Ruler";// [Endcap,Crosspiece,Ruler,Railtest,ZChainLower,BedChainAdaptor]

$fn=$preview?16:96;

module hole(r=-1,r1=2,r2=1,h=1){
    e=cos(360/($fn>0.0?max(3,$fn):ceil(max(min(360/$fn,max(r,r1,r2)*2*PI/$fs),5))));
    cylinder(r1=((r==-1)?r1:r)/e,r2=((r==-1)?r2:r)/e,h=h);
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

function chainsize(chain)=
    // width,height,plate_thick,plate_rad,link_inner_rad,link_outer_rad
    chain=="printed"?
        [20.5,12.5,1.6,6.25,4/2,2/2]
    : chain=="1815"?
        [14,15,2,7.5,6/2,6/2]
    : chain=="2415"?
        [24,15,2,7.5,6/2,6/2]
    : [0,0,0,0,0]
;

module rulermarks(leng=250){
    for (a=[10,5,1]){
        for(b=[0:a:leng]){
            translate([b-0.2,-a/2,-0.75]) cube([0.4,a/2,1]);
        }
    }
    for (a=[0:10:leng]){
        translate([a,-8,-0.75]) linear_extrude(1) text(str((a/10)),size=4,halign="center",valign="center");
    }
}

module ruler(leng=250){
    difference(){
        union(){
            translate([0,-height,-thick]) cube([width,height,thick]);
            translate([-5,-13.3,-thick]) cube([width+ovl*2,6.8,3]);
        }
        rulermarks(leng);
    }
}

module railinsert(h,tol=0.3){
    linear_extrude(h) intersection(){
        translate([0,5,0]) square([15,10],center=true);
        union(){
            hull(){
                translate([0,0,-1]) square([9.16-tol*2,1],center=true);
                translate([0,0.9+tol/2,0]) square([6.2-tol*2,1.8-tol],center=true);
            }
            translate([0,1]) square([6.2-tol*2,4],center=true);
            hull(){
                translate([0,2.62+tol,0]) square([11-tol*2,1.64-tol*2],center=true);
                translate([0,3.95+tol,0]) square([5.68-tol*2,4.3-tol*2],center=true);
            }
        }
    }
}

module cap(x=1,y=1,screwhole=false,thick=2.1,raildepth=3){
    difference(){
        union(){
            hull(){
                cube([x*20,y*20,0.01]);
                translate([thick,thick,thick]) cube([x*20-thick*2,y*20-thick*2,0.01]);
            }
            translate([0,0,-raildepth]) {
                for(a=[0:x-1]){
                    translate([10+a*20,0,0]) railinsert(raildepth);
                    translate([10+a*20,y*20,0]) rotate([0,0,180])railinsert(raildepth);
                }
                for(a=[0:y-1]){
                    translate([0,10+a*20,0]) rotate([0,0,-90]) railinsert(raildepth);
                    translate([x*20,10+a*20,0]) rotate([0,0,90])railinsert(raildepth);
                }
            }
        }
        if(screwhole) for(a=[0:x-1],b=[0:y-1]) translate([10+a*20,10+b*20,-0.1]) hole(r1=2.5,r2=2.5+thick/2,h=thick+0.2);
    }
}

module testrail(leng=15){
    rad=15;
    difference(){
        union(){
            cylinder(h=leng*2,r=rad/cos(30),$fn=6);
            for(a=[0:5]) rotate([0,0,30+60*a]){
                translate([rad,0,0]) rotate([0,0,-90]) railinsert(leng,a*0.1);
            }
        }
        for(a=[0:5]) rotate([0,0,30+60*a]){
            translate([rad-1,0,leng*2-2]) rotate([0,90,0]) linear_extrude(2) text(str(0.1*a),size=6,valign="center");
        }
    }
}

module retainer(){
    translate([0,-20,-5]) cube([250,20,5]);
    hull(){
        translate([0,-20,-0.01]) cube([250,20,0.01]);
        translate([-4,-17.9,2.1]) cube([258,15.8,0.01]);
        translate([105,-10,0]) cube([40,10,2.1]);
    }
    translate([-20,-20,0]) cap(1,1,false,2.1,5);
    translate([250,-20,0]) cap(1,1,false,2.1,5);
    translate([115,0,-10]) railinsert(12,tol=0.25);
    translate([135,0,-10]) railinsert(12,tol=0.25);
}

module zchainbottom(){
    h1=8;
    epos=25;
    elen=20;
    chainpos=45;
    chain_width=24;
    chain_height=h1;
    length=chainpos+7.5;
    
    chw=24;
    p_thick=2;
    difference(){
        union(){
            
            cube([40,length,p_thick]);
            for (p=[10,30]) translate([p,0,0]) rotate([90,180,180]) railinsert(length,tol=0.25);
            for (a=[-1,1]){
                //cable channel wall
                translate([20+a*(chain_width/2-p_thick/2),7.5+chainpos/2,p_thick+h1/2]) cube([p_thick,chainpos,h1],center=true);
                translate([20+a*(chain_width/2-p_thick/2),7.5,p_thick-0.01]) union(){
                    
                    //chain link mount
                    hull(){
                        cube([p_thick,15,0.01],center=true);
                        translate([-p_thick/2,0,chain_height]) rotate([90,0,90]) cylinder(h=p_thick,r=7.5);
                    }
                    //chain link protrusion
                    translate([a*p_thick*1.5,0,chain_height]) rotate([a*-90,0,90]) intersection(){
                        cylinder(r=2.9,h=2);
                        shear(zx=-0.75) translate([-3,-3,0]) cube([6,6,12]);
                    }
                }
            }
            //end wall - base of chain - poss not required
            //translate([(40-chain_width)/2,0,0]) cube([chain_width,p_thick,h1+p_thick]);
            //end wall - towards z motor
            translate([(40-chain_width)/2,length-p_thick,0]) cube([chain_width,p_thick,h1+p_thick]);
        }
        //cable entry position
        translate([0,epos+elen,p_thick]) rotate([0,-90,180]) roundedrectangle(elen,20,h1*2,h1);
        translate([20,length,p_thick+h1]) rotate([90,0,0]) roundedrectangle(20,h1*2,p_thick*3,h1,centre=true,$fn=96);
    }
}

module bchainadaptor(){
    ichain_width=14.2;
    ichain_height=15;
    ichain_rad=15/2;
    ichain_i_rad=5.8/2;

    ochain_width=20.5;
    ochain_height=12.5;
    ochain_rad=12.5/2;
    ochain_i_rad=4.5/2;
    ochain_i_rad2=3/2;
    ochain_i_t=1.6;

    p_thick=1.8;
    chain_sep=ichain_rad+ochain_rad+p_thick*2;
    /*#cube([ichain_width,ichain_rad*2,1],center=true);
    #translate([0,chain_sep,0]) cube([ochain_width,ochain_rad*2,1],center=true);*/
    difference(){
        union(){
   
            for(a=[-1,1]){
                hull(){
                    translate([a*(ichain_width/2),0,ichain_rad]) rotate([0,a*90,0]) translate([0,0,-p_thick]) cylinder(r=ichain_rad,h=p_thick);
                    translate([a*(ichain_width-p_thick)/2,chain_sep/4+p_thick/4,ichain_rad-p_thick/2]) cube([p_thick,chain_sep/2+p_thick/2,ichain_rad*2+p_thick],center=true);
                }
                translate([a*(ichain_width/2),0,ichain_rad]) rotate([0,a*90,0]) intersection(){
                    cylinder(r=ichain_i_rad,h=p_thick);
                    shear(zy=0.75) cube([6,6,p_thick*2],center=true);
                }
                hull(){
                    translate([a*(ochain_width+ochain_i_t)/2,chain_sep*3/4,ochain_rad-p_thick/2]) cube([ochain_i_t,p_thick*2+ochain_rad,ochain_rad*2+p_thick],center=true);
                    translate([a*(ochain_width/2),chain_sep,ochain_rad]) rotate([0,a*90,0]) cylinder(r=ochain_rad,h=ochain_i_t);
                }
                hull(){
                    translate([a*(ochain_width+ochain_i_t)/2,chain_sep/2,ochain_rad]) cube([ochain_i_t,p_thick,ochain_rad*2],center=true);
                    translate([a*(ichain_width-p_thick)/2,chain_sep/2,ichain_rad]) cube([p_thick,p_thick,ichain_rad*2],center=true);
                }
                translate([-ichain_width/2,0,-p_thick]) cube([ichain_width,ichain_rad+p_thick,p_thick]);
                translate([-ochain_width/2-p_thick,chain_sep/2-p_thick/2,-p_thick]) cube([ochain_width+p_thick*2,ochain_rad+p_thick*2,p_thick]);
            }
        }
        for(a=[-1,1]) translate([a*ochain_width/2,chain_sep,ochain_rad]) rotate([0,90*a,0]) cylinder(r1=ochain_i_rad,r2=ochain_i_rad2,h=ochain_i_t);
    }
}

module addchaininner(chaintype="printed",offset=[0,0,0],rotate=[0,0,0],sloped_pin=false,clearchannel=true){
        // width,height,plate_thick,plate_rad,link_inner_rad,link_outer_rad

    stats=chainsize(chaintype);
    width=stats[0];
    height=stats[1];
    p_thick=stats[2];
    rad=stats[3];
    i_rad1=stats[4];
    i_rad2=stats[5];
    difference(){
        union(){
            children();
            for(a=[-1,1]){
                hull(){
                    translate([a*(width/2),0,0]) rotate([0,a*-90,0]) cylinder(r=rad,h=p_thick);
                    translate([a*(width-p_thick)/2,(height-p_thick)/2,0]) cube([p_thick,p_thick,height],center=true);
                }
                translate([a*(width/2),0,0]) rotate([0,a*90,0]) intersection(){
                    cylinder(r1=i_rad1,r2=i_rad2,h=p_thick);
                    shear(zy=sloped_pin?0.75:0) cube([i_rad1*2,i_rad1*2,p_thick*2],center=true);
                }
            }
        }
        //removal
        if (clearchannel) cube([width-p_thick*2,height,rad*2], center=true);
    }
}

module addchainouter(chaintype="printed",offset=[0,0,0],rotation=[0,0,0],sloped_pin=true,clearchannel=true){
        // width,height,plate_thick,plate_rad,link_inner_rad,link_outer_rad

    stats=chainsize(chaintype);
    width=stats[0];
    height=stats[1];
    p_thick=stats[2];
    rad=stats[3];
    i_rad1=stats[4];
    i_rad2=stats[5];
    difference(){
        union(){
            children();
            translate(offset) rotate(rotation) for(a=[-1,1]){
               hull(){
                translate([a*(width/2),0,0]) rotate([0,a*90,0]) cylinder(r=rad,h=p_thick);
                translate([a*(width+p_thick)/2,(height-p_thick)/2,0]) cube([p_thick,p_thick,height],center=true);
               }
            }
        }
        //removal
        translate(offset) rotate(rotation){
            for(a=[-1,1]) translate([a*width/2,0,0]) rotate([0,90*a,0]) cylinder(r1=i_rad1,r2=i_rad2,h=p_thick);
            if (clearchannel) cube([width,height,rad*2], center=true);
        }
    }
}

if (model=="Ruler") ruler();
if (model=="Endcap") cap(1,1,true);
if (model=="Railtest") testrail();
if (model=="Crosspiece") retainer();
if (model=="ZChainLower") zchainbottom();
if (model=="BedChainAdaptor") {
    //bchainadaptor();
    addchainouter("printed",offset=[0,15,0],rotation=[180,0,0]) addchaininner("1815");
}