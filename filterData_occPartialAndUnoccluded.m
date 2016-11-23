function pLoad = filterData_occPartialAndUnoccluded(pLoad)
% pLoad = filterData_occPartialAndUnoccluded(pLoad)
%
% Filters out eavily-occluded people, leaving clear and partial
% occlusion cases.

pLoad = initLabelFields(pLoad);

pLoad.lbls = {'person'};
pLoad.ilbls = {'person-part'};
pLoad.ignDiff = 0;

end
