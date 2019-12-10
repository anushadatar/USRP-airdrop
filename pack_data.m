function prepared_data = pack_data(compressed_data)
    % add known bits and pad end with 0s
    final_length = 100000;
    known_data = ones(1,200);
    compressed_length = de2bi(length(compressed_data), 20, 'left-msb');
    known_compressed = [known_data compressed_length compressed_data];
    prepared_data = [known_compressed zeros(1,final_length-length(known_compressed))];
    % 1:200 - known data (1s)
    % 201:220 - length of compressed data (in binary)
    % 221:(220+length(compressed_data)) - compressed data
    % rest is padding (0s)
end
