function [maxsamples] = find_length_of_notes(notes)
%FIND_LENGTH_OF_NOTES find the length of notes
%   in samples

maxsamples = 0;
for n=1:length(notes)
    if notes{n}.start + notes{n}.duration > maxsamples
        maxsamples = notes{n}.start + notes{n}.duration;
    end
end

