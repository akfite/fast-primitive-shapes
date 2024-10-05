function varargout = upsample(N, varargin)
%UPSAMPLE Resamples xdata and ydata to have N points on each side.

    narginchk(2,inf);

    % parameterize t along the line connecting each vertex
    t = linspace(0, 1, N)';
    n_sides = size(varargin{1},1) - 2;

    for i = 1:numel(varargin)
        xdata = varargin{i};
        xstart = shiftdim(xdata(1:end-2,:), -2);
        xend = shiftdim(xdata(2:end-1,:), -2);
        xnew = xstart + (t .* (xend - xstart));
        xdata = reshape(xnew, (n_sides)*N, []);
        xdata(end+1,:) = nan; %#ok<*AGROW>

        % remove repeated vertices
        xdata(N:N:(N*(n_sides-1)),:) = [];

        % assign to output
        varargout{i} = xdata;
    end

end

