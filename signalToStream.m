% Populate Kafka topic "NoisySineWave" with data to demonstrate how to 
% stream Kafka data through MATLAB system objects. 
%
% Derived from this DSP example:
% https://www.mathworks.com/help/dsp/ug/filter-frames-of-a-noisy-sine-wave-signal-in-matlab.html

% Generate 1,000 frames from each sine wave, with 4,000 samples per frame.
% Will create a Kafka stream with 4,000,000 samples.
frameSize = 4000;
frameCount = 1000;
N = frameSize*frameCount;

% Sine wave generators from the DSP toolbox.
Sine1 = dsp.SineWave('Frequency',1e3,'SampleRate',44.1e3, ...
    'SamplesPerFrame',frameSize);
Sine2 = dsp.SineWave('Frequency',10e3,'SampleRate',44.1e3, ...
    'SamplesPerFrame',frameSize);

% Write a noisy sine wave to a Kafka topic. Kafka streams require timetable
% data. Set the start time far enough in the past that the stream ends at 
% "now". 
ks = kafkaStream("mpskafka2936glnxa64.mathworks.com", 9092,...
    "BinarySineWave",BodyFormat="Binary",PublishSchema=false, ...
    Order="IngestTime");
startTime = datetime('now') - (milliseconds(N)/10);
frameDuration = (milliseconds(1)/10)*frameSize;

% Measure elapsed time
t = tic;
for f = 1:frameCount
    % Since this takes some time to run, print out progress.
    if mod(f,10) == 0, fprintf(1,"%d%% ", floor(f/10)); end
    if mod(f,100) == 0, fprintf(1,"\n"); end

    % Kafka streams expect timetable data, so create a datetime vector from
    % the start time and the frame size.
    ts = startTime + (milliseconds(1:frameSize)/10)';

    % Create a noisy signal and store it in a timetable.
    x = Sine1()+Sine2()+0.1.*randn(frameSize,1);
    tt = timetable(ts,x);

    % Write the timetable to Kafka
    writetimetable(ks,tt);

    % Move the start time to the beginning of the next frame.
    startTime = startTime + frameDuration;
end
fprintf(1,"\n");
toc(t)



