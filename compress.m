function  compressed_data = compress(packet)
    % compresses bitstream
    % input: bitstream 
    % output: bitstream

    % finagle packet array into string
    input = join(string(packet), '');
    input = input{1};
    
    % initialize dictionary and variables
    keySet = {'0' '1'};
    valueSet = [0 1];
    lzw_dict = containers.Map(keySet, valueSet);
    val = 1;    % value of last key in dictionary
    encoded = '';
    b_len = 13;  % length of binary string
    
    % 1. input first byte, store in STRING
    string_ = input(1);

    for i = 2:length(input)
       % 2. input next byte, store in CHAR
       char = input(i);
       
       % 3. is STRING+CHAR in dictionary?
       if isKey(lzw_dict, strcat(string_, char)) % yes
           % 7. STRING = STRING+CHAR
           string_ = strcat(string_, char);

       else % no
           % finagle integer into [bin_bits]-bit binary string
           int_ = lzw_dict(string_);
           bin_ = de2bi(int_, b_len, 'left-msb');
           str_ = string(bin_);
           str_joined = join(str_, '');
           str_joined = str_joined{1};
           
           % 4. output the code for STRING
           encoded = strcat(encoded,str_joined);
           % 5. add entry in dictionary for STRING+CHAR
           lzw_dict(strcat(string_, char)) = val+1;
           % 6. STRING = CHAR
           string_ = char;
           val = val+1;
       end
    end
    
    % finagle integer into [bin-bits]-bit binary string
	int_ = lzw_dict(string_);
    bin_ = de2bi(int_, b_len, 'left-msb');
    str_ = string(bin_);
    str_joined = join(str_, '');
    str_joined = str_joined{1};
    
    % 9. output the code for STRING
    encoded = strcat(encoded,str_joined);
    
    % turn encoded string into array
    compressed_data = [];
    for i = 1:length(encoded)
        compressed_data(i) = str2double(encoded(i));
    end
end
