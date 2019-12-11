function [trimmed_rotated,rotate_angle] = rotate_dat(unsmeared_dat)
%FIND_ROTATE finds the rotated angle of the known bits at the beginning of
%transmission. Return angle and datas
%   Detailed explanation goes here
%unsmeared_dat
known = unsmeared_dat(1:10000)
est_known = mean(known)
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
  trimmed_rotated=unsmeared_dat.*exp(1i*angle);
  

end

