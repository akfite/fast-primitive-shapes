function [xdata, ydata] = ellipse(x, y, x_radius, y_radius, N)
%ELLIPSE Create data for plotting ellipses (and therefor also circles)
%
%   Usage:
%
%       [xdata, ydata] = FPS.ELLIPSE(x, y)
%       [xdata, ydata] = FPS.ELLIPSE(x, y, r)
%       [xdata, ydata] = FPS.ELLIPSE(x, y, x_radius, y_radius)
%       [xdata, ydata] = FPS.ELLIPSE(x, y, x_radius, y_radius, N)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each ellipse
%
%       x_radius, y_radius <numeric vectors>
%           - the radius of the ellipse in the x and y directions
%
%       N (=100) <1x1 integer>
%           - the number of points to use to plot each ellipse
%           - affects the smoothness
%           - must be greater than or equal to 4 (to prevent degenerate shapes)
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each ellipse, with a NaN as the last element
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
%       [xd, yd] = FPS.ELLIPSE(1:100, 1:100, 10*rand(1,100));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.PLUS, FPS.RECTANGLE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(1,:) {mustBeReal}
        y(1,:) {mustBeReal} = x
        x_radius(1,:) {mustBeReal} = 1
        y_radius(1,:) {mustBeReal} = x_radius
        N(1,1) uint32 {mustBeGreaterThanOrEqual(N, 4)} = 100
    end

    % validate inputs are uniformly-sized
    sz = [length(x), length(y), length(x_radius), length(y_radius)];
    assert(all(sz == sz(1) | sz == 1), ...
        'fps:nonuniform_input', ...
        'Inputs must be the same size or scalar (lengths = [%d, %d, %d, %d])', ...
        sz(1), sz(2), sz(3), sz(4));

    % expand scalar inputs to uniform size
    % (this will happen via implicit expansion for radius)
    if isscalar(y), y = repmat(y, size(x)); end

    % parameterize x and y --> t, leaving a NaN as the last row
    % to separate each ellipse
    t = [linspace(0, 2*pi, N), NaN]'; % column vector

    % use implicit expansion to efficiently create the output matrix
    xdata = x + (x_radius .* cos(t));
    ydata = y + (y_radius .* sin(t));

end
