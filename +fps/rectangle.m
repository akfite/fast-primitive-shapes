function [xd, yd] = rectangle(x, y, x_radius, y_radius, N)
%RECTANGLE Create data for plotting rectangles (and therefore also squares)
%
%   Usage:
%
%       [xdata, ydata] = FPS.RECTANGLE(x, y)
%       [xdata, ydata] = FPS.RECTANGLE(x, y, r)
%       [xdata, ydata] = FPS.RECTANGLE(x, y, x_radius, y_radius)
%       [xdata, ydata] = FPS.RECTANGLE(x, y, x_radius, y_radius, N)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each rectangle
%
%       x_radius, y_radius <numeric vectors>
%           - the half-width and half-height for each rectangle
%
%       N (=2) <1x1 integer>
%           - the number of points used to draw each line
%           - more than 2 points can be useful if the output data will undergo
%             a transformation, such as spherical to cartesian coordinates
%           - the total number of points per rectangle will be N*4
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each rectangle, with a NaN as the last element
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
%       [xd, yd] = FPS.RECTANGLE(1:100, 1:100, 10*rand(1,100), 10*rand(1,100));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.LINE, FPS.PLUS

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(:,1) {mustBeReal}
        y(:,1) {mustBeReal} = x
        x_radius(:,1) {mustBeReal} = 1
        y_radius(:,1) {mustBeReal} = x_radius
        N(1,1) uint32 {mustBeGreaterThanOrEqual(N, 2)} = 2
    end

    % validate inputs are uniformly-sized
    sz = [length(x), length(y), length(x_radius), length(y_radius)];
    assert(all(sz == sz(1) | sz == 1), ...
        'fps:nonuniform_input', ...
        'Inputs must be the same size or scalar (lengths = [%d, %d, %d, %d])', ...
        sz(1), sz(2), sz(3), sz(4));

    % solve for the extents
    x0 = x - x_radius;
    x1 = x + x_radius;
    y0 = y - y_radius;
    y1 = y + y_radius;

    % expand scalars
    nrep = max(sz);
    if isscalar(x0), x0 = repmat(x0, [nrep 1]); end
    if isscalar(x1), x1 = repmat(x1, [nrep 1]); end
    if isscalar(y0), y0 = repmat(y0, [nrep 1]); end
    if isscalar(y1), y1 = repmat(y1, [nrep 1]); end
    
    % create coordinate pairs for lines starting at bottom-left corner
    % and moving counter-clockwise around the rectangle
    xpairs = [
        x0 x0
        x0 x1
        x1 x1
        x1 x0
        ];

    ypairs = [
        y0 y1
        y1 y1
        y1 y0
        y0 y0
        ];

    [xd, yd] = fps.line(xpairs, ypairs, N);

end
