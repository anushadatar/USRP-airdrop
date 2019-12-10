function prepared_data = pack_data(compressed_data)
    % add known bits and pad end with 0s
    final_length = 100000;
    known_data = ones(1,200);
    known_compressed = [known_data compressed_data];
    prepared_data = [known_compressed zeros(1,final_length-length(known_compressed))];
end
