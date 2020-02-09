function IND = select_signals_amplitute(pool)

IND = [1:240];
for i = 1:length(pool)
    highest = max(pool{i});
    IND = intersect(find(highest>0.07), IND);
end

end