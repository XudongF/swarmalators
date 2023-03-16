%%Main


tic
clear all;
close all;

for KVariable = -1:0.1:2
    for JVariable = -1:0.1:1
        for trial = 1:10
            clearvars -except KVariable JVariable trial botRad threshDist
            botRad = 1;
            InitializationVariables;

            InitialConfigurationRandom;

            finalTimeStep = 1000;
            timeStep = 0;

            while(timeStep < finalTimeStep)
                timeStep = timeStep + 1;
                if(timeStep > 1)
                    TotalMovementAndPhaseCalculation;
                end
                
                RecordResults;
            end

            SaveSimulationData;
        end
    end
end
toc

