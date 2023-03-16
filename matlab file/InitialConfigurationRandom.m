%%InitialConfigurationRandom

for ii = 1:numBots
    center(ii,1) = -plotXLimit + rand*2*plotXLimit;
    center(ii,2) = -plotYLimit + rand*2*plotYLimit;
%     botCenter(ii,1) = center(ii,1) - botRad*cos(phase(ii));
%     botCenter(ii,2) = center(ii,2) - botRad*sin(phase(ii));
end