function expData = calcTrialsVars(expData,blockNum)
global params;  
numTrials = params.trialVars.numTrialsPerBlock;


%%%%%%%----- trial type discrimination/esitimation -----%%%%%%%%%%
k = round(numTrials*params.responseVar.percentEstimation); 
l = numTrials-k;
esti = ones(k,1); %estimation type is one
disc = zeros(l,1); % discrimination is zero
trialsType = [esti; disc];
trialsType = trialsType(randperm(numTrials));

%%%%%%%----- Angels -----%%%%%%%%%%
% Computing gabor angels for all stimuli for all trials, so angels are
% distributed randomly
anglesPossiblities = params.stim.possibleAngels(1,:)'; % creats a matrix of all combinations of angles

%%%%%%%----- mix trials - counterbalancing -----%%%%%%%%%%
if params.stair.runStair==0
    numStaircases = 1;
else
    numStaircases = params.stair.numStaircases;
end
    
stairPossiblities  = 1: numStaircases'; 
len = length(params.stim.possibleAngels); 
idx = [1 len; 
      len+1, len*2;
      len*2+1, len*3]; 
for i =1:numStaircases
    factors(idx(i,1):idx(i,2),:) = [repmat(stairPossiblities(i),length(anglesPossiblities),1)  anglesPossiblities];
end
minPerCond = length(factors);
if [round(numTrials/minPerCond)-(numTrials/minPerCond)~=0]
    error('Number of trials must be able to be divided by number of all possible angles in a trial (to allow conterbalancing across trials).');
end
trialSeq = repmat(factors,numTrials/minPerCond,1);
mixedOrd = randperm(numTrials);
trialSeq = trialSeq(mixedOrd,:);
%%%% asigments
stairOrder = trialSeq(:,1);
angles   = trialSeq(:,2);

%%%%%%%----- dot coherence \\staircases  -----%%%%%%%%%%
if params.stair.runStair
    dotCoh = NaN(numTrials,1);
    [stair dotCoh] = createStairs(stairOrder,dotCoh);
else
    dotCoh = params.stair.nonStairCoh*ones(numTrials,1);
    stair = NaN;
end

%%%%%%%----- output  -----%%%%%%%%%%

expData.angles      = [expData.angles angles'];
expData.trialsType  = [expData.trialsType trialsType'];
expData.stairOrder  = [expData.stairOrder stairOrder'];
expData.dotCoh      = [expData.dotCoh dotCoh'];
expData.stairs      = [expData.stairs; stair];
expData.block       = [expData.block blockNum*ones(1,params.trialVars.numTrialsPerBlock)];








