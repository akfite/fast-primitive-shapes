function [xdata, ydata] = hexagon(x, y, x_radius, y_radius, opts)
%HEXAGON Create data for plotting hexagons.
%
%   Usage:
%
%       [xdata, ydata] = FPS.HEXAGON(x, y, opts...)
%       [xdata, ydata] = FPS.HEXAGON(x, y, r, opts...)
%       [xdata, ydata] = FPS.HEXAGON(x, y, x_radius, y_radius, opts...)
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
%           - the number of points to use for each component line of the hexagon
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
%       [xd, yd] = FPS.HEXAGON(1:100, 1:100, 10*rand(1,100));
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

    % validate inputs are uniformly-sized
    sz = [length(x), length(y), length(x_radius), length(y_radius)];
    assert(all(sz == max(sz) | sz == 1), ...
        'fps:nonuniform_input', ...
        'Inputs must be the same size or scalar (lengths = [%d, %d, %d, %d])', ...
        sz(1), sz(2), sz(3), sz(4));

    if isscalar(x_radius), x_radius = repmat(x_radius, [1 max(sz)]); end
    if isscalar(y_radius), y_radius = repmat(y_radius, [1 max(sz)]); end

    % define each hexagon centered on the origin
    vertex_angles = pi/180 * ([360:-60:0 NaN])';
    xv = x_radius .* cos(vertex_angles);
    yv = y_radius .* sin(vertex_angles);

    % optionally apply rotation
    if opts.Rotation ~= 0
        dcm = [
            cosd(opts.Rotation) -sind(opts.Rotation)
            sind(opts.Rotation) cosd(opts.Rotation)
        ];
        new_xy = dcm * [xv(:)'; yv(:)'];
        xv = reshape(new_xy(1,:), size(xv));
        yv = reshape(new_xy(2,:), size(yv));
    end

    % translate to desired positions
    xdata = xv + x;
    ydata = yv + y;

    if opts.N > 2
        x = [reshape(xdata(1:6,:),[],1), reshape(xdata(2:7,:),[],1)];
        y = [reshape(ydata(1:6,:),[],1), reshape(ydata(2:7,:),[],1)];
        [xdata,ydata] = fps.line(x, y, opts.N);

        % return as one column per hexagon
        xdata = reshape(xdata, (opts.N+1)*6, []);
        ydata = reshape(ydata, (opts.N+1)*6, []);
    end

end
