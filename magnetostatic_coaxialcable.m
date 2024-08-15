clc
clear
emagmodel = createpde(electromagnetic="magnetostatic");
a = input("outer radius: ");
b = input("inner radius: ");
C1 = [1,-1,-7,a]';
C2 = [1,-1,-7,b]';
axis equal
gm = [C1,C2];
sf = 'C1-C2';
ns = char('C1','C2');
ns = ns';
axis equal
dl = decsg(gm,sf,ns);
g = geometryFromEdges(emagmodel,dl);
pdegplot(emagmodel,EdgeLabels="on")

emagmodel.VacuumPermeability = 4*pi*10^-7;
mu_R = input("Relative Permeability: ");
electromagneticProperties(emagmodel,RelativePermeability=mu_R);

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

%electromagneticBC(emagmodel,"Edge",1:4, "FarField","absorbing", "Thickness",0.1)

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",2,"Hedge",{1,scale1,2,scale2,3,scale3,4,scale4,5,scale5,6,scale6,7,scale7,8,scale8});
pdemesh(mesh_Hmax)

% Define charge density
electromagneticSource(emagmodel,CurrentDensity=5*10^-9);

%electromagneticProperties(emagmodel,"Conductivity",6e4);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy],ColorMap="hot")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.MagneticPotential,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy], ColorMap="hot")
axis equal
%{
x=linspace(-10,10);
y=linspace(-10,10);
Bmag = sqrt(R.MagneticFluxDensity.Bx.^2 + R.MagneticFluxDensity.By.^2);
r = sqrt(x.^2+y.^2);
L = Bmag*r.^2*pi/(5*10^-9);
L
%}

%{
syms r theta
[Btheta,Brho] = cart2pol(R.MagneticFluxDensity.Bx,R.MagneticFluxDensity.By);
L1 = int(Btheta,theta,[0,2*pi]);
L2 = int(Brho*r/(5*10^-9),r,[b,a]);
Lpul = dot(L1,L2);
double((Lpul))
syms x y
r = sqrt(x^2+y^2);
Bmag = sqrt(R.MagneticFluxDensity.Bx.^2 + R.MagneticFluxDensity.By.^2);
[Btheta,Brho] = cart2pol(R.MagneticFluxDensity.Bx,R.MagneticFluxDensity.By);
L1 = int(Bmag,x,[-8,8]);
L2 = int(Bmag*r/(5*10^-9),y,[-8,8]);
Lpul = sqrt(L1.^2+L2.^2);
double(Lpul)

syms r theta
[Btheta,Brho] = cart2pol(R.MagneticFluxDensity.Bx,R.MagneticFluxDensity.By);
B = sqrt(Btheta.^2+Brho.^2);
L = int(int(B*r/(5*10^-9),r,[b,a]),theta,[0,2*pi]);
double(L)
Bmag = sqrt(R.MagneticFluxDensity.Bx.^2 + R.MagneticFluxDensity.By.^2);
figure
pdeplot(emagmodel,"XYData",Bmag,"FlowData",[R.MagneticFluxDensity.Bx,R.MagneticFluxDensity.By])
%}
%{
[Btheta,Brho] = cart2pol(R.MagneticFluxDensity.Bx,R.MagneticFluxDensity.By);
B = @(theta,r) [Btheta,Brho];
polarfun = @(theta,r) B.*r/(5*10^-9);
q = integral2(polarfun,0,2*pi,b,a);
q
%}
%{
r = linspace(1,8,519);
theta = linspace(0,2*pi,519);
dr = 7/519;
dtheta = 2*pi/519;
BBx = R.MagneticFluxDensity.Bx;
BBy = R.MagneticFluxDensity.By;
[Btheta,Brho] = cart2pol(BBx,BBy);
ds = @(r) r.*dr*dtheta;
q = integral2(polarfun,0,pi*2,b,a);
q
%}
Bmag = sqrt(R.MagneticFluxDensity.Bx.^2 + R.MagneticFluxDensity.By.^2);
Bmag

BBx = R.MagneticFluxDensity.Bx;
BBy = R.MagneticFluxDensity.By;
[Btheta,Brho] = cart2pol(BBx,BBy);
si = size(BBx);
s = si(1);
r = linspace(b,a,s);
x = linspace(b,a,s);
y = linspace(b,a,s);

theta = linspace(0,2*pi,s);
dr = (a-b)/(s);
dtheta = 2*pi/(s);
Bmag = Bmag.*r;
Iq = 5*10^-9*ones(size(Bmag)).*r;
n3 = trapz(r,Iq);
n4 = trapz(theta,n3);
n2 = trapz(r,Bmag);
n2
n1 = trapz(theta,n2);
n1/n4

%{
BBx = R.MagneticFluxDensity.Bx;
BBy = R.MagneticFluxDensity.By;
fun = @(BBx,BBy) R.MagneticFluxDensity.Bx.*R.MagneticFluxDensity.By;
[Btheta,Brho] = cart2pol(BBx,BBy);
polarfun = @(Btheta,Brho) fun(Brho.*cos(Btheta),Brho.*sin(Btheta)).*Brho;
q = integral2(polarfun,0,pi*2,b,a);
q
%}

%{
B = @(x,y) [R.MagneticFluxDensity.Bx,R.MagneticFluxDensity.By];
r = @(x,y) x.^2+y.^2;
u = @(B,r) B.*r/5*10^-9;
q = integral2(u,-8,8,-8,8);
q
%}
%Lpul = emagmodel.VacuumPermeability*mu_R*log(a/b)/(2*pi);
%Lpul