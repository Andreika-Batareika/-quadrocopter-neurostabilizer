mdl = 'NetworkOrgignalparametrs3Copter';
open_system(mdl)
Tf = 3;
Ts = 0.01;
Te = 0.012;
Tm = 0.025;
maxEpisodes = 2000;
rng(0)
numObs = 6;
obsInfo = rlNumericSpec([numObs 1]);
obsInfo.Name = 'observations';

numAct = 4;
actInfo = rlNumericSpec([numAct 1],'LowerLimit',-1,'UpperLimit',1);
actInfo.Name = 'torque';

blk = [mdl,'/Контроллер/RL Agent'];
env = rlSimulinkEnv(mdl,blk,obsInfo,actInfo);
env.ResetFcn = @(in) ResetFcn1(in);

AgentSelection = 'DDPG';
switch AgentSelection
    case 'DDPG'
        agent = tcreateDDPGAgent(numObs,obsInfo,numAct,actInfo,Ts);
    case 'TD3'
        agent = createTD3Agent(numObs,obsInfo,numAct,actInfo,Ts);
    otherwise
        disp('Enter DDPG or TD3 for AgentSelection')
end

maxSteps = floor(Tf/Ts);
maxEpisodes = 3000;
maxSteps = floor(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxEpisodes,...
    'MaxStepsPerEpisode',maxSteps,...
    'ScoreAveragingWindowLength',250,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','EpisodeCount',...
    'StopTrainingValue',maxEpisodes,...
    'SaveAgentCriteria','EpisodeCount',...
    'SaveAgentValue',maxEpisodes);

%trainOpts.UseParallel = true;
%trainOpts.ParallelizationOptions.Mode = 'async';
%trainOpts.ParallelizationOptions.StepsUntilDataIsSent = 32;
%trainOpts.ParallelizationOptions.DataToSendFromWorkers = 'Experiences';

 %trainingStats = train(agent,env,trainOpts);