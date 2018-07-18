function pLoad = filterData_scaleSmallOut(pLoad)
% filterData_scaleSmallOut(pLoad)
%
% Filters out bounding boxes that are of small scale.

pLoad = initpLoad(pLoad);

pLoad.aRng = [1300 inf];

end
