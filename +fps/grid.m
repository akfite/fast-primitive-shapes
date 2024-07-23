function [xd, yd] = grid(varargin)
%GRID Create x & y-data to define nan-separated lines in a grid pattern.
%
%   Usage:
%
%       [xdata, ydata] = FPS.GRID(x)
%       [xdata, ydata] = FPS.GRID(x, y)
%       [xdata, ydata] = FPS.GRID(___, N)
%
%   Inputs:
%
%       x, y <numeric vectors>
%           - the coordinates of the lines to draw, where one line will be drawn
%             for each x and each y to form an overlapping grid
%
%       N (=2) <1x1 integer>
%           - the number of points to use to represent each line
%           - more than 2 points can be useful if the output data will undergo
%             a transformation, such as cartesian to spherical coordinates
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
%       [xd,yd] = FPS.GRID(1:10);
%       figure; plot(xd(:), yd(:));
%
%       % example 2
%       [xd,yd] = FPS.GRID(3.5:7.5, 8.5:15.5);
%
%       figure; 
%       imagesc(randn(25)); caxis([-10 10]); colormap gray; hold on
%       plot(xd(:), yd(:), 'c-');
%
%   See also FPS.LINE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    narginchk(1, 3);

    if isscalar(varargin{end})
        N = varargin{end};
        varargin(end) = [];
    else
        N = 2;
    end

    if isscalar(varargin)
        x = varargin{1};
        y = x;
    else
        x = varargin{1};
        y = varargin{2};
    end

    % inputs must be column vectors
    x = x(:);
    y = y(:);

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
    [xd, yd] = fps.line(line_x, line_y, N);

end
