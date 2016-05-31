% this file is used to generate the boxes from the images. 
% it will read the image files from texture and generate the metadata 
% after that, it will output the metadata file to ./boxes/. 

basedir = '/home/xpeng/A_PROJECTS/2016_NIPS/texture';
textbsdir ='/home/xpeng/A_PROJECTS/2016_NIPS/';
patch_per_image = 40;
dirlist = dir(basedir);
for i = 22:22
	mkdir([textbsdir 'texture_crop/' dirlist(i).name ]);
	fprintf('%s \n', dirlist(i).name);
	imagelist = dir([basedir '/' dirlist(i).name]);
	len = length(imagelist);
	metadata = struct;
	cnt = 1;
	for j = 347:len
			% get only image file
			[filename, fileext] = strtok(imagelist(j).name,'.');
			if (strcmpi(fileext, '.jpg')~=1) &&(strcmpi(fileext, '.png')~=1) &&(strcmpi(fileext, '.jpeg')~=1)
				continue;
			end			

			%info = imfinfo([basedir '/' dirlist(i).name '/' imagelist(j).name]);
			%fprintf('%s \n', 'is image');
			metadata(cnt).name = imagelist(j).name;
			try 
				img = imread([basedir '/' dirlist(i).name '/' imagelist(j).name]); 
			catch
				continue;
			end
			[h , w , d]= size(img);	
			if d>3	%gif files
				continue;
			end
			metadata(cnt).boxes=[];
			metadata(cnt).class = dirlist(i).name;
			metadata(cnt).imgsize = [h, w, d];
			fprintf('%d %d/%d \n', i, j, len);
			for k =1:patch_per_image
				crop_ratio = 0.05+0.2*rand(4,1); % crop ratio is between 5%~15%.
				
				margin_x_left = ceil(crop_ratio(1)*w);
				crop_x_left = margin_x_left;
				margin_x_right = ceil(crop_ratio(3)*w);
				crop_x_right = w-margin_x_right;

				margin_y_upper = ceil(crop_ratio(2)*h);
				crop_y_upper = margin_y_upper;
				margin_y_down  = ceil(crop_ratio(4)*h);
				crop_y_down = h - margin_y_down;

				metadata(cnt).boxes = [metadata(cnt).boxes ;...
				crop_x_left,crop_y_upper, crop_x_right,  crop_y_down,1];
				crop_img = img(crop_y_upper:crop_y_down,crop_x_left:crop_x_right,:);
				if size(crop_img,1)==0
					continue;				
				end
				imwrite(crop_img , [textbsdir 'texture_crop/' dirlist(i).name '/' imagelist(j).name '_' mat2str(k) '.jpg']);
			end
			cnt = cnt+1;
		
	end
	save(['./boxes/' dirlist(i).name '.mat'], 'metadata')
end
