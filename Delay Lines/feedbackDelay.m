%% AFX -- Figure 2.1 - Basic delay
%
% References:
% http://www.mathworks.com/help/dsp/ref/dsp.delay-class.html
% http://www.mathworks.com/help/dsp/systemobjectslist.html
%

% Begin with a clean workspace
clear, close all

%% User interface:

% Effect parameters with suggested initial value and typical range:
delay_ms = 500; % delay line length (ms) / 300ms / 0 to 2000ms or more
g_dB = -5; % feed-forward gain (dB) / -5dB / -120dB to +2dB
more_time_sec = 1; % time extension after source audio ends (seconds)
writeFile = true;
% Source audio:
file_name = 'show.m4a';%'A_eng_f1.wav'; % mono
%file_name = 'Mixing Audio (Roey Izhaki)\11-014 Guitar Src.wav'; % stereo
%audio_folder = 'C:\doering\Class\ECE497afx\resources\sounds';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader(file_name);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0; % useful for very short audio clips

audio_writer = dsp.AudioFileWriter('feedbackDelay2.ogg');
audio_writer.SampleRate = 44100;
audio_writer.FileFormat = 'ogg';
%% Convert the user interface values:
% delay in samples and linear gain
delay = (delay_ms/1000)*audio_reader.SampleRate;
g = 2^(0/6);
gfb = 2^(0/6);

%% Create the delay line object
audio_delayline = dsp.Delay(round(delay));

%% Read, process, and play the audio
pass_first_time = 1;
%while ~isDone(audio_reader)
for C = 1:300
    % Retrieve the next audio frame from the file
    x = step(audio_reader);
    
    % Retrieve the next frame from the delay line; check to make sure it is
    % the first loop since there isnt anything from the delay line at first
    % insert a new frame, too;
    if pass_first_time
        pass_first_time = 0;
        delayline_out = step(audio_delayline, x);
    else
        delayline_out = gfb*step(audio_delayline, x);
    end
    % Generate the output
   % y = x + (g-gfb)*delayline_out;    % mixed to mono
   y = x + g*delayline_out;
   %y = [x g*delayline_out];    % stereo
    
    % Listen to the results
    step(audio_player, y);
    if writeFile  step(audio_writer, y); end
end

% Run for extended time after source audio ends; use silence as input
x(:) = 0;
for k=1:floor(more_time_sec*audio_reader.SampleRate/audio_reader.SamplesPerFrame)
    delayline_out = step(audio_delayline, x);
    y = x + g*delayline_out;
    step(audio_player, y);
end

%% Clean up
release(audio_reader);
release(audio_player);

% All done!
