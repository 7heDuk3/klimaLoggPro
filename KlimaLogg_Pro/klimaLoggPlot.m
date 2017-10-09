clear all

filename = "KlimaLoggPro.txt";
fileTest = "test.txt";
fileID = fopen(filename);

sensorNodes = 3;
dataSources = 3 + 1;

%throw = fscanf(fileID, '%s');
%fullString = textscan(fileID, '%s');

testString = fscanf(fileID, '%s')
%fullString = textscan(fileID, '%s', 'Delimiter', ';')

%fullIncJunk = cell2struct(fullString);

%length = size(fullString)

testString(regexp(testString,'[",;, ]'))=[' ']

testString(regexp(testString,'[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z]')) = [ ]

[dim, length] = size(testString)

nums = zeros(length,1);

j = 1;
u = 25;

numProp = isstrprop(testString, 'digit');
idx = find(numProp);

[dontCare, floatL] = size(idx);
timeDateCount = 0;

for k = 1:floatL
    if u <= k
        if (testString(idx(u) + 4) == '-') && (testString(idx(u) + 7) == '-')
            u = u + 14;
            timeDateCount = timeDateCount + 1;
        else
            if testString(idx(u) + 1) == '.'
                testString(idx(u):(idx(u) + 2));
                nums(j) = str2double(testString(idx(u):(idx(u)+2)));
                u = u + 2;
                j = j + 1;
            else
                if testString(idx(u) + 2) == '.'
                    testString(idx(u):(idx(u) + 3));
                    nums(j) = str2double(testString(idx(u):(idx(u)+3)));
                    u = u + 3;
                    j = j + 1;
                else
                    nums(j) = str2double(testString(idx(u):(idx(u)+1)));
                    j = j + 1;
                    u = u + 2;
                end
            end
        end
    end
end

nNumsTot = j - 1;
nNums = nNumsTot / (3 * dataSources);

% VISSA MÄTNINGAR SAKNAS => 
% * nNumsTot blir ej jämnt delbart med 3 * dataSources


tempMatrix = zeros(timeDateCount, dataSources);
rhMatrix = zeros(timeDateCount, dataSources);
dewMatrix = zeros(timeDateCount, dataSources);

tempIdx = 1;
rhIdx = 2;
dewIdx = 3;
a4 = 1;

for k = 1:timeDateCount
    for m = 1:dataSources
        tempMatrix(k, m) = nums(tempIdx);
        rhMatrix(k, m) = nums(rhIdx);
        dewMatrix(k, m) = nums(dewIdx);
        
        tempIdx = tempIdx + 3;
        rhIdx = rhIdx + 3;
        dewIdx = dewIdx + 3;
    end
end

testString(50:100)

% make string array of size timeDateCount
dateTime = strings(timeDateCount, 1);

u = 25;
j = 1;

for k = 1:floatL
    if j > timeDateCount
        break;
    end
    
    if (testString(idx(u) + 4) == '-') && (testString(idx(u) + 7) == '-')
        dateTime(j,1) = testString(idx(u):(idx(u)+9))+" "+testString((idx(u)+10):(idx(u)+14));
        u = u + 14;
        j = j + 1;
    else
        u = u + 1;
    end
end

plot(tempMatrix(:, 1))
hold on
plot(tempMatrix(:, 2))
plot(tempMatrix(:, 3))
plot(tempMatrix(:, 4))
set(gca,'xticklabel', dateTime)

plot(rhMatrix(:, 1))
hold on
plot(rhMatrix(:, 2))
plot(rhMatrix(:, 3))
plot(rhMatrix(:, 4))
set(gca,'xticklabel', dateTime)

plot(dewMatrix(:, 1))
hold on
plot(dewMatrix(:, 2))
plot(dewMatrix(:, 3))
plot(dewMatrix(:, 4))
set(gca,'xticklabel', dateTime)

