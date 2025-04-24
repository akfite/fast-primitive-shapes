function [xdata, ydata] = star(x, y, outer_radius, inner_radius, num_points, opts)
%STAR Create data for plotting N-pointed stars.
%
%   Usage:
%
%       [xdata, ydata] = FPS.STAR(x, y, outer_r, inner_r, num_pts, opts...)
%
%   Inputs:
%
%       x, y <numeric vector>
%           - the center coordinates for each star
%
%       outer_radius <numeric vector>
%           - the distance from the center to the outer points of the star
%
%       inner_radius <numeric vector>
%           - the distance from the center to the inner points (indentations)
%             of the star. Must be <= outer_radius.
%
%       num_points <1x1 uint32>
%           - the number of outer points on the star (e.g., 5 for a standard star)
%           - must be >= 3.
%
%   Inputs (optional param-value pairs):
%
%       'N' (=2) <1x1 uint32>
%           - the number of points used to draw each line segment of the star
%           - this is mainly useful if the data will undergo some
%             user-defined transformation, such as spherical to cartesian.
%
%       'Rotation' (=0) <1xN double>
%           - the rotation of each star about its center point
%           - degrees, where positive is a clockwise rotation. The first
%             outer point will be oriented along this angle relative to the
%             positive x-axis before clockwise rotation is applied.
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each star, with a NaN as the last element
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
%       % Example 1: Single star
%       [xd, yd] = fps.star(0, 0, 5, 2, 5);
%       figure; plot(xd, yd, '.-'); axis equal; title('Single Star');
%
%       % Example 2: Multiple stars with varying sizes and rotations
%       n_stars = 10;
%       centers_x = rand(1, n_stars) * 50;
%       centers_y = rand(1, n_stars) * 50;
%       outer_r = 2 + 3*rand(1, n_stars);
%       inner_r = outer_r .* (0.2 + 0.4*rand(1, n_stars)); % Inner r < Outer r
%       rotations = rand(1, n_stars) * 360;
%
%       [xd, yd] = fps.star(centers_x, centers_y, outer_r, inner_r, 5, ...
%                           'N', 3, 'Rotation', rotations);
%
%       figure; plot(xd(:), yd(:), 'b-'); axis equal;
%       hold on; plot(centers_x, centers_y, 'r.'); % Show centers
%       title(sprintf('%d Stars (N=3)', n_stars));
%
%   See also FPS.REGULAR_POLYGON, FPS.CIRCLE, FPS.RECTANGLE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(1,:) {mustBeReal}
        y(1,:) {mustBeReal} = x
        outer_radius(1,:) {mustBeReal, mustBePositive} = 1
        inner_radius(1,:) {mustBeReal, mustBeNonnegative} = 0.5 % Default inner radius
        num_points(1,1) uint32 {mustBeGreaterThanOrEqual(num_points, 3)} = 5
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
        opts.Rotation(1,:) double = 0
    end

    % validate inputs are uniformly-sized or scalar
    sz = [length(x), length(y), length(outer_radius), length(inner_radius)];
    nrep = max(sz); % Number of stars to generate
    assert(all(sz == nrep | sz == 1), ...
        'fps:nonuniform_input', ...
        'Inputs x, y, outer_radius, inner_radius must be the same size or scalar.');
    assert(all(inner_radius <= outer_radius), ...
        'fps:invalidRadius', 'Inner radius must be less than or equal to outer radius.');

    % expand scalars
    if nrep > 1
        if isscalar(x), x = repmat(x, [1 nrep]); end
        if isscalar(y), y = repmat(y, [1 nrep]); end
        if isscalar(outer_radius), outer_radius = repmat(outer_radius, [1 nrep]); end
        if isscalar(inner_radius), inner_radius = repmat(inner_radius, [1 nrep]); end
    end

    num_vertices = 2 * num_points; % uint32

    % angles for each vertex (alternating outer/inner)
    angle_step = pi / double(num_points); % angle between adjacent vertices (ensure double division)
    angles = pi/2 + double((num_vertices):-1:0)' * angle_step; % convert sequence to double

    % create alternating radius matrix R (num_vertices+1) x nrep
    radii_pair = [outer_radius; inner_radius]; % stack outer/inner as a 2 x nrep block
    num_pairs_needed = ceil((num_vertices + 1) / 2);
    radii_repeated = repmat(radii_pair, num_pairs_needed, 1); % (num_pairs*2) x nrep
    R = radii_repeated(1:(num_vertices + 1), :); % (num_vertices+1) x nrep

    % calculate relative coordinates (before rotation and offset)
    x_rel = R .* cos(angles);
    y_rel = R .* sin(angles);

    % add NaN separators
    xdata = [x_rel; nan(1, nrep)];
    ydata = [y_rel; nan(1, nrep)];

    if any(opts.Rotation ~= 0)
        [xdata, ydata] = fps.internal.rotate_2d(opts.Rotation, xdata, ydata);
    end

    % re-center
    xdata = xdata + x;
    ydata = ydata + y;

    if opts.N > 2
        [xdata, ydata] = fps.internal.upsample(opts.N, xdata, ydata);
    end

end
