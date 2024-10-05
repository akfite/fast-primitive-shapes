function [xdata, ydata] = diamond(x, y, x_radius, y_radius, opts)
%DIAMOND Create data for plotting diamonds.
%
%   Usage:
%
%       [xdata, ydata] = FPS.DIAMOND(x, y)
%       [xdata, ydata] = FPS.DIAMOND(x, y, r)
%       [xdata, ydata] = FPS.DIAMOND(x, y, x_radius, y_radius)
%       [xdata, ydata] = FPS.DIAMOND(x, y, x_radius, y_radius, N)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each diamond
%
%       x_radius, y_radius <numeric vectors>
%           - the half-width and half-height for each diamond
%
%       N (=2) <1x1 integer>
%           - the number of points used to draw each line
%           - more than 2 points can be useful if the output data will undergo
%             a transformation, such as spherical to cartesian coordinates
%           - the total number of points per diamond will be N*4
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each diamond, with a NaN as the last element
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
%       [xd, yd] = FPS.DIAMOND(1:100, 1:100, 3*rand(1,100), 3*rand(1,100));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.LINE, FPS.PLUS, FPS.RECTANGLE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(:,1) {mustBeReal}
        y(:,1) {mustBeReal} = x
        x_radius(:,1) {mustBeReal} = 1
        y_radius(:,1) {mustBeReal} = x_radius
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
        opts.Rotation(1,1) double = 0
    end

    [xdata, ydata] = fps.regular_polygon(x, y, x_radius, y_radius, 4, ...
        'N', opts.N, ...
        'Rotation', -90);

    if opts.Rotation ~= 0
        [xdata, ydata] = fps.internal.rotate_2d(opts.Rotation, xdata, ydata, x, y);
    end

end

