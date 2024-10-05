function varargout = upsample(N, varargin)
%UPSAMPLE Uses a parameterization along each vertex-edge to upsample.
%
%   Note: this requires inputs to be in the specific nan-spaced matrix
%   format expected by the FPS library and is intended for internal-use only.

    narginchk(2,inf);

    % parameterize t along the line connecting each vertex
    t = linspace(0, 1, N)';

    for i = 1:numel(varargin)
        xdata = varargin{i};
        xstart = shiftdim(xdata(1:end-2,:), -2);
        xend = shiftdim(xdata(2:end-1,:), -2);
        xnew = xstart + (t .* (xend - xstart));
        xdata = reshape(xnew, size(xstart,3)*N, []);
        xdata(end+1,:) = nan; %#ok<*AGROW>

        % assign to output
        varargout{i} = xdata;
    end

end

