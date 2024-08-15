model = createpde(3);
L = 100e-3; % Beam length in meters
H = 1e-3; % Overall height of the beam
H2 = H/2; % Height of each layer in meters

topLayer = [3 4 0 L L 0 0 0 H2 H2];
bottomLayer = [3 4 0 L L 0 -H2 -H2 0 0];
gdm = [topLayer;bottomLayer]';
g = decsg(gdm,'R1+R2',['R1';'R2']');

geometryFromEdges(model,g);
figure
pdegplot(model,"EdgeLabels","on", ...
               "FaceLabels","on")
xlabel("X-coordinate, meters")
ylabel("Y-coordinate, meters")
axis([-.1*L,1.1*L,-4*H2,4*H2])
axis square
E = 2.0e9; % Elastic modulus, N/m^2
NU = 0.29; % Poisson's ratio
G = 0.775e9; % Shear modulus, N/m^2
d31 = 2.2e-11; % Piezoelectric strain coefficients, C/N
d33 = -3.0e-11;
relPermittivity = 12;
permittivityFreeSpace = 8.854187817620e-12; % F/m
C11 = E/(1 - NU^2); 
C12 = NU*C11;
c2d = [C11 C12 0; C12 C11 0; 0 0 G];
pzeD = [0 d31; 0 d33; 0 0];
pzeE = c2d*pzeD;
D_const_stress = [relPermittivity 0;
                  0 relPermittivity]*permittivityFreeSpace;
D_const_strain = D_const_stress - pzeD'*pzeE;
cond_scaling = 1e5;
c11 = [c2d(1,1) c2d(1,3) c2d(3,1) c2d(3,3)];
c12 = [c2d(1,3) c2d(1,2); c2d(3,3) c2d(2,3)];
c21 = c12';

c22 = [c2d(3,3) c2d(2,3) c2d(3,2) c2d(2,2)];
c13 = [pzeE(1,1) pzeE(1,2); pzeE(3,1) pzeE(3,2)];
c31 = cond_scaling*c13';
c23 = [pzeE(3,1) pzeE(3,2); pzeE(2,1) pzeE(2,2)];
c32 = cond_scaling*c23';

c33 = cond_scaling*[D_const_strain(1,1)
                    D_const_strain(2,1)
                    D_const_strain(1,2)
                    D_const_strain(2,2)];
ctop = [c11(:); c21(:); -c31(:);
        c12(:); c22(:); -c32(:);
       -c13(:); -c23(:); -c33(:)];
cbot = [c11(:); c21(:); c31(:);
        c12(:); c22(:); c32(:);
        c13(:); c23(:); -c33(:)];
f = [0 0 0]';
specifyCoefficients(model,"m",0,"d",0,"c",ctop,"a",0,"f",f,"Face",2);
specifyCoefficients(model,"m",0,"d",0,"c",cbot,"a",0,"f",f,"Face",1);
voltTop = applyBoundaryCondition(model,"mixed", ...
                                       "Edge",1,...
                                       "u",100,...
                                       "EquationIndex",3);
voltBot = applyBoundaryCondition(model,"mixed", ...
                                       "Edge",2,...
                                       "u",0,...
                                       "EquationIndex",3);

clampLeft = applyBoundaryCondition(model,"mixed", ...
                                         "Edge",6:7,...
                                         "u",[0 0],...
                                         "EquationIndex",1:2);
msh = generateMesh(model,"Hmax",5e-4);
result = solvepde(model);
rs = result.NodalSolution;
feTipDeflection = min(rs(:,2));
fprintf("Finite element tip deflection is: %12.4e\n",feTipDeflection);
tipDeflection = -3*d31*100*L^2/(8*H2^2);
fprintf("Analytical tip deflection is: %12.4e\n",tipDeflection);
varsToPlot = char('X-Deflection, meters', ...
                  'Y-Deflection, meters', ...
                  'Electrical Potential, Volts');
for i = 1:size(varsToPlot,1)
  figure;
  pdeplot(model,"XYData",rs(:,i),"Contour","on")
  title(varsToPlot(i,:))
  % scale the axes to make it easier to view the contours
  axis([0, L, -4*H2, 4*H2])
  xlabel("X-Coordinate, meters")
  ylabel("Y-Coordinate, meters")
  axis square
end
