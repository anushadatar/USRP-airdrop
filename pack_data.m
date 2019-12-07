function prepared_data = pack_data(compressed_data)
    % repeat each bit 3 times for redundancy
    prepared_data = repelem(compressed_data,3);
end 
