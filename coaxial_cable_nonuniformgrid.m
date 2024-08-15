clc
clear
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
electromagneticProperties(emagmodel,RelativePermittivity=1);

% Apply boundary conditions
% Constraint
BC2 = input("Boundary value on edge 2: ");
electromagneticBC(emagmodel,Voltage=BC2,Edge=2);
BC3 = input("Boundary value on edge 3: ");
electromagneticBC(emagmodel,Voltage=BC3,Edge=3);
BC5 = input("Boundary value on edge 5: ");
electromagneticBC(emagmodel,Voltage=BC5,Edge=5);
BC6 = input("Boundary value on edge 6: ");
electromagneticBC(emagmodel,Voltage=BC6,Edge=6);

% Lower plate
BC4 = input("Boundary value on edge 4: ");
electromagneticBC(emagmodel,Voltage=BC4,Edge=4);
BC8 = input("Boundary value on edge 8: ");
electromagneticBC(emagmodel,Voltage=BC8,Edge=8);
BC10 = input("Boundary value on edge 10: ");
electromagneticBC(emagmodel,Voltage=BC10,Edge=10);
BC11 = input("Boundary value on edge 11: ");
electromagneticBC(emagmodel,Voltage=BC11,Edge=11);

% Upper plate
BC7 = input("Boundary value on edge 7: ");
electromagneticBC(emagmodel,Voltage=BC7,Edge=7);
BC9 = input("Boundary value on edge 9: ");
electromagneticBC(emagmodel,Voltage=BC9,Edge=9);
BC1 = input("Boundary value on edge 1: ");
electromagneticBC(emagmodel,Voltage=BC1,Edge=1);
BC12 = input("Boundary value on edge 12: ");
electromagneticBC(emagmodel,Voltage=BC1,Edge=12);

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

if BC9 == 0
    C9 = DefaultScale;
elseif BC9>500
    C9 = 500;
else
    C9=BC9;
end

if BC10 == 0
    C10 = DefaultScale;
elseif BC10>500
    C10 = 500;
else
    C10=BC10;
end

if BC11 == 0
    C11 = DefaultScale;
elseif BC11>500
    C11 = 500;
else
    C11=BC11;
end

if BC12 == 0
    C12 = DefaultScale;
elseif BC12>500
    C12 = 500;
else
    C12=BC12;
end

scale1 = scaleofBCinterval * (1/abs(C1));%input
scale2 = scaleofBCinterval * (1/abs(C2));
scale3 = scaleofBCinterval * (1/abs(C3));
scale4 = scaleofBCinterval * (1/abs(C4));
scale5 = scaleofBCinterval * (1/abs(C5));
scale6 = scaleofBCinterval * (1/abs(C6));
scale7 = scaleofBCinterval * (1/abs(C7));
scale8 = scaleofBCinterval * (1/abs(C8));
scale9 = scaleofBCinterval * (1/abs(C9));
scale10 = scaleofBCinterval * (1/abs(C10));
scale11 = scaleofBCinterval * (1/abs(C11));
scale12 = scaleofBCinterval * (1/abs(C12));

figure;
mesh_Hmax = generateMesh(emagmodel,"Hmax",2,"Hedge",{1,scale1,2,scale2,3,scale3,4,scale4,5,scale5,6,scale6,7,scale7,8,scale8,9,scale9,10,scale10,11,scale11,12,scale12});
pdemesh(mesh_Hmax)

% Define charge density
%electromagneticSource(emagmodel,ChargeDensity=5E-9);

figure;

R = solve(emagmodel);

pdeplot(mesh_Hmax,FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal

figure;
pdeplot(mesh_Hmax,XYData=R.ElectricPotential, FlowData=[R.ElectricField.Ex, R.ElectricField.Ey],ColorMap="jet")
axis equal