function newCell = str2cells(someString)

someString=strtrim(someString);

spaces=isspace(someString);

idx=0;
while sum(spaces)~=0
    idx=idx+1;
    newCell{idx}=strtrim(someString(1:find(spaces==1,1,'first')));
    someString=strtrim(someString(find(spaces==1,1,'first')+1:end));
    spaces=isspace(someString);
end
newCell{idx+1}=someString;