function [ final_row , final_col ] = findCell( submatrix, number )

    index = rem(number-1,16) + 1; % index of the submatrix
    Sub_index = mod (  ( rem(number-1,16) + fix((number-1)/16) )  , 4 )+1; % index inside submatrix

    %% find_rc

    [row,col] = find_rc(submatrix, index);

    %% inSubmatrix

    [drow, dcol] = inSubmatrix(Sub_index);

    %% final index

    final_row = row + drow;
    final_col = col + dcol;
    
end

