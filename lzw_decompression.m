input = '1036045328';
ocode = str2double(input(1));
keySet = {'a' 'b' 'd' 'n' '_'};
valueSet = [0 1 2 3 4];
lzw_dict = containers.Map(valueSet, keySet);
decoded = lzw_dict(ocode);
char = '';

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
    lzw_dict(strcat(ocode, str2double(char))) = string; % this line doesn't work yet
    ncode = ocode;
end