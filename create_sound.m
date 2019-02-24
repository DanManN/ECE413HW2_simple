function [sound] = create_sound(instrument,notes,constants)
%CREATE_SOUND Creates a sound
%   Creates a sound waveform of a specified note(s) 
%   based on instrument/time specifications

if length(notes) == 1
    notes = {notes};
end

root = '';
scale = '';
if startsWith(instrument.temperament,'Just')
    root = notes{1}.note;
    scale = instrument.mode;
end

narray = zeros(length(notes),instrument.totalTime);

switch instrument.sound
    
    case {'Additive'}
        
        % Bell, fade out
        AMP = [1, 0.67, 1, 1.8, 2.76, 1.67, 1.46, 1.33, 1.33, 1, 1.33]';
        DUR = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075]';
        FRQ = [0.56, 0.56 + i, 0.92, 0.92 + 1.7i, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07].';
        for n = 1:length(notes)
           note = notes{n};
           freq = note2freq({note.note,root,scale},constants.notes);
           tone = zeros(11,note.duration);
           for m = 1:11
               dur = floor(note.duration*DUR(m));
               decay = linspace(1,0,dur/2);
               tone(m,1:dur) = (1:dur)/constants.fs;
               tone(m,:) = freq*tone(m,:).*real(FRQ(m))+imag(FRQ(m));
               tone(m,:) = AMP(m)*cos(2*pi*tone(m,:));
               tone(m,dur-length(decay)+1:dur) = tone(m,dur-length(decay)+1:dur).*decay;
           end
           narray(n,1+note.start:note.duration) = sum(tone);
        end
    
    case {'Subtractive'}
        
        % Sawtooth, slow open, fade in
        freq = 100;
        frame = 1024;
        oscil = sawtooth(2*pi*freq*(0:frame-1)/constants.fs)';
        vbw = dsp.VariableBandwidthFIRFilter(...
                'FilterType','Bandpass',...
                'FilterOrder',500,...
                'SampleRate',constants.fs,...
                'CenterFrequency',440,...
                'Bandwidth',440/8,...
                'Window','Chebyshev'...
                );
        for n = 1:length(notes)
            note = notes{n};
            center = note2freq({note.note,root,scale},constants.notes);
            dur = note.duration;
            fadein = linspace(0,1,dur/2);
            tone = zeros(1,dur);
            ind = 1;
            vbw.Bandwidth = center/16;
            for ii=linspace(center*0.8,center,dur/frame)
                vbw.CenterFrequency = ii;
                tone(ind:ind+frame-1) = vbw(oscil);
                ind = ind+frame;
            end
            tone(1:length(fadein)) = tone(1:length(fadein)).*fadein;
            narray(n,1+note.start:dur) = tone*10^(center/freq);
        end
        
    case {'FM'}
        
        % Trumpet
        fc_fm = 1;
        IMAX = 1/2;
        for n = 1:length(notes)
            note = notes{n};
            fc = note2freq({note.note,root,scale},constants.notes);
            fm = fc/fc_fm;
            dur = note.duration;
            t = (1:dur)/constants.fs;
            f1 = [linspace(0,1,floor(dur/8)),...
                  linspace(1,0.75,floor(dur/8)),...
                  0.75*ones(1,floor(dur/2)),...
                  linspace(0.75,0,floor(dur/4))];
            f1 = [f1, zeros(1,dur-length(f1))];
            f2 = f1;
            tone = f1.*cos(2*pi*(IMAX*f2.*cos(2*pi*fm*t)+fc.*t));
            narray(n,1+note.start:dur) = tone;
        end

    case {'Waveshaper'}
        
        % Clarinet
        Fx=@(x) (x<=200).*(x/400 - 1)...
              + (x>200&x<311).*(x/112 - 16/7)...
              + (x>=311).*(x/400 - 111/400);
        for n = 1:length(notes)
            note = notes{n};
            freq = note2freq({note.note,root,scale},constants.notes);
            dur = note.duration;
            t = (1:dur)/constants.fs;
            env = 255*[linspace(0,1,floor(dur*0.002)),...
                       linspace(1,0.75,floor(dur*.085)),...
                       0.75*ones(1,floor(dur*0.763)),...
                       linspace(0.75,0,floor(dur*0.15))];
            env = [env, zeros(1,dur-length(env))];
            tone = env.*cos(2*pi*freq*t)+256;
            narray(n,1+note.start:dur) = Fx(tone);
        end
        
    otherwise
        
        %Pure
         for n = 1:length(notes)
            note = notes{n};
            freq = note2freq({note.note,root,scale},constants.notes);
            dur = note.duration;
            t = (1:dur)/constants.fs;
            narray(n,1+note.start:dur) = cos(2*pi*freq*t);
         end
        
end

sound = sum(narray,1);

end

