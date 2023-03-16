%%TotalMovementAndPhaseUpdateCalculation



for ii = 1:numBots
    dPosX(ii) = 0;
    dPosY(ii) = 0;
    dPhase(ii) = 0;
    revolveX(ii) = 0;
    revolveY(ii) = 0;
    for jj = 1:numBots
        if(ii ~= jj)
            distBetweenBots = sqrt(((center(jj,1)-center(ii,1))^2)+((center(jj,2)-center(ii,2))^2));
            dPhase(ii) = dPhase(ii) + K*sin(phase(jj)-phase(ii) - pi/4*abs((natFreq(ii)/(abs(natFreq(ii))))-(natFreq(jj)/(abs(natFreq(jj))))))/distBetweenBots;
            dPosX(ii) = dPosX(ii) + (center(jj,1)-center(ii,1))/(distBetweenBots)*(A + J*(cos(phase(jj)-phase(ii) - pi/2*abs((natFreq(ii)/(abs(natFreq(ii))))-(natFreq(jj)/(abs(natFreq(jj)))))))) - B*(center(jj,1)-center(ii,1))/(distBetweenBots^2);
            dPosY(ii) = dPosY(ii) + (center(jj,2)-center(ii,2))/(distBetweenBots)*(A + J*(cos(phase(jj)-phase(ii) - pi/2*abs((natFreq(ii)/(abs(natFreq(ii))))-(natFreq(jj)/(abs(natFreq(jj)))))))) - B*(center(jj,2)-center(ii,2))/(distBetweenBots^2);
            
        end
    end
    if(natFreq(ii) > 0)
        revolveX(ii) = c*cos(phase(ii) + pi/2);
        revolveY(ii) = c*sin(phase(ii) + pi/2);
    else
        revolveX(ii) = c*cos(phase(ii) - pi/2);
        revolveY(ii) = c*sin(phase(ii) - pi/2);
    end
end

for ii = 1:numBots
    center(ii,1) = center(ii,1) + revolveX(ii)*dt + dPosX(ii)/numBots*dt;
    center(ii,2) = center(ii,2) + revolveY(ii)*dt + dPosY(ii)/numBots*dt;
    phase(ii) = phase(ii) + (natFreq(ii)+(dPhase(ii)/numBots))*dt;
    phase(ii) = mod(phase(ii),2*pi);
end

