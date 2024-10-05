function [xdata, ydata] = square(x, y, radius, opts)
%SQUARE Create data for plotting squares.
%
%   Usage:
%
%       [xdata, ydata] = FPS.SQUARE(x, y, opts...)
%       [xdata, ydata] = FPS.SQUARE(x, y, radius, opts...)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each square
%
%       radius <numeric vectors>
%           - the half-width and half-height of each square
%
%   Inputs (optional param-value pairs):
%
%       'N' (=2) <1x1 uint32>
%           - the number of points used to draw each line in the square
%           - this is mainly useful if the data will undergo some
%             user-defined transformation, such as spherical to cartesian
%             (see test/fps_example.m for an example)
%
%       'Rotation' (=0) <1x1 double>
%           - the rotation of each square about its center point
%           - degrees, where positive is a clockwise rotation
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each square, with a NaN as the last element
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
%       [xd, yd] = fps.square(1:10, 1:10, rand(1,10));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.ELLIPSE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(:,1) {mustBeReal}
        y(:,1) {mustBeReal} = x
        radius(:,1) {mustBeReal} = 1
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
        opts.Rotation(1,1) double = 0
    end

    [xdata, ydata] = fps.rectangle(x, y, radius, radius, ...
        'N', opts.N, ...
        'Rotation', opts.Rotation);

end
