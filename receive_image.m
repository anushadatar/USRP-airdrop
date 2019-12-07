function[] = receive_image(rx_filename)
    unpacked_data = unpack_data(rx_filename);
    decompressed_data = decompress(unpacked_data);
    data2photo(decompressed_data);
end