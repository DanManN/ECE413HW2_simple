function [sound] = create_sound(instrument,notes,constants)
%CREATE_SOUND Creates a sound
%   Creates a sound waveform of a specified note(s) 
%   based on instrument/time specifications

narray = zeros(length(notes),instrument.totalTime);

switch instrument.sound
    case {'Additive'}
        
        AMP = [1, 0.67, 1, 1.8, 2.76, 1.67, 1.46, 1.33, 1.33, 1, 1.33]';
        DUR = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075]';
        FRQ = [0.56, 0.56 + i, 0.92, 0.92 + 1.7i, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07].';
        
        for n = 1:length(notes)
           note = notes{n};
           freq = note2freq(note.note,constants.notes);
           tone = zeros(11,note.duration);
           for m = 1:11
               dur = note.duration*DUR(m)
               decay = linspace(1,0,dur/2);
               tone(m,1:dur) = (1:dur)/constants.fs;
               tone(m,:) = freq*tone(m,:).*real(FRQ(m))+imag(FRQ(m));
               tone(m,:) = AMP(m)*sin(2*pi*tone(m,:));
               tone(m,dur-length(decay)+1:dur) = tone(m,dur-length(decay)+1:dur).*decay;
           end
           narray(n,1+note.start:note.duration) = sum(tone);
        end
    
    case {'Subtractive'}
        
        freq = 100;
        frame = 1024;
        oscil = sawtooth(2*pi*freq*(0:frame-1)/constants.fs)';
        
        for n = 1:length(notes)
            note = notes{n};
            center = note2freq(note.note,constants.notes);
            dur = note.duration;
            fadein = linspace(0,1,dur/2);
            vbw = dsp.VariableBandwidthFIRFilter(...
                    'FilterType','Bandpass',...
                    'FilterOrder',500,...
                    'SampleRate',constants.fs,...
                    'CenterFrequency',center,...
                    'Bandwidth',center/4,...
                    'Window','Chebyshev'...
                    );
            tone = zeros(1,dur);
            ind = 1;
            for ii=linspace(center*0.7,center*1.1,dur/frame)
                tone(ind:ind+frame-1) = vbw(oscil);
                ind = ind+frame;
                vbw.CenterFrequency = ii;
            end
            tone(1:length(fadein)) = tone(1:length(fadein)).*fadein;
            narray(n,1+note.start:dur) = tone;
        end
        
    case {'FM'}
        
        fc_fm = 1;
        IMAX = 5/(2*pi*100);
        
        for n = 1:length(notes)
            note = notes{n};
            fc = note2freq(note.note,constants.notes)
            fm = fc/fc_fm;
            dur = note.duration;
            t = 1:dur;
            f1 = [linspace(0,1,dur/8), linspace(1,0.75,dur/8), 0.75*ones(1,dur/2), linspace(0.75,0,dur/4)];
            f2 = f1;
            tone = f1.*cos(2*pi*(IMAX*fm*f2.*cos(2*pi*fm*t)+fc));
            narray(n,1+note.start:dur) = tone;
        end

    case {'Waveshaper'}
        
end

sound = sum(narray,1);

end

