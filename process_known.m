function  [filtered_data, rotate_angle] = process_known(datastream)
%function inputs recieved raw data and ouputs cleaned data with front end
%noise removed and "known bits" removed. It also outputs the angle in which
%the data is rotated in the constellation for future correction. 
%input:  raw data stream. Vector 1xN
%   
%output: 
%  filetered data:  vector 1xM
%  rotate_angle: angle in radians