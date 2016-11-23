function [results, gtMats, dtMats, gtIndex, exps] = evalAll(detectionFiles, algNames, gtDirBase, varargin)
% [results, gtMats, dtMats, gtIndex, exps] = evalAll(detectionFiles, algNames, gtDirBase, ...)
%
% (Required) Inputs:
%  detectionFiles   Cell array of paths to detection files to evaluate
%  algNames         Array of names for each detection file for plotting.
%                   Defaults to names of detection files if empty.
%  gtDirBase        Base directory of database contents. Ground truth will
%                   be read from [gtDirBase '/' evalSet
%                   '/collected/AnnotationsPositiveNegative'].
%
% (Optional) Parameters <default>:
%  indexFileOut     Path to file to which to write indexing of images being
%                   evaluated. <[]>
%  gtCache          Path to location to write ground truth data to, for
%                   loading (faster operation) on subsequent calls. Ignored
%                   if empty <[]>
%  evalSet          Database subset to evaluate on. <'test'>
%  plotRocs         Whether to plot ROC curves <0>
%
% Outputs:
%  -- Sizes below refer to 
%    nExp  = number of experiments being run
%    nAlgs = number of detection files provided
%  results          Struct array of results needed for ROC plots, size
%                   [nExp nAlgs]. Contains fields
%    .fp            False positive rate per score (ROC x-vals)
%    .tp            True positive rate per score (ROC y-vals)
%    .score         Detection scores (threshold) for each data point above
%    .ref           TP rate at reference FP values 10.^(-2:.25:0), for
%                   computing mean accuracy
%  gtMats           Cell array of loaded ground truth data (size nExp)
%  dtMats           Cell array of loaded detections (size nAlgs)
%  gtIndex          Cell array of file names of images, for verifying
%                   iteration order
%  exps             Array of experiment configurations

p = inputParser;
p.addParameter('indexFileOut', []);
p.addParameter('gtCache', []);
p.addParameter('evalSet', 'test');
p.addParameter('plotRocs', 0);
p.parse(varargin{:});
res = p.Results;

indexFileOut = res.indexFileOut;
gtCache = res.gtCache;
evalSet = res.evalSet;
plotRocs = res.plotRocs;

nAlgs = numel(detectionFiles);
if isempty(algNames)
  algNames = cell(1, nAlgs);
  for ix = 1:nAlgs
    [~, algNames{ix}] = fileparts(detectionFiles{ix});
  end
end

gtDir = fullfile(gtDirBase, evalSet, 'collected', 'AnnotationsPositiveNegative');

baselineFilters = {@filterData_occPartialAndUnoccluded};

exps = {
  'Baseline',     baselineFilters
  'Env=Orange',   {baselineFilters{:}, @filterData_envOrangeOnly}
  'Env=Apple',    {baselineFilters{:}, @filterData_envAppleOnly}
  'All',          {@filterData_occIncludeAll}
  'Occ=Clear',    {@filterData_occUnoccludedOnly} 
  'Occ=Partial',  {@filterData_occPartialOnly} 
  'Occ=Heavy',    {@filterData_occHeavyOnly} 
  'Scale=Large',  {baselineFilters{:}, @filterData_scaleLargeOnly}
  'Scale=Medium', {baselineFilters{:}, @filterData_scaleMediumOnly}
  'Scale=Small',  {baselineFilters{:}, @filterData_scaleSmallOnly}
  'Pose=Typical', {baselineFilters{:}, @filterData_unusualPosesOut} 
  'Pose=Unusual'  {baselineFilters{:}, @filterData_unusualPosesOnly} 
  'Motion=Static',{baselineFilters{:}, @filterData_movingPeopleOut} 
  'Motion=Moving',{baselineFilters{:}, @filterData_movingPeopleOnly} 
  };
nExps = size(exps, 1);

% -- Load ground truth data

% Load cached ground truth if available
if not(isempty(gtCache)) && exist(gtCache, 'file')
  loaded = load(gtCache);
  gtMats  = loaded.gtMats;
  gtIndex = loaded.gtIndex;
end

% Generate ground truth data matrix if it wasn't loaded
if not(exist('gtMats', 'var'))
  gtMats = cell(1, nExps);
  for expNum = 1:nExps
    pLoad = initpLoad(struct);
    filters = exps{expNum, 2};
    for filtID = 1:numel(filters)
      pLoad = filters{filtID}(pLoad);
    end
    [gtMats{expNum}, gtIndex] = loadGT(gtDir, pLoad);
  end
  if not(isempty(gtCache)) && not(exist(gtCache, 'file'))
    save(gtCache, 'gtMats', 'gtIndex', '-v7.3')
  end
end

% -- Generate index file if requested
if not(isempty(indexFileOut))
  fid = fopen(indexFileOut, 'w');
  for ix = 1:numel(gtIndex)
    fprintf(fid, '%d,%s\n', ix, gtIndex{ix});
  end
  fclose(fid);
end

nImgs = size(gtMats{1}, 2);

% -- Load detection files
dtMats = cell(1, nAlgs);
for algNum = 1:nAlgs
  dts = load(detectionFiles{algNum});
  ids=dts(:,1); assert(max(ids)<=nImgs);
  
  dtc = cell(1, nImgs);
  for ix = 1:nImgs
    dtc{ix} = dts(ids == ix,2:6);
  end
  dtMats{algNum} = dtc;
end

% -- Evaluate detections against all experiments
ref = 10.^(-2:.25:0);
mul = 0; % whether to allow multiple matches to each gt
thrAP = [0.3 0.4 0.5 0.6 0.7]; % Overlap threshold
for expNum = 1:nExps
  for algNum = 1:nAlgs
    refV = zeros(numel(thrAP), numel(ref));
    for thrIx = 1:numel(thrAP)
      curThr = thrAP(thrIx);
      [gt,dt] = bbGt('evalRes', gtMats{expNum}, dtMats{algNum}, curThr, mul); % Apply ignore flags
      [res.fp, res.tp, res.score, refV(thrIx,:)] = bbGt('compRoc',gt,dt,1,ref);
      if curThr == 0.5
        res.mAP = []; res.ref = []; % Placeholders
        results(expNum, algNum) = res;
      end
    end
    results(expNum, algNum).ref = refV;
    results(expNum, algNum).mAP = mean(mean(refV));
  end
end

% -- Generate ROCs
if plotRocs
  lims = [3.1e-3 1e1 .05 1]; % ROC range limits
  colors = 'rgbcmyk';
  for expNum = 1:nExps
    figure('Position', [1 1 400 300])
    clf
    hold on
    for algNum = 1:nAlgs
      curRes = results(expNum, algNum);
      plotRoc([curRes.fp curRes.tp],'logx',1,'logy',1,'xLbl','fppi',...
        'lims',lims,'color',colors(algNum),'smooth',1,'fpTarget',refV);
    end
    % Remove exta plot lines
    plotH = findobj(gcf,'type','line');
    toDelete = true(1, numel(plotH));
    for ix = 1:numel(plotH)
      if plotH(ix).LineWidth == 4 && plotH(ix).MarkerSize == 6
        toDelete(ix) = false;
      end
    end
    delete(plotH(toDelete))
    legend(algNames, 'Location', 'Best')
    title(exps{expNum, 1})
    hold off
  end
end


end

function [gt0, gtIndexRet] = loadGT(gtDir, pLoad)

persistent keyPrv gtPrv gtIndex;
fs = bbGt('getFiles', {gtDir});
gtFs = fs(1,:);
key={gtDir,pLoad}; n=length(gtFs);
if not(exist('gtIndex', 'var'))
  gtIndex = cell(1, n);
end
if(isequal(key,keyPrv)), gt0=gtPrv; else gt0=cell(1,n);
  for i=1:n
    [~,gt0{i}]=bbGt('bbLoad', gtFs{i}, pLoad);
    [~, gtIndex{i}] = fileparts(gtFs{i});
  end
  gtPrv=gt0; keyPrv=key;
end
gtIndexRet = gtIndex;

end
