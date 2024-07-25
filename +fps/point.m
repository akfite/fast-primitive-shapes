function varargout = point(pt)
%POINT Reshapes vector data into a form ready to use with plot, plot3, etc

    for i = size(pt,2):-1:1
        varargout{i} = pt(:,i);
    end

end

