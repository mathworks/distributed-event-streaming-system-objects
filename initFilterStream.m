function state = initFilterStream(config)
% initFilterStream Setup low pass filter for processing noisy sine wave
% signal. This function is called exactly once, at the beginning of stream
% processing.

    % Create a DSP LowPassFilter, which is a MATLAB system object.
    state.FIRLowPass = dsp.LowpassFilter('PassbandFrequency',5000,...
        'StopbandFrequency',8000);
end