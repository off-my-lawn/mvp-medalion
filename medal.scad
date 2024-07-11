Side="Front"; // [Front, Back]
Style="SWS"; // [SWS, TGSS, Blank]

Size=50;
Thickness=2.24;

Position="Blocker"; // [Blocker, Jammer]
Date="20/04/24";
TeamA="BRDL";
TeamB="DVRDC";

layer_height=.16;
Height1=4;
Height2=8;
style_height=layer_height*Height1;
text_height=layer_height*Height2;
fn=200;

module sws_front(size, height)
{
    r1=200;
    linear_extrude(height)
    {
        scale(size/(r1*2))
        {
            translate([-r1,-r1])
            translate([44,50])
            scale(0.23)
            import("victoria.svg");
        }
        difference()
        {
            circle(d=size, $fn=fn);
            circle(d=size*.95, $fn=fn);
        }
    }
}

module sws_back(size, height)
{
    r1=25;
    //difference()
    //{
        //cylinder(height, d=50);
        linear_extrude(height)
        {
            translate([-r1,-r1])
            {
                import("sws.svg",$fn=fn);
            }
            difference()
            {
                circle(d=size, $fn=fn);
                circle(d=size*.95, $fn=fn);
            }
        }
        //translate([0,19.5,-1])
        //cylinder(Thickness+2, r=3, $fn=fn);
    //}1
}

module tgss_front(size, height)
{
    r1=25;
    linear_extrude(height)
    {
        translate([-r1,-r1])
        {
            import("tgss.svg",$fn=fn);
        }
        //difference()
        //{
        //    circle(d=size, $fn=fn);
        //    circle(d=size*.95, $fn=fn);
        //}
    }
}

module tgss_back(size, height)
{
    // done by tgss_medal
}

module handle(size, thickness)
{
    of=1;// Offset because zero feels too close for TGSS style
    handle=20;
    difference()
    {
        union()
        {
            translate([-handle/2, size/2+2*thickness+of, 0])
            rotate([0,90,0])
            cylinder(handle, r=thickness, $fn=fn);
            translate([-handle/2, size/2+2*thickness+of, 0])
            rotate([90,0,01])
            cylinder(5*thickness, r=thickness, $fn=fn);
            translate([handle/2, size/2+2*thickness+of, 0])
            rotate([90,0,0])
            cylinder(5*thickness, r=thickness, $fn=fn);
            translate([-handle/2, size/2+2*thickness+of, 0])
            sphere(thickness, $fn=fn);
            translate([handle/2, size/2+2*thickness+of, 0])
            sphere(thickness, $fn=fn);
        }
        translate([-handle/2-thickness, size/2+3*thickness+of, 0])
        rotate([180,0,0])
        cube([handle+2*thickness,8*thickness,thickness]);
    }
}

module tgss_medal(size, thickness, reversed)
{
    p=[
        [1,1], [1,.5], [1,1], [2,2], 
        [1.5,1.5], [.5,.5], [1,1], [1.5,1.5], 
        [1.5,1.5], [2,2], [1,1], [2,1], 
        [.75,1], [.5,.5], [1.5,1.5], [1,2], 
        [3,0], [2,.5], [1,1], [3,2]
    ];
    count=len(p);
    ir=.5;
    h1=style_height*reversed;
    h2=layer_height*reversed;
    w=8.2;
    r=size/2;
    a=360/count;
    union()
    {
        for (i = [0:count-1]) {
            ni=[r*ir*sin(a),r*ir*cos(a)];
            no=[r*sin(a)+p[i].x,r*cos(a)+p[i].y];
            mirror([reversed,0,0])
            rotate(a*i)
            polyhedron(
                points=[
                    [0,r,thickness+h2],        // 0
                    [no.x,no.y,thickness+h1],  // 1
                    [ni.x,ni.y,thickness+h1],  // 2
                    [0,r*ir,thickness+h2*2],   // 3
                    [0,r,0],                   // 4
                    [no.x,no.y,0],             // 5
                    [ni.x,ni.y,0],             // 6
                    [0,r*ir,0]                 // 7
                ],
                faces=[
                    [0,1,2,3],
                    [1,0,4,5],
                    [2,1,5,6],
                    [3,2,6,7],
                    [7,6,5,4],
                    [0,3,7,4]
                ],
                convexity=2);
        }
        cylinder(thickness,d=r+2);
        handle(size, thickness);
    }
}

module base_medal(size, thickness)
{
    difference()
    {
        cylinder(thickness,d=size, $fn=fn);
        //translate([0,19.5,-1])
        //cylinder(thickness+2, r=3, $fn=fn);
    }
    handle(size, thickness);
}

module front_text(s)
{
    linear_extrude(text_height)
    {
        translate([0,-11,0])
        text("MVP",font="Helvetica:style=Bold",size=8,halign="center",$fn=fn);
        translate([0,-18,0])
        text(s,font="Helvetica:style=Bold",size=6,halign="center",$fn=fn);
    }
}

module back_text(date, team1, team2)
{
    linear_extrude(text_height)
    {
        if(team1 == "")
        {
            translate([0,1,0])
            text(date,font="Helvetica",size=8,halign="center",valign="bottom",$fn=fn);
            translate([0,-1,0])
            text(team2,font="Helvetica",size=8,halign="center",valign="top",$fn=fn);
        }
        else
        {
            translate([0,9,0])
            text(date,font="Helvetica:style=Bold",size=6,halign="center",$fn=fn);
            translate([0,-1,0])
            text(team1,font="Helvetica:style=Bold",size=6,halign="center",$fn=fn);
            if(team1 != "Low Contact")
                translate([0,-8,0])
                text("v",font="Helvetica:style=Bold",size=6,halign="center",$fn=fn);
            translate([0,-16,0])
            text(team2,font="Helvetica:style=Bold",size=6,halign="center",$fn=fn);
        }
    }
}


/*color("orange")
translate([0, 0, thickness])
sws_back(diameter, 3*layer_height);

color("red")
back_text("20/04/24", "BRDL", "DVRDC");*/

module front()
{
    color("orange")
    if(Style=="SWS")
    {
        //translate([-diameter/2, -diameter/2, thickness])
        sws_front(Size, style_height);
    }
    else if(Style=="TGSS")
        tgss_front(Size, style_height);
    color("red")
    front_text(Position);
}

module back()
{
    color("orange")
    if(Style=="SWS")
        sws_back(Size, style_height);
    else if(Style=="TGSS")
        tgss_back(Size, style_height);
    color("red")
    back_text(Date, TeamA, TeamB);
}

module medal()
{
    color("gold")
    if(Style != "TGSS")
        base_medal(Size, Thickness);
    else if(Side=="Front")
        tgss_medal(Size, Thickness, 0);
    else
        tgss_medal(Size, Thickness, 1);
    translate([0, 0, Thickness])
    if(Side == "Front")
        front();
    else
        back();
}

medal();