clc
clear
% Define pde as "electrostatic". It enables us to use some useful functions.
emagmodel = createpde(electromagnetic="electrostatic");


% Constructing the geometry
% Square inside at the center of a circle
g = geometryFromEdges(emagmodel,@scatterg);
xlim([0 1.5])
ylim([-0.25 1.25])
hold on

% Define permittivity of the medium
emagmodel.VacuumPermittivity = 8.85*10^-12;
electromagneticProperties(emagmodel,RelativePermittivity=1);

% Apply boundary conditions
% Inner edges
electromagneticBC(emagmodel,Voltage=0,Edge=1);
electromagneticBC(emagmodel,Voltage=0,Edge=2);
electromagneticBC(emagmodel,Voltage=10,Edge=3);
electromagneticBC(emagmodel,Voltage=0,Edge=4);

% Outer edges
electromagneticBC(emagmodel,Voltage=10,Edge=5);
electromagneticBC(emagmodel,Voltage=0,Edge=8);
electromagneticBC(emagmodel,Voltage=0,Edge=7);
electromagneticBC(emagmodel,Voltage=0,Edge=6);

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",2,"Hedge",{5,0.01,3,0.01});
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