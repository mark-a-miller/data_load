function [afdata] = xfoilpolar2(folder, varargin)
%Read in XFOIL Formatted airfoil data sets
%   You may either input no location and manually select data or specify
%   location via:
%   folder  = base folder location of airfoil data
%   varargin  = extension and/or airfoil name (used as file locator)
%   NOTES: multiple input filenames can be specified in varargin, use a
%   cell array.

if nargin == 1 %find file in given folder:
   [inpafname,folder] = uigetfile({'*.dat', 'Data Files';...
       '*.polar', 'Polar Files'},... 
       'Select airfoil file to load:',folder, 'MultiSelect','on');
   %Build full pathnames
    ff = fullfile(folder,inpafname);
    if ischar(ff)==1; ff= {ff}; end
    
elseif nargin == 2
    inpafname = varargin{:};
    %Build pathnames based on manual user input list, inpafname may contain
    %path snippets, so create a new fullfolder list
    m = 0; ff=cell(1,1);
    for k = 1:numel(inpafname)
    %fname may contain path snippets, combine each:
    [cfold, cname,~] = fileparts(fullfile(folder,inpafname{k}));
    %Search for any files containing this: %
    filekey = fullfile(cfold,['*' cname '*']);
    D = dir(filekey) ;
    if isempty(D)
        warning('No matching filenames found!')
        disp(['Filekey used: ' filekey])
        return
    else
        m=m+1;
        ff{m} = fullfile(D.folder,D.name);
    
    end
    end
    
else
    warning('Inputs not correct!')
    return
end

%separate out full path from file name%
% [fullfold, afname,~] = fileparts(fullfile(folder,inpafname));


afdata = struct('name','','path','','Re',[],'Ncrit',[],...
                'xtr_top',[],'xtr_bot',[],'Mach',[],...
                'alpha',[],'Cl',[],'Cd',[],'Cm',[],...
                'CDp',[],'Top_Xtr',[],'Bot_Xtr',[]) ;
%Load in and process each data set%
for j = 1:numel(ff)
    [cfold, cname,~] = fileparts(ff{j});
    afdata(j).name = cname;
    afdata(j).path = cfold;
    %Load in data%
    [fid,message] = fopen(ff{j},'r'); 
    disp(message)
    df = textscan(fid,'%s',...
                  'HeaderLines',1,'delimiter',' ',...
                  'MultipleDelimsAsOne',1) ;
    fclose(fid);
    df = df{1};
    %Find Reynolds Number%
    Reind = find(strcmp(df,'Re')) ;
    Re1 = str2double(df{Reind+2}) ;
    Re2 = str2double(df{Reind+4}) ;
    afdata(j).Re = Re1 .* 10.^ Re2 ;
    %Find Ncrit%
    Ncritind = find(strcmp(df,'Ncrit'));
    afdata(j).Ncrit = str2double(df{Ncritind+2});
    %Find Mach #%
    Maind = find(strcmp(df,'Mach')); 
    afdata(j).Mach = str2double(df{Maind(2)+2});%Note repeated key
    %Find Top and Bottom Transition Points%
    xtrfind = find(strcmp(df,'xtrf'));
    afdata(j).xtr_top = str2double(df{xtrfind+2});
    afdata(j).xtr_bot = str2double(df{xtrfind+4});
    %Find Number of columns%
    colind = find(contains(df,'------'));
    ncol = colind(end) - colind(1) + 1; %Number of columns
    stdat = colind(end) + 1; %Data start location
    
    %Generate indices for linear data array to output%
    alphaind = stdat:ncol:numel(df);
    Clind    = stdat+1:ncol:numel(df);
    Cdind    = stdat+2:ncol:numel(df);
    Cdpind   = stdat+3:ncol:numel(df);
    Cmind    = stdat+4:ncol:numel(df);
    xtind    = stdat+5:ncol:numel(df);
    xbind    = stdat+6:ncol:numel(df);
    
    for k = 1:numel(alphaind)
    afdata(j).alpha(k,1) = str2double(df{alphaind(k)});
    afdata(j).Cl(k,1)    = str2double(df{Clind(k)});
    afdata(j).Cd(k,1)    = str2double(df{Cdind(k)});
    afdata(j).Cm(k,1)    = str2double(df{Cmind(k)});
    afdata(j).CDp(k,1)   = str2double(df{Cdpind(k)});
    afdata(j).Top_Xtr(k,1)   = str2double(df{xtind(k)});
    afdata(j).Bot_Xtr(k,1)   = str2double(df{xbind(k)});
    end
    
    clear df

%     
end








end

