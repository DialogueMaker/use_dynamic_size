--!strict

local React = require(script.Parent.roblox_packages.react);

local function useDynamicSize(gui: GuiBase2d?, minimumWidth: number?, minimumHeight: number?): boolean

  local checkCondition = React.useCallback(function()

    assert(gui, "GuiBase2d instance required.");

    local isAtOrAboveMinimumHeight = minimumHeight == nil or gui.AbsoluteSize.Y >= minimumHeight;
    local isAtOrAboveMinimumWidth = minimumWidth == nil or gui.AbsoluteSize.X >= minimumWidth;

    return isAtOrAboveMinimumHeight and isAtOrAboveMinimumWidth;

  end, {gui :: unknown, minimumHeight, minimumWidth});

  local isConditionMet, setIsConditionMet = React.useState(if gui then checkCondition() else false);

  React.useEffect(function()

    if not gui then

      return;

    end;

    local function updateStatus()

      setIsConditionMet(checkCondition());

    end;

    local viewportChangedEvent = gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateStatus);    

    task.spawn(updateStatus);

    return function()

      viewportChangedEvent:Disconnect();

    end;

  end, {gui :: unknown, checkCondition});

  return isConditionMet;

end

return useDynamicSize;