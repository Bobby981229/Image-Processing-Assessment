function [rectx, recty, area, perimeter] = minboundrect(x, y, metric)
% minboundrect: Compute the minimal bounding rectangle of points in the plane
if (nargin < 3) || isempty(metric)
    metric = 'a';
elseif ~ischar(metric)
    error 'Metric must be a character flag if it is supplied.'
else
    % check for 'a' or 'p'
    metric = lower(metric(:)');
    ind = strmatch(metric, {'area', 'perimeter'});
    if isempty(ind)
        error 'Metric does not match either ''area'' or ''perimeter'''
    end
    
    % just keep the first letter.
    metric = metric(1);
end
% preprocess data
x = x( : );
y = y( : );
n = length(x);
if n ~= length(y)
    error 'x and y must be the same sizes'
end
if n > 3
    edges = convhull(x, y);
    x = x(edges);
    y = y(edges);
    % probably fewer points now, unless the points are fully convex
    nedges = length(x) - 1;
elseif n > 1
    % n must be 2 or 3
    nedges = n;
    x(end + 1) = x(1);
    y(end + 1) = y(1);
else
    % n must be 0 or 1
    nedges = n;
end
% find the bounding rectangle
switch nedges
    case 0
        % empty
        rectx = [];
        recty = [];
        area = [];
        perimeter = [];
        return
    case 1
        % with one point
        rectx = repmat(x, 1, 5);
        recty = repmat(y, 1, 5);
        area = 0;
        perimeter = 0;
        return
    case 2
        % only two points
        rectx = x([1 2 2 1 1]);
        recty = y([1 2 2 1 1]);
        area = 0;
        perimeter = 2 * sqrt(diff(x).^2 + diff(y).^2);
        return
end
% 3 or more points.
% will need a 2x2 rotation matrix through an angle theta
Rmat = @(theta) [cos(theta) sin(theta); -sin(theta) cos(theta)];
% get the angle of each edge of the hull polygon.
ind = 1:(length(x)-1);
edgeangles = atan2(y(ind+1) - y(ind), x(ind+1) - x(ind));
% move the angle into the first quadrant.
edgeangles = unique(mod(edgeangles,pi/2));
% now just check each edge of the hull
nang = length(edgeangles);
area = inf;
perimeter = inf;
met = inf;
xy = [x, y];
for i = 1 : nang
    % rotate the data through -theta
    rot = Rmat(-edgeangles(i));
    xyr = xy * rot;
    xymin = min(xyr, [], 1);
    xymax = max(xyr, [], 1);
    
    % The area and the perimeter
    A_i = prod(xymax - xymin);
    P_i = 2 * sum(xymax - xymin);
    
    if metric=='a'
        M_i = A_i;
    else
        M_i = P_i;
    end
    
    % new metric value for the current interval
    if M_i < met
        % keep this one
        met = M_i;
        area = A_i;
        perimeter = P_i;
        rect = [xymin; [xymax(1), xymin(2)]; xymax; [xymin(1), xymax(2)]; xymin];
        rect = rect * rot';
        rectx = rect( : , 1);
        recty = rect( : , 2);
    end
end
end