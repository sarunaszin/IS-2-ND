function cat = arr2cat(arr)
%------------------------------------
% Funkcja zmieniająca kategorie na tablicę (wyjście sieci)
%------------------------------------
    cat = categorical;
    for i=1:size(arr, 2)
        if arr(1, i) == 1
            cat(i) = categorical({'NF'});
        elseif arr(2, i) == 1
            cat(i) = categorical({'OC'});
        elseif arr(3, i) == 1
            cat(i) = categorical({'G'});
        elseif arr(4, i) == 1
            cat(i) = categorical({'OFF'});
        elseif arr(5, i) == 1
            cat(i) = categorical({'SAT'});
        end
    end
end
%------------------------------------