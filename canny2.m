function [edge_final] = canny2(InputImage,T1, T2)
% convert rgb to grayscale and apply double precision to improve image reliability
    InputImage = rgb2gray(InputImage);
  
   %Image Filtering (Gaussian Filter) using predefined function
   FilteredImage = imgaussfilt(InputImage);
  
  %Detection of edges using 1st derivative edge detector (magnitude and orientation)
  [BW,thresh,gv,gh] = edge(FilteredImage,'Sobel');
   magnitude = sqrt(gv.*gv + gh.*gh);
   orientation = atan2(gv,gh)*(180/pi);
   [rows,columns] = size(magnitude);

   %make negative values positive
       for i=1:rows
        for j=1:columns
            if(orientation(i,j) < 0)
                tmp=orientation(i,j);
                orientation(i,j)=tmp + 360;
            end    
        end
       end
  
 

 %------------------Non-maximum suppression------------------------------
  
   % Set Edges to Zeros
    magnitude(1,:)=0;
    magnitude(end,:)=0;
    magnitude(:,1)=0;
    magnitude(:,end)=0;
   
%--------------------------------------------------------------------------------------------------------------------
% For each pixel, check the two neighboring pixels in the gradient
% direction...If pixel < values of the two neighbors --> set to zero
  orientation2 = zeros(size(orientation,1),size(orientation,2));

    for i=1:rows
        for j=1:columns
            if((orientation(i, j) >= 0 ) && (orientation(i, j) < 22.5) || (orientation(i, j) >= 157.5) && (orientation(i, j) < 202.5) || (orientation(i, j) >= 337.5) && (orientation(i, j) <= 360))
                 orientation2(i,j)=0;
            end
            if((orientation(i, j) >= 22.5) && (orientation(i, j) < 67.5) || (orientation(i, j) >= 202.5) && (orientation(i, j) < 247.5))
              orientation2(i,j)=45;
            end
            if((orientation(i, j) >= 67.5 && orientation(i, j) < 112.5) || (orientation(i, j) >= 247.5 && orientation(i, j) < 292.5))
                orientation2(i,j)=90;
            end
            if((orientation(i, j) >= 112.5 && orientation(i, j) < 157.5) || (orientation(i, j) >= 292.5 && orientation(i, j) < 337.5))
               orientation2(i,j)=135;
            end
        end
    end
    

%--------------------------------------------------------------------------------------------------------------
   for i=2:rows-1
        for j=2:columns-1
                if(orientation2(i,j)==0)
                   if(magnitude(i,j) > magnitude(i,j+1) && magnitude(i,j) > magnitude(i,j-1))
                      magnitude(i,j)=0;
                   end
                end
                if(orientation2(i,j)==45)
                   if(magnitude(i,j) > magnitude(i+1,j-1)&& magnitude(i,j) >  magnitude(i-1,j+1))
                       magnitude(i,j)=0;
                   end
                end
                if(orientation2(i,j)==90)
                   if(magnitude(i,j)> magnitude(i+1,j)&& magnitude(i,j) >  magnitude(i-1,j))
                        magnitude(i,j)=0;
                   end
                end
                if(orientation2(i,j)==135)
                   if(magnitude(i,j)> magnitude(i+1,j+1) &&  magnitude(i,j) >  magnitude(i-1,j-1))
                        magnitude(i,j)=0;
                   end
                end
        end
   end

%-----------------------------------------------------------------------------------------------------------
    for i=2:rows-1 %#ok<*FXSET>
        for j=2:columns-1
            if(magnitude(i,j) > T2)
                magnitude(i,j) = 1;
            elseif(magnitude(i,j) < T1)
                magnitude(i,j)=0;
            elseif (magnitude(i+1,j)>T2 || magnitude(i-1,j)>T2 || magnitude(i,j+1)>T2 || magnitude(i,j-1)>T2 || magnitude(i-1, j-1)>T2 || magnitude(i-1, j+1)>T2 || magnitude(i+1, j+1)>T2 || magnitude(i+1, j-1)>T2)
                magnitude(i,j) = 1;
            end 
        end
    end
    
edge_final = uint8(magnitude.*255);
%  imshow(magnitude);
%Show final edge detection result
imshow(edge_final);
%------------------------------------------------------------------------------------------------------------------
 
end