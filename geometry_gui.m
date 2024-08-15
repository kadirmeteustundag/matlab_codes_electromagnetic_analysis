function geometry_gui
    % Create a figure and axes
    fig = figure('Position', [100 100 500 500]);
    ax = axes('Parent', fig, 'Units', 'normalized', 'Position', [0.1 0.1 0.8 0.8]);

    % Create a rectangle
    rect = imrect(ax, [100 100 200 200]);

    % Create an ellipse
    ellipse = imellipse(ax, [200 200 150 100]);

    % Create a polygon
    polygon = impoly(ax, [300 300; 350 400; 400 350; 350 300]);

    % Create a freehand drawing
    freehand = imfreehand(ax);

    % Add a button to clear the axes
    uicontrol('Style', 'pushbutton', 'String', 'Clear Axes', ...
        'Units', 'normalized', 'Position', [0.1 0.9 0.2 0.05], ...
        'Callback', @(~,~) clear_axes(ax));
end

function clear_axes(ax)
    % Clear the axes
    cla(ax);
end