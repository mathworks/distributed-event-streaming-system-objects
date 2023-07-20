% Apply streaming analytic function filterStream to the Kafka topic
% NoisySineWave. filterStream applies a low pass filter to the signal.
% Write the resulting filtered signal to the Kafka topic LowPassSineWave.

% Set a frame size of 4,000 messages. Each timetable read from Kafka will
% contain this many rows.
frameSize = 4000;

% Kafka cluster network address
host = "mpskafka2936glnxa64.mathworks.com";
port = 9092;

% Input and output streams
inputTopic = "NoisySineWave";
inKS = kafkaStream(host, port, inputTopic, Rows=frameSize);

outputTopic = "LowPassSineWave";
outKS = kafkaStream(host, port, outputTopic, Rows=frameSize);

% Delete the output topic so we start fresh
try deleteTopic(outKS); catch, end

% Use an EventStreamProcessor to apply the streaming analytic to the input
% Kafka topic and write the result to the output Kafka topic.
esp = eventStreamProcessor(inKS,@filterStream,@initFilterStream,...
    OutputStream=outKS);

% Test the streaming analytic by processing 10 frames. This produces 10
% frames in the output topic.
N = 10;
execute(esp,N);

% Set up spectrum analyzer to visualize results.
SpecAna = spectrumAnalyzer('PlotAsTwoSidedSpectrum',false,...
    'SampleRate',44.1e3,...
    'ShowLegend',true, ...
    'YLimits',[-145,45]);

SpecAna.ChannelNames = {'Original noisy signal',...
    'Lowpass filtered signal'};

% Seek back to the beginning of both the input and output streams. Read N
% frames from each stream and use the spectrum analyzer to compare the
% input and output signals.
seek(inKS,"Beginning");
seek(outKS,"Beginning");
t = tic;
for f = 1:N
    % Read input signal (noisy sine wave)
    ttX = readtimetable(inKS);

    % Read output signal (low pass filtered signal)
    ttY = readtimetable(outKS);

    % Compare raw and filtered signals.
    SpecAna(ttX.x, ttY.y)
end
release(SpecAna);
toc(t)


