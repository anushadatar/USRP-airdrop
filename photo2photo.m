%tests conversion from color image to sendable packet and then
%recontruction from packet
[im_size, packet] = photo2data('color_chicken.png') %works
com_p = compress(packet) %debatable
decom_p = decompress(com_p) %debatable
data2photo(packet) %works