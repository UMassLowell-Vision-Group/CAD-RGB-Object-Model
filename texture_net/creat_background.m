 target_dir  = '/home/xpeng/project/nips2016/texture/texture_crop/aa';
image_dir = '/home/xpeng/project/nips2016/yfccimage';

image_list = dir(image_dir);
num_base = 100000;
iter = 12;

start_at = iter*num_base+3;  
end_at = (iter+1)*num_base;

for i =start_at :end_at
	fprintf('%d/%d\n', i,end_at);

	im = imread([image_dir '/' image_list(i).name]);
	im = double(im);	
	im_mean=mean(mean(im));
	if ndims(im)<3
		continue;	
	end
	im1=im;
	im1(:,:,1) = im(:,:,1)-im_mean(1,1,1);
	im1(:,:,2) = im(:,:,2)-im_mean(1,1,2);
	im1(:,:,3) = im(:,:,3)-im_mean(1,1,3);
	im1=uint8(im1);
	im = uint8(im);
	aver = sum(sum(sum(im1)))/(size(im1,1)*size(im1,2));
	if aver<10
		continue;
	end
	[h,w,d] = size(im);
	crop_ratio = 0.05 + 0.4 * rand(4,1);
	margin_x_left = ceil(crop_ratio(1)*w);
	crop_x_left = margin_x_left;
	margin_x_right = ceil(crop_ratio(3)*w);
	crop_x_right = w-margin_x_right;
	margin_y_upper = ceil(crop_ratio(2)*h);
	crop_y_upper = margin_y_upper;
	margin_y_down  = ceil(crop_ratio(4)*h);
	crop_y_down = h - margin_y_down;
	crop_img = im(crop_y_upper:crop_y_down,crop_x_left:crop_x_right,:);
	imwrite(crop_img, [target_dir '/' image_list(i).name]);
end
