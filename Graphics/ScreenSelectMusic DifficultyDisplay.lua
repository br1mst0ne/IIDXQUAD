local t = Def.ActorFrame {};

local tLocation = {
	Beginner	= 18*0.40,
	Easy 		= 18*1.46,
	Medium		= 18*2.52,
	Hard		= 18*3.58,
	Challenge	= 18*4.64,
	Edit 		= 18*5.70,
};
local tColour = {
	Beginner	= "#01c6f8",
	Easy 		= "#01c6f8",
	Medium		= "#f1a201",
	Hard		= "#f1a201",
	Challenge	= "#f00200",
	Edit 		= "#f00200",
};
function str(num)
	str2 = " "
	for e = 1,num do	
		str2 = str2.." " 
	end
	return str2
end

t[#t+1] = Def.ActorFrame {
	LoadFont("StepsDisplay","Meter") .. {
		--i'm lazy ;)
		Text="DIFFICULTY"..str(9).."EASY"..str(77).."HARD";
		InitCommand=function(self)
			self:y(-6):zoom(0.4):zoomy(0.3):diffuse(color("#ffffff")):x(-346):strokecolor(color("#000000")):halign(0)
		end;
	};
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(390,20):x(-170)
		end;
		CurrentSongChangedMessageCommand=function(self)
			self:playcommand("On")
		end;
		CurrentStepsP1ChangedMessageCommand=function(self)
			self:playcommand("On")
		end;
		OnCommand=function(self)
			if GAMESTATE:GetCurrentSteps(PLAYER_1) then
				local diffname = ToEnumShortString(GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty())
				local song = GAMESTATE:GetCurrentSong()
				if song then
					self:y(tLocation[diffname])
					self:diffuse(color(tColour[diffname]))
				else
					self:diffusealpha(0)
				end;
			end;
		end
	}
};

for idx,diff in pairs(Difficulty) do
	local sDifficulty = ToEnumShortString( diff );
	t[#t+1] = Def.ActorFrame {
		SetCommand=function(self)
			local c = self:GetChildren();
			local song = GAMESTATE:GetCurrentSong()
			local meter = "";
			if song then
				local st = GAMESTATE:GetCurrentStyle():GetStepsType()
				local steps = song:GetOneSteps( st, diff );
				if steps then
					meter = steps:GetMeter();
				end
			end
			c.Meter:settext( meter );
			c.Diff:settext( sDifficulty );
		end;
		CurrentSongChangedMessageCommand=function(self)
			self:playcommand("Set")
		end;
		--
		Def.Quad{
			InitCommand=function(self)
				self:zoomto(30,15):y(tLocation[sDifficulty]):diffuse(color("0,0,0,0.5"))
			end;
		};
		Def.Quad{
			InitCommand=function(self)
				self:zoomto(260,15):y(tLocation[sDifficulty]):diffuse(color("0,0,0,0.5")):x(-150)
			end;
		};
		Def.Quad{
			InitCommand=function(self)
				self:zoomto(70,15):y(tLocation[sDifficulty]):diffuse(color("0,0,0,0.5")):x(-320)
			end;
		};
		LoadFont("StepsDisplay","Meter") .. {
			Name="Diff";
			InitCommand=function(self)
				self:y(tLocation[sDifficulty]):zoom(0.5):diffuse(color( tColour[sDifficulty] )):x(-320):strokecolor(color("#000000"))
			end;
		};
		LoadFont("StepsDisplay","Meter") .. {
			Name="Meter";
			InitCommand=function(self)
				self:y(tLocation[sDifficulty]):zoomy(0.5):diffuse(color( tColour[sDifficulty] )):strokecolor(color("#000000"))
			end;
		};
	};
	for i = 1,12 do
		t[#t+1] = Def.ActorFrame {
			InitCommand=function(self)
				self:x(-280)
			end;
			Def.Quad{
				InitCommand=function(self)
					self:zoomto(16,9):y(tLocation[sDifficulty]):diffuse(color( tColour[sDifficulty] )):x(i*20)
				end;
				CurrentSongChangedMessageCommand=function(self) 
				local song = GAMESTATE:GetCurrentSong()
					local song = GAMESTATE:GetCurrentSong()
					if song then
						local st = GAMESTATE:GetCurrentStyle():GetStepsType()
						local steps = song:GetOneSteps( st, diff );
						if steps then
							meter = steps:GetMeter();
							if i < meter+1 then 
								self:diffusealpha(1)
							else
								self:diffusealpha(0.5)
							end
						else
							self:diffusealpha(0.5)
						end
					else
						self:diffusealpha(0.5)
					end	
				end;
			};
		};
	end
end
return t