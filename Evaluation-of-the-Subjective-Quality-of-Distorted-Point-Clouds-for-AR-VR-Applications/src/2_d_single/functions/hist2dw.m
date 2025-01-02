function f  = hist2dw(x,y,weights,xedges,yedges)
%all inputs should be vectors
[~,xbin] = histc(x,xedges);
[~,ybin] = histc(y,yedges);

xbin(xbin==0) = inf;
ybin(ybin==0) = inf;
xnbin = numel(xedges);
ynbin = numel(yedges);

xy = xbin * ynbin + ybin;

[xyu,id] = unique(xy);
% if isinf(xyu(end))
    xyu(end) = []; % remove Inf bin
    id(end) = [];
% end
hstres = histc(xy,xyu);
hstres = hstres.*weights(id); % add the weights to the histogram
f(ynbin,xnbin)=0; % preallocate memory
f(xyu-ynbin) = hstres;