function varargout = mesh(faces, vertices)
%MESH Convert a mesh into data that can be plotted as a single line.
%
%   Usage:
%
%       [xdata, ydata, ...] = FPS.MESH(faces, vertices)
%
%   Inputs:
%
%       faces <FxC uint32>
%           - the connectivity matrix that describes which vertices
%             connect to form each face in the mesh
%
%       vertices <NxD numeric>
%           - the coordinates of each vertex in the mesh
%           - one column for each dimension
%
%   Outputs:
%
%       xdata, ydata, ... <3xM double>
%           - the number of output args will be equal to the number of columns
%             (dimensions) in the vertex matrix
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
%       fv = surf2patch(peaks(50))
%       [x,y,z] = fps.mesh(fv.faces, fv.vertices);
%
%       figure;
%       plot3(x(:), y(:), z(:))
%       title('this is one line object');
%
%   See also: FPS.LINE

%   Author:     Austin Fite
%   Contact:    akfite@gmail.com

    arguments
        faces(:,:) uint32
        vertices(:,:)
    end

    assert(nargout <= size(vertices,2),...
        'fps:too_many_outputs', ...
        'Number of output args exceeds the number of dimensions in the mesh (%d > %d)', ...
        nargout, size(vertices,2));

    n_faces = size(faces,1);
    n_edges_per_face = size(faces,2);

    % pre-allocate line index array
    lines = zeros(numel(faces), 2, 'uint32');

    for iedge = 1:size(faces,2)
        istart = (iedge-1) * n_faces + 1;
        iend = iedge * n_faces;

        lines(istart:iend, 1) = faces(:, iedge);
        lines(istart:iend, 2) = faces(:, 1+mod(iedge, n_edges_per_face));
    end

    % convert line indices to vertex locations
    for idim = size(vertices,2):-1:1
        varargout{idim} = vertcat(...
            vertices(lines(:,1), idim)', ...
            vertices(lines(:,2), idim)', ...
            nan(1, size(lines,1)));
    end

end