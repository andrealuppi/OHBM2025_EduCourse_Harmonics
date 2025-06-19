function[harmonic_energy] = fcn_harmonic_energy(myMaps, harmonics, frequencies)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INPUTS:
% myMaps: vector of size N-by-1, or matrix of size N-by-T
% harmonics: matrix of size N-by-K with each COLUMN representing one eigenmode
% frequencies: vector of the K eigenvalues associated with each harmonic
% Note: K is equal to N

%% OUTPUTS: 
% harmonic_energy: K-by-T weighted contribution of each harmonic to each map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(myMaps,1) ~= numel(frequencies)
    myMaps = myMaps'; %try transposing
end
assert(size(myMaps,1) == numel(frequencies)) %if it still did not work, stop


for t = 1:size(myMaps,2)
    for k = 1:size(harmonics, 2);
        
        %Alpha is the projection of the temporal activation onto a given harmonic k
        harmonic_alpha(k,t) =  dot(myMaps(:,t), harmonics(:, k));
        harmonic_power(k,t) = abs(harmonic_alpha(k,t));  %Following Atasoy 2017 SciRep
        harmonic_energy(k,t) = harmonic_power(k,t)^2 * frequencies(k,1)^2;
    end
end
    
