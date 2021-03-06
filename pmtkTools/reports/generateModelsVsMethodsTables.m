function generateModelsVsMethodsTables()
%% Make the models vs methods tables
%
%PMTKneedsMatlab

% This file is from pmtk3.googlecode.com


[basic, supervised, latent, graphical] = classNameMappings();

titles = {
    'Basic Models'    
    'Supervised Models'
    'Latent Variable Models'
    'Graphical Models'
    };

outputFiles = {
    'basicModels.html'
    'supervisedModels.html'
    'latentModels.html'
    'graphicalModels.html'
    };

outputDir          = fullfile(pmtk3Root, 'docs', 'modelsByMethods'); 
exceptionThreshold = 2; % 'methods' must occur strictly more than exceptionThreshold times to appear as a separate column
excludedDirs = {
    'sub'
    'Variable_selection'
    'svmFunctions'
    'linregRobustStudent'
    'Algorithms'
    };
%%
outputFiles        = cellfuncell(@(f)fullfile(outputDir, f), outputFiles);
allModels          = [basic; supervised; latent; graphical]; 
modelClasses       = {basic, supervised, latent, graphical};
%%
rootDir   = fullfile(pmtk3Root(), 'toolbox'); 
allFiles  = filelist(rootDir);
check     = @(f)isempty(intersect(excludedDirs, pathFolders(f)));
files     = allFiles(cellfun(check, allFiles));
allModels = sortfun(@(x)length(x), allModels);
allModels = allModels(end:-1:1); 
fnames    = fnameOnly(files);
mStruct   = createStruct(allModels); 
remaining = true(numel(fnames), 1); 
for i = 1:numel(allModels)
    m              = allModels{i}; 
    mStrLen        = length(m); 
    ndx            = strncmpi(m, fnames, mStrLen) & remaining;
    remaining(ndx) = false;
    funcs          = cellfuncell(@(f)f(mStrLen+1:end), fnames(ndx)); 
    mStruct.(m)    = funcs; 
end

for i = 1:numel(modelClasses)
    models = modelClasses{i};
    [umodels, umethods, table] = aggregate(structSubset(mStruct, models)); 
    printReport(umodels, umethods, table, exceptionThreshold, titles{i}, outputFiles{i}); 
end

end

function [umodels, umethods, table] = aggregate(S)
%% Aggregate the data in the model class struct S
m         = struct2cell(S);
methods   = vertcat(m{:});
umethods  = unique(methods); 
umodels   = fieldnames(S); 
modelMap  = enumerate(umodels);
methodMap = enumerate(umethods);
table     = zeros(numel(umodels), numel(umethods));
for i = 1:numel(umodels)
   model = umodels{i};
   meths = S.(model); 
   for j = 1:numel(meths)
      table(modelMap.(model), methodMap.(meths{j})) = 1;  
   end
end
end

function printReport(umodels, umethods, table, exceptionThreshold, title, outputFile)
%% Print the html report

count = sum(table);
exceptions = count <= exceptionThreshold;

colNames = umethods(~exceptions);
rowNames = umodels;
data = repmat({'N'}, numel(rowNames), numel(colNames));
dataColors = repmat({'#DCDCDC'}, numel(rowNames), numel(colNames));
data(logical(table(:, ~exceptions))) = {'Y'};
dataColors(logical(table(:, ~exceptions))) = {'lightgreen'};

%% add exceptions
exceptionTxt = gatherExceptions(umodels, umethods, table, exceptionThreshold);
colNames = [rowvec(colNames), {'Exceptions'}];
data = [data, exceptionTxt];
dataColors = [dataColors, repmat({'#F0FFFF'}, numel(rowNames), 1)];

pmtkRed = getConfigValue('PMTKred');
header = formatHtmlText(...
{
'<font align="left" style="color:%s"><h2>PMTK: %s</h2></font>'
'Auto-generated by %s.m'
''
'Revision Date: %s'
''
''
''
}, pmtkRed, title, mfilename, date);

len = cellfun('length', colNames);
maxNlen = max(len);
for i=1:numel(colNames)
    name = colNames{i};
    l = len(i);
    pad = repmat('&nbsp;', 1, ceil((maxNlen + 4 - l)/2));
    name = sprintf('%s%s%s',pad, name, pad);
    colNames{i} = name;
end
headerColor = '#F0FFFF';
rowNameColors = repmat({headerColor}, numel(rowNames), 1);
colNameColors = repmat({headerColor}, numel(colNames), 1);
%% create table
htmlTable(  'data'          , data                         , ...
            'header'        , header                       , ...
            'dataAlign'     , 'center'                     , ...
            'rowNames'      , rowNames                     , ...
            'colNames'      , colNames                     , ...
            'doSave'        , true                         , ...
            'filename'      , outputFile                   , ...
            'doShow'        , false                        , ...
            'dataColors'    , dataColors                   , ...
            'dataValign'    , 'center'                     , ...
            'colNameColors' , colNameColors                , ...
            'rowNameColors' , rowNameColors)
end

function exceptionTxt = gatherExceptions(umodels, umethods, table, thresh)
%% Create the text for the exception column of a report
exceptionNdx = sum(table) <= thresh;
exceptionTxt = cell(numel(umodels), 1);
for i=1:numel(umodels)
    exceptionTxt{i} = formatHtmlText(umethods(exceptionNdx & table(i, :)));
end
end
