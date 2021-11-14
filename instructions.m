function instructions(wPtr)
global params;

instruct = 'Indicate whether the motion direction was upwards or downwards from horizontal ';
% keys = 'Track the overall direction of the stimulus with your eyes as best as possible.';
% start ='Do not track one individual dot - rather try to track the global motion';
%start = 'Press space to start!';

Screen('TextSize', wPtr, params.textVars.size);
Screen('TextColor', wPtr, params.textVars.color);
Screen('TextBackgroundColor',wPtr, params.textVars.bkColor );

Screen('DrawText', wPtr, instruct, params.screenVar.centerPix(1)-450, params.screenVar.centerPix(2)-150);
% Screen('DrawText', wPtr, keys, params.screenVar.centerPix(1)-350, params.screenVar.centerPix(2));
% Screen('DrawText', wPtr, start, params.screenVar.centerPix(1)-350, params.screenVar.centerPix(2)+150);

Screen('Flip', wPtr);

keyIsDown = 0;
while (~keyIsDown)
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(kbname('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end
   
end