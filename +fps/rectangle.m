function [xdata, ydata] = rectangle(x, y, x_radius, y_radius, opts)
%RECTANGLE Create data for plotting rectangles.
%
%   Usage:
%
%       [xdata, ydata] = FPS.RECTANGLE(x, y, opts...)
%       [xdata, ydata] = FPS.RECTANGLE(x, y, r, opts...)
%       [xdata, ydata] = FPS.RECTANGLE(x, y, x_radius, y_radius, opts...)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each rectangle
%
%       x_radius, y_radius <numeric vectors>
%           - the half-width and half-height for each rectangle
%
%   Inputs (optional param-value pairs):
%
%       'N' (=2) <1x1 uint32>
%           - the number of points used to draw each line in the rectangle
%           - this is mainly useful if the data will undergo some
%             user-defined transformation, such as spherical to cartesian
%             (see test/fps_example.m for an example)
%
%       'Rotation' (=0) <1x1 double>
%           - the rotation of each rectangle about its center point
%           - degrees, where positive is a clockwise rotation
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
%       [xd, yd] = fps.rectangle(1:10, 1:10, rand(1,10), rand(1,10));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.LINE, FPS.PLUS

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(1,:) {mustBeReal}
        y(1,:) {mustBeReal} = x
        x_radius(1,:) {mustBeReal} = 1
        y_radius(1,:) {mustBeReal} = x_radius
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
        opts.Rotation(1,1) double = 0
    end

    % validate inputs are uniformly-sized
    sz = [length(x), length(y), length(x_radius), length(y_radius)];
    assert(all(sz == sz(1) | sz == 1), ...
        'fps:nonuniform_input', ...
        'Inputs must be the same size or scalar (lengths = [%d, %d, %d, %d])', ...
        sz(1), sz(2), sz(3), sz(4));

    % expand scalars
    nrep = max(sz);
    if nrep > 1
        if isscalar(x), x = repmat(x, [1 nrep]); end
        if isscalar(y), y = repmat(y, [1 nrep]); end
        if isscalar(x_radius), x_radius = repmat(x_radius, [1 nrep]); end
        if isscalar(y_radius), y_radius = repmat(y_radius, [1 nrep]); end
    end

    % defined at the origin, clockwise starting at bottom left corner
    xdata = [
        -x_radius
        -x_radius
        x_radius
        x_radius
        -x_radius
        nan(1, nrep)
        ];

    ydata = [
        -y_radius
        y_radius
        y_radius
        -y_radius
        -y_radius
        nan(1, nrep)
        ];

    if opts.Rotation ~= 0
        [xdata, ydata] = fps.internal.rotate_2d(opts.Rotation, xdata, ydata);
    end

    xdata = xdata + x;
    ydata = ydata + y;

    if opts.N > 2
        [xdata, ydata] = fps.internal.upsample(opts.N, xdata, ydata);
    end

end
