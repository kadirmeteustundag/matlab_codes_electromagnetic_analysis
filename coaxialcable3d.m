emagmodel = createpde("electromagnetic","electrostatic");
%gm = multicylinder([3 10],10,"Void",[true,false]);
%{
C1 = multicylinder(20,[10 10],"ZOffset",[0 10]);
C2 = multicylinder(10,[10 10],"ZOffset",[0 10]);
gm = [C1,C2];
sf = 'C1-C2';
ns = char('C1','C2');
ns = ns';
dl = decsg(gm,sf,ns);
geometryFromEdges(emagmodel,dl);

hold on
%}
% Define permittivity of the medium
%pdegplot(emagmodel,"CellLabels","on","FaceAlpha",0.5,EdgeLabels="on",FaceLabels="on")
gm = multicylinder([3 10],10,"Void",[true,false]);
emagmodel.Geometry = gm;
pdegplot(emagmodel,"CellLabels","on","FaceAlpha",0.5,FaceLabels="on")
emagmodel.VacuumPermittivity = 8.85*10^-12;
electromagneticProperties(emagmodel,RelativePermittivity=1);

% Apply boundary conditions
% Inner edges
electromagneticBC(emagmodel,Voltage=0,Face=1);
electromagneticBC(emagmodel,Voltage=10000,Face=2);
electromagneticBC(emagmodel,Voltage=10000,Face=3);
%electromagneticBC(emagmodel,Voltage=0,Face=4);

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",2);
%,"Hedge",{5,0.01,3,0.01}
pdemesh(mesh_Hmax)

% Define charge density
electromagneticSource(emagmodel,ChargeDensity=5*10^-9);

figure;
R = solve(emagmodel);

pdeplot3D(mesh_Hmax,FlowData=[R.ElectricField.Ex, R.ElectricField.Ey,R.ElectricField.Ez])
axis equal

figure;
%pdeplot3D(mesh_Hmax,XYData=R.ElectricPotential, FlowData=[R.ElectricField.Ex, R.ElectricField.Ey,R.ElectricField.Ez])
pdeplot3D(emagmodel,"ColorMapData",R.ElectricPotential)
axis equal
