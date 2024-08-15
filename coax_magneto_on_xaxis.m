emagmodel = createpde(electromagnetic="magnetostatic");
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

emagmodel.VacuumPermeability = 4*pi*10^-7;
electromagneticProperties(emagmodel,"RelativePermeability",1);

mu_R_dielectric_medium = input("Relative Permeability of Dielectric Medium: ");
electromagneticProperties(emagmodel,RelativePermeability=mu_R_dielectric_medium,Face=2);

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",0.2);
pdemesh(mesh_Hmax)

inner_area = pi*(r2^2-r1^2);
outer_area = pi*(r4^2-r3^2);

electromagneticSource(emagmodel,"CurrentDensity",-(1/(outer_area)),"Face",1);
electromagneticSource(emagmodel,"CurrentDensity",(1/(inner_area)),"Face",3);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy],ColorMap="hot")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.MagneticPotential,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy], ColorMap="hot")
axis equal

BBx = R.MagneticFluxDensity.Bx;
BBy = R.MagneticFluxDensity.By;
b = r2;
a = r3;

v = linspace(-r4,r4,51);
[X,Y] = meshgrid(v);

Hintrp = interpolateMagneticField(R,X,Y);
HintrpX = reshape(Hintrp.Hx,size(X));
HintrpY = reshape(Hintrp.Hy,size(Y));

figure
quiver(X,Y,HintrpX,HintrpY,"Color","red")


mesh_y = mesh_Hmax.Nodes(2,:)';
mesh_x = mesh_Hmax.Nodes(1,:)';
Bthrough_x_on_positivexaxis = BBy((mesh_y<mesh_Hmax.MaxElementSize & mesh_y>-mesh_Hmax.MaxElementSize) & mesh_x>0);
k = size(Bthrough_x_on_positivexaxis);
integration_length = linspace(b,a,k(1));
Lpul_numeric = trapz(integration_length,Bthrough_x_on_positivexaxis)
Lpul_analytic = emagmodel.VacuumPermeability*mu_R_dielectric_medium*log(a/b)/(2*pi)
percentage_error = abs(1-Lpul_numeric/Lpul_analytic)*100

A_diff = (max(R.MagneticPotential)-min(R.MagneticPotential));
L2 = A_diff
