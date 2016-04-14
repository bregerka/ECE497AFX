file_name = 'show.m4a';%'guitar.wav';

%% Create the audio reader and player objects
audio_reader = dsp.AudioFileReader(file_name);
audio_player = dsp.AudioPlayer('SampleRate', audio_reader.SampleRate);
audio_player.QueueDuration = 0;

test_tone = dsp.SineWave(1,1000);
test_tone.SampleRate = audio_reader.SampleRate; %required; defaults to 1000Hz
test_tone.SamplesPerFrame = audio_reader.SamplesPerFrame; % required; defaults to 1

values = [0 20 50 0];


f = figure;
b = uicontrol('Parent',f,'Style','slider','Position',[80,50,25,200],...
              'value',values(1), 'min',-30, 'max',8);
b2 = uicontrol('Parent',f,'Style','slider','Position',[200,50,25,200],...
              'value',values(2), 'min',20, 'max',9000);
 b3 = uicontrol('Parent',f,'Style','slider','Position',[320,50,25,200],...
               'value',values(3), 'min',50, 'max',5000);
% b4 = uicontrol('Parent',f,'Style','slider','Position',[440,50,25,200],...
%               'value',values(4), 'min',-10, 'max',10);


%fvtool(H,H2);

%% Read, process, and play the audio
while ~isDone(audio_reader)
    drawnow();
     H = dsp.ParametricEQFilter('CenterFrequency',b2.Value,'Bandwidth',b3.Value,'PeakGaindB',b.Value);
%     H2 = dsp.ParametricEQFilter('CenterFrequency',250,'Bandwidth',7000,'PeakGaindB',b2.Value);
%     H3 = dsp.ParametricEQFilter('CenterFrequency',500,'Bandwidth',7000,'PeakGaindB',b2.Value);
%     H4 = dsp.ParametricEQFilter('CenterFrequency',1000,'Bandwidth',7000,'PeakGaindB',b2.Value);
    
 %   H = dsp.ParametricEQFilter('Specification','Quality factor and center frequency','CenterFrequency',125,'QualityFactor',sqrt(2),'PeakGaindB',b.Value);
 %   H2 = dsp.ParametricEQFilter('Specification','Quality factor and center frequency','CenterFrequency',250,'QualityFactor',sqrt(2),'PeakGaindB',b2.Value);
  %  H3 = dsp.ParametricEQFilter('Specification','Quality factor and center frequency','CenterFrequency',500,'QualityFactor',sqrt(2),'PeakGaindB',b3.Value);
  %  H4 = dsp.ParametricEQFilter('Specification','Quality factor and center frequency','CenterFrequency',1000,'QualityFactor',sqrt(2),'PeakGaindB',b4.Value);
    
  %  b.Value
  %  b2.Value
    
%    addlistener(b,'ActionEvent');
    %addlistener(b, 'ContinuousValueChange', @myCallbackFcn);
    %b2.addlistener;
    %sValue = get(handles.slider,'Value');
    %b.Callback = @(b) updateSystem(f,b.Value);
   % b.Value;
    % Retrieve the next audio frame from the file
    x = step(audio_reader);
    
    % Uncommment this line to use the 440-Hz test tone instead
    %x = step(test_tone);
    
    % Generate the output
    y = step(H,x);
   %y = step(H2,y);
   % y = step(H3,y);
   % y = step(H4,y);
    %y = [y y];
    % plot(y);
    % Listen to the results
    step(audio_player, y);

end


%% Clean up
release(audio_reader);
release(audio_player);

% All done!