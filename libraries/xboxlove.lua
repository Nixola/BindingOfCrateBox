--[[
	Copyright © 2013 Samuel Guillaume
	This work is free. You can redistribute it and/or modify it under the
	terms of the Do What The Fuck You Want To Public License, Version 2,
	as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
--]]

local _PLATFORM = os.getenv("windir") and "win32" or "unix"
local joystickCount = love.joystick.getJoystickCount()

xboxlove = {}
xboxlove.__index = xboxlove

function xboxlove.create(joystick)

	local new = {}
	setmetatable(new,xboxlove)

	if not (joystick and joystick:isGamepad()) then

		return nil
	end

	new.joystick = joystick

	new.Axes = {}
	new.Axes.LeftX        = 0
	new.Axes.LeftY        = 0
	new.Axes.LeftAngle    = nil 
	new.Axes.Triggers     = 0
	new.Axes.LeftTrigger  = 0
	new.Axes.RightTrigger = 0
	new.Axes.RightX       = 0
	new.Axes.RightY       = 0
	new.Axes.RightAngle   = nil
  
	new.Axes.Deadzone = {}
	new.Axes.Deadzone.LeftX        = 0
	new.Axes.Deadzone.LeftY        = 0
	new.Axes.Deadzone.LeftTrigger  = 0
	new.Axes.Deadzone.RightTrigger = 0
	new.Axes.Deadzone.Triggers     = 0
	new.Axes.Deadzone.RightX       = 0
	new.Axes.Deadzone.RightY       = 0

	new.Dpad = {}
	new.Dpad.Direction = 'c'
	new.Dpad.Centered  = true
	new.Dpad.Up 	   = false
	new.Dpad.Down 	   = false
	new.Dpad.Right 	   = false
	new.Dpad.Left 	   = false

	new.Buttons = {}
	new.Buttons.A          = false
	new.Buttons.B          = false
	new.Buttons.X          = false
	new.Buttons.Y          = false
	new.Buttons.LT         = false
	new.Buttons.RT         = false
	new.Buttons.LB         = false
	new.Buttons.RB         = false
	new.Buttons.Back       = false
	new.Buttons.Start      = false
	new.Buttons.LeftStick  = false
	new.Buttons.RightStick = false
	new.Buttons.Home       = false

	return new
end

function xboxlove:getJoystick()
	return self.joystick
end

function xboxlove:setJoystick(joystick)
	joystick = tonumber(joystick)
	if not joystick then return false
	elseif joystick < 1 or joystick > joystickCount then
		return false
	end
	self.joystick = joystick
	return true
end

function xboxlove:setDeadzone(axes,deadzone)
	deadzone = tonumber(deadzone)
	if not deadzone then return false
	elseif deadzone >= 1 or deadzone < 0 then return false end

	axes = tostring(axes):upper()
	done = false
	if axes == "ALL" then
		self.Axes.Deadzone.LeftX    = deadzone
		self.Axes.Deadzone.LeftY    = deadzone
		self.Axes.Deadzone.Triggers = deadzone
		self.Axes.Deadzone.RightX   = deadzone
		self.Axes.Deadzone.RightY   = deadzone
		done = true
	else
		if axes:find("LX") then
			self.Axes.Deadzone.LeftX        = deadzone ; done = true end
		if axes:find("LY") then    
			self.Axes.Deadzone.LeftY        = deadzone ; done = true end
		if axes:find("TRIG") then    
			self.Axes.Deadzone.Triggers     = deadzone ; done = true end
		if axes:find("TLEFT") then
			self.Axes.Deadzone.LeftTrigger  = deadzone ; done = true end
		if axes:find("TRIGHT") then
			self.Axes.Deadzone.RightTrigger = deadzone ; done = true end
		if axes:find("RX") then
			self.Axes.Deadzone.RightX       = deadzone ; done = true end
		if axes:find("RY") then    
			self.Axes.Deadzone.RightY       = deadzone ; done = true end
	end

	return done
end

function xboxlove:isDown(button)
	for k,v in pairs(self.Buttons) do
		if k:upper() == tostring(button):upper() then return v end
	end
	return false
end

function xboxlove:update(dt)
	--if _PLATFORM == "win32" then

		-- Axes :
		self.Axes.LeftX    = self.joystick:getGamepadAxis("leftx")
		self.Axes.LeftY    = self.joystick:getGamepadAxis("lefty")
		--self.Axes.Triggers = love.joystick.getAxis(self.joystick,3)
		self.Axes.RightX   = self.joystick:getGamepadAxis("rightx")
		self.Axes.RightY   = self.joystick:getGamepadAxis("righty")
		--[[
		if self.Axes.Triggers < 0 then 
			self.Axes.RightTrigger = math.abs(self.Axes.Triggers)
			self.Axes.LeftTrigger = 0
		elseif self.Axes.Triggers > 0 then
			self.Axes.LeftTrigger  = math.abs(self.Axes.Triggers)
			self.Axes.RightTrigger = 0
		else
			self.Axes.RightTrigger = 0
			self.Axes.LeftTrigger = 0
		end--]]
		self.Axes.leftTrigger  = self.joystick:getGamepadAxis("triggerleft")
		self.Axes.RightTrigger = self.joystick:getGamepadAxis("triggerright")

			-- Dpad :
		local Dpad = self.joystick:getHat(1)
		if Dpad == 'c' then
			self.Dpad.Centered = true
			self.Dpad.Up       = false
			self.Dpad.Down     = false
			self.Dpad.Right    = false
			self.Dpad.Left     = false
		else
			self.Dpad.Centered = false
			if Dpad:find('d') then self.Dpad.Down  = true else self.Dpad.Down  = false end
			if Dpad:find('r') then self.Dpad.Right = true else self.Dpad.Right = false end
			if Dpad:find('u') then self.Dpad.Up    = true else self.Dpad.Up    = false end
			if Dpad:find('l') then self.Dpad.Left  = true else self.Dpad.Left  = false end
		end
		self.Dpad.Direction = Dpad

			-- Buttons
		self.Buttons.A          = self.joystick:isGamepadDown("a")
		self.Buttons.B          = self.joystick:isGamepadDown("b")
		self.Buttons.X          = self.joystick:isGamepadDown("x")
		self.Buttons.Y          = self.joystick:isGamepadDown("y")
		self.Buttons.LB         = self.joystick:isGamepadDown("leftshoulder")
		self.Buttons.RB         = self.joystick:isGamepadDown("rightshoulder")
		self.Buttons.Back       = self.joystick:isGamepadDown("back")
		self.Buttons.Start      = self.joystick:isGamepadDown("start")
		self.Buttons.LeftStick  = self.joystick:isGamepadDown("leftstick")
		self.Buttons.RightStick = self.joystick:isGamepadDown("rightstick")
		self.Buttons.Home       = self.joystick:isGamepadDown("guide")

		self.Buttons.LT = self.joystick:getGamepadAxis("triggerleft") == 1
		self.Buttons.RT = self.joystick:getGamepadAxis("triggerright") == 1

	--[[else
			-- Axes
		self.Axes.LeftX    = self.joystick:getGamepadAxis("leftx")
		self.Axes.LeftY    = self.joystick:getGamepadAxis("lefty")
		--self.Axes.Triggers = love.joystick.getAxis(self.joystick,3)
		self.Axes.RightX   = self.joystick:getGamepadAxis("rightx")
		self.Axes.RightY   = self.joystick:getGamepadAxis("righty")
		self.Axes.leftTrigger  = self.joystick:getGamepadAxis("triggerleft")
		self.Axes.RightTrigger = self.joystick:getGamepadAxis("triggerright")

			-- Dpad
		self.Dpad.Up    = love.joystick.isDown(self.joystick, 1)
		self.Dpad.Down  = love.joystick.isDown(self.joystick, 2)
		self.Dpad.Left  = love.joystick.isDown(self.joystick, 3)
		self.Dpad.Right = love.joystick.isDown(self.joystick, 4)

		self.Dpad.Direction = ''
		if (not self.Dpad.Up) and (not self.Dpad.Down) and (not self.Dpad.Left) and (not self.Dpad.Right) then
			self.Dpad.Direction = 'c'
			self.Dpad.Centered = true
		else
			self.Dpad.Centered = false
			if self.Dpad.Right then
				self.Dpad.Direction = self.Dpad.Direction..'r'
			elseif self.Dpad.Left then
				self.Dpad.Direction = self.Dpad.Direction..'l'
			end

			if self.Dpad.Down then
				self.Dpad.Direction = self.Dpad.Direction..'d'
			elseif self.Dpad.Up then
				self.Dpad.Direction = self.Dpad.Direction..'u'
			end
		end

			-- Buttons
		self.Buttons.A          = self.joystick:isGamepadDown("a")
		self.Buttons.B          = self.joystick:isGamepadDown("b")
		self.Buttons.X          = self.joystick:isGamepadDown("x")
		self.Buttons.Y          = self.joystick:isGamepadDown("y")
		self.Buttons.LB         = self.joystick:isGamepadDown("leftshoulder")
		self.Buttons.RB         = self.joystick:isGamepadDown("rightshoulder")
		self.Buttons.Back       = self.joystick:isGamepadDown("back")
		self.Buttons.Start      = self.joystick:isGamepadDown("start")
		self.Buttons.LeftStick  = self.joystick:isGamepadDown("leftstick")
		self.Buttons.RightStick = self.joystick:isGamepadDown("rightstick")
		self.Buttons.Home       = self.joystick:isGamepadDown("guide")

		self.Buttons.LT = self.joystick:getAxis("triggerleft") == 1
		self.Buttons.RT = love.joystick.getAxis("triggerright") == 1

	end--]]
	   
	   -- Apply Deadzones
	local z = 0
	

	if self.Axes.LeftX > 0 then z = 1 else z = -1 end
	self.Axes.LeftX = math.abs(self.Axes.LeftX) - self.Axes.Deadzone.LeftX
	if self.Axes.LeftX < 0 then self.Axes.LeftX = 0 end
	self.Axes.LeftX = self.Axes.LeftX*(1/(1 - self.Axes.Deadzone.LeftX))*z
	
	if self.Axes.LeftY > 0 then z = 1 else z = -1 end
	self.Axes.LeftY = math.abs(self.Axes.LeftY) - self.Axes.Deadzone.LeftY
	if self.Axes.LeftY < 0 then self.Axes.LeftY = 0 end
	self.Axes.LeftY = self.Axes.LeftY*(1/(1 - self.Axes.Deadzone.LeftY))*z

	if math.abs(self.Axes.Triggers) < self.Axes.Deadzone.Triggers then self.Axes.Triggers = 0 end
	
	if self.Axes.RightX > 0 then z = 1 else z = -1 end
	self.Axes.RightX = math.abs(self.Axes.RightX) - self.Axes.Deadzone.RightX
	if self.Axes.RightX < 0 then self.Axes.RightX = 0 end
	self.Axes.RightX = self.Axes.RightX*(1/(1 - self.Axes.Deadzone.RightX))*z
	
	if self.Axes.RightY > 0 then z = 1 else z = -1 end
	self.Axes.RightY = math.abs(self.Axes.RightY) - self.Axes.Deadzone.RightY
	if self.Axes.RightY < 0 then self.Axes.RightY = 0 end
	self.Axes.RightY = self.Axes.RightY*(1/(1 - self.Axes.Deadzone.RightY))*z

	if self.Axes.LeftTrigger  and math.abs(self.Axes.LeftTrigger)  < self.Axes.Deadzone.LeftTrigger  then self.Axes.LeftTrigger  = 0 end
    if self.Axes.RightTrigger and math.abs(self.Axes.RightTrigger) < self.Axes.Deadzone.RightTrigger then self.Axes.RightTrigger = 0 end
	
			-- Angles
	if self.Axes.LeftY == 0 and self.Axes.LeftX == 0 then
    	self.Axes.LeftAngle = nil
    else
    	self.Axes.LeftAngle = math.atan2(self.Axes.LeftY,self.Axes.LeftX)
    end
	if self.Axes.RightY == 0 and self.Axes.RightX == 0 then
    	self.Axes.RightAngle = nil
    else
    	self.Axes.RightAngle = math.atan2(self.Axes.RightY,self.Axes.RightX)
    end
end