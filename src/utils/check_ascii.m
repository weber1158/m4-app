function bool = check_ascii(fullpath_to_file)
%Return whether file contains non-ASCII characters
%
%Syntax
% bool = CHECK_ASCII(full_path_to_file)
%

txt = fileread(fullpath_to_file);
charCodes = double(txt);
isASCII = (charCodes >= 32 & charCodes <= 126) | charCodes == 9 | charCodes == 10 | charCodes == 13;
bool = any(~isASCII);

end