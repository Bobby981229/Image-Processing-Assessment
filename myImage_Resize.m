% The aim of function is to rescale image size
function imageResize = myImage_Resize(image, x, y)

[h, w]=size(image);
imageResize=zeros(h*x,w*y);
rot=[x 0 0;0 y 0;0 0 1];     % Transformation matrix

for i=1:h*x
    for j=1:w*y
        pix=[i j 1]/rot;
        
        float_Y=pix(1)-floor(pix(1));
        float_X=pix(2)-floor(pix(2));
        
        if pix(1) < 1 % Boundary handling
            pix(1) = 1;
        end
        
        if pix(1) > h
            pix(1) = h;
        end
        
        if pix(2) < 1
            pix(2) =1;
        end
        
        if pix(2) > w
            pix(2) =w;
        end
        
        % Four adjacent points
        pix_up_left=[floor(pix(1)) floor(pix(2))];
        pix_up_right=[floor(pix(1)) ceil(pix(2))];
        pix_down_left=[ceil(pix(1)) floor(pix(2))];
        pix_down_right=[ceil(pix(1)) ceil(pix(2))];
        
        
        % Calculate the weights of the four adjacent points
        value_up_left=(1-float_X)*(1-float_Y); 
        value_up_right=float_X*(1-float_Y);
        value_down_left=(1-float_X)*float_Y;
        value_down_right=float_X*float_Y;
        
        % Bilinear interpolation by weight
        imageResize(i,j)=value_up_left*image(pix_up_left(1),pix_up_left(2))+ ...
            value_up_right*image(pix_up_right(1),pix_up_right(2))+ ...
            value_down_left*image(pix_down_left(1),pix_down_left(2))+ ...
            value_down_right*image(pix_down_right(1),pix_down_right(2));
    end
end

% Convert to an 8-bit unsigned integer.
imageResize = uint8(imageResize);