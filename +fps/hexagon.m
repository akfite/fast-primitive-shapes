function [xdata, ydata] = hexagon(x, y, x_radius, y_radius, opts)
%HEXAGON Create data for plotting hexagons.
%
%   Usage:
%
%       [xdata, ydata] = FPS.HEXAGON(x, y, opts...)
%       [xdata, ydata] = FPS.HEXAGON(x, y, r, opts...)
%       [xdata, ydata] = FPS.HEXAGON(x, y, x_radius, y_radius, opts...)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each hexagon
%
%       x_radius, y_radius <numeric vectors>
%           - the radii of the ellipse that circumscribes the hexagon
%
%   Inputs (param-value pairs)
%
%       'N' (=2) <1x1 uint32>
%           - the number of points to use for each line of the hexagon
%
%       'Rotation' (=0) <1x1 double>
%           - the rotation of each hexagon about its center point
%           - degrees, positive is a clockwise rotation
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each hexagon, with a NaN as the last element
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
%       [xd, yd] = fps.hexagon(1:10, 1:10, rand(1,10));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.ELLIPSE, FPS.LINE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(1,:) {mustBeReal}
        y(1,:) {mustBeReal} = x
        x_radius(1,:) {mustBeReal} = 1
        y_radius(1,:) {mustBeReal} = x_radius
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
        opts.Rotation(1,1) double = 0 % degrees, clockwise is positive
    end

    [xdata, ydata] = fps.regular_polygon(x, y, x_radius, y_radius, 6, ...
        'N', opts.N, ...
        'Rotation', opts.Rotation);

end
