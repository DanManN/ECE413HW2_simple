function [sound] = create_sound(instrument,notes,constants)
%CREATE_SOUND Creates a sound
%   Creates a sound waveform of a specified note(s) 
%   based on instrument/time specifications

switch instrument.sound
    case {'Additive'}
        AMP = [1, 0.67, 1, 1.8, 2.76, 1.67, 1.46, 1.33, 1.33, 1, 1.33]'
        DUR = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075]'
        FRQ = [0.56, 0.56 + i, 0.92 + 1.7i, 1.19, 0.7, 2, 2.74, 0.3, 3.76, 4.07].'
        
        narray = zeros(length(notes),instrument.totalTime);
        for n = 1:length(notes)
           note = notes{n};
           tone = zeros(11,note.duration)
           for m = 1:11
               dur = note.duration*DUR(m);
               tone(m,1:dur) = (0:dur)/constants.fs;
           end
           tone = note2freq(note.note,constants.notes)*tone.*real(FRQ)+imag(FRQ);
           tone = sum(AMP.*sin(2*pi*tone))
           narray(n,1+note.start:note.duration+1) = tone;
        end
        sound = sum(narray,1);
    
    case {'Subtractive'}
        sound = [1]
    case {'FM'} 
        sound = [1]
    case {'Waveshaper'}
        sound = [1]
        
end


end

