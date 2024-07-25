function varargout = point(pt)
%POINT Reshapes vector data into a form ready to use with plot, plot3, etc

    arguments
        pt(:,:) {mustBeReal}
    end

    assert(size(pt,2) <= 3 && size(pt,2) >= 1, ...
        'Expected the matrix of vectors to be Nx2 or Nx3.');

    for i = size(pt,2):-1:1
        varargout{i} = pt(:,i);
    end

end
