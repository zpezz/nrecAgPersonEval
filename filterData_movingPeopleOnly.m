function pLoad = filterData_movingPeopleOnly(pLoad)
% pLoad = filterData_movingPeopleOnly(pLoad)
%
% Setting to evaluate on people in motion, setting all other data to ignored.

pLoad = initpLoad(pLoad);

pLoad.name = 'ovingPerson';
pLoad.invName = 1;

end
