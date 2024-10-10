function [xd, yd] = grid(x, y, opts)
%GRID Create data to plot a grid pattern.
%
%   Usage:
%
%       [xdata, ydata] = FPS.GRID(x, opts...)
%       [xdata, ydata] = FPS.GRID(x, y, opts...)
%
%   Inputs:
%
%       x, y <numeric vectors>
%           - the coordinates of the lines to draw, where one line will be drawn
%             for each x and each y to form an overlapping grid
%
%   Inputs (optional param-value pairs):
%
%       'N' (=2) <1x1 uint32>
%           - the number of points used to draw each line
%           - for instance with N=3, an additional point will be added at the
%             midpoint of both lines
%           - this is mainly useful if the line data will undergo some
%             user-defined transformation, such as spherical to cartesian
%             (see test/fps_deathstar_example.m for an example)
%
%   Outputs:
%
%       xdata, ydata <numeric matrix>
%           - one column for each line, with a NaN as the last element
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
%       % example 1
%       [xd,yd] = fps.grid(1:25);
%       figure; plot(xd(:), yd(:)); axis tight
%
%       % example 2
%       [xd,yd] = fps.grid(3.5:7.5, 8.5:15.5, 'N', 3);
%
%       figure; 
%       imagesc(randn(25)); caxis([-10 10]); colormap gray; hold on
%       plot(xd(:), yd(:), 'c-');
%
%   See also FPS.LINE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        x(:,1) double
        y(:,1) double = x
        opts.N(1,1) uint32 {mustBeGreaterThanOrEqual(opts.N, 2)} = 2
    end

    % pre-allocate
    line_x = nan(numel(x) + numel(y), 2);
    line_y = nan(numel(x) + numel(y), 2);

    % create lines at x=i (vertical lines);
    line_x(1:numel(x), :) = repmat(x, [1 2]);
    line_y(1:numel(x), :) = repmat(y([1 end])', [numel(x), 1]);

    % create lines at y=i (horizontal lines)
    line_x(numel(x)+1:end, :) = repmat(x([1 end])', [numel(y), 1]);
    line_y(numel(x)+1:end, :) = repmat(y, [1 2]);

    % convert coordinate pairs to lines ready to plot
    [xd, yd] = fps.line(line_x, line_y, opts.N);

end
