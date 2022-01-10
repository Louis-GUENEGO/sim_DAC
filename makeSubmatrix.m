function [ submatrix ] = makeSubmatrix( diag )
    submatrix = zeros(4);

    i = 1;
    for a = 0:3
        xy = 1;
        for b = 0:3
            submatrix(xy,mod(xy+a-1,4)+1) = diag(i);
            i = i + 1;
            xy = xy + 1;
        end
    end

end

