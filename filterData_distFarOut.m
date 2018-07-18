function pLoad = filterData_distFarOut(pLoad)
% pLoad = filterData_distFarOut(pLoad)
%
% Setting to ignore ignore logs marked "Far".

pLoad = initpLoad(pLoad);

pLoad.name = 'Far';
pLoad.invName = 0;

end
