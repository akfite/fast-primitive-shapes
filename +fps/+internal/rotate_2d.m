function [xdata, ydata] = rotate_2d(angle, xdata, ydata, xcenter, ycenter)
%ROTATE_2D Apply a 2d rotation to a set of points.

    arguments
        angle(1,:) double
        xdata double
        ydata double
        xcenter(1,:) double = 0
        ycenter(1,:) double = 0
    end

    if all(angle == 0)
        return
    end

    assert(isscalar(angle) || numel(angle) == size(xdata,2), ...
        'The rotation angle must be scalar or match the number of shapes (%d != %d)', ...
        numel(angle), size(xdata,2));

    % make clockwise rotation positive
    angle = -angle;

    % define the rotation matrix
    dcm = zeros(2,2,1,numel(angle));
    c = cosd(angle);
    s = sind(angle);
    dcm(1,1,1,:) = c;
    dcm(1,2,1,:) = -s;
    dcm(2,1,1,:) = s;
    dcm(2,2,1,:) = c;

    if nargin > 3
        xdata = xdata - xcenter;
        ydata = ydata - ycenter;
    end

    if isscalar(angle)
        % common rotation for multiple shapes
        points = [xdata(:)'; ydata(:)']; % 2xN
        new_xy = dcm * points;

        xdata = reshape(new_xy(1,:), size(xdata));
        ydata = reshape(new_xy(2,:), size(ydata));
    else
        % separate rotation for each shape
        xdata = shiftdim(xdata, -2);
        ydata = shiftdim(ydata, -2);
        points = cat(1, xdata, ydata);
        new_xy = squeeze(pagemtimes(dcm, points));
        new_xy = permute(new_xy,[2 3 1]);
        
        xdata = new_xy(:,:,1);
        ydata = new_xy(:,:,2);
    end

    if nargin > 3
        xdata = xdata + xcenter;
        ydata = ydata + ycenter;
    end
    
end
