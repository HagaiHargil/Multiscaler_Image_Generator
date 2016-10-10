clearvars;
fileName = 'C:\Users\Hagai\Documents\GitHub\Multiscaler_Image_Generator\Update\live mouse  100 um deep with 62p TAG010.lst';

% fileID = fopen(fileName, 'rt'); % t was added for text mode, to delete \r. Not necessary when using linux.
% fseek(fileID, 1549, 'bof');
% disp('Using only fread:');
% tic;
% A = fread(fileID, [12 inf], '12*char=>char', 1);
% toc;
% fclose(fileID);
% clearvars;

% fileID = fopen(fileName, 'rt'); % t was added for text mode, to delete \r. Not necessary when using linux.
% fseek(fileID, 1549, 'bof');
% disp('Using fread and regexp:');
% tic;
% A3 = fread(fileID, [1 inf], 'char=>char');
% C = regexp(A3, '\n', 'split');
% toc;
% fclose(fileID);
% clearvars;

% fileID = fopen(fileName, 'rt'); % t was added for text mode, to delete \r. Not necessary when using linux.
% fseek(fileID, 1549, 'bof');
% disp('Using fread and textscan:');
% tic;
% A2 = fread(fileID, [1 inf], 'char=>char');
% B = textscan(A2, '%s', 'delimiter', sprintf('\n'));
% toc;
% fclose(fileID);
% clearvars;

f = py.open(fileName, 'r');
f.seek(1549)
disp('Using Pythons splitlines method:');
tic;
P = f.read();
P2 = P.splitlines();
toc;
f.close()
% 
% 
% f = py.open(fileName, 'r');
% f.seek(1549)
% disp('Using Pythons readlines method:');
% tic;
% L = f.readlines();
% toc;
% f.close()

