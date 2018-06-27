function pLoad = filterData_rangeNearOnly(pLoad)
% filterData_rangeNearOnly(pLoad)
%
% Filters out bounding boxes with points that are not of near range.

pLoad = initpLoad(pLoad);

pLoad.zRng = [0 10];

end
