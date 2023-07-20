% Read a noisy sine wave from a Kafka topic and process it with a DSP
% low pass filter, which is a MATLAB system object. Display the results
% using a DSP spectrum analyzer.

% See DSP example for background and overview:
% https://www.mathworks.com/help/dsp/ug/filter-frames-of-a-noisy-sine-wave-signal-in-matlab.html

% The data was generated as 1,000 frames of 4,000 samples each. Samples
% were written individually to the Kafka topic, which therefore consists of
% 4,000,000 messages.
frameSize = 4000;
frameCount = 1000;
N = frameSize*frameCount;

% Set up spectrum analyzer
SpecAna = spectrumAnalyzer('PlotAsTwoSidedSpectrum',false,...
    'SampleRate',44.1e3,...
    'ShowLegend',true, ...
    'YLimits',[-145,45]);

SpecAna.ChannelNames = {'Original noisy signal',...
    'Lowpass filtered signal'};

% Set up low pass filter
FIRLowPass = dsp.LowpassFilter('PassbandFrequency',5000,...
    'StopbandFrequency',8000);

% Read noisy sine wave from Kafka topic. Setting Rows=frameSize ensures
% that each timetable contains an entire frame.
host = "mpskafka2936glnxa64.mathworks.com"; port = 9092;
topic = "NoisySineWave";
inKS = kafkaStream(host, port, topic, Rows=frameSize);

t = tic;
for f = 1:frameCount
    % Primitive progress meter...
    if mod(f,10) == 0, fprintf(1,"%d%% ", floor(f/10)); end
    if mod(f,100) == 0, fprintf(1,"\n"); end

    % Read one entire frame from the Kafka topic
    tt = readtimetable(inKS);

    % Process the frame wit the low pass filter.
    y = FIRLowPass(tt.x);

    % Display the results with the spectrum analyzer.
    SpecAna(tt.x,y)
end

% Clean up and display elapsed time.
release(SpecAna);
toc(t)

