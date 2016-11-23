function pLoad = filterData_occIncludeAll(pLoad)
% Include all people, regardless of occlusion level
%
% Adds flags to include all levels of occlusion.

pLoad = initLabelFields(pLoad);
pLoad.lbls = unique([pLoad.lbls {'person', 'person-part'}]);
pLoad.ignDiff = 0;

end
