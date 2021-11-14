function audFB(correctTrial)
global params;

if correctTrial
    beep2(params.fbVars.high,params.fbVars.dur)
else
    beep2(params.fbVars.low,params.fbVars.dur)    
end