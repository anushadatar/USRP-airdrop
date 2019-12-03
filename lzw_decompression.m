input = '1036045328';
ocode = str2double(input(1));
keySet = {'a' 'b' 'd' 'n' '_'};
valueSet = [0 1 2 3 4];
lzw_dict = containers.Map(valueSet, keySet);
decoded = lzw_dict(ocode);
char = '';
val = 4;

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
