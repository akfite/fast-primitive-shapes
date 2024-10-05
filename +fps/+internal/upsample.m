function varargout = upsample(N, varargin)
%UPSAMPLE Uses a parameterization along each vertex-edge to upsample.
%
%   Note: this requires inputs to be in the specific nan-spaced matrix
%   format expected by the FPS library and is intended for internal-use only.

    narginchk(2,inf);

    % parameterize t along the line connecting each vertex
    t = linspace(0, 1, N)';

    for i = 1:numel(varargin)
        data = varargin{i};

        % pull out the start & end point of each line to upsample
        head = shiftdim(data(1:end-2,:), -2);
        tail = shiftdim(data(2:end-1,:), -2);

        % linear upsampling
        xnew = head + (t .* (tail - head));
        data = reshape(xnew, size(head,3)*N, []);

        % add the last row of NaNs back to separate each shape
        data(end+1,:) = nan; %#ok<*AGROW>

        % assign to output
        varargout{i} = data;
    end

end

