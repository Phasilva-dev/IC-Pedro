function [nsanitarios] = sorteia_sanitario(nmoradores)

prob = random('Uniform',0,1);

if nmoradores == 1
    if prob < 0.79
        nsanitarios = 1;
    elseif prob > 0.79 && prob <0.95
        nsanitarios = 2;
    elseif prob > 0.95 && prob <0.99
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 2
    if prob < 0.70
        nsanitarios = 1;
    elseif prob > 0.70 && prob <0.92
        nsanitarios = 2;
    elseif prob > 0.92 && prob <.98
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 3
    if prob < 0.69
        nsanitarios = 1;
    elseif prob > 0.69 && prob <0.91
        nsanitarios = 2;
    elseif prob > 0.91 && prob <.98
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 4
    if prob < 0.65
        nsanitarios = 1;
    elseif prob > 0.65 && prob <0.89
        nsanitarios = 2;
    elseif prob > 0.89 && prob <.97
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 5
    if prob < 0.67
        nsanitarios = 1;
    elseif prob > 0.67 && prob <0.90
        nsanitarios = 2;
    elseif prob > 0.90 && prob <.97
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 6
    if prob < 0.69
        nsanitarios = 1;
    elseif prob > 0.69 && prob <0.91
        nsanitarios = 2;
    elseif prob > 0.91 && prob <.97
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 7
    if prob < 0.69
        nsanitarios = 1;
    elseif prob > 0.69 && prob <0.92
        nsanitarios = 2;
    elseif prob > 0.92 && prob <.97
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 8
    if prob < 0.70
        nsanitarios = 1;
    elseif prob > 0.7 && prob <0.91
        nsanitarios = 2;
    elseif prob > 0.91 && prob <.97
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 9
    if prob < 0.70
        nsanitarios = 1;
    elseif prob > 0.7 && prob <0.91
        nsanitarios = 2;
    elseif prob > 0.91 && prob <.97
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 10
    if prob < 0.69
        nsanitarios = 1;
    elseif prob > 0.69 && prob <0.9
        nsanitarios = 2;
    elseif prob > 0.9 && prob <.97
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 11
    if prob < 0.69
        nsanitarios = 1;
    elseif prob > 0.69 && prob <0.9
        nsanitarios = 2;
    elseif prob > 0.9 && prob <.96
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 12
    if prob < 0.67
        nsanitarios = 1;
    elseif prob > 0.67 && prob <0.88
        nsanitarios = 2;
    elseif prob > 0.88 && prob <.95
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores == 13
    if prob < 0.66
        nsanitarios = 1;
    elseif prob > 0.66 && prob <0.87
        nsanitarios = 2;
    elseif prob > 0.87 && prob <.95
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
elseif nmoradores >= 14
    if prob < 0.63
        nsanitarios = 1;
    elseif prob > 0.63 && prob <0.84
        nsanitarios = 2;
    elseif prob > 0.84 && prob <.92
        nsanitarios = 3;
    else
        nsanitarios = 4;
    end
end

 
    

        
        