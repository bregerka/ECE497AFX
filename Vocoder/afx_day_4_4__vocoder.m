%% AFX -- Day 4-4 - Vocoder
%

% Begin with a clean workspace
clear

% Name of this effect
effect_name = 'vocoder';
write_audio = false;

%% User interface:

% Effect parameters with suggested initial value and typical range:
N = 20; % filter order / 20 / 2 to 60
frame_size = 256; % samples per frame / 1024 / 1024 to 16384 or higher
   % (use a power of two)

% Options:
listen_to_original_speech = false;
listen_to_original_music = false;
use_signal_generator = false; f0_Hz = 50;
visualize_spectrum = false; pause_delay_s = 0.1;

% Audio files -- s = speech, m = music, y = output:
% IMPORTANT: All audio files must be the same sampling rate!
s_name = 'FF34_04.wav';
%s_name = 'mike-cox_bueller';
%s_name = 'A_eng_f1.wav';
%s_name = 'missedit';
s_type = 'wav';
%m_name = '22-013 Original Distorted Guitar - mono';
%m_name = 'audiocheck.net_whitenoise';
m_name = 'MF34_04.wav';
%m_name = 'mike-cox_guitar';
y_type = 'wav';
audio_folder = 'C:\doering\Class\ECE497afx\resources\sounds';

%% Create the input/output file names
s_filename = [audio_folder '\' s_name '.' s_type];
m_filename = [audio_folder '\' m_name '.' s_type];
y_name = sprintf('%s_%s_%s__%g_%g',effect_name,s_name,m_name, ...
    N,frame_size);
y_filename = [audio_folder '\' y_name '.' y_type];

%% Create the audio reader, player, and writer objects
speech_reader = dsp.AudioFileReader(s_name);
speech_reader.SamplesPerFrame = frame_size;
music_reader = dsp.AudioFileReader(m_name);
music_reader.SamplesPerFrame = frame_size;
audio_player = dsp.AudioPlayer('SampleRate', speech_reader.SampleRate);
audio_player.QueueDuration = 0; % 0 useful for short clips; 1 is default
if write_audio
    audio_writer = dsp.AudioFileWriter('Audio/Test');
    audio_writer.SampleRate = speech_reader.SampleRate;
    audio_writer.FileFormat = s_type;
end

%% Create a signal generator as optional input instead of musical instrument
fs_Hz = speech_reader.SampleRate;
x1period = sawtooth(2*pi*(0:fs_Hz/f0_Hz-1)*f0_Hz/fs_Hz)';
x1period = diric(2*pi*(0:fs_Hz/f0_Hz-1)*f0_Hz/fs_Hz,100)';
%x1period = square(2*pi*(0:fs_Hz/f0_Hz-1)*f0_Hz/fs_Hz)';
sigsrc = dsp.SignalSource(x1period);
sigsrc.SamplesPerFrame = frame_size;
sigsrc.SignalEndAction = 'Cyclic repetition';

%% Create signal sinks to capture the output waveform and filter coefficients
sigsink = dsp.SignalSink;
acoeffs = dsp.SignalSink;
gcoeffs = dsp.SignalSink;
s_sink = dsp.SignalSink;

%% Create the spectral envelope estimator and the all-pole filter
spectenv = dsp.BurgAREstimator;
spectenv.EstimationOrderSource = 'Property';
spectenv.EstimationOrder = N;

apfilt = dsp.AllpoleFilter;

%% Read, process, play, and write the audio
while ~isDone(speech_reader)
    % Retrieve the next audio frame from the two files
    s = step(speech_reader);
    m = step(music_reader);
    if use_signal_generator m = step(sigsrc); end

    % Append the speech audio frame to matrix
    step(s_sink,s');
        
    % Estimate the spectral envelope and filter gain from the speech
    [a,g] = step(spectenv,s);
    a = a';
    g = sqrt(g); % works much better for scaling
    step(acoeffs,a);
    step(gcoeffs,g);
    %fvtool(g,a)  % view the spectral envelope
    
    % Apply the spectral envelope to the music
    apfilt.Denominator = a;
    y = g*step(apfilt,m);
    
    % Listen to the results
    if ~visualize_spectrum
        if listen_to_original_speech
            step(audio_player, s);
        else if listen_to_original_music
                step(audio_player, m);
            else
                step(audio_player, y);
            end
        end
    end
        
    
    % Append this frame to the output signal array
    step(sigsink,y);

    % Write the output
    if write_audio step(audio_writer, y); end
end

% Visualize the signal spectrum and its spectral envelope;
% comment out the audio_player above when using this section
if visualize_spectrum
    a = acoeffs.Buffer;
    g = gcoeffs.Buffer;
    s = s_sink.Buffer;
    for frame_num = 1:size(s,1)
        %frame_num = 33;
        ff = speech_reader.SampleRate*(0:frame_size/2-1)/frame_size;
        sspec = abs(fft(s(frame_num,:)));
        sspec((frame_size/2)+1:frame_size)=[];
        env = abs(freqz(g(frame_num),a(frame_num,:),frame_size/2));
        plotyy(ff, sspec, ff, env), xlabel('frequency (Hz)');
        sound(s(frame_num,:),speech_reader.SampleRate);
        pause(pause_delay_s)
    end
end

%% Clean up
release(speech_reader);
release(music_reader);
release(audio_player);
if write_audio release(audio_writer); end

% All done!
