clc
clear
% Define pde as "electrostatic". It enables us to use some useful functions.
emagmodel = createpde(electromagnetic="electrostatic");

% Constructing the geometry
% Square inside at the center of another square
g = geometryFromEdges(emagmodel,@scatterg);
pdegplot(emagmodel,EdgeLabels="on")
xlim([0 1.5])
ylim([-0.25 1.25])
hold on

% Define permittivity of the medium
emagmodel.VacuumPermittivity = 8.85*10^-12;
electromagneticProperties(emagmodel,RelativePermittivity=1);

% Apply boundary conditions
% Outer edges
electromagneticBC(emagmodel,Voltage=20,Edge=6);
electromagneticBC(emagmodel,Voltage=0,Edge=1);
electromagneticBC(emagmodel,Voltage=30,Edge=2);
electromagneticBC(emagmodel,Voltage=0,Edge=7);

% Inner edges
electromagneticBC(emagmodel,Voltage=0,Edge=3);
electromagneticBC(emagmodel,Voltage=0,Edge=4);
electromagneticBC(emagmodel,Voltage=500,Edge=5);
electromagneticBC(emagmodel,Voltage=0,Edge=8);

figure;
mesh_Hmax = generateMesh(emagmodel,'Hmin',0.29,"Hmax",0.3);
pdemesh(mesh_Hmax)

% Define charge density
electromagneticSource(emagmodel,ChargeDensity=5E-9);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.ElectricPotential, FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal