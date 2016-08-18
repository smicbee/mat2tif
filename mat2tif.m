%OpenFileDialog Prompt
[FileName,PathName,FilterIndex] = uigetfile;

%wechsle in Filepath
cd(PathName);

%lese .mat file in Variable
st = open(FileName);

%Fielnames der Structure variablen als array um sie danach dynamisch
%ansprechen zu können
SNames = fieldnames(st); 
for i = 1:length(SNames(:))
    SName = [SNames{:}];
    stuff = st.(SName);
end


SNames = fieldnames(stuff); 

%imgstack vorher initialisieren und mit nullen füllen
imgstack = zeros(1,1024,1024);
%SName vorher initialisieren und Wert zuweisen
SName = 0;

%imgstack(index, x-Werte, y-Werte) -> Alle Bilder in einem 3D Array
for i = 1:length(SNames(:))
    SName = [SNames{i}];
    imgstack(i,:,:) = stuff.(SName);
end

%maximalen Wert aller Bilder ermitteln
vmax = max(imgstack(:));
%und dann dadurch dividieren (element wise)
imgstack(:) = (2^16-1)*imgstack(:)/vmax;

%imagesc(squeeze(imgstack(1,:,:)));

for q = 1:size(imgstack(:,:))
%squeeze reduziert den 3D Stack wieder zu einem 2D Bild vom index q
bild = squeeze(imgstack(q,:,:));
%als 16bit tif speichern
imwrite(uint16(bild),[SNames{q} '.tif'],'tif');
end

%alle Variablen löschen und Speicher freigeben
clearvars;
%ende im gelände :P