function filtered_X = filter_far_3d_points(X)
    radius = 2;
    n_neighbors = 5;

    idx = boolean(dbscan(X(1:3,:)',radius,n_neighbors)+1)';
    filtered_X = X(:,idx);

    disp("filtered from: "+size(X,2)+" to: "+ size(filtered_X,2) +" 3D points");
end
