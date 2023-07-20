# Example: Streaming Apache Kafka &reg; data through a MATLAB &reg; System Object

The DSP System Toolbox &trade; demonstrates its LowPassFilter object (which is a kind of 
MATLAB system object) with this example:
<https://www.mathworks.com/help/dsp/ug/filter-frames-of-a-noisy-sine-wave-signal-in-matlab.html>

The code in this repository demonstrates how to connect that DSP system object
to signals streaming in Kafka. 

The example demonstrates how to develop a stream-based signal processing algorithm in MATLAB
and then deploy that algorithm to MATLAB Production Server &trade;.

The techniques demonstrated in this example are not specific to the DSP System Toolbox. In principal
they can be applied to any of MATLAB's system objects, assuming that object is compatible with
the streaming data in question.

Note: If you are viewing this as a text file, I recommend dragging it into a web browser
which will format it for better readability.

# Motivation
Why connect system objects to Kafka streams? Because, to quote the MATLAB documenation: "System 
objects are optimized for iterative computations that process large streams of data in segments." 
And: 
- Kafka is a common source of large streams of data.
- The Streaming Data Framework for MATLAB Production Server &trade; delivers Kafka data to MATLAB 
applications in segments.

In short, because the data delivered by the streaming data framework matches the system
object's expectations exactly. And the system objects solve a problem faced by many signal
processing solutions that use only the streaming data framework: system objects maintain state
that helps smooth or eliminate artificial transients that can arise at the seams of a segmented 
signal. 

For more on System Objects:
<https://www.mathworks.com/help/matlab/matlab_prog/what-are-system-objects.html>

# Overview
The example applies a DSP LowPassFilter to a noisy sine wave streaming through the Kafka 
topic "NoisySineWave." The sine wave consists of 4,000,000 samples. The example code reads
the signal as 1,000 segments of 4,000 samples each. 

The example demonstrates how to:

1. Create a stream object connected to the noisy sine wave Kafka topic.
2. Read data from the Kafka topic and pass it to the DSP LowPassFilter.
3. Display the filtered signal using a spectrum analyzer.
4. Capture the output of the low pass filter and write it to a second Kafka topic, 
"LowPassSineWave".
5. Wrap the DSP LowPassFilter in a deployable stream processing function.
6. Test the deployable function by simulating the production environment in MATLAB.
7. Package the stream processing function for deployment to MATLAB Production Server.

# Requirements

In order to run all the files in this example, you'll need:

- MATLAB 22b or later
- DSP System Toolbox
- Streaming Data Framework for MATLAB Production Server
- MATLAB Compiler &trade; and MATLAB Compiler SDK &trade;
- MATLAB Production Server

**filterNoise** requires only MATLAB, DSP System Toolbox and the Streaming Data Framework, 
demonstrating how to read Kafka streams into MATLAB timetables.

Download the streaming data framework from MATLAB File Exchange:
<https://www.mathworks.com/matlabcentral/fileexchange/118415-streaming-data-framework-for-matlab-production-server>

# Manifest (Alphabetical)
This repository should contain at least the following files:

- **deployFilterStream.m**: Package example for deployment to MATLAB Production Server.
- **filterNoise.m**: Pass Kafka-hosted signal data through a DSP LowPassFilter.
- **filterStream.m**: Streaming analytic function that applies DSP LowPassFilter to Kafka topic.
- **initFilterStream.m**: Initialize streaming analytic state; creates low pass filter object.
- **signalToStream.m**: Publish noisy sine wave signal to Kafka topic.
- **streamSystemObject.m**: Live script that walks through entire workflow.
- **testFilterStream.m**: Test streaming analytic function on Kafka stream.

And this file, **README.md**.

# Running the Example

The workflow consists of three phases:

1. Develop and test algorithm.
2. Embed algorithm in streaming analytic function and test.
3. Package algorithm for deployment to MATLAB Production Server.

The steps of each phase are captured in MATLAB scripts. Explore the scripts 
in this order:

1. **filterNoise**: Reads signal from Kafka, applies low pass filter, visualizes results with spectrum analyzer.
2. **testFilterStream**: Applies streaming analytic function to Kafka-hosted signal, writes filtered signal to output stream.
3. **deployFilterStream**: Creates productionServerCompiler project 

The script **streamSystemObject** calls the scripts in that order.

## Publish Noisy Sine Wave to Kafka

The example assumes that the input signal has been published to a Kafka topic
named "NoisySineWave" on the MathWorks internal server mpskafka2936glnxa64.mathworks.com:9092.
 
The file **signalToStream** can be adapted to publish the input stream to your
Kafka cluster.

