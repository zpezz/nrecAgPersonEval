function pLoad = filterData_scaleMediumOnly(pLoad)
% filterData_scaleMediumOnly(pLoad)
%
% Filters out bounding boxes that are not of medium scale.

pLoad = initpLoad(pLoad);

pLoad.aRng = [1300 3500];

end
