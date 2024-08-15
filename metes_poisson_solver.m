clc
clear
% N = point number between two integer
N = 100;

e = input("dielectric constant of the medium: ");
pv = input("charge distribution (give (N*N,1) matrix): ");
f = pv/e;

% set dx = approximate differential length
dx =  1/N;
% first solve the Laplace's equation with finite difference approximation
A_diag0 = eye(N) * (-4 / dx^2);
A_diag0 = A_diag0 + diag(ones(N-1,1), 1) / dx^2;
A_diag0 = A_diag0 + diag(ones(N-1,1), -1) / dx^2;
A_diag1 = eye(N) / dx^2;
% I realised program slows down here because of the size of the matrix.
% Since there are so many 0 entries, using sparse is more efficient
A = sparse(N*N , N*N);

% central diagonal entries
for i = 1:N
    A((i-1)*N+1:(i-1)*N+N, (i-1)*N+1:(i-1)*N+N) = A_diag0; 
end 

% upper and lower diagonal entries
for i = 2:N
    A((i-2)*N+1:(i-2)*N+N, (i-1)*N+1:(i-1)*N+N) = A_diag1;
    A((i-1)*N+1:(i-1)*N+N, (i-2)*N+1:(i-2)*N+N) = A_diag1;
end

% set boundary condition (Dirichlet boundary condition/some constant number)
V0x1 = input("V0x1, x axis lower boundary condition: ");
V0y1 = input("V0y1, y axis left hand side boundary condition: ");
V0x2 = input("V0x2, x axis upper boundary condition: ");
V0y2 = input("V0y2, y axis right hand side boundary condition: ");


% setting x axis lower boundary condition
for i=(N-1)*N+1:1:N*N
    V(i)=V0x1/dx^2;
end

% setting y axis left hand side boundary condition
for i=1:N:N*(N-1)+1
    V(i)=V0y1/dx^2;
end

% setting x axis upper boundary condition
for i=1:1:N
    V(i)=V0y2/dx^2;
end

% setting y axis right hand side boundary condition 
for i=N:N:(N*N)
    V(i)=V0x2/dx^2;
end

% finding potential
V = -A\f;
V = reshape(V, N, N);
surf(V)
grid minor
title("potential distrubition")

% finding electric field
figure;
x = linspace(0,1,(N));
y = x';
reshape(V.',1,[])
[EX,EY] = gradient(-V);
surf(EX,EY);
grid minor
title("electrical field distribution")

% electric field lines and equipotential surfaces
figure;
contour(x,y,V)
hold on
quiver(x,y,EX,EY)
title("electric field lines and equipotential surfaces")

% point charge at the center
% reshape(diag([zeros(1,49) 100000 zeros(1,50)]).',[],1)

% uniform charge distribution
% ones(N*N,1)