function [xdata, ydata] = square(x, y, radius, N)
%SQUARE Create data for plotting squares.
%
%   Usage:
%
%       [xdata, ydata] = FPS.SQUARE(x, y)
%       [xdata, ydata] = FPS.SQUARE(x, y, radius)
%       [xdata, ydata] = FPS.SQUARE(x, y, radius, N)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each square
%
%       radius <numeric vectors>
%           - the half-width and half-height of each square
%
%       N (=2) <1x1 integer>
%           - the number of points used to draw each line
%           - more than 2 points can be useful if the output data will undergo
%             a transformation, such as spherical to cartesian coordinates
%           - the total number of points per square will be N*4
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
%       [xd, yd] = FPS.SQUARE(1:100, 1:100, 10*rand(1,100));
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
        N(1,1) uint32 {mustBeGreaterThanOrEqual(N, 2)} = 2
    end

    [xdata, ydata] = fps.rectangle(x, y, radius, radius, N);

end
