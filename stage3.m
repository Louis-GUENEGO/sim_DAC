function [ diag ] = stage3( diag )

    temp = diag;
    diag([2 3]) = temp ([3 2]);
    diag([6 7]) = temp ([7 6]);
    diag([10 11]) = temp ([11 10]);
    diag([14 15]) = temp ([15 14]);

end

