% Calculate precision and recall ratio to evaluate the method
function [precision, recall] = precision_recall(true_matrix, distance)
%    retrieved = true neighbors
%    distance  = estimated distances

max_hamm = max(distance( : ));
% hamm_thresh = min(3,max_hamm);
total_good_pairs = sum(true_matrix( : ));

% find pairs with similar codes
precision = zeros(max_hamm,1);
recall = zeros(max_hamm,1);

for n = 1:length(precision)
    j = (distance <= ((n - 1) + 0.00001));
    good_pairs = sum(true_matrix(j));
    pairs = sum(j( : ));
    precision(n) = good_pairs / pairs;
    recall(n) = good_pairs / total_good_pairs;
end