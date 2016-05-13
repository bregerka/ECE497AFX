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
more_time_sec = 1;
sampRate = 44100;
%% Create the audio reader and player objects
audio_reader = audioread(file_name);
sigsrc = dsp.SignalSource(audio_reader);
sigsrc.SamplesPerFrame = 4096;
sigsrc.SignalEndAction = 'Set to zero';%feed out zeros
audio_player = dsp.AudioPlayer('SampleRate', 44100);
audio_player.QueueDuration = 0; % useful for very short audio clips

%% Convert the user interface values:
%G = 2^(g_dB/6);
RT60 = 1;

Tau1 = 29.7/1000;
Tau2 = 37.1/1000;
Tau3 = 41.1/1000;
Tau4 = 43.7/1000;
% Tau1 = 19.7/1000;
% Tau2 = 17.1/1000;
% Tau3 = 11.1/1000;
% Tau4 = 13.7/1000;
Tau5 = 5/1000;
Tau6 = 1.7/1000;
%% Convert the user interface values:
% delay in samples and linear gain
delay1 = (Tau1)*sampRate;
delay2 = (Tau2)*sampRate;
delay3 = (Tau3)*sampRate;
delay4 = (Tau4)*sampRate;
delayAP1 = (Tau5)*sampRate;
delayAP2 = (Tau6)*sampRate;
%g = 2^(g_dB/6);
g1 = 10^(-3*Tau1/RT60);
g2 = 10^(-3*Tau2/RT60);
g3 = 10^(-3*Tau3/RT60);
g4 = 10^(-3*Tau4/RT60);
g5 = 10^(-3*Tau5/RT60);
g6 = 10^(-3*Tau6/RT60);
%Number of samples to delay
N1 = round(delay1);
N2 = round(delay2);
N3 = round(delay3);
N4 = round(delay4);
N5 = round(delayAP1);
N6 = round(delayAP2);
%Create Filter Coefficients for Comb Filters
A1 = [1 zeros(1,N1-1) -g1];
B1 = [0 zeros(1,N1-1) 1];
A2 = [1 zeros(1,N2-1) -g2];
B2 = [0 zeros(1,N2-1) 1];
A3 = [1 zeros(1,N3-1) -g3];
B3 = [0 zeros(1,N3-1) 1];
A4 = [1 zeros(1,N4-1) -g4];
B4 = [0 zeros(1,N4-1) 1];
%Create Filter Coefficients for All Pass Filters
AP1 = [1 zeros(1,N5-1) -g5];
BP1 = [-g5 zeros(1,N5-1) 1];
AP2 = [1 zeros(1,N6-1) -g6];
BP2 = [-g6 zeros(1,N6-1) 1];
%% Create the delay line object
%audio_delayline1 = dsp.Delay(round(delay1));
%audio_delayline2 = dsp.Delay(round(delay2));
%audio_delayline3 = dsp.Delay(round(delay3));
%audio_delayline4 = dsp.Delay(round(delay4));
%% Read, process, and play the audio
%while ~isDone(audio_reader)
for c = 1:60
    % Retrieve the next audio frame from the file
    x = step(sigsrc);
    
    % Generate the output
    %y = sign(x).*(1-exp(-abs(G.*x)));
  
    %delayline_out = gfb*step(audio_delayline, x);
    y = filter(B1,A1,x)+filter(B2,A2,x)+filter(B3,A3,x)+filter(B4,A4,x);
    y = filter(BP1,AP1,y);
    y = filter(BP2,AP2,y);

    % Listen to the results
    step(audio_player, y);

end

% Run for extended time after source audio ends; use silence as input
x(:) = 0;
for k=1:floor(more_time_sec*44100/sigsrc.SamplesPerFrame)
    %delayline_out = step(audio_delayline, x);
    step(audio_player, x);
end

%% Clean up
%release(audio_reader);
release(audio_player);

% All done!