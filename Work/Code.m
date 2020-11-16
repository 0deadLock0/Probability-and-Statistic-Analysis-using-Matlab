%{
    Title- Matlab Assignment
    Submitted for- MTH201, winter semester 2020, IIIT Delhi
    Created by- Abhimanyu Gupta (abhimanyu19226@iiitd.ac.in)
%}
%{
    Other files part of this program::
    Experiment1Data.txt - stores data obtained from first experiment
    Experiment2Data.txt - stores data obtained from second experiment
    10MessagesData.txt - stores times gaps of 10 next messages recieved
    ExperimentResult.txt - stores result of the complete experiments performed
    Histogram.fig - contains the histogram generated in the experiment
%}

% Performing both Experiments one by one
%Experiment 1
[recordPlot1,densityFunction1,expectedTimeGap1,P_x_less_than_Ex1,heads1,tails1] = performExperiment('Experiment1Data.txt');
hold on;
%Experiment 2
[recordPlot2,densityFunction2,expectedTimeGap2,P_x_less_than_Ex2,heads2,tails2] = performExperiment('Experiment2Data.txt');

%Storing all the generated data in a string for printing
output='\r\n';
output=strcat(output,'Expected Time Gaps-\r\n');
output=strcat(output,'For Different Senders: ',num2str(expectedTimeGap1),' minute(s)\r\n');
output=strcat(output,'For Same Sender: ',num2str(expectedTimeGap2),' minute(s)\r\n');
output=strcat(output,'\r\n');
output=strcat(output,'Probability that the time elapsed until next message is less than the expected time gap-\r\n');
output=strcat(output,'For Different Senders: ',num2str(P_x_less_than_Ex1),'\r\n');
output=strcat(output,'For Same Sender: ',num2str(P_x_less_than_Ex2),'\r\n');
output=strcat(output,'\r\n');
output=strcat(output,'Heads and Tails Count-\r\n');
output=strcat(output,'For Different Senders:\r\nHead- ',num2str(heads1),', Tail- ',num2str(tails1),'\r\n');
output=strcat(output,'For Same Sender:\r\nHead- ',num2str(heads2),', Tail- ',num2str(tails2),'\r\n');

%Printing experiments results on Command Window
fprintf(output);
%Printing experiments results in text file for future reference
writeToFile('ExperimentResult.txt',output);

%Formatting the Histogram for better visualisation
recordPlot1.FaceColor=[1 0 0];
recordPlot2.FaceColor=[0 0 1];
title('Time Gaps between messages');
xlabel('Time Gap (in minute(s))');
ylabel('Count');
l=legend(strcat('Different Senders: ',num2str(expectedTimeGap1)),strcat('Same Sender: ',num2str(expectedTimeGap2)));
title(l,'Expected Time Gap');

%Saving the generated Histogram in a file for future reference
savefig('Histogram.fig');

%Inbuilt functions to simplify some task

% Performing an experiment given the file which contains the observations
function [recordPlot,densityFunction,expectedTimeGap,P_x_less_than_Ex,heads,tails] = performExperiment(file)
    [recordPlot,densityFunction]=plotHistogramAndDensityFunction(file); %Ploting histogram and fitting density function 
    expectedTimeGap=densityFunction.mu; %Calculating Expected Time Gap
    P_x_less_than_Ex=cdf(densityFunction,expectedTimeGap); %Calculating Probability that the time elapsed until next message is less than the expected time gap
    messagesData=readData('10MessagesData.txt'); %Reading data for last part of experiment
    [heads,tails]=Head_and_Tail(expectedTimeGap,messagesData); %Noting head and tails count
end

%Function to plot a histogram for data stored in a text file
function [recordPlot,densityFunction] = plotHistogramAndDensityFunction(file)
    record=readData(file);
    recordPlot=histogram(record); %ploting histogram
    densityFunction=fitdist(record,'Normal'); %fiting density function
end

%Function to read data(numbers) from a given text file
function record = readData(file)
    fileID=fopen(file,'r');
    record=fscanf(fileID,'%d');
    fclose(fileID);
end

%Function to note number of heads and tails for given expectation
function [heads,tails] = Head_and_Tail(expectation,data)
    heads=0;
    tails=0;
    [n,m]=size(data);
    for i=1:n
        if data(i)<expectation
            heads=heads+1;
        else
            tails=tails+1;
        end
    end
end

%Function to write data to a given file
function writeToFile(file,data)
    fileID=fopen(file,'wt');
    fprintf(fileID,data);
    fclose(fileID);
end