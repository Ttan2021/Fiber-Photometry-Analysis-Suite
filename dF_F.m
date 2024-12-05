% 1st section to unswap sig/ref flips

% "V" Cross situation 
% First subsection to account specifically for when sig goes to ref, then
% labeled labeled as ref going forward. Ref becomes labeled sig and
% continue. Importantly, when sig goes to ref, the original pt where sig
% should've gone is gone, result is the region where it crosses looks like
% a V. 

prompt = 'What type of crossing do you have, x or v?';
signal_swapping_choice = input(prompt);

if signal_swapping_choice == 'v'
    
    prompt = 'Where is the crossing pt, bottom of V: ';
    crossing_pt = input(prompt); 

    sig_1st_half = sig(1:crossing_pt - 1);
    sig_1st_half(crossing_pt) = (sig(crossing_pt - 1) + ref(crossing_pt + 1))/2; 

    sig_2nd_half = ref(crossing_pt + 1 : size(sig));

    ref_1st_half = ref(1:crossing_pt);
    ref_2nd_half = sig(crossing_pt + 1 : size(ref));

    sig_working = vertcat(sig_1st_half, sig_2nd_half);
    ref_working = vertcat(ref_1st_half, ref_2nd_half);  
    
end

if signal_swapping_choice == 'x'
    
    prompt = 'Where is the crossing pt, middle of x, use decimal: ';
    crossing_pt = input(prompt); 
    
    sig_1st_half = sig(1:crossing_pt - 0.5);
    sig_2nd_half = ref(crossing_pt + 0.5 : size(sig));
    
    ref_1st_half = ref(1:crossing_pt - 0.5);
    ref_2nd_half = sig(crossing_pt + 0.5 : size(ref));
    
    sig_working = vertcat(sig_1st_half, sig_2nd_half);
    ref_working = vertcat(ref_1st_half, ref_2nd_half); 
    
end


% This section is now dedicated towards calculating dF_F. mean baseline
% fluorescence is defined by minutes 2-3 (although can different)

sig_motion_corrected = sig_working - ref_working;
%plot(sig_motion_corrected);

mean_baseline = mean(sig_motion_corrected(600:1800));

dfF = (sig_motion_corrected - mean_baseline)/abs(mean_baseline) ; 


length_minutes = length(sig)/600;
x_label = 0:seconds(0.1):minutes(length_minutes);
x_label = x_label(1:length(x_label) - 1).';

plot(x_label , dfF);

title('Sim1-Cre GCAMP6f PVH Crus1 Gi/12hr fast/CNO at 3min');
xlabel = 'Time (mins)';
ylabel = 'dF/F, baseline defined as avg of minutes 2-3';
xlim([0 30]);
ylim([-0.5 1]);




