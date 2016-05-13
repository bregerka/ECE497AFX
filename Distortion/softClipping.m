%% AFX -- Figure 2.1 - Basic delay
%
% References:
% http://www.mathworks.com/help/dsp/ref/dsp.delay-class.html
% http://www.mathworks.com/help/dsp/systemobjectslist.html
%

% Begin with a clean workspace
clear, close all

%% User interface:
writeFile = true;
more_time_sec = .5;
% Source audio:
file_name = 'Original Guitar.wav';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader(file_name);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0; % useful for very short audio clips

audio_writer = dsp.AudioFileWriter('softClipG_500.wav');
audio_writer.SampleRate = audio_reader.SampleRate;
audio_writer.FileFormat = 'wav';
%% Convert the user interface values:
G = 500;

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
    if writeFile  step(audio_writer, y); end
end

% Run for extended time after source audio ends; use silence as input
x(:) = 0;
for k=1:floor(more_time_sec*audio_reader.SampleRate/audio_reader.SamplesPerFrame)
    step(audio_player, x);
end

%% Clean up
release(audio_reader);
release(audio_player);
release(audio_writer);
% All done!