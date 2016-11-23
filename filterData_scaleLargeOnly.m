function pLoad = filterData_scaleLargeOnly(pLoad)
% filterData_scaleLargeOnly(pLoad)
%
% Filters out bounding boxes that are not of large scale.

pLoad = initpLoad(pLoad);

pLoad.aRng = [3501 inf];

end
