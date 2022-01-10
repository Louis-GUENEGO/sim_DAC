function [ row,col ] = find_rc ( submatrix, x )

[row,col] = find((submatrix > x-1) & (submatrix < x+1),1);
row = (row-1)*2+1;
col = (col-1)*2+1;

end

