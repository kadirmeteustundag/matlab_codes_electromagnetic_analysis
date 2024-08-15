clc;clearvars;clear all;clear xlim ylim;
h_plate = 0.01;
x1 = 1;
x2 = 5;
y1 = 1;
y2 = 5;
emagmodel = createpde(electromagnetic="electrostatic");
SQ1 = [3; 4; x1; x2; x2; x1; y1-h_plate; y1-h_plate; y1; y1];
SQ2 = [3; 4; x1; x2; x2; x1; y2; y2; y2+h_plate; y2+h_plate];
SQ3 = [3; 4; x1; x2; x2; x1; y1+0.001; y1+0.001; y2-0.001; y2-0.001];
%SQ4 = [3; 4; 0; x2+1; x2+1; 0; 0; 0; x2+1; x2+1];
SQ4 = [3; 4; -50; 51; 51; -50; -50; -50; 51; 51];
gd = [SQ1 SQ2 SQ3 SQ4];
sf = 'SQ4-(SQ3+SQ1+SQ2)+(SQ3+SQ1+SQ2)';
ns = char('SQ1','SQ2','SQ3','SQ4');
ns = ns';
dl = decsg(gd,sf,ns);
geometryFromEdges(emagmodel,dl);
pdegplot(emagmodel,EdgeLabels="on",FaceLabels="on")
ylim([y1-1 y2+1]);
xlim([x1-1 x2+1]);


emagmodel.VacuumPermittivity = 8.85*10^-12;
electromagneticProperties(emagmodel,"RelativePermittivity",1);

epsulon_R_dielectric_medium = input("Relative Permittivity of Dielectric Medium: ");
electromagneticProperties(emagmodel,RelativePermittivity=epsulon_R_dielectric_medium,Face=3);

electromagneticBC(emagmodel,"Edge",[2 3 5 6],"FarField","absorbing", "Thickness",0.2);

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",0.2);
pdemesh(mesh_Hmax)
ylim([y1-1 y2+1]);
xlim([x1-1 x2+1]);

area_of_one_rect = (x2-x1)*h_plate;
electromagneticSource(emagmodel,"ChargeDensity",(1/(area_of_one_rect)),"Face",2);
electromagneticSource(emagmodel,"ChargeDensity",-(1/(area_of_one_rect)),"Face",4);

figure;
R = solve(emagmodel);
pdeplot(mesh_Hmax,FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
ylim([y1-1 y2+1]);
xlim([x1-1 x2+1]);

figure;
pdeplot(mesh_Hmax,XYData=R.ElectricPotential, FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
ylim([y1-1 y2+1]);
xlim([x1-1 x2+1]);

Ex = R.ElectricField.Ex;
Ey = R.ElectricField.Ey;
b = x1;
a = x2;

% for dielectric medium
nodes_y_coordinates = mesh_Hmax.Nodes(2,:)';
nodes_x_coordinates = mesh_Hmax.Nodes(1,:)';
E_x_on_positivexaxis = Ey((nodes_x_coordinates<2+mesh_Hmax.MaxElementSize & nodes_x_coordinates>2-mesh_Hmax.MaxElementSize) & (nodes_y_coordinates>1 & nodes_y_coordinates<3));
k = size(E_x_on_positivexaxis);
integration_length = linspace(b,a,k(1));
V_along_positive_x = (trapz(integration_length,E_x_on_positivexaxis));
Cpul_numeric_of_dielectric_medium = 1/V_along_positive_x
Cpul_analytic_of_dielectric_medium = (x2-x1)*emagmodel.VacuumPermittivity*epsulon_R_dielectric_medium/(y2-y1)
percentage_error = abs(1-Cpul_numeric_of_dielectric_medium/Cpul_analytic_of_dielectric_medium)*100

P1 = R.ElectricPotential((nodes_x_coordinates<2+mesh_Hmax.MaxElementSize/2 & nodes_x_coordinates>2-mesh_Hmax.MaxElementSize/2)&(nodes_y_coordinates<1+mesh_Hmax.MaxElementSize/2 & nodes_y_coordinates>1-mesh_Hmax.MaxElementSize/2));
P2 = R.ElectricPotential((nodes_x_coordinates<2+mesh_Hmax.MaxElementSize/2 & nodes_x_coordinates>2-mesh_Hmax.MaxElementSize/2)&(nodes_y_coordinates<3+mesh_Hmax.MaxElementSize/2 & nodes_y_coordinates>3-mesh_Hmax.MaxElementSize/2));
Vnew = P1(1)-P2(1);
C=1/(Vnew);
k1 = 1.06109;
k2 = 1.6798e-03;
C_xiang = C/(1+(k1*(y2-y1)+k2*(y2-y1)^2)/(x2-x1))
percentage_error2 = abs(1-Cpul_numeric_of_dielectric_medium/C_xiang)*100

Vdiff = max(R.ElectricPotential)-min(R.ElectricPotential);
C2 = 1/Vdiff