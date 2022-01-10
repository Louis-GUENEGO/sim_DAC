function [ drow,dcol ] = inSubmatrix( index )

    if (index == 2)
        drow = 0;
        dcol = 1;
    elseif (index == 3)
        drow = 1;
        dcol = 1;
    elseif (index == 4)
        drow = 1;
        dcol = 0;
    elseif (index == 1)
        drow = 0;
        dcol = 0;
    else
        drow = 100000;
        dcol = 100000;
    end
    
end

