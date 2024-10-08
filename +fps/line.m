function varargout = line(varargin)
%LINE Connect each element in vectors [X1 X2], [Y1 Y2], ... to form NaN-separated lines.
%
%   Usage:
%
%       [xdata, ydata, ...] = FPS.LINE(x, y, ..., N)
%
%   Inputs:
%
%       x, y, ... <Mx2 numeric matrix>
%           - coordinate pairs defining the start & end point of each line
%           - each row is a new line
%
%       N (=2) <1x1 integer>
%           - the number of points used to draw each line
%           - more than 2 points can be useful if the output data will undergo
%             a transformation, such as spherical to cartesian coordinates
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
%       [xd, yd] = fps.line(rand(100,2), rand(100,2));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%   See also FPS.PLUS, FPS.RECTANGLE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    if isscalar(varargin{end})
        N = varargin{end};
        varargin(end) = [];
    else
        N = 2;
    end

    % validate inputs
    n_rows = cellfun(@(x) size(x,1), varargin);
    assert(all(n_rows == n_rows(1) | n_rows == 1), ...
        'fps:nonuniform_input', ...
        'Inputs must all have the same number of rows');
    validateattributes(N, {'numeric'}, {'integer','scalar','>=', 2});

    % pack into NaN-separated arrays
    for i = numel(varargin):-1:1
        arg = varargin{i};
        validateattributes(arg, {'numeric'}, {'2d','real','ncols', 2});

        varargout{i} = vertcat(...
            arg', ...
            nan(1, size(arg, 1)));
    end

    if N > 2
        [varargout{1:nargout}] = fps.internal.upsample(N, varargout{:});
    end

end
