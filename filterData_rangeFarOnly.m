function pLoad = filterData_rangeFarOnly(pLoad)
% filterData_rangeFarOnly(pLoad)
%
% Filters out bounding boxes with points that are not of far range.

pLoad = initpLoad(pLoad);

pLoad.zRng = [20 inf];

end
