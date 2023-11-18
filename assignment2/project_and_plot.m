function project_and_plot(P, Xs, im, x)
    % project and plot the 3D points "Xs"
    % inot the camera "P" on the image "im",
    % alongside plotting the "im" image
    % point "x"
    xProj = pflat(P * Xs);
    visible = isfinite(x(1 ,:)); 
    imagesc(im);
    hold on;
    plot(x(1, visible), x(2, visible),'*');
    plot(xProj(1,visible), xProj(2,visible),'ro');
end