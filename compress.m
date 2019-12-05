function  compressed_data = compress(packet)
    input = packet; %might not work for binary 
    string = input(1);
    keySet = {'0' '1'};
    valueSet = [0 1];
    val = 1;
    encoded = '';
    lzw_dict = containers.Map(keySet, valueSet);

    for i = 2:length(input)
       char = input(i);
       if isKey(lzw_dict, strcat(string, char))
           string = strcat(string, char);
       else
           encoded = strcat(encoded,int2str(lzw_dict(string)));
           lzw_dict(strcat(string, char)) = val+1;
           string = char;
           val = val+1;
       end
    end

    encoded = strcat(encoded,int2str(lzw_dict(string)));
    compressed_data = encoded
end