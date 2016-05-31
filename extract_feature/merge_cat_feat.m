a=load('feture_shape_gussian_noise.mat');
a=a.feature;
b=load('feture_texture.mat');
b=b.feature;

sa = sum(a,2);
sb = sum(b,2);

for  i = 1:length(sa)
	a(i, :) = a(i,:)/sa(i);
	b(i, :) = b(i,:)/sb(i);
end
c = max(a,b);
[val, feat_cache] =max(c');

feat_cache =feat_cache';

save('feat_merge_gussian_noise.mat', 'feat_cache');
