function pLoad = filterData_scaleSmallOnly(pLoad)
% filterData_scaleSmallOnly(pLoad)
%
% Filters out bounding boxes that are not of small scale.

pLoad = initpLoad(pLoad);

pLoad.aRng = [0 1299];

end
