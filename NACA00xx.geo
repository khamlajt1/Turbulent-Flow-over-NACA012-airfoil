// NACA00XX Aerofoil Shape and Spline fit
Include "Progression.geo";
Geometry.CopyMeshingMethod = 1;
U = 30; //Incoming velocity 10m/s
grid = 1;//
nPoints = 200; // Number of discretization points
//Airfoil number
NACA00XX = 12;
// Thickness
t = NACA00XX/100;
alpha = 0;// Angle of attack
a0 = 0.2969;
a1 = -0.126;
a2 = -0.3516;
a3 = 0.2843;
a4 = -0.1036;// For a closed trailing edge -0.1036===For a opened trailing edge 0.1015
c = 1;//0.2;// Chord Length
r_inner = 0;//0.8;
AMI = r_inner + 0.3;// Radius of the AMI
r_outer = 10*r_inner;
r_hub = 0.1;// hub dimater
cc = 0;//c;//
shift = 0;
B = 2; //Number of blades
alpha = 0;
If (B == 9)
         angle = 360/B;//
EndIf
If (B == 8)
         angle = 360/B;//
EndIf
If (B == 7)
         angle = 360/B;//
EndIf
If (B == 6)
         angle = 360/B;//
EndIf
If (B == 5)
         angle = 360/B;//
EndIf
If (B == 4)
         angle = 360/B;//
EndIf
If (B == 3)
         angle = 360/B;//
EndIf
If (B == 2)
         angle = 360/B;//
EndIf
e = 0.1;
//Number of Nodes
x = 1;//1.97; //1.4;1.97;
e1 = 0;
n1 = 55*x;
n2 = 50*x;
n3 = 90*x;//385;//90*x+0;//(1-(c/8-(c/8)/(nPoints-1)))*n2/(c/8-(c/8)/(nPoints-1));
n4 = 50*x;
rm = 1.125;//
rc = 1.19;//
rf = 1.083;//
x1 = 14*c;
y1 = 15*c;
If (U == 30)
         yPls = 8.5e-5;//1.2e-4;//3.7e-3;//
EndIf
// Upper part======================================================================================================================
//Leading edge-The suction surface (a.k.a. upper surface) is generally associated with higher velocity and lower static pressure.
xx_lu = 0;
spacing = (c/8-xx_lu)/(nPoints-1);
For i In {0 : nPoints-2}
  xx_lu = spacing+xx_lu;
  x = xx_lu-spacing;
  pList[i] = newp;
  //Printf("%g",pList[i]);
  //Printf("%g",x);
  Point(pList[i]) = {x-cc/2,
                ( (5*t*c)*(((a0*(x/c)^0.5)+(a1*(x/c))+(a2*(x/c)^2)+(a3*(x/c)^3)+(a4*(x/c)^4)))+r_inner ),
                0};
EndFor
Spline(newl) = pList[];
//Traling edge-The suction surface (a.k.a. upper surface) is generally associated with higher velocity and lower static pressure.
pList[0] = nPoints-1;
spacing = (c-c/8)/(nPoints-1);
xx_te = c/8;
For i In {0 : nPoints-2}
  xx_te = spacing+xx_te;
  x = xx_te;
  pList[i] = newp;
  //Printf("%g",x);
  //Printf("%g",newp);
  Point(pList[i]) = {x-cc/2,
                ( (5*t*c)*(((a0*(x/c)^0.5)+(a1*(x/c))+(a2*(x/c)^2)+(a3*(x/c)^3)+(a4*(x/c)^4)))+r_inner ),
                0};
EndFor
Spline(newl) = {nPoints-1, pList[]};
Coherence;
Point(399) = {x1, 0, 0, 0};
Point(400) = {x1, y1, 0, 0};
Point(401) = {1, y1, 0, 0};
Point(402) = {-x1+c, y1, 0, 0};
Point(403) = {-x1+c, 0, 0, 0};
Line(3) = {401, 398};
Line(4) = {398, 399};
Line(5) = {399, 400};
Line(6) = {400, 401};
Line(7) = {401, 402};
Line(8) = {402, 403};
Line(9) = {403, 1};
Line(10) = {199, 402};
Line Loop(11) = {10, 8, 9, 1};
Plane Surface(12) = {11};
Line Loop(13) = {7, -10, 2, -3};
Plane Surface(14) = {13};
Line Loop(15) = {6, 3, 4, 5};
Plane Surface(16) = {15};
//======================================================================================================================
nbpts = n1;
L = y1;
StartCell = yPls;
low = 0;
high = 100;
tol = 0.0000001;
r = (low+high)/2;
Call Progression;
Printf("%g",r);
Transfinite Line {-9, 10, -3, 5} = n1 Using Progression 1.19;//r; Coarse 1.19; Medium 1.125; Fine
Delete nbpts;
Delete r;
Delete L;
//======================================================================================================================
Transfinite Line {8, 1}=n2 Using Progression 1;
Transfinite Line {-7, 2}=n3 Using Progression 1;
//======================================================================================================================
nbpts = n4;
L = x1;
StartCell = (1-c/8-(c/8-xx_lu)/(nPoints-1))/n3;
low = 0;
high = 100;
tol = 0.0000001;
r = (low+high)/2;
Call Progression;
Printf("%g",r);
Transfinite Line {-6, 4}=n4 Using Progression r;//.15;
Delete nbpts;
Delete r;
Delete L;
Transfinite Surface "*";
Recombine Surface "*";

//======================================================================================================================
If (grid == 1)
Rotate {{-1, 0, 0}, {0, 0, 0}, Pi} {
  Duplicata { Surface{16, 12, 14}; }
}
Rotate {{0, 0, 1}, {0, 0, c/2}, -alpha*Pi/180} {
  Line{1, 2, 26, 30};
}
Extrude {0, 0, 1} {
  Surface{12, 17, 14, 22, 16, 27};
Layers{1};
Recombine;
}
Physical Surface("inlet") = {43, 109};
Physical Surface("exit") = {139, 73};
Physical Surface("top") = {83, 127};
Physical Surface("bottom") = {149, 61};
Physical Surface("front") = {96, 52, 118, 74, 140, 162};
Physical Surface("back") = {12, 14, 16, 17, 22, 27};
Physical Surface("airfoil") = {91, 51, 117, 157};
Physical Volume("internal") = {1, 3, 5, 4, 6, 2};
EndIf
If (grid == 2)
Rotate {{0, 0, 1}, {0, 0, c/2}, -alpha*Pi/180} {
  Line{1, 2};
}
Extrude {0, 0, 1} {
  Surface{12, 14, 16};
Layers{1};
Recombine;
}
Physical Surface("top") = {47, 69};
Physical Surface("inlet") = {29};
Physical Surface("exit") = {81};
Physical Surface("front") = {60, 38, 82};
Physical Surface("back") = {12, 14, 16};
Physical Surface("airfoil") = {55, 37};
Physical Surface("bottom") = {33, 77};
Physical Volume("internal") = {1, 2, 3};
EndIf
Coherence;

Coherence;
Coherence;
Coherence;
