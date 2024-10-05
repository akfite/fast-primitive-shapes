function [xdata, ydata] = circle(x, y, radius, opts)
%CIRCLE Create data for plotting circles.
%
%   Usage:
%
%       [xdata, ydata] = FPS.CIRCLE(x, y, opts...)
%       [xdata, ydata] = FPS.CIRCLE(x, y, radius, opts...)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each circle
%
%       radius <numeric vectors>
%           - the radius of each circle
%
%   Inputs (optional param-value pairs):
%
%       N (=100) <1x1 integer>
%           - the number of points to use to plot each circle
%           - affects the smoothness
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
%       [xd, yd] = fps.circle(1:100, 1:100, 10*rand(1,100));
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
        opts.N(1,1) uint32 = 100
    end

    [xdata, ydata] = fps.regular_polygon(x, y, radius, radius, opts.N);

end
