function [trimmed_rotated,rotate_angle] = rotate_dat(unsmeared_dat)
    % Rotate the data based on the offset of the known bits. 
    % Input:  unsmeared_data  = Recevied data corrected for frequency error.
    % Output: trimmed_rotated = Data rotated 
    %         rotate_angle    = Angle that the constellation is rotated by.

    known = unsmeared_dat(1:10000);
    est_known = mean(known);
    
    % Find angle of rotation of known bits.
    if real(est_known) > 0
        if imag(est_known) > 0
            angle = 0;
        else
            angle = -3*pi/2;
        end
    else
        if imag(est_known) > 0
            angle = -pi/2;
        else
            angle = -pi;
        end
    end
    rotate_angle = angle;
    % Actually rotate the data.
    trimmed_rotated=unsmeared_dat.*exp(1i*angle);
end