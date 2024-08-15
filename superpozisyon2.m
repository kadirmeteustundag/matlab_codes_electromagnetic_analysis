clc
clear
emagmodel = createpde(electromagnetic="magnetostatic");
R1 = [3,4,-10,10,10,-10,-10,-10,10,10]';
C1 = [1,0,0,1]';
C1 = [C1;zeros(length(R1) - length(C1),1)];
C2 = [1,0,0,8]';
C2 = [C2;zeros(length(R1) - length(C2),1)];
gm = [R1,C1,C2];
sf = '((R1+C2)-C1)';
ns = char('R1','C1','C2');
ns = ns';
g = decsg(gm,sf,ns);
geometryFromEdges(emagmodel,g);
pdegplot(emagmodel,EdgeLabels="on",FaceLabels="on")
axis equal

emagmodel.VacuumPermeability = 4*pi*10^-7;
electromagneticProperties(emagmodel,"RelativePermeability",1);

mu_R_dielectric_medium = input("Relative Permeability of Dielectric Medium: ");
electromagneticProperties(emagmodel,RelativePermeability=mu_R_dielectric_medium,Face=2);
% Apply boundary conditions
% Inner edges

BC1 = input("Boundary value on edge 1: ");
electromagneticBC(emagmodel,MagneticPotential=BC1,Edge=1);
BC2 = input("Boundary value on edge 2: ");
electromagneticBC(emagmodel,MagneticPotential=BC2,Edge=2);
BC3 = input("Boundary value on edge 3: ");
electromagneticBC(emagmodel,MagneticPotential=BC3,Edge=3);
BC4 = input("Boundary value on edge 4: ");
electromagneticBC(emagmodel,MagneticPotential=BC4,Edge=4);

% Outer edges
BC5 = input("Boundary value on edge 5: ");
electromagneticBC(emagmodel,MagneticPotential=BC5,Edge=5);
BC6 = input("Boundary value on edge 6: ");
electromagneticBC(emagmodel,MagneticPotential=BC6,Edge=6);
BC7 = input("Boundary value on edge 7: ");
electromagneticBC(emagmodel,MagneticPotential=BC7,Edge=7);
BC8 = input("Boundary value on edge 8: ");
electromagneticBC(emagmodel,MagneticPotential=BC8,Edge=8);

DefaultScale = 1;%input
scaleofBCinterval = 1;

if BC1 == 0
    C1=DefaultScale;
elseif BC1>500
    C1 = 500;
else
    C1=BC1;
end

if BC2 == 0
    C2=DefaultScale;
elseif BC2>500
    C2 = 500;
else
    C2=BC2;
end

if BC3 == 0
    C3=DefaultScale;
elseif BC3>500
    C3 = 500;    
else
    C3=BC3;
end

if BC4 == 0
    C4=DefaultScale;
elseif BC4>500
    C4 = 500;
else
    C4=BC4;
end

if BC5 == 0
    C5=DefaultScale;
elseif BC5>500
    C5 = 500;    
else
    C5=BC5;
end

if BC6 == 0
    C6=DefaultScale;
elseif BC6>500
    C6 = 500;    
else 
    C6=BC6;
end

if BC7 == 0
    C7=DefaultScale;
elseif BC7>500
    C7 = 500;
else
    C7=BC7;
end

if BC8 == 0
    C8 = DefaultScale;
elseif BC8>500
    C8 = 500;
else
    C8=BC8;
end

scale1 = scaleofBCinterval * (1/C1);%input
scale2 = scaleofBCinterval * (1/C2);
scale3 = scaleofBCinterval * (1/C3);
scale4 = scaleofBCinterval * (1/C4);
scale5 = scaleofBCinterval * (1/C5);
scale6 = scaleofBCinterval * (1/C6);
scale7 = scaleofBCinterval * (1/C7);
scale8 = scaleofBCinterval * (1/C8);

electromagneticBC(emagmodel,"Edge",1:4, "FarField","absorbing", "Thickness",0.001)

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",2,"Hedge",{1,scale1,2,scale2,3,scale3,4,scale4,5,scale5,6,scale6,7,scale7,8,scale8});
pdemesh(mesh_Hmax)

% Define current density
%electromagneticSource(emagmodel,CurrentDensity=5*10^-9);
%electromagneticSource(emagmodel,"CurrentDensity",5*10^-9,"Face",1);
%electromagneticProperties(emagmodel,"Conductivity",6e4);

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
r1 = linspace(b,a,s);
r2 = linspace(0,b,s);
theta = linspace(0,2*pi,s);
dr = (a-b)/(s);
dtheta = 2*pi/(s);
Bmag = Bmag.*r1;
Iq = 5*10^-9*ones(size(Bmag)).*r2;
n3 = trapz(r2,Iq);
n4 = trapz(theta,n3);
n2 = trapz(r1,Bmag);
n1 = trapz(theta,n2);
n1/n4

%Lpul = emagmodel.VacuumPermeability*mu_R*log(a/b)/(2*pi);
%Lpul