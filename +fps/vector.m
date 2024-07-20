function varargout = vector(origin, direction)
%VECTOR Reshapes vector data into a form ready to use with line, plot, plot3, etc
%
%   Usage:
%
%       [xdata, ydata, ...] = FPS.VECTOR(origin, direction)
%
%   Inputs:
%
%       origin <NxD numeric>
%           - the starting point for each vector
%           - matrix where columns are vector components, rows index the vectors
%           - e.g. Nx3 for N 3-dimensional vectors
%
%       direction <NxD numeric>
%           - the direction for each vector
%           - matrix where columns are vector components, rows index the vectors
%           - e.g. Nx3 for N 3-dimensional vectors
%
%   Outputs:
%
%       xdata, ydata, ... <numeric matrix>
%           - each output is a matrix ready to be provided to plot, plot3, or line
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
%       % 2-dimensional
%       [xd, yd] = fps.vector([0 0], randn(500, 2));
%
%       figure; plot(xd, yd); title('multiple line objects (slow)');
%       figure; plot(xd(:), yd(:)); title('single line object (fast)');
%
%       % 3-dimensional
%       [xd, yd, zd] = fps.vector([0 0 0], randn(500, 3));
%
%       figure; plot3(xd, yd, zd); title('multiple line objects (slow)');
%       figure; plot3(xd(:), yd(:), zd(:)); title('single line object (fast)');
%
%   See also FPS.LINE

    arguments
        origin(:,:) {mustBeReal}
        direction(:,:) {mustBeReal}
    end

    assert(...
        size(origin,2) == size(direction,2), ...
        'fps:mismatch_columns', ...
        'The number of columns for both inputs must be the same (or scalar)');
    assert(...
        size(origin,1) == size(direction,1) || size(origin,1) == 1 || size(direction,1) == 1, ...
        'fps:mismatch_rows', ...
        'The number of rows for both inputs must be the same (or scalar)');

    % expand inputs to the same size
    if size(direction, 1) == 1 && size(origin, 1) > 1
        direction = repmat(direction, [size(origin,1) 1]);
    end
    if size(origin, 1) == 1 && size(direction, 1) > 1
        origin = repmat(origin, [size(direction,1) 1]);
    end

    vector_dims = size(origin, 2);
    num_lines = size(origin, 1);

    % find vector end point
    head = origin + direction;

    % write to separate vars for compatibility with plot, plot3, etc
    for i = vector_dims:-1:1
        varargout{i} = vertcat(...
            origin(:,i).', ...
            head(:,i).', ...
            nan(1, num_lines));
    end

end

