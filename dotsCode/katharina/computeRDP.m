function [allPosPix dircs] = computeRDP(trialDir, trialCoh, stimPosNr, stim, screen, centerPixel)

trialDir = deg2rad(trialDir);

% Compute motion direction for coherent motion
dxdy = zeros(stim.numDots,2); 
dxdy_dirc 	= repmat(stim.speed * (1/screen.hz) * [cos(trialDir) sin(trialDir)], stim.numDots, 1);

% Compute motion direction for NON coherent motion (random directions)
randDirc = randi(360,stim.numDots,1); 
randDirc = deg2rad(randDirc);
dxdy_rand 	= (stim.speed * (1/screen.hz) * [cos(randDirc) sin(randDirc)]);

% Calculate which dots will be moving coherently and which will not
L = rand(stim.numDots,1) < trialCoh/100;
dxdy(L,:) = dxdy_dirc(L,:); 
dircs = repmat(trialDir,stim.numDots,1);
if sum(~L) > 0, dxdy(~L,:) = dxdy_rand(~L,:); end
dircs(~L) = randDirc(~L);

%Initial random dot position
% randAnglesRad = pi*2*(rand(stim.numDots,1)); randAmps = sqrt(params.stim.radiusDeg*(rand(stim.numDots,1)));
% [allPos.x,allPos.y] = pol2cart(randAnglesRad,randAmps);
q = rand(stim.numDots,1)*pi*2; 
r = rand(stim.numDots,1)*0.9;
allPos.x = r.*stim.size/2.*cos(q);
allPos.y = r.*stim.size/2.*sin(q);

%Compute motion according to direction, wrap if necessary and randomly
%re-assign postions if limited lifetime for dots
jump = 1; % counts number of 'jumps' if dot lifetime is limited
for i = 2 : stim.numFrames
    allPos.x(:,i) = allPos.x(:,i-1) + dxdy(:,1);
    allPos.y(:,i) = allPos.y(:,i-1) + dxdy(:,2);
    [th(:,i) rad(:,i)] = cart2pol(allPos.x(:,i),allPos.y(:,i));
    wrap = rad(:,i) > stim.size/2; 
    if sum(wrap) > 0
        rotateAngle = -dircs(wrap);
        allPosRTmp = rotateByAngle([allPos.x(wrap,i) allPos.y(wrap,i)], rotateAngle);
        allPosR.x = allPosRTmp(:,1); 
        allPosR.y = allPosRTmp(:,2); 
        allPosR.x = -allPosR.x;
        allPosTmp = rotateByAngle([allPosR.x allPosR.y], -rotateAngle);
        allPos.x(wrap,i) = allPosTmp(:,1); 
        allPos.y(wrap,i) = allPosTmp(:,2); 
    end  
    if stim.lifetime && i == jump*stim.lifetime_frames && i < stim.numFrames
        q = rand(stim.numDots,1)*pi*2;
        r = rand(stim.numDots,1)*0.9;
        allPos.x(:,i) = r.*stim.size/2.*cos(q);
        allPos.y(:,i) = r.*stim.size/2.*sin(q);
        jump = jump + 1;
    end
end
%Transform to pixels from visual degrees
allPosPix.x = round(screen.xpxpdeg .* allPos.x) + stim.pos_px(stimPosNr,1) + centerPixel(1); 
allPosPix.y = round(screen.ypxpdeg .* allPos.y) - stim.pos_px(stimPosNr,2) + centerPixel(2); 	