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
 uicontrol('Style','text','Position',[70 300 60 50],'String','Gain(dB):');
 txt = uicontrol('Style','text','Position',[130 300 40 50],'String',b.Value);
 b2 = uicontrol('Parent',f,'Style','slider','Position',[110,50,25,200],...
              'value',values(2), 'min',20, 'max',9000);
 uicontrol('Style','text','Position',[60 280 80 50],'String','Center Freq:');
 txt1 = uicontrol('Style','text','Position',[130 280 40 50],'String',b2.Value);
 b3 = uicontrol('Parent',f,'Style','slider','Position',[140,50,25,200],...
               'value',values(3), 'min',50, 'max',5000);
 uicontrol('Style','text','Position',[70 260 60 50],'String','Bandwidth:');
 txt2 = uicontrol('Style','text','Position',[130 260 40 50],'String',b3.Value);
 b4 = uicontrol('Parent',f,'Style','slider','Position',[200,50,25,200],...
              'value',values(4), 'min',-30, 'max',8);
 uicontrol('Style','text','Position',[190 300 60 50],'String','Gain(dB):');
 txt3 = uicontrol('Style','text','Position',[240 300 40 50],'String',b4.Value);
 b5 = uicontrol('Parent',f,'Style','slider','Position',[230,50,25,200],...
              'value',values(5), 'min',20, 'max',9000);
 uicontrol('Style','text','Position',[180 280 80 50],'String','Center Freq:');
 txt4 = uicontrol('Style','text','Position',[250 280 40 50],'String',b5.Value);
 b6 = uicontrol('Parent',f,'Style','slider','Position',[260,50,25,200],...
               'value',values(6), 'min',50, 'max',5000);
 uicontrol('Style','text','Position',[190 260 60 50],'String','Bandwidth:');
 txt5 = uicontrol('Style','text','Position',[250 260 40 50],'String',b6.Value);
 b7 = uicontrol('Parent',f,'Style','slider','Position',[320,50,25,200],...
              'value',values(7), 'min',-30, 'max',8);
 uicontrol('Style','text','Position',[310 300 60 50],'String','Gain(dB):');
 txt6 = uicontrol('Style','text','Position',[370 300 40 50],'String',b7.Value);
 b8 = uicontrol('Parent',f,'Style','slider','Position',[350,50,25,200],...
              'value',values(8), 'min',20, 'max',9000);
 uicontrol('Style','text','Position',[300 280 80 50],'String','Center Freq:');
 txt7 = uicontrol('Style','text','Position',[370 280 40 50],'String',b8.Value);
 b9 = uicontrol('Parent',f,'Style','slider','Position',[380,50,25,200],...
               'value',values(9), 'min',50, 'max',5000);
 uicontrol('Style','text','Position',[310 260 60 50],'String','Bandwidth:');
 txt8 = uicontrol('Style','text','Position',[370 260 40 50],'String',b9.Value);
 b10 = uicontrol('Parent',f,'Style','slider','Position',[440,50,25,200],...
              'value',values(7), 'min',-30, 'max',8);
 b11 = uicontrol('Parent',f,'Style','slider','Position',[470,50,25,200],...
              'value',values(8), 'min',20, 'max',9000);
 b12 = uicontrol('Parent',f,'Style','slider','Position',[500,50,25,200],...
               'value',values(9), 'min',50, 'max',5000);

 btn = uicontrol('Style', 'pushbutton', 'String', 'Zeroize',...
        'Position', [300 380 50 50],...
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
    txt.String = round(b.Value,2);
    txt1.String = round(b2.Value);
    txt2.String = round(b3.Value);
    txt3.String = round(b4.Value,2);
    txt4.String = round(b5.Value);
    txt5.String = round(b6.Value);
    txt6.String = round(b7.Value,2);
    txt7.String = round(b8.Value);
    txt8.String = round(b9.Value);
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