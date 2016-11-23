function pLoad = filterData_unusualPosesOnly(pLoad)
% pLoad = filterData_unusualPosesOnly(pLoad)
%
% Setting to evaluate on unusual poses, setting all other data to ignored.

pLoad = initpLoad(pLoad);

pLoad.name = '(Fall|Lying|SittingLeave)';
pLoad.invName = 1;

end
