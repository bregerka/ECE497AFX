% Begin with a clean workspace
clear, close all
writeFile = true;

%% User interface:

% Effect parameters with suggested initial value and typical range:
LFO_freq_Hz = 5;   % low-frequency oscillator rate (Hz) / 1Hz / 0.1 to 10Hz
LFO_depth_samples = 1024; % low-frequency oscillator depth (samples) / 5000 / 65536
delay_max_ms = 1000; % max delay line length (ms) / 0ms / 0 to 1000ms
                     % (the delay line max length is 65535 samples)

% Sinewave oscillator (test input)
osc_freq_Hz = 350;

% Source audio:
file_name = 'show.wav';
audio_folder = 'C:\Users\bochnoej\Documents\GitHub\ECE497AFX\Audio';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader([audio_folder '\' file_name]);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0;
audio_writer = dsp.AudioFileWriter('SnareVibrato.ogg');
audio_writer.SampleRate = 44100;
audio_writer.FileFormat = 'ogg';

%% Convert the user interface values:
% delay in samples and linear gain
delay_max = (delay_max_ms/1000)*audio_reader.SampleRate;

%% Create the delay line object
audio_delayline = dsp.VariableIntegerDelay;
%audio_delayline = dsp.VariableFractionalDelay;
audio_delayline.MaximumDelay = delay_max;

%% Create the sinewave oscillators
% (the default samples per frame is 1)
test_tone = dsp.SineWave(1,osc_freq_Hz);
test_tone.SampleRate = audio_reader.SampleRate; %required; defaults to 1000Hz
test_tone.SamplesPerFrame = audio_reader.SamplesPerFrame; % required; defaults to 1
%test_tone.SamplesPerFrame = 2^10; % required; defaults to 1
   % evidently the variable integer delay can accept an array of
   % delays? The samples/frame parameter only affects the sound at 
   % values near 1 or 2; longer frame times show evidence of working 
   % properly at the individual sample level; as evidence, listen to
   % one frame of y when samples per frame is 2^14

   
%% Create one period of a non-sinusoidal signal waveform
fs_Hz = audio_reader.SampleRate; % sampling rate
f0_Hz = LFO_freq_Hz; % LFO frequency

% choose (uncomment) one of these to use as the LFO waveform, if sinewave
% is used ensure that correct lines of code are uncommented in audio player
%LFO = dsp.SineWave(0.5,LFO_freq_Hz);
LFO = 1000*sawtooth(2*pi*(0:fs_Hz/f0_Hz-1)*f0_Hz/fs_Hz)';
%LFO = 1000*sawtooth(2*pi*(0:fs_Hz/f0_Hz-1)*f0_Hz/fs_Hz,0.5)';

%Two more lines of code that are uncommented if sine wave is used
%LFO.SampleRate = audio_reader.SampleRate;
%LFO.SamplesPerFrame = audio_reader.SamplesPerFrame;

% visualize one period of the waveform
figure(1);
plot(LFO);
title('one period');

%% Create a signal source from this waveform
sigsrc = dsp.SignalSource(LFO);
sigsrc.SamplesPerFrame = LFO_depth_samples;
sigsrc.SignalEndAction = 'Cyclic repetition';

%Creating signal sink to check final output
sigsink = dsp.SignalSink;


%% Read, process, and play the audio
while ~isDone(audio_reader)
    
    % Generate the next frame from the signal source
     z1 = step(sigsrc);
     
    % Guitar, stereo
     z = [z1 z1];
     
    %Test Tone, mono
    % z = z1;
    
    % Retrieve the next audio frame from the file
     x = step(audio_reader);
    
    % Uncommment this line to use the 440-Hz test tone instead
    %  x = step(test_tone);
    
    % Get the next low-frequency oscillator output frame used only with
    % sine wave
    %lfo = (step(LFO)+0.5)*LFO_depth_samples;
       
    % Retrieve the next frame from the delay line;
    % insert a new frame, too;
    delayline_out = step(audio_delayline, x, z);
    
    % Generate the output
    y = delayline_out;
    
    % Listen to the results
    step(audio_player, y);
    
     % Storing signals to check results
    step(sigsink,y);
    
     if writeFile  step(audio_writer, y); end
   
end

% plot a portion of the entire waveform that was collected within the loop
figure(2)
yall = sigsink.Buffer;
plot(yall(1:fs_Hz));
title('signal')

%% Clean up
release(audio_reader);
release(audio_player);

% All done!
