function [sound] = create_sound(instrument,notes,constants)
%CREATE_SOUND Creates a sound
%   Creates a sound waveform of a specified note(s) 
%   based on instrument/time specifications

decay = 10.^(0:-0.1:-1000);

switch instrument.sound
    case {'Additive'}
        AMP = [1, 0.67, 1, 1.8, 2.76, 1.67, 1.46, 1.33, 1.33, 1, 1.33]';
        DUR = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075]';
        FRQ = [0.56, 0.56 + i, 0.92, 0.92 + 1.7i, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07].';
        
        narray = zeros(length(notes),instrument.totalTime);
        for n = 1:length(notes)
           note = notes{n};
           freq = note2freq(note.note,constants.notes);
           tone = zeros(11,note.duration);
           for m = 1:11
               dur = note.duration*DUR(m)
               tone(m,1:dur) = (1:dur)/constants.fs;
               tone(m,:) = freq*tone(m,:).*real(FRQ(m))+imag(FRQ(m));
               tone(m,:) = AMP(m)*sin(2*pi*tone(m,:));
               %tone(m,dur-length(decay)+1:dur) = tone(m,dur-length(decay)+1:dur).*decay;
           end
           narray(n,1+note.start:note.duration) = sum(tone);
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

