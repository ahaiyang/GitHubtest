local _mutils       = require 'app.utils.MUtils'
local SettingLayer = class("SettingLayer",cc.Node)

function SettingLayer:ctor()
	self.root_node = cc.CSLoader:createNode("SettingLayer.csb")
	self:addChild(self.root_node)
	self.root_node:setPositionY(_mutils.getAddH()/2)
	display.getRunningScene():addChild(self)

	local btn_close = _mutils.seekNodeByName(self.root_node, "btn_close")
	
	btn_close:setTouchEnabled(true)
	_mutils.addBtnPressedListener(btn_close, function(sender)
        self:removeFromParent()
    end)

    local soundEftSlider = _mutils.seekNodeByName(self.root_node, "Slider_soundEffect")
    local soundEftPercent = audio.getSoundsVolume()
	soundEftPercent = math.floor(soundEftPercent)
	soundEftSlider:setPercent(soundEftPercent)
	soundEftSlider:addEventListener(function(sender, eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			local soundEftPercent = soundEftSlider:getPercent()
			self:setEffectButton(soundEftPercent)
		end
	end)
	self.soundEftSlider = soundEftSlider

	-- 音乐调节
	local musicSlider = _mutils.seekNodeByName(self.root_node, "Slider_music")
	local musicPercent = audio.getMusicVolume()
	print("musicPercent-->",musicPercent)
	musicPercent = math.floor(musicPercent)
	musicSlider:setPercent(musicPercent*100)
	musicSlider:addEventListener(function(sender, eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			local musicPercent = musicSlider:getPercent()
			self:setMusicButton(musicPercent)
		end
	end)
	self.musicSlider = musicSlider

	self:setEffectButton(50)
	self:setMusicButton(50)

	
end

function SettingLayer:setMusicButton( _volume )
	if not _volume then
		return
	end
	print("_volume-->",_volume)
	self.musicSlider:setPercent(_volume)
	audio.setMusicVolume(_volume/100)
end

function SettingLayer:setEffectButton( _volume )
	if not _volume then
		return
	end
	print("_volume-->",_volume)
	self.soundEftSlider:setPercent(_volume)
	audio.setSoundsVolume(_volume/100)
end
return SettingLayer