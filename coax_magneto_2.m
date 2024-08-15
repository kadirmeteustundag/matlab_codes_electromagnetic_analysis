emagmodel = createpde(electromagnetic="magnetostatic");
%se = input("square edge length: ");
%R1 = [3,4,-se,se,se,-se,-se,-se,se,se]';
C1 = [1,0,0,0.8]';
C2 = [1,0,0,1]';
%C1 = [C1;zeros(length(R1) - length(C1),1)];
C3 = [1,0,0,8]';
%C3 = [C3;zeros(length(R1) - length(C3),1)];
C4 = [1,0,0,8.2]';
%C4 = [C4;zeros(length(R1) - length(C4),1)];
gm = [C1,C3,C4,C2];
sf = '(C3+C4+C2)-C1';
ns = char('C1','C3','C4','C2');
ns = ns';
g = decsg(gm,sf,ns);
geometryFromEdges(emagmodel,g);
pdegplot(emagmodel,EdgeLabels="on",FaceLabels="on")
axis equal

emagmodel.VacuumPermeability = 4*pi*10^-7;
electromagneticProperties(emagmodel,"RelativePermeability",1);

mu_R_dielectric_medium = input("Relative Permeability of Dielectric Medium: ");
electromagneticProperties(emagmodel,RelativePermeability=mu_R_dielectric_medium,Face=2);

%electromagneticBC(emagmodel,"Edge",1:4, "FarField","absorbing", "Thickness",1)

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",0.5);
pdemesh(mesh_Hmax)

electromagneticSource(emagmodel,"CurrentDensity",-(5/3.24)*10^-9,"Face",1);
electromagneticSource(emagmodel,"CurrentDensity",(5/0.36)*10^-9,"Face",3);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy],ColorMap="hot")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.MagneticPotential,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy], ColorMap="hot")
axis equal

Bmag = sqrt(R.MagneticFluxDensity.Bx.^2 + R.MagneticFluxDensity.By.^2);
Bmag

BBx = R.MagneticFluxDensity.Bx;
BBy = R.MagneticFluxDensity.By;
[Btheta,Brho] = cart2pol(BBx,BBy);
si = size(BBx);
s = si(1);
b = 1;
a = 8;
x = linspace(b,a,s);
y = linspace(b,a,s);
z = linspace(b,a,s);
r1 = linspace(b,a,s);
r2 = linspace(0.8,b,s);
theta = linspace(0,2*pi,s);
dr = (a-b)/(s);
dtheta = 2*pi/(s);
Bmag = Bmag.*r1.*z;
Iq = 5*10^-9*pi*pi*ones(size(Bmag));
n3 = trapz(r2,Iq);
n4 = trapz(theta,n3);
n2 = trapz(r1,Bmag);
n1 = trapz(z,n2);
n1/n4