function [xdata, ydata] = plus(x, y, x_radius, y_radius, opts)
%PLUS Create data for plotting plus-signs (i.e. "+").
%
%   Usage:
%
%       [xdata, ydata] = FPS.PLUS(x, y)
%       [xdata, ydata] = FPS.PLUS(x, y, r)
%       [xdata, ydata] = FPS.PLUS(x, y, x_radius, y_radius)
%       [xdata, ydata] = FPS.PLUS(x, y, x_radius, y_radius, N)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each plus-sign
%
%       x_radius, y_radius <numeric vectors>
%           - the half-width and half-height for each plus-sign
%
%       N (=2) <1x1 integer>
%           - the number of points used to draw each line
%           - more than 2 points can be useful if the output data will undergo
%             a transformation, such as spherical to cartesian coordinates
%           - the total number of points per plus-sign will be N*2
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each plus, with a NaN as the last element
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
%       [xd, yd] = FPS.PLUS(1:100, 1:100, 10*rand(1,100), 10*rand(1,100));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.RECTANGLE

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
    
    % create the points for each line
    linebreak = nan(1, nrep);
    origin = zeros(1, nrep);

    xdata = [
        ... horizontal line
        -x_radius
        x_radius
        linebreak
        ... vertical line
        origin
        origin
        linebreak
        ];

    ydata = [
        ... horizontal line
        origin
        origin
        linebreak
        ... vertical line
        -y_radius
        y_radius
        linebreak
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

