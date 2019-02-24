function [freq,Notes] = note2freq(note,Notes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [ freq ] = note2freq( note, Notes )
% 
% This function returns the frequency of a given note as listed here:
% http://en.wikipedia.org/wiki/Piano_key_frequencies
%
% OUTPUTS
%   freq = The note frequency in Hertz
%
% INPUTS
%   note = The note expressed as a letter followed by a number
%          (interpreted in equal temperament)
%            or
%          Cell array of two such notes and scale type, [note,root,scale]
%          (interpreted as just temperament)
%   Notes (optional) = The lookup table of notes to frequency to use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Inputs expressed as a letter followed by a number
%       where A4 = 440 (the A above middle C)
%       See http://en.wikipedia.org/wiki/Piano_key_frequencies for note
%       numbers and frequencies

    if nargin < 2
        table = {
        'B8',7902.133;
        'A#8',7458.62;
        'Bb8',7458.62;
        'A8',7040;
        'G#8',6644.875;
        'Ab8',6644.875;
        'G8',6271.927;
        'F#8',5919.911;
        'Gb8',5919.911;
        'F8',5587.652;
        'E8',5274.041;
        'D#8',4978.032;
        'Eb8',4978.032;
        'D8',4698.636;
        'C#8',4434.922;
        'Db8',4434.922;
        'C8',4186.009;
        'B7',3951.066;
        'A#7',3729.31;
        'Bb7',3729.31;
        'A7',3520;
        'G#7',3322.438;
        'Ab7',3322.438;
        'G7',3135.963;
        'F#7',2959.955;
        'Gb7',2959.955;
        'F7',2793.826;
        'E7',2637.02;
        'D#7',2489.016;
        'Eb7',2489.016;
        'D7',2349.318;
        'C#7',2217.461;
        'Db7',2217.461;
        'C7',2093.005;
        'B6',1975.533;
        'A#6',1864.655;
        'Bb6',1864.655;
        'A6',1760;
        'G#6',1661.219;
        'Ab6',1661.219;
        'G6',1567.982;
        'F#6',1479.978;
        'Gb6',1479.978;
        'F6',1396.913;
        'E6',1318.51;
        'D#6',1244.508;
        'Eb6',1244.508;
        'D6',1174.659;
        'C#6',1108.731;
        'Db6',1108.731;
        'C6',1046.502;
        'B5',987.7666;
        'A#5',932.3275;
        'Bb5',932.3275;
        'A5',880;
        'G#5',830.6094;
        'Ab5',830.6094;
        'G5',783.9909;
        'F#5',739.9888;
        'Gb5',739.9888;
        'F5',698.4565;
        'E5',659.2551;
        'D#5',622.254;
        'Eb5',622.254;
        'D5',587.3295;
        'C#5',554.3653;
        'Db5',554.3653;
        'C5',523.2511;
        'B4',493.8833;
        'A#4',466.1638;
        'Bb4',466.1638;
        'A4',440;
        'G#4',415.3047;
        'Ab4',415.3047;
        'G4',391.9954;
        'F#4',369.9944;
        'Gb4',369.9944;
        'F4',349.2282;
        'E4',329.6276;
        'D#4',311.127;
        'Eb4',311.127;
        'D4',293.6648;
        'C#4',277.1826;
        'Db4',277.1826;
        'C4',261.6256;
        'B3',246.9417;
        'A#3',233.0819;
        'Bb3',233.0819;
        'A3',220;
        'G#3',207.6523;
        'Ab3',207.6523;
        'G3',195.9977;
        'F#3',184.9972;
        'Gb3',184.9972;
        'F3',174.6141;
        'E3',164.8138;
        'D#3',155.5635;
        'Eb3',155.5635;
        'D3',146.8324;
        'C#3',138.5913;
        'Db3',138.5913;
        'C3',130.8128;
        'B2',123.4708;
        'A#2',116.5409;
        'Bb2',116.5409;
        'A2',110;
        'G#2',103.8262;
        'Ab2',103.8262;
        'G2',97.99886;
        'F#2',92.49861;
        'Gb2',92.49861;
        'F2',87.30706;
        'E2',82.40689;
        'D#2',77.78175;
        'Eb2',77.78175;
        'D2',73.41619;
        'C#2',69.29566;
        'Db2',69.29566;
        'C2',65.40639;
        'B1',61.73541;
        'A#1',58.27047;
        'Bb1',58.27047;
        'A1',55;
        'G#1',51.91309;
        'Ab1',51.91309;
        'G1',48.99943;
        'F#1',46.2493;
        'Gb1',46.2493;
        'F1',43.65353;
        'E1',41.20344;
        'D#1',38.89087;
        'Eb1',38.89087;
        'D1',36.7081;
        'C#1',34.64783;
        'Db1',34.64783;
        'C1',32.7032;
        'B0',30.86771;
        'A#0',29.13524;
        'Bb0',29.13524;
        'A0',27.5;
        'G#0',25.95654;
        'Ab0',25.95654;
        'G0',24.49971;
        'F#0',23.12465;
        'Gb0',23.12465;
        'F0',21.82676;
        'E0',20.60172;
        'D#0',19.44544;
        'Eb0',19.44544;
        'D0',18.35405;
        'C#0',17.32391;
        'Db0',17.32391;
        'C0',16.3516
        };
        Notes = cell2table(table(:,2),'RowNames',table(:,1),'VariableNames',{'Hz'});
    end
    
    if class(note) == 'cell'
        try
            if class(note{3}) == 'char'
                justrat = [16/15 10/9 9/8 6/5 5/4 4/3 45/32 64/45 3/2 8/5 5/3 7/4 16/9 9/5 15/8 2];
                switch note{3}
                    case {'Major','major','M','Maj','maj'}
                        scale = [1 cumprod(justrat([3 2 1 3 2 3 1]),2)];
                    case {'Minor','minor','m','Min','min'}
                        scale = [1 cumprod(justrat([3 1 2 3 1 3 2]),2)];
                    otherwise
                        scale = justrat;
                end
            else
                scale = note{3};
            end
            [~,ind] = min(abs(scale-Notes(note{1},1).Hz/Notes(note{2},1).Hz));
            freq = Notes(note{2},1).Hz*scale(ind);
        catch ME
            try 
                freq = Notes(note{1},1).Hz;
            catch ME
                freq = 440;
            end
        end
    else
        try 
            freq = Notes(note,1).Hz;
        catch ME
            freq = 440;
        end
    end
end

