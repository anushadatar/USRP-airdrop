input = 'banana_bandana';
string = input(1);
keySet = {'a' 'b' 'd' 'n' '_'};
valueSet = [0 1 2 3 4];
val = 4;
encoded = '';
lzw_dict = containers.Map(keySet, valueSet);

for i = 2:strlength(input)
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