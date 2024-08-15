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

%electromagneticBC(emagmodel,"Edge",1:4, "FarField","absorbing", "Thickness",1)

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",0.3);
pdemesh(mesh_Hmax)

a1 = pi*(r2^2-r1^2);
a2 = pi*(r4^2-r3^2);

electromagneticSource(emagmodel,"CurrentDensity",-(1/(a2)),"Face",1);
electromagneticSource(emagmodel,"CurrentDensity",(1/(a1)),"Face",3);

figure;
R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy],ColorMap="hot")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.MagneticPotential,FlowData=[R.MagneticField.Hx, R.MagneticField.Hy], ColorMap="hot")


axis equal


BBx = R.MagneticFluxDensity.Bx;
BBy = R.MagneticFluxDensity.By;
si = size(BBx);
s = si(1);
b = 1;
a = 8;
Bmag = sqrt(R.MagneticFluxDensity.Bx.^2 + R.MagneticFluxDensity.By.^2);

aci = atan(BBy./BBx);

Bthro03 = zeros(s,1);
p=1;
while p<s+1
    if abs(aci(p))<0.0005
           Bthro03(p) = Bmag(p);
    end
    p=p+1;
end
Bthro3=nonzeros(Bthro03);
z = size(Bthro3);
r5 = linspace(b,a,z(1));
h=trapz(r5,Bthro3)


sorted = sort(aci);
Bthroo=sorted(s-30:s);
o = size(Bthroo);
r6 = linspace(b,a,31);
e=trapz(r6,Bthroo)