function pLoad = initLabelFields(pLoad)
% pLoad = initLabelFields(pLoad)
%
% Initializes lbls and ilbls to empty arrays if they don't exist, so they
% can safely just be appended to.

pLoad = initpLoad(pLoad);
if not(isfield(pLoad, 'lbls')), pLoad.lbls = {}; end
if not(isfield(pLoad, 'ilbls')), pLoad.ilbls = {}; end

end