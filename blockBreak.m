function blockBreak(wPtr, b)
global params;
if b>1
    instruct = sprintf('Block number %d ended. Press space!', b-1);

    Screen('TextSize', wPtr, params.textVars.size);
    Screen('TextColor', wPtr, params.textVars.color);
    Screen('TextBackgroundColor',wPtr, params.textVars.bkColor );

    Screen('DrawText', wPtr, instruct, params.screenVar.centerPix(1)-350, params.screenVar.centerPix(2));
    Screen('Flip', wPtr);

    keyIsDown = 0;
    while (~keyIsDown)
        [keyIsDown,secs,keyCode] = KbCheck;
         if keyCode(kbname('Space')),  keyIsDown = 1; break; else keyIsDown =0;  end   
    end
end