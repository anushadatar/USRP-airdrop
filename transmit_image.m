function[] = transmit_image(image_file, tx_filename)
% TODO: Remove image size
[im_size, packet] = photo2data(image_file);
% compress
compressed_data = compress(packet);
% add redundancy and known bits
prepared_data = prepare_data_for_transmission(compressed_data);
% save file somewhere send over channel
write_usrp_data_file_function(prepared_data, tx_filename);
end