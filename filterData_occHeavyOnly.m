function pLoad = filterData_occHeavyOnly(pLoad)
% filterData_occHeavyOnly(pLoad)
%
% Filters out unoccluded and partially-occluded people, leaving only heavy
% occlusion cases.

pLoad = initLabelFields(pLoad);

pLoad.lbls = {'person-part'};
pLoad.ilbls = {'person'};
pLoad.ignDiff = 0; % doesn't matter in this case

end
