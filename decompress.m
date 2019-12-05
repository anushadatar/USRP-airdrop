function  decompressed_data = decompress(packet)
    input = packet; %might not work for binary
    ocode = str2double(input(1));
    keySet = {'0' '1'};
    valueSet = [0 1 2 3 4];
    lzw_dict = containers.Map(valueSet, keySet);
    decoded = lzw_dict(ocode);
    char = '';
    val = 1; %might be wrong ask viv

    for i = 2:strlength(input)
        ncode = str2double(input(i));

        if isKey(lzw_dict, ncode)
            string = lzw_dict(ncode);
        else
            string = lzw_dict(ocode);
            string = strcat(string, char);
        end

        decoded = strcat(decoded, string);
        char = string(1);
        lzw_dict(val+1) = strcat(lzw_dict(ocode), char);
        ocode = ncode;
        val = val+1;
    end
    decompressed_data = decoded
end
