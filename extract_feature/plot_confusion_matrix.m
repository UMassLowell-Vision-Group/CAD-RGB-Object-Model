tickname={'aero','bike','bird','boat','botle', 'bus','car', 'cat','chair', ... 
 'cow', 'table', 'dog', 'horse','mbik','pers','plant','sheep','sofa','train','tv'};
cat_ld = load('cat_texture.mat');
feat_cache_ld = load('feat_merge_gussian.mat');

cat = cat_ld.cat;
feat_cache = feat_cache_ld.feat_cache - 1;
feat_cache =feat_cache;


[sort_gt, ind] = sort(cat, 'ascend');
feat_cache = feat_cache(ind);
sind = find(sort_gt==feat_cache);
fprintf('%f\n', length(sind)/length(cat));
[C,index] = confusionmat( feat_cache,sort_gt);
x_sum = sum(C);
C = double(C);
p=zeros(20,1);
for i =1:20
	C(:,i) = C(:,i)/x_sum(i);
	p(i) = C(i,i);
end




imagesc(C);

set(gca,'XTickLabel',tickname(1:20));

xtick_rotate([1:20],45,tickname,'Fontsize',11,'FontWeight', 'Bold');

set(gca,'yTickLabel',tickname(1:20));
ytick_rotate([1:20],45,tickname,'Fontsize',11,'FontWeight', 'Bold');

%ylabel('Prediction');

%xlabel('Ground Truth');
title('Confusion Matrix (Texture CNN)','Fontsize',12);
%xlabel('Ground Truth');

