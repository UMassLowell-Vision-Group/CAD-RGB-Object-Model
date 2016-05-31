% this file will generate trainval file from ./boxes.
% then it will generate the output file to ./trainval_file
% it will first read all the image and then do a randperm.

basedir = '/home/xpeng/A_PROJECTS/2016_NIPS/';
img_base = '/home/xpeng/A_PROJECTS/2016_NIPS/texture_crop/';
file_basedir='/home/xpeng/A_PROJECTS/2016_NIPS/trainval_file/';

dirlist = dir([img_base ]);  
fid= fopen([file_basedir 'train.txt'], 'w');

for i = 3:length(dirlist)
	fprintf('%d\n', i);
%for i  = 3:3
	imglist = dir([img_base dirlist(i).name '/*.jpg']);
	for j =1:length(imglist)
		fprintf(fid, '%s %d\n', [img_base, dirlist(i).name '/' imglist(j).name], i-3);
	end
end



fclose all;
