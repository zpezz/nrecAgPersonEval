function pLoad = filterData_distFarOnly(pLoad)
% pLoad = filterData_distFarOnly(pLoad)
%
% Setting to evaluate on logs marked "close" only, setting all other data to ignored.

pLoad = initpLoad(pLoad);

pLoad.name = 'Far';
pLoad.invName = 1;

end
