%%SaveSimulationData

%save('SimData.mat');
save(strcat('SimData_K', num2str(KVariable), '_J', num2str(JVariable), '_R', num2str(botRad),'_Sigma', num2str(threshDist), '_NumBots', num2str(numBots), '_Trial', num2str(trial), '.mat'));