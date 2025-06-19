function[harmonics, sorted_eigs] = fcn_extract_connectome_eigenmodes(input_matrix)


%%%%%%%%%%%%%%%%%%%%
%% Inputs: 
% input_matrix: a square symmetric matrix (presumed to be the structural connectome)
%
%% Outputs: 
% harmonics: the connectome eigenmodes, sorted
% eigenvalues: the eigenvalues associated with each harmonic/eigenmode, 
% by which they are sorted.
%
% This code follows the method of Atasoy et al (2016) Nat Commun
%%%%%%%%%%%%%%%%%%%%

A = input_matrix ./ max(input_matrix(:)); %set max to 1
        
%Laplacian
D = diag(sum(A,2)); %using strength not degree as per Atasoy 2016
L = D - A ;

%Normalised Laplacian
delta = (D^-(1/2)) * L * (D^-(1/2));

[eigenvecs, eigenvals] = eig(delta);
[sorted_eigs, idx] = sort(diag(eigenvals));
harmonics = eigenvecs(:, idx);

end %eof