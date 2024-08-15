emagmodel = createpde("electromagnetic","electrostatic");
gm = multicylinder([3 10],10,"Void",[true,false]);
emagmodel.Geometry = gm;
pdegplot(emagmodel,"CellLabels","on","FaceAlpha",0.5,FaceLabels="on")
