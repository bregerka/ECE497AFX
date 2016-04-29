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
G = 60;

%% Read, process, and play the audio
pass_first_time = 1;
bDelays = 0;
while ~isDone(audio_reader)
    % Retrieve the next audio frame from the file
    x = step(audio_reader);
    
    % Generate the output
    y = sign(x).*(1-exp(-abs(G.*x)));
    
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