%%RecordResults

if(timeStep == 1)
    recordCenter(1:finalTimeStep,1:numBots,1:2) = 0;
    recordPhase(1:finalTimeStep,1:numBots) = 0;
end

for ii = 1:numBots
    recordCenter(timeStep,ii,1) = center(ii,1);
    recordCenter(timeStep,ii,2) = center(ii,2);
    recordPhase(timeStep,ii) = phase(ii);
end