local Addon = select(2, ...) ---@type Addon
local ActionTypes = Addon:GetModule("ActionTypes")
local StateManager = Addon:GetModule("StateManager")
local Wux = Addon.Wux

--- @class Actions
local Actions = Addon:GetModule("Actions")

--- @class ReducerFactories
local ReducerFactories = Addon:GetModule("ReducerFactories")

-- ============================================================================
-- Actions - excludeConsumables
-- ============================================================================

--- @param value boolean
--- @return WuxAction
function Actions:SetExcludeConsumables(value)
  local actionType = StateManager:IsCharacterSpecificSettings() and
      ActionTypes.Perchar.SET_EXCLUDE_CONSUMABLES or
      ActionTypes.Global.SET_EXCLUDE_CONSUMABLES
  return { type = actionType, payload = value }
end

-- ============================================================================
-- ReducerFactories - excludeConsumables
-- ============================================================================

--- Returns a new reducer for `excludeConsumables` using the given `defaultState` and `actionTypes`.
--- @param defaultState GlobalState | PercharState
--- @param actionTypes ActionTypesGlobal | ActionTypesPerchar
--- @return WuxReducer<boolean>
function ReducerFactories.excludeConsumables(defaultState, actionTypes)
  --- @param state boolean
  --- @param action WuxAction
  return function(state, action)
    state = Wux:Coalesce(state, defaultState.excludeConsumables)

    if action.type == actionTypes.SET_EXCLUDE_CONSUMABLES then
      return action.payload
    end

    return state
  end
end
