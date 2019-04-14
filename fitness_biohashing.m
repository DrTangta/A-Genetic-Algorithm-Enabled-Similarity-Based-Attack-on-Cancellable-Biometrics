function [distance] = fitness_biohashing(x, hashcode,opts)

[transformed_data] = biohashing(x,opts.model);

[distance] = 1 - matching_IoM(hashcode,transformed_data);
end