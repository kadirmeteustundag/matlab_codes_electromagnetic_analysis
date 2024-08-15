
emagmodel = createpde(electromagnetic="electrostatic");
%C1 = [1,0.5,-0.7,0.7]';
%C2 = [1,0.5,-0.5,0.5]';
pos = [2 4 2 2];
C1=rectangle('Position',pos,'Curvature',[1 1]);
pos = [2.5 4.5 1 1];
C2=rectangle('Position',pos,'Curvature',[1 1]);
axis equal
gm = [C1,C2];
sf = 'C1-C2';
ns = char('C1','C2');
ns = ns';
dl = decsg(gm,sf,ns);
geometryFromEdges(emagmodel,dl);
pdegplot(emagmodel,EdgeLabels="on")
%{
clear model
model = createpde;
g = geometryFromEdges(model,@circleg);
pdegplot(model)
%}

