%% AFX -- Figure 2.1 - Basic delay
%
% References:
% http://www.mathworks.com/help/dsp/ref/dsp.delay-class.html
% http://www.mathworks.com/help/dsp/systemobjectslist.html
%

% Begin with a clean workspace
clear, close all

%% User interface:

% Source audio:
file_name = 'guitar.wav';%'snare.wav';%'A_eng_f1.wav'; % mono
%file_name = 'Mixing Audio (Roey Izhaki)\11-014 Guitar Src.wav'; % stereo
%audio_folder = 'C:\doering\Class\ECE497afx\resources\sounds';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader(file_name);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0; % useful for very short audio clips

%% Convert the user interface values:
%G = 2^(g_dB/6);
delay_ms1 = 29.7;
delay_ms2 = 37.1;
delay_ms3 = 41.1;
delay_ms4 = 43.7;
G = 60;
%% Convert the user interface values:
% delay in samples and linear gain
delay1 = (delay_ms1/1000)*audio_reader.SampleRate;
delay2 = (delay_ms2/1000)*audio_reader.SampleRate;
delay3 = (delay_ms3/1000)*audio_reader.SampleRate;
delay4 = (delay_ms4/1000)*audio_reader.SampleRate;
g = 2^(g_dB/6);
gfb = 2^(0/6);

%% Create the delay line object
audio_delayline1 = dsp.Delay(round(delay1));
audio_delayline2 = dsp.Delay(round(delay2));
audio_delayline3 = dsp.Delay(round(delay3));
audio_delayline4 = dsp.Delay(round(delay4));
%% Read, process, and play the audio
pass_first_time = 1;
bDelays = 0;
while ~isDone(audio_reader)
    % Retrieve the next audio frame from the file
    x = step(audio_reader);
    
    % Generate the output
    %y = sign(x).*(1-exp(-abs(G.*x)));
    
    if pass_first_time
        pass_first_time = 0;
        delayline_out = step(audio_delayline, x);
    else
        delayline_out = gfb*step(audio_delayline, x);
    end
    % Listen to the results
    step(audio_player, y);

end

% Run for extended time after source audio ends; use silence as input
x(:) = 0;
for k=1:floor(more_time_sec*audio_reader.SampleRate/audio_reader.SamplesPerFrame)
    delayline_out = step(audio_delayline, x);
    y = x + delayline_out;
    step(audio_player, y);
end

%% Clean up
release(audio_reader);
release(audio_player);

% All done!