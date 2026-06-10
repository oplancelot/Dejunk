-- ============================================================================
-- Dejunk Compatibility Layer for WotLK 3.3.5 (Ascension WoW)
-- This file MUST be loaded before all other Dejunk files.
-- ============================================================================

-- C_Container 兼容
if not C_Container then
  C_Container = {}
end
if not C_Container.GetContainerItemInfo then
  C_Container.GetContainerItemInfo = function(bag, slot)
    local texture, count, locked, quality, readable, lootable, link, _, hasNoValue, itemID = GetContainerItemInfo(bag, slot)
    if not texture then return nil end
    return {
      iconFileID = texture,
      stackCount = count,
      isLocked = locked,
      quality = quality,
      isReadable = readable,
      hasLoot = lootable,
      hyperlink = link,
      hasNoValue = hasNoValue,
      itemID = itemID,
    }
  end
end
C_Container.GetContainerNumSlots = C_Container.GetContainerNumSlots or GetContainerNumSlots
C_Container.GetContainerItemID = C_Container.GetContainerItemID or function(bag, slot)
  local link = GetContainerItemLink(bag, slot)
  if not link then return nil end
  return tonumber(link:match("item:(%d+):"))
end
C_Container.UseContainerItem = C_Container.UseContainerItem or UseContainerItem
C_Container.PickupContainerItem = C_Container.PickupContainerItem or PickupContainerItem
C_Container.GetContainerItemPurchaseInfo = C_Container.GetContainerItemPurchaseInfo or function() return nil end

-- C_Item 兼容
if not C_Item then
  C_Item = {}
end

if not C_Item.GetItemInfo then
  C_Item.GetItemInfo = GetItemInfo
end

if not C_Item.GetItemInfoInstant then
  -- WotLK doesn't have GetItemInfoInstant, so we fallback to GetItemInfo
  C_Item.GetItemInfoInstant = GetItemInfo
end

if not GetItemInfoInstant then
  GetItemInfoInstant = GetItemInfo
end

if not C_Item.GetDetailedItemLevelInfo then
  C_Item.GetDetailedItemLevelInfo = GetDetailedItemLevelInfo or function(item)
    -- In 3.3.5, GetDetailedItemLevelInfo does not exist; fall back to nil so callers use itemLevel
    return nil
  end
end
if not C_Item.GetItemInfoInstant then
  C_Item.GetItemInfoInstant = GetItemInfoInstant or function(itemID)
    -- In 3.3.5, GetItemInfoInstant may not exist; fall back to GetItemInfo
    local name = GetItemInfo(itemID)
    return name and itemID or nil
  end
end
C_Item.IsEquippableItem = C_Item.IsEquippableItem or IsEquippableItem
C_Item.IsCosmeticItem = C_Item.IsCosmeticItem or function() return false end
C_Item.IsLocked = C_Item.IsLocked or function(location)
  if location and location.IsValid and location:IsValid() then
    local bag, slot = location:GetBagAndSlot()
    if bag and slot then
      local _, _, locked = GetContainerItemInfo(bag, slot)
      return locked or false
    end
  end
  return false
end
C_Item.IsBound = C_Item.IsBound or function() return false end
C_Item.IsBoundToAccountUntilEquip = C_Item.IsBoundToAccountUntilEquip or function() return false end

-- C_AddOns 兼容
if not C_AddOns then
  C_AddOns = {}
end
C_AddOns.GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
C_AddOns.LoadAddOn = C_AddOns.LoadAddOn or LoadAddOn

-- C_CurrencyInfo 兼容
if not C_CurrencyInfo then
  C_CurrencyInfo = {}
end
C_CurrencyInfo.GetCoinTextureString = C_CurrencyInfo.GetCoinTextureString or GetCoinTextureString

-- Enum 兼容
if not Enum then
  Enum = {}
end
Enum.ItemQuality = Enum.ItemQuality or {
  Poor = 0, Common = 1, Standard = 1,
  Uncommon = 2, Good = 2,
  Rare = 3, Epic = 4, Legendary = 5, Artifact = 6, Heirloom = 7
}
Enum.ItemClass = Enum.ItemClass or {
  Consumable = 0, Container = 1, Weapon = 2, Gem = 3, Armor = 4,
  Reagent = 5, Projectile = 6, Tradegoods = 7, Recipe = 9, Quiver = 11,
  Quest = 12, Key = 13, Miscellaneous = 15, Battlepet = 17
}
Enum.ItemArmorSubclass = Enum.ItemArmorSubclass or {
  Generic = 0, Cloth = 1, Leather = 2, Mail = 3, Plate = 4,
  Cosmetic = 5, Shield = 6, Libram = 7, Idol = 8, Totem = 9, Sigil = 10, Relic = 11
}
Enum.ItemWeaponSubclass = Enum.ItemWeaponSubclass or {
  Axe1H = 0, Axe2H = 1, Bows = 2, Guns = 3, Mace1H = 4, Mace2H = 5,
  Polearm = 6, Sword1H = 7, Sword2H = 8, Warglaive = 9, Staff = 10,
  Bearclaw = 11, Catclaw = 12, Unarmed = 13, Generic = 14,
  Dagger = 15, Thrown = 16, Obsolete3 = 17, Crossbow = 18,
  Wand = 19, Fishingpole = 20
}
Enum.ItemGemSubclass = Enum.ItemGemSubclass or { Artifactrelic = 11 }
Enum.BankType = Enum.BankType or { Account = 2 }

-- WOW_PROJECT 兼容
WOW_PROJECT_ID = WOW_PROJECT_ID or 11 -- Default to Wrath
WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE or 1
WOW_PROJECT_CLASSIC = WOW_PROJECT_CLASSIC or 2
WOW_PROJECT_BURNING_CRUSADE_CLASSIC = WOW_PROJECT_BURNING_CRUSADE_CLASSIC or 5
WOW_PROJECT_CATACLYSM_CLASSIC = WOW_PROJECT_CATACLYSM_CLASSIC or 14
WOW_PROJECT_MISTS_CLASSIC = WOW_PROJECT_MISTS_CLASSIC or 15
WOW_PROJECT_WRATH_CLASSIC = WOW_PROJECT_WRATH_CLASSIC or 11

-- ItemLocation polyfill
if not ItemLocation then
  ItemLocation = {}
  ItemLocation.__index = ItemLocation
  function ItemLocation:CreateEmpty()
    return setmetatable({ bagID = nil, slotIndex = nil }, self)
  end
  function ItemLocation:SetBagAndSlot(bag, slot)
    self.bagID = bag; self.slotIndex = slot
  end
  function ItemLocation:GetBagAndSlot()
    return self.bagID, self.slotIndex
  end
  function ItemLocation:IsValid()
    return self.bagID ~= nil and self.slotIndex ~= nil
  end
end

-- NUM_TOTAL_EQUIPPED_BAG_SLOTS 兼容
NUM_TOTAL_EQUIPPED_BAG_SLOTS = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4

-- SOUNDKIT 兼容
if not SOUNDKIT then
  SOUNDKIT = {}
end
SOUNDKIT.ITEM_REPAIR = SOUNDKIT.ITEM_REPAIR or 5328

-- SafeUnpack 兼容
if not SafeUnpack then
  SafeUnpack = unpack
end

-- Clamp 兼容
if not Clamp then
  Clamp = function(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
  end
end

-- GetItemInfoFromHyperlink 兼容
if not GetItemInfoFromHyperlink then
  GetItemInfoFromHyperlink = function(link)
    if not link then return nil end
    return tonumber(link:match("item:(%d+):"))
  end
end

-- C_EquipmentSet 兼容 (3.3.5 has Equipment Manager with different API)
if not C_EquipmentSet then
  C_EquipmentSet = {}
end
C_EquipmentSet.GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs or function()
  local ids = {}
  if GetNumEquipmentSets then
    for i = 1, GetNumEquipmentSets() do
      ids[#ids + 1] = i
    end
  end
  return ids
end
C_EquipmentSet.GetItemLocations = C_EquipmentSet.GetItemLocations or function(setId)
  if GetEquipmentSetLocations then
    local name = GetEquipmentSetInfo(setId)
    if name then
      local locations = GetEquipmentSetLocations(name)
      if locations then return locations end
    end
  end
  return {}
end

-- C_Bank 兼容
if not C_Bank then
  C_Bank = {}
end
C_Bank.IsItemAllowedInBankType = C_Bank.IsItemAllowedInBankType or function() return false end

-- EventRegistry polyfill (no-op for 3.3.5)
if not EventRegistry then
  EventRegistry = {}
  function EventRegistry:RegisterCallback(event, callback, owner)
    -- No-op: EventRegistry does not exist in 3.3.5
  end
  function EventRegistry:UnregisterCallback(event, owner)
    -- No-op
  end
end

-- StaticPopup_ForEachShownDialog polyfill
if not StaticPopup_ForEachShownDialog then
  StaticPopup_ForEachShownDialog = function(callback)
    for i = 1, STATICPOPUP_NUMDIALOGS or 4 do
      local popup = _G["StaticPopup" .. i]
      if popup then
        callback(popup)
      end
    end
  end
end

-- SetColorTexture polyfill for 3.3.5
-- In 3.3.5, textures use SetTexture with color values instead of SetColorTexture
do
  local testFrame = CreateFrame("Frame")
  local testTexture = testFrame:CreateTexture()
  if testTexture and not testTexture.SetColorTexture then
    local textureMeta = getmetatable(testTexture)
    if textureMeta and textureMeta.__index then
      textureMeta.__index.SetColorTexture = function(self, r, g, b, a)
        self:SetTexture(r, g, b, a)
      end
    end
  end
  testTexture = nil
  testFrame = nil
end

-- CreateColorFromHexString polyfill
-- In 3.3.5, the Color Mixin and CreateColorFromHexString do not exist.
if not CreateColorFromHexString then
  -- Color mixin polyfill
  local ColorMixin = {}
  ColorMixin.__index = ColorMixin

  function ColorMixin:GetRGBA()
    return self.r, self.g, self.b, self.a
  end

  function ColorMixin:GetRGB()
    return self.r, self.g, self.b
  end

  function ColorMixin:GetRGBAsBytes()
    return
      math.floor(self.r * 255 + 0.5),
      math.floor(self.g * 255 + 0.5),
      math.floor(self.b * 255 + 0.5)
  end

  function ColorMixin:SetRGBA(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
  end

  function ColorMixin:GenerateHexColor()
    return ("ff%.2x%.2x%.2x"):format(self:GetRGBAsBytes())
  end

  function ColorMixin:GenerateHexColorMarkup()
    return "|c" .. self:GenerateHexColor()
  end

  function ColorMixin:WrapTextInColorCode(text)
    return self:GenerateHexColorMarkup() .. text .. "|r"
  end

  CreateColorFromHexString = function(hexString)
    -- hexString format: AARRGGBB
    local a = tonumber(hexString:sub(1, 2), 16) / 255
    local r = tonumber(hexString:sub(3, 4), 16) / 255
    local g = tonumber(hexString:sub(5, 6), 16) / 255
    local b = tonumber(hexString:sub(7, 8), 16) / 255
    local color = setmetatable({ r = r, g = g, b = b, a = a }, ColorMixin)
    return color
  end
end

-- CreateColor polyfill
if not CreateColor then
  CreateColor = function(r, g, b, a)
    return CreateColorFromHexString(
      ("%.2x%.2x%.2x%.2x"):format(
        math.floor((a or 1) * 255 + 0.5),
        math.floor(r * 255 + 0.5),
        math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5)
      )
    )
  end
end

-- WrapTextInColorCode polyfill
if not WrapTextInColorCode then
  WrapTextInColorCode = function(text, colorHexStr)
    -- colorHexStr format: AARRGGBB
    return "|c" .. colorHexStr .. (text or "") .. "|r"
  end
end

-- Mixin polyfill (used extensively in Retail WoW UI framework)
if not Mixin then
  Mixin = function(object, ...)
    for i = 1, select("#", ...) do
      local mixin = select(i, ...)
      if mixin then
        for k, v in pairs(mixin) do
          object[k] = v
        end
      end
    end
    return object
  end
end

-- BackdropTemplateMixin polyfill
-- In 3.3.5, SetBackdrop is native on all frames, so this is a no-op.
if not BackdropTemplateMixin then
  BackdropTemplateMixin = {}
end

-- SetClipsChildren polyfill
-- In 3.3.5, SetClipsChildren may not exist on frames
do
  local testFrame = CreateFrame("Frame")
  if not testFrame.SetClipsChildren then
    local frameMeta = getmetatable(testFrame)
    if frameMeta and frameMeta.__index then
      frameMeta.__index.SetClipsChildren = function() end
    end
  end
  testFrame = nil
end

-- PlaySound compatibility
-- In 3.3.5, PlaySound may accept a sound ID or filename string differently
-- Wrap to handle both numeric IDs and SOUNDKIT table values
do
  local _PlaySound = PlaySound
  if _PlaySound then
    PlaySound = function(soundID, ...)
      if type(soundID) == "number" then
        pcall(_PlaySound, soundID, ...)
      elseif type(soundID) == "string" then
        pcall(_PlaySound, soundID, ...)
      end
    end
  end
end
