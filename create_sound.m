function [sound] = create_sound(instrument,notes,constants)
%CREATE_SOUND Creates a sound
%   Creates a sound waveform of a specified note(s) 
%   based on instrument/time specifications

switch instrument.sound
    case {'Additive'}
        
        narray = zeros(length(notes),instrument.totalTime);
        for n = 1:length(notes)
           note = notes{n};
           narray(n,1+note.start:note.duration+1) = (0:note.duration)*note2freq(note.note,notes)/constants.fs;
        end
        sound = sum(sin(2*pi*narray),1);
    
    case {'Subtractive'}
        sound = [1]
    case {'FM'} 
        sound = [1]
    case {'Waveshaper'}
        sound = [1]
        
end


end

