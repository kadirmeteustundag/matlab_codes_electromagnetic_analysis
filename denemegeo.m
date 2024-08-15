%{
model = createpde;
R1 = [3,4,-1,1,1,-1,0.75,0.75,-0.75,-0.75]';
%R1 = [2,3,-1,1,-1,0.5,0.5,-0.75]';
%R1 = [1,0,0,1,1]';
g = decsg(R1);
f=geometryFromEdges(model,g);
h=rotate(f, 30, [0,0]);
pdegplot(h,EdgeLabels="on",FaceLabels="on")
xlim([-1.1,1.1])
ylim([-0.9,0.6])
%}
emagmodel = createpde(electromagnetic="electrostatic");


% Constructing the geometry
% Square inside at the center of a circle
g = geometryFromEdges(emagmodel,@scatterg);
xlim([0 1.5])
ylim([-0.25 1.25])
hold on
%specifyCoefficients(emagmodel, 'm', 0, 'd', 0, 'c', 1, 'a', 0, 'f', 1)
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
%electromagneticSource(emagmodel,ChargeDensity=5*10^-9);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.ElectricPotential, FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal