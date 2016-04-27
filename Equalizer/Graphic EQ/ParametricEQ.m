file_name = 'show.m4a';%'guitar.wav';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader(file_name);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0;

%test_tone = dsp.SineWave(1,1000);
%test_tone.SampleRate = audio_reader.SampleRate; %required; defaults to 1000Hz
%test_tone.SamplesPerFrame = audio_reader.SamplesPerFrame; % required; defaults to 1

values = [0 20 50 0 20 50 0 20 50 0 20 50];


 f = figure;
 b = uicontrol('Parent',f,'Style','slider','Position',[80,50,25,200],...
              'value',values(1), 'min',-30, 'max',8);
 txt = uicontrol('Style','text','Position',[50 50 25 200],'String',b.Value);
 b2 = uicontrol('Parent',f,'Style','slider','Position',[110,50,25,200],...
              'value',values(2), 'min',20, 'max',9000);
 b3 = uicontrol('Parent',f,'Style','slider','Position',[140,50,25,200],...
               'value',values(3), 'min',50, 'max',5000);
 b4 = uicontrol('Parent',f,'Style','slider','Position',[200,50,25,200],...
              'value',values(4), 'min',-30, 'max',8);
 b5 = uicontrol('Parent',f,'Style','slider','Position',[230,50,25,200],...
              'value',values(5), 'min',20, 'max',9000);
 b6 = uicontrol('Parent',f,'Style','slider','Position',[260,50,25,200],...
               'value',values(6), 'min',50, 'max',5000);
 b7 = uicontrol('Parent',f,'Style','slider','Position',[320,50,25,200],...
              'value',values(7), 'min',-30, 'max',8);
 b8 = uicontrol('Parent',f,'Style','slider','Position',[350,50,25,200],...
              'value',values(8), 'min',20, 'max',9000);
 b9 = uicontrol('Parent',f,'Style','slider','Position',[380,50,25,200],...
               'value',values(9), 'min',50, 'max',5000);
 b10 = uicontrol('Parent',f,'Style','slider','Position',[440,50,25,200],...
              'value',values(7), 'min',-30, 'max',8);
 b11 = uicontrol('Parent',f,'Style','slider','Position',[470,50,25,200],...
              'value',values(8), 'min',20, 'max',9000);
 b12 = uicontrol('Parent',f,'Style','slider','Position',[500,50,25,200],...
               'value',values(9), 'min',50, 'max',5000);

 btn = uicontrol('Style', 'pushbutton', 'String', 'Zeroize',...
        'Position', [300 300 50 50],...
        'Callback','cla');  
     H = dsp.ParametricEQFilter('CenterFrequency',b2.Value,'Bandwidth',b3.Value,'PeakGaindB',b.Value);
     H2 = dsp.ParametricEQFilter('CenterFrequency',b5.Value,'Bandwidth',b6.Value,'PeakGaindB',b4.Value);
     H3 = dsp.ParametricEQFilter('CenterFrequency',b8.Value,'Bandwidth',b9.Value,'PeakGaindB',b7.Value);
     H4 = dsp.ParametricEQFilter('CenterFrequency',b11.Value,'Bandwidth',b12.Value,'PeakGaindB',b10.Value);

%fvtool(H,H2);

%% Read, process, and play the audio
while ~isDone(audio_reader)
    drawnow();
    H.CenterFrequency = b2.Value;
    H.Bandwidth = b3.Value;
    H.PeakGaindB = b.Value;
    H2.CenterFrequency = b5.Value;
    H2.Bandwidth = b6.Value;
    H2.PeakGaindB = b4.Value;
    H3.CenterFrequency = b8.Value;
    H3.Bandwidth = b9.Value;
    H3.PeakGaindB = b7.Value;
    H4.CenterFrequency = b11.Value;
    H4.Bandwidth = b12.Value;
    H4.PeakGaindB = b10.Value;
    txt.String = b.Value;
    % Retrieve the next audio frame from the file
    x = step(audio_reader);
    
    % Uncommment this line to use the 440-Hz test tone instead
    %x = step(test_tone);
    
    % Generate the output
    y = step(H,x);
    y = step(H2,y);
    y = step(H3,y);
    y = step(H4,y);
   % specAn = dsp.SpectrumAnalyzer('SampleRate',44100);
    %step(specAn,y)
    %plot(y)
    % Listen to the results
    %audiowrite('Audio\testingWrite.wav',y,44100);
    step(audio_player, y);

end


%% Clean up
release(audio_reader);
release(audio_player);

% All done!