file_name = 'guitar.wav';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader(file_name);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0;

% Fs  = 48e3;
% N   = 4;
% G   = 10; % 10 dB
% Wo1 = 0;
% Wo2 = 1; % Corresponds to Fs/2 (Hz) or pi (rad/sample)
% BW = 1000/(Fs/2); % Bandwidth occurs at 7.4 dB in this case
% [B1,A1] = designParamEQ(N,G,Wo1,BW);
% [B2,A2] = designParamEQ(N,G,Wo2,BW);
% dsp.VariableBandwidthIIRFilter()
% BQ1 = dsp.BiquadFilter('SOSMatrix',[B1.',[ones(2,1),A1.']]);
% BQ2 = dsp.BiquadFilter('SOSMatrix',[B2.',[ones(2,1),A2.']]);
% hfvt = fvtool(BQ1,BQ2,'Fs',Fs,'Color','white');
% legend(hfvt,'Low Shelf Filter','High Shelf Filter');
max_f = 44.1e3;
nyq = max_f/2;
Q = 1.4;
wo = 2.205e3/nyq;
bw = wo/Q;
%[b,a] = iirnotch(wo,bw);
%fvtool(b,a);
d = fdesign.parameq('N,Flow,Fhigh,Gref,G0,GBW,Gst',...
       4,0,.4,0,-15,-14,-1);
 Hd = design(d,'cheby2');
 fvtool(Hd)

%% Read, process, and play the audio
while ~isDone(audio_reader)
    % Retrieve the next audio frame from the file
    x = step(audio_reader);
    
    % Uncommment this line to use the 440-Hz test tone instead
    % x = step(test_tone);
    
    % Get the next low-frequency oscillator output frame
    %lfo = (step(LFO)+0.5)*LFO_depth_samples;
    
    % Retrieve the next frame from the delay line;
    % insert a new frame, too;
   % delayline_out = step(audio_delayline, x, lfo);
    
    % Generate the output
  % y = delayline_out;
    y = filter(Hd,x);
    % Listen to the results
    step(audio_player, y);

end


%% Clean up
release(audio_reader);
release(audio_player);

% All done!