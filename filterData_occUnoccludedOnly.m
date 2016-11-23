function pLoad =  filterData_occUnoccludedOnly(pLoad)
% pLoad =  filterData_occUnoccludedOnly(pLoad)
%
% Sets to ignore all data with any significant occlusion

pLoad = initLabelFields(pLoad);

pLoad.lbls = {'person'};
pLoad.ilbls = {'person-part'};
pLoad.ignDiff = 1;

end
