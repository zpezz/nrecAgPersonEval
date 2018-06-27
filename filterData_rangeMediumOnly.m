function pLoad = filterData_rangeMediumOnly(pLoad)
% filterData_rangeMediumOnly(pLoad)
%
% Filters out bounding boxes with points that are not of medium range.

pLoad = initpLoad(pLoad);

pLoad.zRng = [10 20];

end
