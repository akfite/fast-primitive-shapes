function varargout = point(pt)
%POINT Reshapes vector data into a form ready to use with plot, plot3, etc

    arguments
        pt(:,:) {mustBeReal}
    end

    assert(size(pt,2) <= 3 && size(pt,2) >= 1, ...
        'Expected the matrix of vectors to be Nx2 or Nx3.');

    % add a row of NaNs at the end so that the output data can be cleanly
    % concatenated with output of other +fps functions
    pt(end+1,:) = nan;

    for i = size(pt,2):-1:1
        varargout{i} = pt(:,i);
    end

end
