function [] = nifti2gif(niftiFile, filename, mprage)
% This function takes a 3-D nifti image and turns it into a gif.
%
% INPUTS:
%   niftiFile: filename of 3-D nifti image
%   filename: filename of output gif image
%   mprage: flag to use MPRAGE settings (1 if MPRAGE, 0 otherwise)

% Code adapted from Benoit_11:
% http://stackoverflow.com/questions/29640641/how-to-convert-nii-format-file-into-2d-image/29641295


% Load file

% % non-SPM approach
% S = load_nii(nifti);
% A = S.img;

% % SPM approach
V = spm_vol(niftiFile);
A = spm_read_vols(V);


% Define slices
NumSlices = size(A,3);

if mprage
    slices = 1:2:NumSlices; % every other slice for mprage
else
    slices = 1:NumSlices;
end


% Draw images for each slice
figure(1)

for k = slices
    
    if mprage
        imshow(squeeze(A(:,k,:,1)),[]) % axial slices for mprage
    else
        imshow(flipud(A(:,:,k,1)'),[]) % default slices, flips to better orientation for epis
    end
    drawnow
    
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    
    pause(.1)
    
end