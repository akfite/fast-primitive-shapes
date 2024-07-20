function [xdata, ydata] = circle(x, y, radius, N)
%CIRCLE Create data for plotting circles.
%
%   Usage:
%
%       [xdata, ydata] = FPS.CIRCLE(x, y)
%       [xdata, ydata] = FPS.CIRCLE(x, y, radius)
%       [xdata, ydata] = FPS.CIRCLE(x, y, radius, N)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each circle
%
%       radius <numeric vectors>
%           - the radius of each circle
%
%       N (=100) <1x1 integer>
%           - the number of points to use to plot each circle
%           - affects the smoothness
%           - must be greater than or equal to 4 (to prevent degenerate shapes)
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each circle, with a NaN as the last element
%           - you can use these arrays directly with plot() and line(), however
%             take note of the difference in how to make the call:
%
%                   plot(xdata, ydata)        -->   multiple line objects (slow)
%                   plot(xdata(:), ydata(:))  -->   single line object    (fast)
%
%           - the data is provided as a matrix (i.e. prior to flushing with (:))
%             so that the user has the flexibility to apply transformations, or
%             just to plot as multiple objects as some applications require
%
%   Examples:
%
%       [xd, yd] = FPS.CIRCLE(1:100, 1:100, 10*rand(1,100));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.ELLIPSE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(1,:) {mustBeReal}
        y(1,:) {mustBeReal} = x
        radius(1,:) {mustBeReal} = 1
        N(1,1) uint32 {mustBeGreaterThanOrEqual(N, 4)} = 100
    end

    [xdata, ydata] = fps.ellipse(x, y, radius, radius, N);

end
