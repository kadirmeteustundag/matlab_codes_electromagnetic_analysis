emagmodel = createpde(electromagnetic="electrostatic");
r1 = input("from inside to outside, r1: ");
C1 = [1,0,0,r1]';
r2 = input("r2: ");
C2 = [1,0,0,r2]';
r3 = input("r3: ");
C3 = [1,0,0,r3]';
r4 = input("r4: ");
C4 = [1,0,0,r4]';

gm = [C1,C3,C4,C2];
sf = '(C3+C4+C2)-C1';
ns = char('C1','C3','C4','C2');
ns = ns';
g = decsg(gm,sf,ns);
geometryFromEdges(emagmodel,g);
pdegplot(emagmodel,EdgeLabels="on",FaceLabels="on")
axis equal

emagmodel.VacuumPermittivity = 8.85*10^-12;
electromagneticProperties(emagmodel,"RelativePermittivity",1);

epsulon_R_dielectric_medium = input("Relative Permittivity of Dielectric Medium: ");
electromagneticProperties(emagmodel,RelativePermittivity=epsulon_R_dielectric_medium,Face=2);


figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",0.2);
pdemesh(mesh_Hmax)

inner_area = pi*(r2^2-r1^2);
outer_area = pi*(r4^2-r3^2);

electromagneticSource(emagmodel,"ChargeDensity",-(1/(outer_area)),"Face",1);
electromagneticSource(emagmodel,"ChargeDensity",(1/(inner_area)),"Face",3);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.ElectricPotential, FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal

Ex = R.ElectricField.Ex;
Ey = R.ElectricField.Ey;
b = r2;
a = r3;

%for dielectric medium
nodes_y_coordinates = mesh_Hmax.Nodes(2,:)';
nodes_x_coordinates = mesh_Hmax.Nodes(1,:)';
E_x_on_positivexaxis = Ex((nodes_y_coordinates<mesh_Hmax.MaxElementSize & nodes_y_coordinates>-mesh_Hmax.MaxElementSize) & nodes_x_coordinates>0);
k = size(E_x_on_positivexaxis);
integration_length = linspace(b,a,k(1));
V_along_positive_x = trapz(integration_length,E_x_on_positivexaxis);
Cpul_numeric_of_dielectric_medium = 1/V_along_positive_x
Cpul_analytic_of_dielectric_medium = 2*pi*emagmodel.VacuumPermittivity*epsulon_R_dielectric_medium/(log(a/b))
percentage_error = abs(1-Cpul_numeric_of_dielectric_medium/Cpul_analytic_of_dielectric_medium)*100

%for whole geometry
integration_length_wh = linspace(0,r4,k(1));
V_along_positive_x_wh = trapz(integration_length_wh,E_x_on_positivexaxis);
Cpul_numeric_wh = 1/V_along_positive_x_wh

Vdiff = max(R.ElectricPotential)-min(R.ElectricPotential);
C2 = 1/Vdiff