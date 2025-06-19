

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OVERVIEW
% This code accompanies my presentation at the OHBM 2025 Educational Course
% on Brain Eigenmodes
%
% Simple code and example data to explore connectome harmonics aka
% structural eigenmodes (Atasoy et al., 2016 Nat Commun; Atasoy et al 2017
% SciRep).
% First, extract harmonics from a structural connectome and visualise them,
% comparing different atlas scales to appreciate differences in
% granularity.
% Second, use the harmonics to characterise some brain maps in terms of
% relative contribution from different harmonics.


%% REQUIREMENTS
% This code should be self-contained and ready to use with the provided data
% For full functionality (visualisation) please ensure that you have the 
% ENIGMA Toolbox (Lariviere 2020 Nature Methods) on your MATLAB path.
% Link: https://enigma-toolbox.readthedocs.io/en/latest/
% They also have full Python usability if you prefer.
% 
% The connectivity data here are reproduced from there to ensure that this code is 
% self-contained if necessary, but the surface-plotting functionalities 
% will only work with ENIGMA toolbox; otherwise a much simpler plot will be
% made.
%
% Andrea Luppi 2025; Email: andrea.luppi@psych.ox.ac.uk

clear all; close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part 1: Extracting and inspecting structural eigenmodes

% load structural connectome in Schaefer-400 atlas, from ENIGMA Toolbox
SC_S400=csvread('data/strucMatrix_ctx_schaefer_400.csv');

% plot the SC
figure; imagesc(SC_S400) 

% This uses the normalised Laplacian so eigenvalues will be bound 
% between 0 and 2 for a symmetric (positive-definite) matrix;
% however the 0-eigenvalue might not be exactly zero due to numerical issues
[harmonics_SC400, frequencies_SC400] = fcn_extract_connectome_eigenmodes(SC_S400);


% plot on brain (ignoring the first harmonic)
for i = 2:4
    fcn_plot_brain_ENIGMA(harmonics_SC400 ...
        (:,i), 'Schaefer', ['Schaefer-400 SC Eigenmode number ', num2str(i)])
end



% Now repeat with scale 100
SC_S100=csvread('data/strucMatrix_ctx_schaefer_100.csv');

[harmonics_SC100, frequencies_SC100] = fcn_extract_connectome_eigenmodes(SC_S100);


% plot on brain (ignoring the first harmonic) - note the similarity 
% with the scale 400 (ignoring sign, which is arbitrary): 
% both coarse-grained and fine-grained parcellations produce equally
% smooth-looking harmonics
for i = 2:4
    fcn_plot_brain_ENIGMA(harmonics_SC100 ...
        (:,i), 'Schaefer', ['Schaefer-100 SC Eigenmode number ', num2str(i)])
end

% now plot the fine-grained ones for each: parcellations are now easier to
% tell apart because of the different granularity
% and the brain patterns do not match anymore
for i = 1:3
    fcn_plot_brain_ENIGMA(harmonics_SC100 ...
        (:,100-i), 'Schaefer', ['Schaefer-100 SC Eigenmode number ', num2str(100-i)])

        fcn_plot_brain_ENIGMA(harmonics_SC400 ...
        (:,400-i), 'Schaefer', ['Schaefer-400 SC Eigenmode number ', num2str(400-i)])
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part 2: Using structural eigenmodes map characterisation

% Load some maps to decode
smoothMap = csvread('data/smoothMap_Schaefer400.csv');
fcn_plot_brain_ENIGMA(smoothMap, 'Schaefer', ['Smoother map'])

midMap = csvread('data/midMap_Schaefer400.csv');
fcn_plot_brain_ENIGMA(midMap, 'Schaefer', ['Mid-smoothness map'])

fineMap = csvread('data/fineMap_Schaefer400.csv');
fcn_plot_brain_ENIGMA(fineMap, 'Schaefer', ['Finer map'])

% Obtain their energy (normalised contribution) 
% in terms of structural harmonics
[harmonic_energy] = fcn_harmonic_energy([smoothMap, midMap, fineMap], harmonics_SC400, frequencies_SC400)


% Now plot: notice how as the maps get finer-grained, contributions
% from the fine-grained harmonics increase
figure; hold on
subplot(3,1,1)
plot(1:size(harmonic_energy, 1), harmonic_energy(:,1), 'red')
subplot(3,1,2)
plot(1:size(harmonic_energy, 1), harmonic_energy(:,2), 'blue')
ylabel('Harmonic Energy (normalised contribution)')
subplot(3,1,3)
plot(1:size(harmonic_energy, 1), harmonic_energy(:,3), 'black')
xlabel('Harmonic Frequency Number K')



