function varargout = connect(p1, p2, N)
%CONNECT Draw lines connecting arrays of points p1 and p2.
%
%   Usage:
%
%       [xdata, ydata, ...] = FPS.CONNECT(p1, p2)
%       [xdata, ydata, ...] = FPS.CONNECT(p1, p2, N)
%
%   Inputs:
%
%       p1, p2 <double matrix>
%           - each row represents a point in 2d, 3d, etc space
%           - e.g. if both are 10x3 arrays, we will create the data
%             to plot 10 separate 3-dimensional lines.  likewise for
%             10x2 input, we'll create 10 separate 2-dimensional lines
%
%       N (=2) <1x1 integer>
%           - the number of points used to draw each line
%
%   Outputs:
%
%       xdata, ydata, ... <numeric matrix>
%           - one column for each line, with a NaN as the last element
%           - number of outputs will equal the number of columns in p1 & p2
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
%       [x, y] = fps.circle(0, 0, 1, 'N', 20);
%
%       % connnect the points in the circle to the center
%       N = 3;
%       [xd, yd] = fps.connect([x(:) y(:)], [0 0], N);
%
%       figure;
%       plot(xd(:), yd(:), '.-');
%
%   See also: FPS.VECTOR, FPS.LINE

    arguments
        p1(:,:) double
        p2(:,:) double
        N(1,1) uint32 = 2
    end

    assert(size(p1,2) == size(p2,2), ...
        'Both points must have the same number of dimensions (columns).');

    if size(p1,2) ~= nargout && nargout > 0
        warning('fps:connect:missing_outputs', ...
            'The input data has %d dims, but nargout is %d (they should match)', ...
            size(p1,2), nargout);
    end

    % expand args
    if size(p2,1) == 1 && size(p1,1) > 1
        p2 = repmat(p2, size(p1,1), 1);
    end
    if size(p1,1) == 1 && size(p2,1) > 1
        p1 = repmat(p1, size(p2,1), 1);
    end

    assert(size(p1,1) == size(p2,1), ...
        'Dimensions of the two arrays are incompatible.');

    for col = size(p1,2):-1:1
        varargout{col} = [
            p1(:,col).'
            p2(:,col).'
            nan(1, size(p1,1));
            ];
    end

    if N > 2
        [varargout{1:nargout}] = fps.internal.upsample(N, varargout{:});
    end

end

