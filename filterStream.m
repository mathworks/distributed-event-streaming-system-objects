function [result,state] = filterStream(signal,state)
% filterStream Pass the input signal through a low pass filter. Capture the
% resulting filtered signal in a timetable with the same timestamps as the
% input signal.

    % Retrieve the DSP LowPassFilter object from inter-frame persistent
    % state.
    FIRLowPass = state.FIRLowPass;

    % Apply the low pass filter to the signal
    y = FIRLowPass(signal.x);

    % Create a timetable from the filtered signal and the input signal
    % timestamps.
    ts = signal.Properties.RowTimes;
    result = timetable(ts,y);

    % Preserve the low pass filter in inter-frame persistent state. This
    % ensures the state is loaded by whichever MPS worker processes the
    % next frame of the signal.
    state.FIRLowPass = FIRLowPass;
end