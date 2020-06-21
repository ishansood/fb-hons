
function relevance = shortFB(experiment, summaryTable, fixlvl)  

 %  Author: Kat 
    %  Date Created: 
    %  Last Edit: 
     
    %  Cognitive Science Lab, Simon Fraser University 
    %  Originally Created For: feedback
      
    %  Reviewed: Ishan
    %  Verified: 

    
    %  PURPOSE: investigate what people look at when feedback phases get so
    %  short that they contain only 1, 2 or 3 fixations. 
 
    
    %  INPUT: 
    
%         experiment: experiment name

%         summaryTable: binned data table (loaded from directory in master.m)

%         fixlvl: fixation level table for relevant experiment.

    
    %  OUTPUT: 3x1 matrix of fixations counts. relevance(1) = relevant
    %  stimulus features, relevance(2) = irrelevant stimulus features,
    %  relevance(3) = feedback buttons.

    
    %  Additional Scripts Used: []
    
    
    %  Additional Comments: this is the quarantine version aka I had to
    %  load a .mat version of the fixation level table. normally we would
    %  call from SQL directly. likely will change back to this once we can
    %  get back in the lab.
    
 
    % identify trials with fewer than 4 feedback phase fixations. fc4
    % stands for fixation count: phase 4
    % Subjects will be only those with less then 4 feedback phase fixations, such that there
    % is no repetition aka subjects are all unique - IS
    shortTrials = summaryTable(summaryTable.fc4 < 4, :);   
    subjects = unique(shortTrials.Subject);
    
    % fixations will be a list of all the fixations in the experiment
    % occurring during short feedback phases
    fixations = [];
    
    % loop through each subject
    for i = 1:length(subjects)
        
        % this gives us trial ID of all trials with a short enough fb
        % phase for the current subject
        % Iterate through all unique participants and get their trial ID - IS
        trials = shortTrials.Trial(shortTrials.Subject == subjects(i)); 
        
        % this gives us all fixations for the current subject
        subjectFixations = fixlvl(fixlvl.Subject == subjects(i), :);
        
        % this gives us all p4 fixations for the current subject
        subjectp4 = subjectFixations(subjectFixations.TrialPhase == 4, :);
        
        % and this goes through all the short trials and picks fixations
        % from there
        for j = 1:length(trials)
            short = subjectp4.funcRelevance(subjectp4.TrialID == trials(j));
            fixations = [fixations; short];
        end       
    
    end
    % This for loop and the nested for loop just goes and gets the specific attributes 
    % from the unique subjects and place them in a variable for further use - IS
    
    
    % funcRelevance definitions:
        % 1, 2: relevant features
        % 3: irrelevant feature 
        % > 3: feedback button 
        % 0: something else aka useless
        
    relevant = sum(fixations == 1 | fixations == 2);
    irrelevant = sum(fixations == 3);
    button = sum(fixations > 3);
   
   % These names are all very similar and could be very easily misused, may want to make it more descriptive for readers - IS
    relevance = [relevant, irrelevant, button];
    
    
    % quick plot of our results
    figure()
    bar(relevance, 0.95);
    
    % (commented out the title for the final plots used in my paper)
    
    % title('location of fixations in very short feedback phases')
    ylabel('number of fixations')
    ylim([0 8500])
    xticks([1 2 3])
    xticklabels({'Rel. feature', 'Irrel. feature', 'FB'})
    
    % saving plot where I want it
    fnPlot = strcat('/Users/16132/Documents/lab/KAT/', experiment, '/plots/short.png');
    saveas(gca, char(fnPlot));
    close all

end


