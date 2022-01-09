-- ANSI sequence-based text highlight
--
--[[ Examples
	
	package.loaded["highlight"]  = nil
	hl = require'highlight'
	hl.enabled = true
	print(hl.Color(hl.color.red)() .. " Hello ! " .. hl.hl(30,47,4)() .. hl.Color(hl.color.green, hl.attr.bg, hl.attr.bright)())
	print(" whole the " .. hl.Attr(hl.attr.reverse)() .. "WORld" .. hl.Off() .. "Off")
	hl.enabled = false
	print(hl.Color(hl.color.red)() .. " Hello ! " .. hl.hl(30,47,4)() .. hl.Color(hl.color.green, hl.attr.bg, hl.attr.bright)())

]]--



local hl = {}

hl.enabled = true

local mt = {}

-- If certain highlight is not defined, return empty string
-- This will allow client modules safely use custom highlight definitions

mt.__index = function()
	return ''
end

setmetatable(hl, mt)

local function seq(t, term)
	if hl.enabled then
		local CSI = '\27['
		if term == nil then term = 'm' end

		return CSI .. table.concat(t, ";") .. term
	else
		return ''
	end
end

local function csi(term, ...) local t = {...}; return function() return seq(t, term) end end

local function H(...) return csi('m', ...) end

hl.hl = H
hl.Hl = H

-- Screen and cursor control

hl.Cls = csi('J', 2)

hl.Locate = function(row, col)
	if row == nil then row = 1 end
	if col == nil then col = 1 end

	return csi('H', row, col)
end

hl.CursorSave = csi('s')

hl.CursorRestore = csi('u')

hl.Tab = function(col)
	if col == nil then
		return '\t'
	else
		return csi('G', col)
	end
end

hl.ScrollRange = function(start, stop)
	start = start or ""
	stop = stop or ""

	return csi('r', start, stop)
end

-- Colors and attributes

hl.attr = {}
hl.color = {}


hl.attr.off = 0
hl.attr.bold = 1
hl.attr.faint = 2
hl.attr.italic = 3
hl.attr.underline = 4 
hl.attr.reverse = 7
hl.attr.strikeout = 9

hl.attr.fg = 0
hl.attr.bg = 10
hl.attr.dark = 30
hl.attr.bright = 90

hl.color.black = 0
hl.color.red = 1
hl.color.green = 2
hl.color.yellow = 3
hl.color.blue = 4
hl.color.magenta = 5
hl.color.cyan = 6
hl.color.white = 7

hl.Off = H(hl.attr.off)
hl.Bold = H(hl.attr.bold)
hl.Faint = H(hl.attr.faint)
hl.Italic = H(hl.attr.italic)
hl.Underline = H(hl.attr.underline)
hl.Reverse = H(hl.attr.reverse)
hl.Strikeout = H(hl.attr.strikeout)

hl.Attr = H

-- Standard colors

hl.Color = function(color, dark_bright, fg_bg)
	if dark_bright == nil then dark_bright = hl.attr.dark end
	if fg_bg == nil then fg_bg = hl.attr.fg end
	return H(color + dark_bright + fg_bg)
end
hl.BrightColor = function(color, fg_bg) return hl.Color(color, hl.attr.bright, fg_bg) end
hl.BgColor = function(color, dark_bright) return hl.Color(color, dark_bright, hl.attr.bg) end
hl.BrightBgColor = function(color) return hl.Color(color, hl.attr.bright, hl.attr.bg) end

local colors = { 'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Magenta', 'Cyan', 'White' } 

for i = 0, 7 do
	local color = colors[i+1]
	hl[color] = hl.Color(i)
	hl["Bright" .. color] = hl.BrightColor(i)
	hl["Bg" .. color] = hl.BgColor(i)
	hl["BrightBg" .. color] = hl.BrightBgColor(i)
end

-- 8-bit colors

hl.Color8 = function(color, fg_bg)
	if fg_bg == nil then fg_bg = hl.attr.fg end
	return H(38 + fg_bg, 5, color)
end
hl.BgColor8 = function(color) return hl.Color8(color, hl.attr.bg) end

-- 24-bit colors

hl.Color24 = function(r, g, b, fg_bg)
	if fg_bg == nil then fg_bg = hl.attr.fg end
	return H(38 + fg_bg, 2, r, g, b)
end
hl.BgColor24 = function(r, g, b) return hl.Color24(r, g, b, hl.attr.bg) end

-- Printing color tables

hl.printColorTable = function()
	
	print(hl.Bold() .. hl.Underline() .. "Color table" .. hl.Off())
	print()
	print(hl.Italic() .. "Atributes" .. hl.Off())
	print("\t" .. hl.Off() .. "Off" .. hl.Off())
	print("\t" .. hl.Bold() .. "Bold" .. hl.Off())
	print("\t" .. hl.Faint() .. "Faint" .. hl.Off())
	print("\t" .. hl.Italic() .. "Italic" .. hl.Off())
	print("\t" .. hl.Underline() .. "Underline" .. hl.Off())
	print("\t" .. hl.Strikeout() .. "Strikeout" .. hl.Off())
	print("\t" .. hl.Reverse() .. "Reverse" .. hl.Off())
	print()
	print(hl.Italic() .. "Standard colors" .. hl.Off())
	print("\t\t" .. hl.Faint() .. "Dark" .. hl.Off() .. "\t\t" .. hl.Bold() .. "Bright" .. hl.Off())
	print(hl.Faint() .. "\tText\t" .. hl.Reverse() .. "Bg" .. hl.Off() .. hl.Bold() .. "\tText\t" .. hl.Reverse() .. "Bg" .. hl.Off())
	for i = 0,7 do
		local color = colors[i + 1]
		print("\t" .. hl.Color(i)() .. color .. 
			"\t" .. hl.Color((i + 1) % 8)() .. hl.BgColor(i)() .. color .. hl.Off() ..
			"\t" .. hl.BrightColor(i)() .. color ..
			"\t" .. hl.Color((i + 1) % 8)() .. hl.BrightBgColor(i)() .. color .. hl.Off())
	end
	print()
	print(hl.Italic() .. "8-bit colors (standard, 6-bit RGB, grayscale)" .. hl.Off())
	local c = 0
	local s = "\t"
	for c = 0, 15 do
		s = s .. hl.Color8(c)() .. string.format(" %02x", c)
	end
	s = s .. "\n\t" .. hl.Color8(0x10)()
	for c = 0, 15 do
		s = s .. hl.BgColor8(c)() .. string.format(" %02x", c)
	end
	print(s .. hl.Off())
	for i = 0,6 do
		s = "\t"
		for j = 16,51 do
			c = i * (51-16+1) + j
			if c >= 255 then break end
			s = s .. hl.Color8(c)() .. string.format(" %02x", c)
		end
		s = s .. hl.Black() .. "\n\t"
		for j = 16,51 do
			c = i * (51-16+1) + j
			if c >= 256 then break end
			s = s .. hl.BgColor8(c)() .. string.format(" %02x", c)
		end
		print(s .. hl.Off())
		if c >= 255 then break end
	end
end

-- https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences
hl.Border = function(t, l, h, w)
-- print'\27(0 q x l m k j    \27(B'
-- ─ │ ┌ └ ┐ ┘    
  local s = ''

  s = s .. hl.Locate(t, l)()
  s = s .. '\27(0' 

  s = s .. 'l'
  s = s .. string.rep('q', w - 2)
  s = s .. 'k'

  s = s .. '\27(B' 

  for i = t + 1, t + h - 2 do
    s = s .. hl.Locate(i, l)()
    s = s .. '\27(0' 
    s = s .. 'x'
    s = s .. '\27(B' 

    s = s .. hl.Locate(i, l + w - 1)()
    s = s .. '\27(0' 
    s = s .. 'x'
    s = s .. '\27(B' 
  end


  s = s .. hl.Locate(t + h - 1, l)()
  s = s .. '\27(0' 

  s = s .. 'm'
  s = s .. string.rep('q', w - 2)
  s = s .. 'j'

  s = s .. '\27(B' 

  return s
end

hl.SaveScreen = function()
  return csi('h', '?1049')
end

hl.RestoreScreen = function()
  return csi('l', '?1049')
end

-- Length of the visible string not counting control character
-- If limit is specified, the length of the substring of needed length if returned
hl.strlen = function(s, limit)
  -- Skipping sequences of type
  -- \27[(c*)T
  -- where c is non-aphlabetic and T is any alphabetic terminator
  local len = 0
  local skipping = false
  local strlen = string.len(s)
  for i = 1, strlen do
    local c = string.sub(s, i, i)
    local b = string.byte(c)
    if skipping then
      if (b >= string.byte('A') and b <= string.byte('Z')) or (b >= string.byte('a') and b <= string.byte('z')) then
        skipping = false  
      end
    else
      if b == 27 then
        skipping = true
      else
        len = len + 1
	if limit ~= nil then
	  if len >= limit then
	    return i
	  end
        end
      end
    end
  end

  if limit ~= nil then
    return strlen
  else
    return len
  end
end

hl.pad = function(s, width, char)
  local pad = width - hl.strlen(s)
  if pad > 0 then
    if char == nil then char = ' ' end
    return s .. string.rep(char, pad)
  else
    return s
  end
end

hl.cut = function(s, width)
  local cutpoint = hl.strlen(s, width)

  if cutpoint > width then
    return string.sub(s, 1, cutpoint)
  else
    return s
  end
end

hl.align = function(s, width)
  return hl.pad(hl.cut(s, width), width)
end

return hl
