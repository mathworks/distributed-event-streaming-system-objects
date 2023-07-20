% Kafka cluster network address
host = "mpskafka2936glnxa64.mathworks.com";
port = 9092;

% Input and output streams
inputTopic = "NoisySineWave";
inKS = kafkaStream(host, port, inputTopic, Rows=frameSize);

outputTopic = "LowPassSineWave";
outKS = kafkaStream(host, port, outputTopic);

esp = eventStreamProcessor(inKS,@filterStream,@initFilterStream,...
    OutputStream=outKS);

prj = package(esp,StateStore="LocalRedis");