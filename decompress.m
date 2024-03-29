function  decompressed_data = decompress(input)
    % Decompresses bitstream using Lempel-Ziv compression algorithm. 
    % Input:  input             = Compressed bitstream to decompress.
    % Output: decompressed_data = Decompressed image bitstream.
    
    % Initialize dictionary and variables.
    keySet = {'0' '1'};
    valueSet = [0 1];
    lzw_dict = containers.Map(valueSet, keySet);
    char = '';
    val = 1;
    b_len = 13; % Length of binary string.
    
    % 1. input first code, store in OCODE
    ocode_b = input(1:b_len);
    ocode = bi2de(ocode_b, 'left-msb');
    % 2. output translation of OCODE
    decoded = lzw_dict(ocode);

    for i = 2:(length(input)/b_len)
        % 3. input next code, store in NCODE
        ncode_b = input((i-1)*b_len+1:i*b_len);
        ncode = bi2de(ncode_b, 'left-msb');

        % 4. is NCODE in table?
        if isKey(lzw_dict, ncode) % yes
            % 7. STRING = translation of NCODE
            string_ = lzw_dict(ncode);
        else % no
            % 5. string = translation of OCODE
            string_ = lzw_dict(ocode);
            % 6. STRING = STRING+CHAR
            string_ = strcat(string_, char);
        end
        
        % 8. output STRING
        decoded = strcat(decoded, string_);
        % 9. CHAR = the first character in STRING
        char = string_(1);
        % 10. add entry in table for OCODE + CHAR
        lzw_dict(val+1) = strcat(lzw_dict(ocode), char);
        % 11. OCODE = NCODE
        ocode = ncode;
        val = val+1;
    end
    
    % Turn the decoded string into an array.
    decompressed_data = zeros(size(decoded));
    for i = 1:length(decoded)
        decompressed_data(i) = str2double(decoded(i));
    end
end
