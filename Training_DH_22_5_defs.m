
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      screen params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screenVar = struct('num', {1}, 'rectPix',{[0 0  1280 1024]}, 'dist', {57}, 'size', {[41 30]},...
                    'res', {[1280 1024 ]}, 'calib_filename', {'~purplab/mgl/task/displays/0003_fechner_100212.mat'}); 
screenVar.centerPix = [screenVar.rectPix(3)/2 screenVar.rectPix(4)/2];
    % In a new screen, run:
     %test = Screen('OpenWindow', screenVar.num, [], [0 0 1 1]); 
     %white = WhiteIndex(test);
     %black = BlackIndex(test);
     %Screen('Resolutions')
     %Screen('CloseAll');
white = 255; black = 0;
gray = (white+black)/2;
screenVar.bkColor = gray; screenVar.black = black; screenVar.white = white;

%Compute deg to pixels ratio:
ratio = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, [1 1]);
ratioX = ratio(1); ratioY = ratio(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      stimuli params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stim = struct('sizeDeg', {[2 2]}, 'cyclesPerImage', {4}, 'phase_offset', {0},...
    'dur', {0.040}, 'possibleAngels', {[356, 4]}, 'num', {2}, 'contrast', {[0.1551]},...
    'XdistDeg',{1.9134}, 'YdistDeg', {4.6194}, 'radiusDeg',{5}, 'bkColor', {screenVar.bkColor});  
%sqslope = sqrt(2*(stim.radiusDeg^2)); hfslp = 0.5*sqslope;
stim.radiusPix = deg2pix1Dim(stim.radiusDeg, ratioX);

stim.XdistPix = deg2pix1Dim(stim.XdistDeg, ratioX) ; 
stim.YdistPix = deg2pix1Dim(stim.YdistDeg, ratioY); 

stim.sizePix = floor(degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, stim.sizeDeg)); %{[100 100]}

rc1 = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, stim.sizeDeg); 
stim.rectPix =[0, 0, rc1]; 

% Define locations of stimuli in pixels
locationR(1) = (screenVar.centerPix(1)+ stim.XdistPix); locationR(2) = (screenVar.centerPix(2) - stim.YdistPix);
locationL(1) = (screenVar.centerPix(1)- stim.XdistPix); locationL(2) = (screenVar.centerPix(2)+ stim.YdistPix);
%locationR(1) = (screenVar.centerPix(1)+ stim.XdistPix); locationR(2) = (screenVar.centerPix(2) + stim.YdistPix);
%locationL(1) = (screenVar.centerPix(1)- stim.XdistPix); locationL(2) = (screenVar.centerPix(2)- stim.YdistPix);

stim.locationsPix = [locationR; locationL]; %define all locations of stimuli in an array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            fixation params 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Draw fixation cross, sizeCross is the cross size,
% and sizeRect is the size of the rect surronding the cross
fixationVar = struct( 'color',{white},'dur', {1}, 'penWidthPix', {5}, 'bkColor', screenVar.bkColor,...
                      'sizeCrossDeg', {[0.4 0.4]}); 

fixationVar.sizeCrossPix = degs2Pixels(screenVar.res, screenVar.size, screenVar.dist, fixationVar.sizeCrossDeg); % {15}
fixationVar.rectPix = [0 0 fixationVar.sizeCrossPix(1) fixationVar.sizeCrossPix(2)];
fixationVar.rectPix = CenterRectOnPoint(fixationVar.rectPix, screenVar.centerPix(1), screenVar.centerPix(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Pre Cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The experiment is set to either be valid (type 1) or neutral (type 0)
preCue = struct('type', {0}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Exogenous precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
precueExg = struct('rectDeg', {[0.3 0.3]}, 'color',{black}, 'bkColor', {screenVar.bkColor}, ...
                   'dur', {0.067}, 'penWidthPix', {5}); 
precueExg.radiusDeg = stim.radiusDeg - 2; 

sp1 = deg2pix1Dim(precueExg.rectDeg(1), ratioX); sp2 = deg2pix1Dim(precueExg.rectDeg(2), ratioY); 
precueExg.rectPix = [0 0 sp1 sp2];
precueExg.locationsPix = [stim.locationsPix(:,1), stim.locationsPix(:,2)];

precueExg.radiusPix = deg2pix1Dim(precueExg.radiusDeg, ratioX); %ignore y ratio resolution TD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Neutral precue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
neutralCue = struct('rectDeg', {[0.5 0.5]}, 'color',{black}, 'bkColor', {screenVar.bkColor}, ...
                   'dur', {0.067}, 'penWidthPix', {5}); 
sp1 = deg2pix1Dim(neutralCue.rectDeg(1), ratioX); sp2 = deg2pix1Dim(neutralCue.rectDeg(2), ratioY); 
neutralCue.locationsPix = screenVar.centerPix;
neutralCue.rectPix= CenterRectOnPoint([0 0 sp1 sp2], neutralCue.locationsPix(1),neutralCue.locationsPix(2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     ISI params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ISIVar = struct('preDur',{0.053}, 'postDur', {0.2}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     box params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
box = struct('sizePixels', {30}, 'color',{white}, 'slopeVpix', {300}, 'slopeHpix',{150},...
             'bkColor', {screenVar.bkColor}, 'dur', {2}, 'penWidthPix', {5}); 
box.locationsPix = stim.locationsPix;
box.rectPix = CenterRectOnPoint([0 0 box.slopeHpix box.slopeVpix], stim.locationsPix(1,1), stim.locationsPix(1,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     post cue params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
postCueVar = struct('color',{black},'bkColor', {screenVar.bkColor}, 'penWidthPix', {4},...
                    'sizeDeg', {1}, 'centerPix', {screenVar.centerPix},'dur', {0.3} ); 
postCueVar.sizePix = deg2pix1Dim(postCueVar.sizeDeg, ratioX); % considers degrees only in x axis


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     response params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KbName('UnifyKeyNames');
responseVar = struct( 'allowedRespKeys', {['1', '2']},'allowedRespKeysCodes',{[0 0]}, 'dur',{2}); 
for i = 1:length(responseVar.allowedRespKeys)
    responseVar.allowedRespKeysCodes(i) = KbName(responseVar.allowedRespKeys(i));
end
% Note that the correctness of the resp will be computed according to the
% index in the array of resp so that allowedRespKeys(i) is the correct
% response of stim.possibleAngels(i)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Feedback params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fbVars = struct('dur', {0.1}, 'high', {1250}, 'low', {200}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Text params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textVars = struct('color', black, 'bkColor', gray, 'size', 24);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Trial params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trialVars = struct('numTrialsInBlock', {100}, 'validity', {1}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Block params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blockVars = struct('numBlocks', 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Save Data params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveVars = struct('fileName', {'Training'}, 'expTypeDirName', {'Training'},'SubjectInitials', {'D'});

%-------------------------------------------------------------------------%
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%                        TOTAL ALL params                                 %
%----------------------%%%%%%%%%%%%%%%%%%%--------------------------------%
%-------------------------------------------------------------------------%
global params;
params = struct('screenVar', screenVar, 'stim', stim, 'fixationVar', fixationVar, 'precueExg', precueExg, ...
        'box', box, 'postCueVar', postCueVar, 'responseVar', responseVar, 'trialVars', trialVars,...
        'blockVars', blockVars, 'fbVars', fbVars, 'ISIVar', ISIVar, 'neutralCue', neutralCue, 'textVars', textVars, ...
         'saveVars', saveVars, 'preCue', preCue); 
cl = 1;
if cl
    clear white gray black locationL locationR screenVar stim fixationVar precueExg box postCueVar responseVar ;
    clear trialVars i blockVars fbVars ratio ratioX ratioY sp1 sp2 rc1 ISIVar sqslope hfslp neutralCue;
    clear saveVars textVars preCue;
end

%Check if number of trials is OK - i.e enables same amount of trials per
%contrast
n = params.trialVars.numTrialsInBlock;
numContrasts = length(params.stim.contrast);
if (round(n/numContrasts)-(n/numContrasts))~=0
      error('Number of trials must be able to be divided by number of  possible contrasts');
end