function [xdata, ydata] = rotate_2d(angle, xdata, ydata, xcenter, ycenter)
%ROTATE_2D Apply a 2d rotation to a set of points.

    arguments
        angle(1,1) double
        xdata double
        ydata double
        xcenter(1,:) double = 0
        ycenter(1,:) double = 0
    end

    if angle == 0
        return
    end

    % make clockwise rotation positive
    angle = -angle;

    % define the rotation matrix
    dcm = [
        cosd(angle) -sind(angle)
        sind(angle) cosd(angle)
    ];

    if nargin > 3
        xdata = xdata - xcenter;
        ydata = ydata - ycenter;
    end

    points = [xdata(:)'; ydata(:)']; % 2xN
    new_xy = dcm * points;

    xdata = reshape(new_xy(1,:), size(xdata));
    ydata = reshape(new_xy(2,:), size(ydata));

    if nargin > 3
        xdata = xdata + xcenter;
        ydata = ydata + ycenter;
    end
    
end
