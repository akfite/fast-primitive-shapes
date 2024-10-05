function [xdata, ydata] = ellipse(x, y, x_radius, y_radius, opts)
%ELLIPSE Create data for plotting ellipses.
%
%   Usage:
%
%       [xdata, ydata] = FPS.ELLIPSE(x, y)
%       [xdata, ydata] = FPS.ELLIPSE(x, y, r)
%       [xdata, ydata] = FPS.ELLIPSE(x, y, x_radius, y_radius)
%       [xdata, ydata] = FPS.ELLIPSE(x, y, x_radius, y_radius, opts...)
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
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 3)} = 100
        opts.Rotation(1,1) double = 0
    end

    % note: we hijack the downstream meaning of "N" to instead be used
    % here as the smoothness of the circle (and provide no API for adding
    % points between vertices, because who does that for an ellipse?)
    [xdata, ydata] = fps.regular_polygon(x, y, x_radius, y_radius, opts.N);

    if opts.Rotation ~= 0
        [xdata, ydata] = fps.internal.rotate_2d(opts.Rotation, xdata, ydata, x, y);
    end

end
