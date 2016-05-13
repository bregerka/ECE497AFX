file_name = 'Fender Bender.wav';
writeFile = true;
%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader(file_name);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0;

audio_writer = dsp.AudioFileWriter('variedBW.wav');
audio_writer.SampleRate = audio_reader.SampleRate;
audio_writer.FileFormat = 'wav';

values = [0 11000 4500 0 11000 4500 0 11000 4500 0 11000 4500];


 f = figure;
 b = uicontrol('Parent',f,'Style','slider','Position',[80,50,25,200],...
              'value',values(1), 'min',-15, 'max',15);
 uicontrol('Style','text','Position',[70 300 60 50],'String','Gain(dB):');
 txt = uicontrol('Style','text','Position',[140 300 40 50],'String',b.Value);
 b2 = uicontrol('Parent',f,'Style','slider','Position',[110,50,25,200],...
              'value',values(2), 'min',20, 'max',22050);
 uicontrol('Style','text','Position',[60 280 80 50],'String','Center Freq:');
 txt1 = uicontrol('Style','text','Position',[140 280 40 50],'String',b2.Value);
 b3 = uicontrol('Parent',f,'Style','slider','Position',[140,50,25,200],...
               'value',values(3), 'min',50, 'max',9000);
 uicontrol('Style','text','Position',[70 260 75 50],'String','Bandwidth:');
 txt2 = uicontrol('Style','text','Position',[140 260 40 50],'String',b3.Value);
 b4 = uicontrol('Parent',f,'Style','slider','Position',[200,50,25,200],...
              'value',values(4), 'min',-15, 'max',15);
 uicontrol('Style','text','Position',[190 300 60 50],'String','Gain(dB):');
 txt3 = uicontrol('Style','text','Position',[260 300 40 50],'String',b4.Value);
 b5 = uicontrol('Parent',f,'Style','slider','Position',[230,50,25,200],...
              'value',values(5), 'min',20, 'max',22050);
 uicontrol('Style','text','Position',[180 280 80 50],'String','Center Freq:');
 txt4 = uicontrol('Style','text','Position',[260 280 40 50],'String',b5.Value);
 b6 = uicontrol('Parent',f,'Style','slider','Position',[260,50,25,200],...
               'value',values(6), 'min',50, 'max',9000);
 uicontrol('Style','text','Position',[190 260 75 50],'String','Bandwidth:');
 txt5 = uicontrol('Style','text','Position',[260 260 40 50],'String',b6.Value);
 b7 = uicontrol('Parent',f,'Style','slider','Position',[320,50,25,200],...
              'value',values(7), 'min',-15, 'max',15);
 uicontrol('Style','text','Position',[310 300 60 50],'String','Gain(dB):');
 txt6 = uicontrol('Style','text','Position',[380 300 40 50],'String',b7.Value);
 b8 = uicontrol('Parent',f,'Style','slider','Position',[350,50,25,200],...
              'value',values(8), 'min',20, 'max',22050);
 uicontrol('Style','text','Position',[300 280 80 50],'String','Center Freq:');
 txt7 = uicontrol('Style','text','Position',[380 280 40 50],'String',b8.Value);
 b9 = uicontrol('Parent',f,'Style','slider','Position',[380,50,25,200],...
               'value',values(9), 'min',50, 'max',9000);
 uicontrol('Style','text','Position',[310 260 75 50],'String','Bandwidth:');
 txt8 = uicontrol('Style','text','Position',[380 260 40 50],'String',b9.Value);
 b10 = uicontrol('Parent',f,'Style','slider','Position',[440,50,25,200],...
              'value',values(7), 'min',-15, 'max',15);
 uicontrol('Style','text','Position',[430 300 60 50],'String','Gain(dB):');
 txt9 = uicontrol('Style','text','Position',[500 300 40 50],'String',b10.Value);
 b11 = uicontrol('Parent',f,'Style','slider','Position',[470,50,25,200],...
              'value',values(8), 'min',20, 'max',22050);
 uicontrol('Style','text','Position',[420 280 80 50],'String','Center Freq:');
 txt10 = uicontrol('Style','text','Position',[500 280 40 50],'String',b11.Value);
 b12 = uicontrol('Parent',f,'Style','slider','Position',[500,50,25,200],...
               'value',values(9), 'min',50, 'max',9000);
 uicontrol('Style','text','Position',[430 260 75 50],'String','Bandwidth:');
 txt11 = uicontrol('Style','text','Position',[500 260 40 50],'String',b12.Value);

 btn = uicontrol('Style', 'pushbutton', 'String', 'Zeroize',...
        'Position', [300 380 50 50],...
        'Callback','cla');  
     H = dsp.ParametricEQFilter('CenterFrequency',b2.Value,'Bandwidth',b3.Value,'PeakGaindB',b.Value);
     H2 = dsp.ParametricEQFilter('CenterFrequency',b5.Value,'Bandwidth',b6.Value,'PeakGaindB',b4.Value);
     H3 = dsp.ParametricEQFilter('CenterFrequency',b8.Value,'Bandwidth',b9.Value,'PeakGaindB',b7.Value);
     H4 = dsp.ParametricEQFilter('CenterFrequency',b11.Value,'Bandwidth',b12.Value,'PeakGaindB',b10.Value);

%fvtool(H,H2);

%% Read, process, and play the audio
%while ~isDone(audio_reader)
for N = 1:800
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
    txt9.String = round(b10.Value,2);
    txt10.String = round(b11.Value);
    txt11.String = round(b12.Value);

    % Retrieve the next audio frame from the file
    x = step(audio_reader);
    
    % Generate the output
    y = step(H,x);
    y = step(H2,y);
    y = step(H3,y);
    y = step(H4,y);
   
    step(audio_player, y);
  if writeFile  step(audio_writer, y); end
end


%% Clean up
release(audio_reader);
release(audio_player);
release(audio_writer);
% All done!