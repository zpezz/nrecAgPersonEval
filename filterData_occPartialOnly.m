function pLoad = filterData_occPartialOnly(pLoad)
% pLoad = filterData_occPartialOnly(pLoad)
%
% Filters out unoccluded and heavily-occluded people, leaving only partial
% occlusion cases.

pLoad = initLabelFields(pLoad);

pLoad.lbls = {'person'};
pLoad.ilbls = {'person-part'};
pLoad.ignDiff = -1;

end
