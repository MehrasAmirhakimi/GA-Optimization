function [y1, y2] = ix(x1, x2, sdu)
x = RWS(sdu);
if numel(x1) < 3
    [y1, y2] = ux(x1, x2);
else
    switch x
        case 1
            [y1, y2] = spx(x1, x2);
        case 2
            [y1, y2] = dpx(x1, x2);
        case 3
            [y1, y2] = ux(x1, x2);
    end
end

end