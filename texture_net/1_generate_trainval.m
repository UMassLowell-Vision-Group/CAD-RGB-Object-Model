% this file will generate trainval file from ./boxes.
% then it will generate the output file to ./trainval_file
% it will first read all the image and then do a randperm.

basedir = '/home/xpeng/A_PROJECTS/2016_NIPS/boxes/'
img_base = '/home/xpeng/A_PROJECTS/2016_NIPS/texture/';
matfile = dir([basedir '*.mat']);
metadata = [];
fid_train = fopen('./trainval_file/train.txt', 'w');
keySet = {'aeroplane','bicycle','bird','boat','bottle','bus','car','cat','chair',...
	'cow','dining_table','dog','horse','motorbike','person','potted_plant','sheep','sofa','train','tv_monitor'};
valueSet = [0:19];
mapObj = containers.Map(keySet, valueSet);
for i =1:length(matfile)
	metadata_ld = load([basedir matfile(i).name]);
	metadata =[ metadata , metadata_ld.metadata];
end
save('metadata.mat','metadata');

Index = randperm(length(metadata));
save('Index.mat', 'Index');


%for p = 1:length(metadata)
for p = 1:20
	i = Index(p);
	if metadata(i).imgsize(3)>3
		continue;
	end
	fprintf('%d\n', p);

	fprintf(fid_train, '# %d\n', p-1);%image id
	
	fprintf(fid_train, [img_base metadata(i).class '/' metadata(i).name ]);
	fprintf(fid_train,'\n');
	fprintf(fid_train, '%d\n', metadata(i).imgsize(3)); % channel
	fprintf(fid_train, '%d\n', metadata(i).imgsize(1)); % height
	fprintf(fid_train, '%d\n', metadata(i).imgsize(2)); % width
	
	num_of_box = sum(metadata(i).boxes(:,5));
	fprintf(fid_train, '%d\n', num_of_box); % number of box
	for j = 1:length(metadata(i).boxes)
		if(metadata(i).boxes(j, 5) == 1)
			fprintf(fid_train, '%d %d %d %d %d %d\n', mapObj(metadata(i).class), 1, metadata(i).boxes(j,1),...
			metadata(i).boxes(j,2),metadata(i).boxes(j,3),metadata(i).boxes(j,4));
		end
	end
	
	
end


fclose all;
