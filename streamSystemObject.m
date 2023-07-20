%% Populate a Kafka topic, NoisySineWave with a noisy sine wave.
% This has already been done. Don't repeat it unless the topic gets lost or
% corrupted. This takes some time to run.
% signalToStream

%% Pass the noisy sine wave through DSP LowPassFilter 
filterNoise

%% Wrap the DSP low pass filter in a streaming analytic function and test it.
testFilterStream

%% Create a productionServerCompiler project to deploy the streaming analytic.
deployFilterStream