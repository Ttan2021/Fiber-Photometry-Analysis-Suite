% Peristimulus dF/F plot 
Times_To_Analyze=[ % Enter in format as above, in seconds [200 240
                   %                           300 340
                   %                           400 480
                   %        
                   %        * So 300 400 would indicate analysis of frames
                   %        b/w 300 - 400 
                   %                                  ]
             
                     2700 3000 

                  ];


feeding_bout_number = size(Times_To_Analyze,1);

Feeding_Bout_dF_F_Matrix = zeros(feeding_bout_number, 601);

for i = 1:feeding_bout_number

    Time_Start = Times_To_Analyze(i,1);
    Feeding_Bout_dF_F_Matrix(i, :) = dF_F(Time_Start - 300 : Time_Start + 300);
    % Note, the value x in line 21 indicates how many seconds (x/10) before and
    % after feeding bout that you would like to analyze 

end



mean_feeding_bout_trace = mean(Feeding_Bout_dF_F_Matrix);
%plot(mean(Feeding_Bout_dF_F_Matrix));
hold
%for j = 1:feeding_bout_number

%    plot(Feeding_Bout_dF_F_Matrix(j, :))

%end

plot(Feeding_Bout_dF_F_Matrix);
    