%clear;
%addpath(genpath('C:\Documents and Settings\sarit\My Documents\NYU_research\PL_esti_disc\mgl'));
% addpath(genpath('/users/purplab/Desktop/Antoine/AB_CPDTaskDemands/toolbox/mgl'));
%addpath(genpath('/Local/Users/purplab/Desktop/mgl'));
%addpath(genpath('/Applications/Psychtoolbox')); %/users/Shared/Psychtoolbox

Screen('CloseAll'); 
motion_params_estiDisc_testing_post1stair; global params;  
%addpath('/Applications/Psychtoolbox');
homedir = pwd;   
%initials = 'lf'; sesNum = '1d';       
initials = input('Please enter subject initials (2 characters): \n', 's'); %NOT LONGER THAN 2 CHARACTERS  
sesNum = input('Please enter number of session:\n', 's'); % 0 for pretest and posttest, other number for training sessions
c = clock; 
direc = sprintf('%s/results/%s/%s/ses%s', homedir,params.saveVars.expTypeDirName,initials,sesNum); 
saveExpFile = sprintf('%s_%s_ses%s_%02d_%02d_%4d_time_%02d_%02d_%02i.mat', params.saveVars.fileName, initials, sesNum, c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
saveExpFile = sprintf('%s/%s',direc,saveExpFile);
mkdir(direc); 

wPtr = Screen('OpenWindow',  params.screenVar.num, params.screenVar.bkColor, params.screenVar.rectPix);

%Load  new gamma table to fit the current scre 
startclut =0;       
% startclut = Screen('ReadNormalizedGammaTable', params.screenVar.num); 
% load( params.screenVar.calib_filename); 
% new_gamma_table = repmat(calib.table, 1, 3);
% Screen('LoadNormalizedGammaTable',wPtr,new_gamma_table,[]); 

Priority(MaxPriority(wPtr));   
%instructions(wPtr); 
if params.eye.record, el = prepEyelink(wPtr); end;

respEsti = struct('rt', {[]}, 'respAngles', {[]},'block',{[]});
respDisc = struct('rt', {[]}, 'key', {[]}, 'correct', {[]},'block',{[]});
expData  = struct('angles',{[]},'trialsType',{[]}, 'stairOrder',{[]},'dotCoh',{[]},'block',{[]},'stairs',{[]});

%%%% --------------      Start experiment  --------------%%%%%
%HideCursor;
trialNum = 0;
for b = 1:params.blockVars.numBlocks
    expData = calcTrialsVars(expData,b);
    respEsti.block = [respEsti.block b*ones(1,params.trialVars.numTrialsPerBlock,1)];
    respDisc.block = [respDisc.block b*ones(1, params.trialVars.numTrialsPerBlock,1)];
    blockBreak(wPtr, b)
    
    if params.eye.record, cal = EyelinkDoTrackerSetup(el); end;
    
    for t = 1: params.trialVars.numTrialsPerBlock
        trialNum = trialNum +1;
        
        edfFile = sprintf('%st%d.edf',initials,trialNum); el = NaN;
        if params.eye.record
            edfFileStatus = Eyelink('Openfile', edfFile);
            if edfFileStatus ~= 0, fprintf('Cannot open .edf file. Exiting ...'); return; end       
         end
         if isnan(expData.dotCoh(trialNum))
            expData.dotCoh(trialNum) = expData.stairs{b,expData.stairOrder(trialNum)}.threshold;
         end
         [respDiscTrial, respEstiTrial, dircs, allPosPix] = trial(wPtr, expData.angles(trialNum),startclut,direc,edfFile, sesNum, trialNum, el, expData.trialsType(trialNum),expData.dotCoh(trialNum));
         respDisc.rt  = [respDisc.rt respDiscTrial.rt];
         respDisc.key = [respDisc.key respDiscTrial.key];
         respDisc.correct = [respDisc.correct respDiscTrial.correct];
         respEsti.respAngles = [respEsti.respAngles respEstiTrial.respAngle];
         respEsti.rt = [respEsti.rt respEstiTrial.rt];
         if params.stair.runStair
             expData.stairs{b,expData.stairOrder(trialNum)} = upDownStaircase(expData.stairs{b,expData.stairOrder(trialNum)}, respDiscTrial.correct);
         end

        save(saveExpFile)
        Screen('Close');
    end
end          

Screen('Close'); Priority(0);
%expEndDisp(wPtr);   
%Screen('LoadNormalizedGammaTable', wPtr, startclut, []);
Screen('CloseAll'); ShowCursor;
%%%%%-------------     End the experiment    ----------%%%%%

%%%%%------------- Save al  l experiment data ----------%%%%%
cd(direc);
date = sprintf('Date:%02d/%02d/%4d  Time:%02d:%02d:%02i ', c(2),c(3),c(1),c(4),c(5),ceil(c(6)));
save(saveExpFile);
cd(homedir);
%%