function capacitanceCalculatorGUI
    % Create the main figure
    mainFig = figure('Name', 'Capacitance Calculator', 'NumberTitle', 'off', ...
        'Position', [100, 100, 800, 600], 'MenuBar', 'none', 'ToolBar', 'none', ...
        'Resize', 'off', 'CloseRequestFcn', @closeApp);

    % Create UI components
    uicontrol('Style', 'text', 'String', 'Relative Permittivity (εr):', 'Position', [50, 550, 150, 20]);
    epsulonEdit = uicontrol('Style', 'edit', 'Position', [200, 550, 80, 25]);

    uicontrol('Style', 'text', 'String', 'Width (x1):', 'Position', [50, 500, 80, 20]);
    x1Edit = uicontrol('Style', 'edit', 'Position', [200, 500, 80, 25]);

    uicontrol('Style', 'text', 'String', 'Width (x2):', 'Position', [50, 450, 80, 20]);
    x2Edit = uicontrol('Style', 'edit', 'Position', [200, 450, 80, 25]);

    uicontrol('Style', 'text', 'String', 'Height (y1):', 'Position', [50, 400, 80, 20]);
    y1Edit = uicontrol('Style', 'edit', 'Position', [200, 400, 80, 25]);

    uicontrol('Style', 'text', 'String', 'Height (y2):', 'Position', [50, 350, 80, 20]);
    y2Edit = uicontrol('Style', 'edit', 'Position', [200, 350, 80, 25]);

    calculateButton = uicontrol('Style', 'pushbutton', 'String', 'Calculate', 'Position', [300, 50, 100, 40], 'Callback', @calculateCapacitance);

    % Set default values
    set(epsulonEdit, 'String', '1');
    set(x1Edit, 'String', '1');
    set(x2Edit, 'String', '5');
    set(y1Edit, 'String', '1');
    set(y2Edit, 'String', '5');

    % Create axes for geometry and result plots
    axGeometry = axes('Parent', mainFig, 'Position', [0.05, 0.2, 0.4, 0.7]);
    axResult = axes('Parent', mainFig, 'Position', [0.55, 0.2, 0.4, 0.7]);

    % Update capacitance function
    function calculateCapacitance(~, ~)
        % Get user input
        epsulon_R_dielectric_medium = str2double(get(epsulonEdit, 'String'));
        x1 = str2double(get(x1Edit, 'String'));
        x2 = str2double(get(x2Edit, 'String'));
        y1 = str2double(get(y1Edit, 'String'));
        y2 = str2double(get(y2Edit, 'String'));

        % Check for invalid inputs
        if isnan(epsulon_R_dielectric_medium) || isnan(x1) || isnan(x2) || isnan(y1) || isnan(y2)
            msgbox('Invalid input. Please enter numeric values.', 'Error', 'error');
            return;
        end

        % Your existing code for the capacitance calculation
        % ...

        % Visualization of the geometry
        visualizeGeometry(axGeometry, x1, x2, y1, y2);

        % Visualization of the result (you need to adapt this part based on your result visualization)
        % visualizeResults(axResult, R);
        % ...

        % Display results or update the GUI as needed
        % ...
    end

    % Close application function
    function closeApp(~, ~)
        selection = questdlg('Do you want to close the Capacitance Calculator?', 'Close Request', 'Yes', 'No', 'No');
        if strcmp(selection, 'Yes')
            delete(mainFig);
        end
    end

    % Function to visualize the geometry
    function visualizeGeometry(ax, x1, x2, y1, y2)
        cla(ax);
        hold(ax, 'on');
        rectangle(ax, 'Position', [x1, y1, x2 - x1, y2 - y1], 'EdgeColor', 'b', 'LineWidth', 2);
        xlabel(ax, 'X-axis');
        ylabel(ax, 'Y-axis');
        title(ax, 'Capacitor Geometry');
        axis(ax, 'equal');
        grid(ax, 'on');
        hold(ax, 'off');
    end
end
