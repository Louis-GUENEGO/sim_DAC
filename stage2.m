function [ diag ] = stage2( diag )

    temp = diag;
    diag(5:8) = temp (13:16);
    diag(13:16) = temp(5:8);

end

