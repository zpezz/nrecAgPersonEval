function pLoad = filterData_rangeFarOut(pLoad)
% filterData_rangeFarOut(pLoad)
%
% Filters out bounding boxes with points that are of far range.

pLoad = initpLoad(pLoad);

pLoad.zRng = [0 20];

end
