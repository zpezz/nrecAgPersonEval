function pLoad = filterData_unusualPosesOut(pLoad)
% pLoad = filterData_unusualPosesOut(pLoad)
%
% Ignores data from logs showing unusual poses.

pLoad = initpLoad(pLoad);

pLoad.name = '(Fall|Lying|SittingLeave)';
pLoad.invName = 0;

end
