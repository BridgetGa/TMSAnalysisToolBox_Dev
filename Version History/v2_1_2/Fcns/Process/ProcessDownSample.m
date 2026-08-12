%Down samples data and time by a user selected factor
%Inputs: data time, data, factor, sample rate
%Outputs: new time, data, and sample rate

function [newTime,newData,newSampleRate]=ProcessDownSample(app,DataTime,DataAll,Factor,SampleRate)

NewSampleRate=SampleRate/Factor;
if rem(NewSampleRate,Factor) ~= 0
    NewSampleRate=round(SampleRate/Factor);
    Factor=SampleRate/NewSampleRate;
    app.FactorEditField.Value=Factor;

end

newData=[];
for i=1:length(DataAll(:,1))
    Data=DataAll(i,:);
    %downsample
    DataP=[repmat(Data(1),1,SampleRate) Data repmat(Data(end),1,SampleRate)];
    DataB=resample(DataP,SampleRate/Factor,SampleRate);
    %resample assumes the values before and after the data given are zeros,
    %added padding to help with the affects of this on the filter
    RPadding=SampleRate/Factor;
    if rem(SampleRate,Factor) ~= 0
        disp('RPadding is not an integer');
        DataB(1:floor(RPadding)-1)=[]; DataB(end-ceil(RPadding):end)=[];
    else
        DataB(1:RPadding-1)=[]; DataB(end-RPadding:end)=[];

    end
    newData(i,:)=DataB;
end

%downsample time
TimeP=[repmat(DataTime(1),1,SampleRate) DataTime repmat(DataTime(end),1,SampleRate)];
TimeB=resample(TimeP,SampleRate/Factor,SampleRate);
%resample assumes the values before and after the data given are zeros,
%added padding to help with the affects of this on the filter
RPadding=SampleRate/Factor;
if rem(SampleRate,Factor) ~= 0
    disp('RPadding is not an integer');
    TimeB(1:floor(RPadding)-1)=[]; TimeB(end-ceil(RPadding):end)=[];
else
    TimeB(1:RPadding-1)=[]; TimeB(end-RPadding:end)=[];

end
newTime=TimeB;

newSampleRate=SampleRate/Factor;


% newData=DataAll(:,1:Factor:end);
% newTime=DataTime(1:Factor:end);
% newSampleRate=SampleRate/Factor;



end

