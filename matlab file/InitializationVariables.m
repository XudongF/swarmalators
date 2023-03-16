%%InitializationVariables

numBots = 500;
plotXLimit = 1;
plotYLimit = 1;
dt = 0.1;
A = 1;
J = JVariable;
B = 1;
K = KVariable;
threshDist = 100;
c = 1;



center(1:numBots,1:2) = 0;
currentBotRad(1:numBots) = 0;
if(botRad ~= 0)
    maxFreq = c/botRad;
    minFreq = -maxFreq;
else
    maxFreq = 0;
    minFreq = 0;
end

%natFreq(1:numBots) = linspace(minFreq,maxFreq,numBots);
for ii = 1:numBots
    phase(ii) = rand*2*pi;
    
    %%Min,zero,max
%         randNum = rand*3;
%         if(randNum < 1)
%             natFreq(ii) = minFreq;
%         elseif(randNum >= 1 && randNum < 2)
%             natFreq(ii) = 0;
%         else
%             natFreq(ii) = maxFreq;
%         end
    
    %%Min, Max
%     if(ii <= numBots/2)
%         natFreq(ii) = minFreq;
%     else
%         natFreq(ii) = maxFreq;
%     end


    %%Min-Max
    if(ii <= numBots/2)
        natFreq(ii) = 1 + rand*2;
    else
        natFreq(ii) = -1*(1 + rand*2);
    end

    %%0 - Max
%     natFreq(ii) = c/(rand*botRad);
    
    %%Max
%     natFreq(ii) = maxFreq;

    
end
%0..phase(1:numBots) = linspace(2*pi/numBots,2*pi,numBots);
% natFreq(1:numBots) = linspace(-10/(2*pi),10/(2*pi),numBots);
%currentBotRad(1:numBots) = linspace(botRad,2*botRad,numBots);
