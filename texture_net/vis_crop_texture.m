img = imread('/home/xpeng/A_PROJECTS/2016_NIPS/texture/bicycle/0a0ef015a9a00964274e1c2f94bdd201.jpeg');
[h , w , d]= size(img);

f_img =figure;
imshow(img,'border','tight');

hold on;
for i = 1:40
	crop_ratio = 0.05+0.2*rand(4,1); % crop ratio is between 5%~15%.

	margin_x_left = ceil(crop_ratio(1)*w);
	crop_x_left = margin_x_left;
	margin_x_right = ceil(crop_ratio(3)*w);
	crop_x_right = w-margin_x_right;

	margin_y_upper = ceil(crop_ratio(2)*h);
	crop_y_upper = margin_y_upper;
	margin_y_down  = ceil(crop_ratio(4)*h);
	crop_y_down = h - margin_y_down;
	rectangle('Position', [crop_x_left,crop_y_upper, crop_x_right-crop_x_left, crop_y_down-crop_y_upper],...
	'LineWidth', 2, 'EdgeColor', 'r');
	hold on;
end
%	crop_img = img(crop_y_upper:crop_y_down,crop_x_left:crop_x_right, :);


	
	
frm_img = getframe(f_img);
imwrite(frm_img.cdata, 'save.png')

%-------------------------------------

%imshow(crop_img);
