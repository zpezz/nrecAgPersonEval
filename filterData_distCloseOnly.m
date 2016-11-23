function pLoad = filterData_distCloseOnly(pLoad)
% pLoad = filterData_distCloseOnly(pLoad)
%
% Setting to evaluate on logs marked "close" only, setting all other data to ignored.

pLoad = initpLoad(pLoad);

pLoad.name = 'Close';
pLoad.invName = 1;

end
