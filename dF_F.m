% 1st section to unswap sig/ref flips

% "V" Cross situation 
% First subsection to account specifically for when sig goes to ref, then
% labeled labeled as ref going forward. Ref becomes labeled sig and
% continue. Importantly, when sig goes to ref, the original pt where sig
% should've gone is gone, result is the region where it crosses looks like
% a V. 

prompt = 'What type of crossing do you have, x or v or A?';
signal_swapping_choice = input(prompt);

if signal_swapping_choice == 'v'
    
    prompt = 'Where is the crossing pt, bottom of V: ';
    crossing_pt = input(prompt); 

    sig_1st_half = sig(1:crossing_pt - 1);
    sig_1st_half(crossing_pt) = (sig(crossing_pt - 1) + ref(crossing_pt + 1))/2; 

    sig_2nd_half = ref(crossing_pt + 1 : size(sig));

    ref_1st_half = ref(1:crossing_pt);
    ref_2nd_half = sig(crossing_pt + 1 : size(ref));

    sig= vertcat(sig_1st_half, sig_2nd_half);
    ref = vertcat(ref_1st_half, ref_2nd_half);  
    
end

if signal_swapping_choice == 'x'
    
    prompt = 'Where is the crossing pt, middle of x, use decimal: ';
    crossing_pt = input(prompt); 
    
    sig_1st_half = sig(1:crossing_pt-0.5);
    sig_2nd_half = ref(crossing_pt+0.5 : size(sig));
    
    ref_1st_half = ref(1:crossing_pt-0.5);
    ref_2nd_half = sig(crossing_pt + 0.5 : size(ref));
    
    sig = vertcat(sig_1st_half, sig_2nd_half);
    ref = vertcat(ref_1st_half, ref_2nd_half); 
    
end

if signal_swapping_choice == 'A'

    prompt = 'Where is the crossing pt, top of the A:  ';
    crossing_pt = input(prompt);

    sig_1st_half = sig(1:crossing_pt);
    sig_2nd_half = ref(crossing_pt + 1:size(sig))

    ref_1st_half = ref(1:crossing_pt-1);
    ref(crossing_pt) = (ref(crossing_pt -1) + ref(crossing_pt + 1))/2;
    ref_2nd_half = sig(crossing_pt + 1:size(ref));

end


%% 


% This section is now dedicated towards calculating dF_F. mean baseline
% fluorescence is defined by minutes 2-3 (although can different)

sig_motion_corrected = sig - ref;
%plot(sig_motion_corrected);

mean_baseline = mean(sig_motion_corrected(600:1800));

dfF = (sig_motion_corrected - mean_baseline)/abs(mean_baseline) ; 


length_minutes = length(sig)/600;
x_label = 0:minutes(1/600):minutes(length_minutes);
x_label = x_label(1:length(x_label) - 1).';

plot(x_label , dfF);

title('21130 Exp day : Crus1 FIP 12h Fast - Total Trace');
xlabel = 'Time (deciseconds)';
ylabel = 'dF/F, baseline defined as avg of minutes 2-3';
xlim(minutes([0 22]));
ylim([-1 2]);



%% 
Times_To_Analyze=[ % Enter in format as above, in seconds [200 240
                   %                           300 340
                   %                           400 480
                   %        
                   %        * So 300 400 would indicate analysis of frames
                   %        b/w 300 - 400 
                   %                                  ]
             

                 465 496
                 512 520
                 %594 675
                 756 924
                 1054 1160

                  ];


feeding_bout_number = size(Times_To_Analyze,1);

Times_To_Analyze = Times_To_Analyze * 10;

Feeding_Bout_dF_F_Matrix = zeros(feeding_bout_number, 231);

hold;

for i = 1:feeding_bout_number

    Time_Start = Times_To_Analyze (i, 1);
    Feeding_Bout_dF_F_Matrix(i, :) = dfF(Time_Start - 80 : Time_Start + 150);
    
    %plot(dfF((Times_To_Analyze(i,1)-50):Times_To_Analyze(i,2)));
    % Note, the value x in line 21 indicates how many seconds (x/10) before and
    % after feeding bout that you would like to analyze 

end

title('21130L, Exp: Crus1 FIP 12hFasted - Mean Feeding Bout w Food intake at 80')
plot(mean(Feeding_Bout_dF_F_Matrix));

%% This section is to examine correlation b/w feeding bout duration and average AUC

Times_To_Analyze_corr=[ % Enter in format as above, in seconds [200 240
                   %                           300 340
                   %                           400 480
                   %        
                   %        * So 300 400 would indicate analysis of frames
                   %        b/w 300 - 400 
                   %                                  ]
             
              
                  
                 465 496
                 512 520
                 %594 675
                 756 924
                 1054 1160
                  

                  ];

Times_To_Analyze_corr = Times_To_Analyze_corr * 10;

feedingbout_number = length(Times_To_Analyze_corr);

feedingbout_AUC = zeros(feedingbout_number, 1);
feedingbout_duration = zeros(feedingbout_number, 1);
avg_FeedingBout_AUC = zeros(feedingbout_number, 1);

for i = 1: feedingbout_number

    feedingbout_AUC(i,1) = trapz(dfF(Times_To_Analyze_corr(i,1):Times_To_Analyze_corr(i,2)));
    feedingbout_duration(i,1) = Times_To_Analyze_corr(i,2) - Times_To_Analyze_corr(i,1);
    avg_FeedingBout_AUC(i,1) = feedingbout_AUC(i,1)/feedingbout_duration(i,1);

end

scatter(feedingbout_duration, avg_FeedingBout_AUC, 'filled');
hold

%% Linear regression for fitting bout duration and AUC

x = feedingbout_duration;
y = avg_FeedingBout_AUC ;

X = [ones(length(x), 1) x];
b = X\y;

Y_calc = X*b; 

plot(x,Y_calc,'Linestyle', '--')

title('21230 Exp: Feeding bout correlation w AUC/duration. Slope = -0,0001?');
xlabel = 'Feeding bout duration in seconds';
ylabel = 'FIP AUC';
