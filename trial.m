function   [respDisc, respEsti, dircs, allPosPix] = trial(wPtr,trialAngel ,startclut, direc,edfFile,sesNum, trialNum ,el, trialType,dotCoh)
global params;

fixation(wPtr); WaitSecs(params.fixationVar.dur);
Screen('Flip', wPtr); keyIsDown = 0;
% while (~keyIsDown)
%     [del1,del2,keyCode] = KbCheck;
%     if keyCode(kbname('Space')),  break; else keyIsDown =0;  end  
%     if keyCode(kbname('Escape')), 
%         Screen('LoadNormalizedGammaTable', wPtr, startclut, []);
%         Screen('CloseAll'); ShowCursor; error('Experiment stopped by user!'); else keyIsDown =0;  
%     end   
% end

if params.eye.record,
    Eyelink('StartRecording');
    Eyelink('Message', sprintf('StartTrial_Ses_%s_Trial_%d_direction_%d', sesNum,trialNum,trialAngel));
end 
[allPosPix dircs ]= computeMotion_inSquare_BM(trialAngel,dotCoh);
if params.eye.fixCheck, fixationCheck(sesNum,trialNum,trialAngel,el);end

fixation(wPtr);Screen('Flip', wPtr); 
if params.eye.record, Eyelink('Message', 'Fixation1_on'); end;
WaitSecs(params.ISIVar.preDur);
if params.eye.record, Eyelink('Message', 'Fixation1_off'); end;
 
if params.eye.record, Eyelink('Message', 'MotionStimulus_on'); end
moveDots_inSquare_boundary(startclut,allPosPix, wPtr, trialAngel);
if params.eye.record, Eyelink('Message', 'MotionStimulus_off'); end

if params.fixationVar.present2ndFix, 
    if params.eye.record, Eyelink('Message', 'Fixation2_on'); end
    fixation(wPtr); Screen('Flip', wPtr); 
    WaitSecs(params.ISIVar.postDur); 
    if params.eye.record, Eyelink('Message', 'Fixation2_off'); end 
end

beep2(1000,params.fbVars.dur)
Screen('Flip', wPtr); 
if params.eye.record,
    Eyelink('StopRecording'); Eyelink('CloseFile'); 
end

respEsti = struct('rt', {[]}, 'respAngle', {[]});
respDisc = struct('rt', {[]}, 'key', {[]}, 'correct', {[]});

if trialType == 1,
    if params.mouse.present, 
        respEsti = drawMouseAngle(wPtr, trialAngel);
    else
        respEsti.rt = NaN; respEsti.respAngles = NaN;
    end
elseif trialType == 0,
    fixation(wPtr, trialType); Screen('Flip', wPtr); 
    respDisc = response();
    correctTrial = checkResp(respDisc, trialAngel);
    audFB(correctTrial);
    audFB(1);
    respDisc.correct = correctTrial;
end

if params.eye.record,
    Eyelink('ReceiveFile', edfFile, sprintf('%s/%s',direc,edfFile)); 
end









