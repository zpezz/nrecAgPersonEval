function pLoad = initpLoad(pLoad)
% pLoad = initpLoad(pLoad)
%
% Sets format if it is not already defined

if not(isfield(pLoad, 'format'))
  pLoad.format = 1;
end

end