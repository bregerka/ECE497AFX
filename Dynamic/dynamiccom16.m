clear, close all
writeFile = true;


% Source audio:
file_name = 'guitar.wav';
audio_folder = 'C:\Users\bochnoej\Documents\GitHub\ECE497AFX\Audio';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader([audio_folder '/' file_name]);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0;

%Creating signal sink to check final output
sigsink1 = dsp.SignalSink;
sigsink2 = dsp.SignalSink;
audio_writer = dsp.AudioFileWriter('GuitarDynamic20dB.ogg');
audio_writer.SampleRate = 44100;
audio_writer.FileFormat = 'ogg';

%Creating the dynamic range compressor

%Operation threshold in dB, specified as a real scalar.
%Operation threshold is the level above which gain is applied to the input
%signal.
Thresh = -20;

%Attack time in seconds, specified as a real scalar greater than 
% or equal to 0.
AT = 0.01; 

%Compression ratio, specified as a real scalar greater than or 
% equal to 1.Compression ratio is the input/output ratio for signals that 
% overshoot the operation threshold.
Rat = 10; 

%Knee width in dB, specified as a real scalar greater than or equal to 
%0. Knee width is the transition area in the compression characteristic.
KW = 0; 

%Release time in seconds, specified as a real scalar greater than 
% or equal to 0.
RT = 0.2; 

%Input sample rate in Hz, specified as a positive scalar
SR = audio_reader.SampleRate; 

dRC = compressor('Threshold', Thresh, 'Ratio', Rat, 'KneeWidth', KW, ...
'ReleaseTime', RT, 'AttackTime',AT,'SampleRate',SR);

while ~isDone(audio_reader)
       
    % Retrieve the next audio frame from the file, store input for checking
    % results
    x = step(audio_reader);
    step(sigsink1,x);
    
    % Run x through the compressor
    y = step(dRC, x);
    
    % Listen to the Results
    step(audio_player,y);
    
     % Storing signals to check results
    step(sigsink2,y);
       
    if writeFile  step(audio_writer, y); end

   
end

% plot a portion of the entire waveform that was collected within the loop
figure(1)
sink1 = sigsink1.Buffer;
plot(sink1(1:audio_reader.SampleRate));
title('signal')

figure(2)
sink2 = sigsink2.Buffer;
plot(sink2(1:audio_reader.SampleRate));
title('signal')

%% Clean up
release(audio_reader);
release(audio_player);

% All done!
