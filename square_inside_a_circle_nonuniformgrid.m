clc
clear
% Define pde as "electrostatic". It enables us to use some useful functions.
emagmodel = createpde(electromagnetic="electrostatic");

% Constructing the geometry
% Square inside at the center of a circle
g = geometryFromEdges(emagmodel,@scatterg);
pdegplot(emagmodel,EdgeLabels="on")
xlim([0 1.5])
ylim([-0.25 1.25])
hold on

% Define permittivity of the medium
emagmodel.VacuumPermittivity = 8.85*10^-12;
electromagneticProperties(emagmodel,RelativePermittivity=1);

% Apply boundary conditions
% Inner edges
BC1 = input("Boundary value on edge 1: ");
electromagneticBC(emagmodel,Voltage=BC1,Edge=1);
BC2 = input("Boundary value on edge 2: ");
electromagneticBC(emagmodel,Voltage=BC2,Edge=2);
BC3 = input("Boundary value on edge 3: ");
electromagneticBC(emagmodel,Voltage=BC3,Edge=3);
BC4 = input("Boundary value on edge 4: ");
electromagneticBC(emagmodel,Voltage=BC4,Edge=4);

% Outer edges
BC5 = input("Boundary value on edge 5: ");
electromagneticBC(emagmodel,Voltage=BC5,Edge=5);
BC6 = input("Boundary value on edge 6: ");
electromagneticBC(emagmodel,Voltage=BC6,Edge=6);
BC7 = input("Boundary value on edge 7: ");
electromagneticBC(emagmodel,Voltage=BC7,Edge=7);
BC8 = input("Boundary value on edge 8: ");
electromagneticBC(emagmodel,Voltage=BC8,Edge=8);

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

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",2,"Hedge",{1,scale1,2,scale2,3,scale3,4,scale4,5,scale5,6,scale6,7,scale7,8,scale8});
pdemesh(mesh_Hmax)

% Define charge density
electromagneticSource(emagmodel,ChargeDensity=5*10^-9);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.ElectricPotential, FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal