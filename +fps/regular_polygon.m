function [xdata, ydata] = regular_polygon(x, y, x_radius, y_radius, n_sides, opts)
%REGULAR_POLYGON Workhorse function to quickly create any regular polygon shape.
%
%   Usage:
%
%       [xdata, ydata] = FPS.REGULAR_POLYGON(x, y, x_radius, y_radius, n_sides, opts...)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each shape
%
%       x_radius, y_radius <numeric vectors>
%           - the radii of the ellipse that circumscribes the polygon
%
%       n_sides <1x1 integer>
%           - the number of sides in the polygon (also the number of vertices)
%           - for example, with n_sides=6 we will generate hexagons
%
%   Inputs (optional param-value pairs):
%
%       'N' (=2) <1x1 uint32>
%           - the number of points used in the line connecting each vertex
%           - increasing this parameter increases the number of points used
%             to draw the shape without changing the underlying shape
%           - for instance with N=3, an additional point will be added at the
%             midpoint of each side of the polygon
%           - this is mainly useful if the polygon data will undergo some
%             user-defined transformation, such as spherical to cartesian
%             (see test/fps_example.m for an example)
%
%       'Rotation' (=0) <1x1 double>
%           - the rotation of each polygon about its center point
%           - degrees, where positive is a clockwise rotation
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each polygon, with a NaN as the last element
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
%       figure; 
%       tl = tiledlayout('flow');
%
%       for n_sides = 3:11
%           [xdata,ydata] = fps.regular_polygon(rand(10,1), rand(10,1), .1, .1, n_sides, N=3);
%           ax = nexttile(tl);
%           plot(ax, xdata(:), ydata(:), '.-');
%           title(ax,sprintf('sides=%d, N=3', n_sides))
%           axis(ax,'equal'); 
%           drawnow
%       end
%
%   See also FPS.PLUS, FPS.RECTANGLE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(1,:) double
        y(1,:) double
        x_radius(1,:) double
        y_radius(1,:) double
        n_sides(1,1) uint32 {mustBeGreaterThanOrEqual(n_sides, 3)}
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
        opts.Rotation(1,1) double = 0
    end

    % validate inputs are uniformly-sized
    sz = [length(x), length(y), length(x_radius), length(y_radius)];
    max_sz = max(sz);
    assert(all(sz == max_sz | sz == 1), ...
        'fps:nonuniform_input', ...
        'Inputs must be the same size or scalar (lengths = [%d, %d, %d, %d])', ...
        sz(1), sz(2), sz(3), sz(4));

    % expand scalar inputs to uniform size
    % (this will happen via implicit expansion for radius)
    if max_sz > 1
        if isscalar(y), y = repmat(y, size(x)); end
        if isscalar(x), x = repmat(x, size(y)); end
    end

    % parameterize x and y --> t, leaving a NaN as the last row
    % to separate each shape
    rotation = pi/180 * -opts.Rotation; % degrees -> radians
    t = [linspace(rotation+2*pi, rotation, n_sides+1), NaN]'; % column vector

    % use implicit expansion to efficiently create the output matrix
    xdata = x + (x_radius .* cos(t));
    ydata = y + (y_radius .* sin(t));

    % increase the number of data points by parameterizing along the line
    % between each vertex
    if opts.N > 2
        [xdata, ydata] = fps.internal.upsample(opts.N, xdata, ydata);
    end

end
