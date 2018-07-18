function pLoad = filterData_distMediumOnly(pLoad)
% pLoad = filterData_distMediumOnly(pLoad)
%
% Setting to evaluate on logs marked "Medium" only, setting all other data to ignored.

pLoad = initpLoad(pLoad);

pLoad.name = 'Medium';
pLoad.invName = 1;

end
