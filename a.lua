local v_u_1 = {
	["HITBOX_SIZE"] = Vector3.new(2.4, 6.992, 2.4),
	["WALK_SPEED"] = 17.268,
	["SPRINT_SPEED"] = 23,
	["CROUCH_SPEED"] = 5.2,
	["JUMP_VELOCITY"] = 34,
	["PLAYER_REACH"] = 16,
	["ACCELERATION_SPEED"] = 10,
	["DECELERATION_SPEED"] = 10,
	["AIR_ACCELERATION_SPEED"] = 2,
	["AIR_DECELERATION_SPEED"] = 2,
	["FLY_ACCELERATION_SPEED"] = 8,
	["FLY_DECELERATION_SPEED"] = 5,
	["GRAVITY"] = -58,
	["GRAVITY_SCALE"] = 2
}
v_u_1.TERMINAL_VELOCITY = -156.8 * v_u_1.GRAVITY_SCALE
local v_u_2 = v_u_1.HITBOX_SIZE * 0.5
v_u_1.PlayerStates = {}
v_u_1.PersistentStates = {}
function v_u_1.AddPlayer(p3, p4) -- name: AddPlayer
	local v5 = {
		["PLAYER_VELOCITY"] = Vector3.new(0, 0, 0),
		["ABSOLUTE_POSITION"] = Vector3.new(0, 0, 0),
		["canJump"] = false,
		["crouching"] = false,
		["sprinting"] = false,
		["sprintHeld"] = false,
		["anchored"] = false,
		["lastCrouchState"] = nil,
		["jumpHoldDebounce"] = false,
		["OVERLAP"] = nil,
		["neckC0"] = nil,
		["OVERLAP"] = OverlapParams.new(),
		["neckC0"] = CFrame.new()
	}
	v5.OVERLAP.FilterDescendantsInstances = { p4.Character }
	v5.OVERLAP.FilterType = Enum.RaycastFilterType.Exclude
	v5.OVERLAP.CollisionGroup = "Hitbox"
	p3.PlayerStates[p4] = v5
	p3.PersistentStates[p4] = {
		["blocking"] = false
	}
	return v5
end
function v_u_1.RemovePlayer(p6, p7) -- name: RemovePlayer
	p6.PlayerStates[p7] = nil
end
function v_u_1.getCandidates(p8, p9, p10, p11) -- name: getCandidates
	local v12 = p8.PlayerStates[p9].OVERLAP
	local v13 = p10 + p11 * 0.5
	local v14 = p11.X
	local v15 = math.abs(v14) + 2.4000000953674316
	local v16 = p11.Y
	local v17 = math.abs(v16) + 6.992000102996826
	local v18 = p11.Z
	local v19 = math.abs(v18) + 2.4000000953674316
	local v20 = Vector3.new(v15, v17, v19)
	return workspace:GetPartBoundsInBox(CFrame.new(v13), v20, v12)
end
function v_u_1.sweepAxis(p21, p22, p23, p24, p25, p26) -- name: sweepAxis
	-- upvalues: (copy) v_u_2
	if p24 == 0 then
		return p23, 0, false, nil
	end
	local _ = p21.PlayerStates[p22]
	local v27 = p22.Character
	local v28 = v_u_2
	local v29 = p23.X - v28.X
	local v30 = p23.Y - v28.Y
	local v31 = p23.Z - v28.Z
	local v32 = Vector3.new(v29, v30, v31)
	local v33 = p23.X + v28.X
	local v34 = p23.Y + v28.Y
	local v35 = p23.Z + v28.Z
	local v36 = Vector3.new(v33, v34, v35)
	local v37 = p24
	local v38 = false
	local v39 = nil
	for _, v40 in ipairs(p26) do
		if v40:IsA("BasePart") and (v40.CanCollide and not v40:IsDescendantOf(v27)) then
			local v41 = v40.Size * 0.5
			local v42 = v40.Position - v41
			local v43 = v40.Position + v41
			if p25 == "Y" then
				local v44 = v32.X
				local v45 = v36.X
				local v46 = v42.X
				local v47
				if v44 <= v43.X then
					v47 = v46 <= v45
				else
					v47 = false
				end
				if v47 then
					local v48 = v32.Z
					local v49 = v36.Z
					local v50 = v42.Z
					local v51
					if v48 <= v43.Z then
						v51 = v50 <= v49
					else
						v51 = false
					end
					if v51 then
						if p24 > 0 then
							local v52 = v42.Y - v36.Y
							if v52 >= 0 and v52 < v37 then
								v39 = v40
								v37 = v52
								v38 = true
							end
						else
							local v53 = v43.Y - v32.Y
							if v53 <= 0 and v37 < v53 then
								v39 = v40
								v37 = v53
								v38 = true
							end
						end
					end
				end
			elseif p25 == "X" then
				local v54 = v32.Y
				local v55 = v36.Y
				local v56 = v42.Y
				local v57
				if v54 <= v43.Y then
					v57 = v56 <= v55
				else
					v57 = false
				end
				if v57 then
					local v58 = v32.Z
					local v59 = v36.Z
					local v60 = v42.Z
					local v61
					if v58 <= v43.Z then
						v61 = v60 <= v59
					else
						v61 = false
					end
					if v61 then
						if p24 > 0 then
							local v62 = v42.X - v36.X
							if v62 >= 0 and v62 < v37 then
								v39 = v40
								v37 = v62
								v38 = true
							end
						else
							local v63 = v43.X - v32.X
							if v63 <= 0 and v37 < v63 then
								v39 = v40
								v37 = v63
								v38 = true
							end
						end
					end
				end
			else
				local v64 = v32.X
				local v65 = v36.X
				local v66 = v42.X
				local v67
				if v64 <= v43.X then
					v67 = v66 <= v65
				else
					v67 = false
				end
				if v67 then
					local v68 = v32.Y
					local v69 = v36.Y
					local v70 = v42.Y
					local v71
					if v68 <= v43.Y then
						v71 = v70 <= v69
					else
						v71 = false
					end
					if v71 then
						if p24 > 0 then
							local v72 = v42.Z - v36.Z
							if v72 >= 0 and v72 < v37 then
								v39 = v40
								v37 = v72
								v38 = true
							end
						else
							local v73 = v43.Z - v32.Z
							if v73 <= 0 and v37 < v73 then
								v39 = v40
								v37 = v73
								v38 = true
							end
						end
					end
				end
			end
		end
	end
	if v38 then
		if v37 > 0 then
			local v74 = v37 - 0.0001
			v37 = math.max(0, v74)
		else
			local v75 = v37 + 0.0001
			v37 = math.min(0, v75)
		end
	end
	local v76
	if p25 == "Y" then
		v76 = p23 + Vector3.new(0, v37, 0)
	elseif p25 == "X" then
		v76 = p23 + Vector3.new(v37, 0, 0)
	else
		v76 = p23 + Vector3.new(0, 0, v37)
	end
	return v76, v37, v38, v39
end
function v_u_1.tryStepUp(p77, p78, p79, p80, p81, _) -- name: tryStepUp
	-- upvalues: (copy) v_u_2
	local v82 = p77.PlayerStates[p78]
	local v83 = v82.canJump
	local v84 = p78.Character
	if not v83 or p81 == 0 then
		return nil
	end
	local v85 = p81 > 0 and 1 or -1
	local v86 = p79 + (p80 == "X" and Vector3.new(v85, 0, 0) or Vector3.new(0, 0, v85)) * ((p80 == "X" and v_u_2.X or v_u_2.Z) + 0.02)
	local v87 = p80 == "X" and Vector3.new(0, 0, 1) or Vector3.new(1, 0, 0)
	local v88 = p80 == "X" and v_u_2.Z or v_u_2.X
	local v89 = v86 - v87 * (v88 - 0.02)
	local v90 = v86 + v87 * (v88 - 0.02)
	local v91 = RaycastParams.new()
	v91.FilterDescendantsInstances = { v84 }
	v91.FilterType = Enum.RaycastFilterType.Exclude
	local v92 = p79.Y - v_u_2.Y
	local v93 = v92 + 2 + 0.6
	local v94 = nil
	for _, v95 in ipairs({ v86, v89, v90 }) do
		local v96 = workspace
		local v97 = v95.X
		local v98 = v95.Z
		local v99 = v96:Raycast(Vector3.new(v97, v93, v98), Vector3.new(0, -3.1, 0), v91)
		if v99 and v99.Normal.Y > 0.6 then
			local v100 = v99.Position.Y
			if not v94 or v94 < v100 then
				v94 = v100
			end
		end
	end
	if not v94 then
		return nil
	end
	local v101 = v94 - v92
	if v101 <= 0 or v101 > 2.001 then
		return nil
	end
	local v102 = v101 + 0.02
	local v103 = p77:getCandidates(p78, p79, (Vector3.new(0, v102, 0)))
	local v104, v105, v106 = p77:sweepAxis(p78, p79, v101 + 0.02, "Y", v103)
	if v106 and v105 < v101 - 0.001 then
		return nil
	end
	local v107, _, v108 = p77:sweepAxis(p78, v104, p81, p80, (p77:getCandidates(p78, v104, p80 == "X" and Vector3.new(p81, 0, 0) or Vector3.new(0, 0, p81))))
	if v108 then
		return nil
	end
	local v109 = v82.PLAYER_VELOCITY.X
	local v110 = v82.PLAYER_VELOCITY.Z
	v82.PLAYER_VELOCITY = Vector3.new(v109, 0, v110)
	return v107
end
function v_u_1.canStepDown(p111, p112, p113, p114) -- name: canStepDown
	-- upvalues: (copy) v_u_2
	if p114.Magnitude < 1e-6 then
		return false
	end
	local v115 = p111.PlayerStates[p112]
	local v116 = p112.Character
	local v117 = v115.OVERLAP
	local v118 = p114.X
	local v119 = p114.Z
	local v120 = p113 + Vector3.new(v118, 0, v119)
	local v121 = p113.Y - v_u_2.Y
	local v122 = v120.X
	local v123 = v121 - 1.05
	local v124 = v120.Z
	local v125 = Vector3.new(v122, v123, v124)
	local v126 = workspace:GetPartBoundsInBox(CFrame.new(v125), Vector3.new(2.3500001, 2.1, 2.3500001), v117)
	for _, v127 in ipairs(v126) do
		if v127:IsA("BasePart") and (v127.CanCollide and not v127:IsDescendantOf(v116)) then
			local v128 = v127.Position.Y + v127.Size.Y * 0.5
			if v128 < v121 - 0.05 and v121 - v128 <= 2.05 then
				return true
			end
		end
	end
	return false
end
function v_u_1.sweptMove(p129, p130, p131, p132) -- name: sweptMove
	-- upvalues: (copy) v_u_2
	local v133 = p129:getCandidates(p130, p131, p132)
	local v134 = p129.PlayerStates[p130]
	local v135 = v134.canJump
	local v136 = v134.PLAYER_VELOCITY
	local v137, _, v138 = p129:sweepAxis(p130, p131, p132.Y, "Y", v133)
	if v138 and v136.Y < 0 then
		local v139 = v136.X
		local v140 = v136.Z
		v136 = Vector3.new(v139, 0, v140)
	elseif v138 and v136.Y > 0 then
		local v141 = v136.X
		local v142 = v136.Z
		v136 = Vector3.new(v141, 0, v142)
	end
	local v143, _, v144, v145 = p129:sweepAxis(p130, v137, p132.X, "X", v133)
	if v144 then
		local v146 = p129:tryStepUp(p130, v137, "X", p132.X, v133)
		if v146 then
			v143 = v146
		else
			local v147 = false
			if v135 and v145 then
				local v148 = v145.Position.Y + v145.Size.Y * 0.5 - (v137.Y - v_u_2.Y)
				v147 = v148 > -0.05 and v148 <= 2.05 and true or v147
			end
			if not v147 then
				local v149 = v136.Y
				local v150 = v136.Z
				v136 = Vector3.new(0, v149, v150)
			end
		end
	end
	local v151, _, v152, v153 = p129:sweepAxis(p130, v143, p132.Z, "Z", v133)
	if v152 then
		local v154 = p129:tryStepUp(p130, v143, "Z", p132.Z, v133)
		if v154 then
			v151 = v154
		else
			local v155 = false
			if v135 and v153 then
				local v156 = v153.Position.Y + v153.Size.Y * 0.5 - (v143.Y - v_u_2.Y)
				v155 = v156 > -0.05 and v156 <= 2.05 and true or v155
			end
			if not v155 then
				local v157 = v136.X
				local v158 = v136.Y
				v136 = Vector3.new(v157, v158, 0)
			end
		end
	end
	v134.PLAYER_VELOCITY = v136
	return v151
end
function v_u_1.resolveCollision(p159, p160, p161, p162, p163, p164) -- name: resolveCollision
	local v165 = p159.PlayerStates[p160]
	local v166 = v165.PLAYER_VELOCITY
	local v167 = p161 - p162 / 2
	local v168 = p161 + p162 / 2
	local v169 = p163 - p164 / 2
	local v170 = p163 + p164 / 2
	local v171 = v168.X - v169.X
	local v172 = v170.X - v167.X
	local v173 = math.min(v171, v172)
	local v174 = v168.Y - v169.Y
	local v175 = v170.Y - v167.Y
	local v176 = math.min(v174, v175)
	local v177 = v168.Z - v169.Z
	local v178 = v170.Z - v167.Z
	local v179 = math.min(v177, v178)
	local v180
	if v176 < v173 then
		v180 = v176 < v179
	else
		v180 = false
	end
	local v181
	if v180 then
		if p161.Y > p163.Y then
			v181 = p161 + Vector3.new(0, v176, 0)
			if v166.Y < 0 then
				local v182 = v166.X
				local v183 = v166.Z
				v166 = Vector3.new(v182, 0, v183)
			end
		else
			v181 = p161 - Vector3.new(0, v176, 0)
			if v166.Y > 0 then
				local v184 = v166.X
				local v185 = v166.Z
				v166 = Vector3.new(v184, 0, v185)
			end
		end
	elseif v173 < v179 then
		if p161.X > p163.X then
			v181 = p161 + Vector3.new(v173, 0, 0)
		else
			v181 = p161 - Vector3.new(v173, 0, 0)
		end
		local v186 = v166.X
		if math.abs(v186) > 0 and (p161.X > p163.X and v166.X < 0 or p161.X < p163.X and v166.X > 0) then
			local v187 = v166.Y
			local v188 = v166.Z
			v166 = Vector3.new(0, v187, v188)
			if v165.sprinting == true and v166.Z < 17.27 then
				v165.sprinting = false
			end
		end
	else
		if p161.Z > p163.Z then
			v181 = p161 + Vector3.new(0, 0, v179)
		else
			v181 = p161 - Vector3.new(0, 0, v179)
		end
		local v189 = v166.Z
		if math.abs(v189) > 0 and (p161.Z > p163.Z and v166.Z < 0 or p161.Z < p163.Z and v166.Z > 0) then
			local v190 = v166.X
			local v191 = v166.Y
			v166 = Vector3.new(v190, v191, 0)
			if v165.sprinting == true and v166.Z < 17.27 then
				v165.sprinting = false
			end
		end
	end
	v165.PLAYER_VELOCITY = v166
	return v181
end
function v_u_1.checkCollisions(p192, p193, _) -- name: checkCollisions
	local _ = p192.PlayerStates[p193]
	local v194 = p193.Character
	local v195 = v194.PlayerHitbox
	local v196 = v195.Position
	local v197 = OverlapParams.new()
	v197.FilterDescendantsInstances = { v194 }
	v197.FilterType = Enum.RaycastFilterType.Exclude
	local v198 = workspace:GetPartBoundsInBox(CFrame.new(v196), Vector3.new(2.4, 6.992, 2.4), v197)
	for _, v199 in pairs(v198) do
		if v199:IsA("BasePart") and (not v199:IsDescendantOf(v194) and v199.CanCollide) then
			local v200 = v199.Position
			local v201 = v199.Size
			local v202 = v196 - Vector3.new(1.2, 3.496, 1.2)
			local v203 = v196 + Vector3.new(1.2, 3.496, 1.2)
			local v204 = v200 - v201 / 2
			local v205 = v200 + v201 / 2
			local v206
			if v202.X <= v205.X then
				v206 = v203.X >= v204.X
			else
				v206 = false
			end
			local v207
			if v202.Y <= v205.Y then
				v207 = v203.Y >= v204.Y
			else
				v207 = false
			end
			local v208
			if v202.Z <= v205.Z then
				v208 = v203.Z >= v204.Z
			else
				v208 = false
			end
			if v206 then
				if not v207 then
					v208 = v207
				end
			else
				v208 = v206
			end
			if v208 then
				v196 = p192:resolveCollision(p193, v196, Vector3.new(2.4, 6.992, 2.4), v200, v201)
			end
		end
	end
	v195.CFrame = CFrame.new(v196)
end
function v_u_1.applyGravity(p209, p210, p211) -- name: applyGravity
	-- upvalues: (copy) v_u_1
	local v212 = p209.PlayerStates[p210]
	local v213 = v212.PLAYER_VELOCITY
	local v214 = v_u_1.TERMINAL_VELOCITY
	local v215 = v_u_1.GRAVITY
	local v216 = v_u_1.GRAVITY_SCALE
	local v217 = p210.Character
	local v218 = v217.PlayerHitbox
	local v219 = v215 * v216 * p211
	local v220 = v213 + Vector3.new(0, v219, 0)
	if v220.Y < v214 then
		local v221 = v220.X
		local v222 = v220.Z
		v220 = Vector3.new(v221, v214, v222)
	end
	local v223 = v218.Position
	local v224 = v220.Y * p211
	local v225 = v223 + Vector3.new(0, v224, 0)
	local v226 = v218.Position
	local v227 = OverlapParams.new()
	v227.FilterDescendantsInstances = { v217 }
	v227.FilterType = Enum.RaycastFilterType.Exclude
	local v228 = workspace:GetPartBoundsInBox(CFrame.new(v226), Vector3.new(2.4, 6.992, 2.4), v227)
	for _, v229 in pairs(v228) do
		if v229:IsA("BasePart") and (not v229:IsDescendantOf(v217) and v229.CanCollide) then
			local v230 = v229.Position
			local v231 = v229.Size
			local v232 = v225 - Vector3.new(1.2, 3.496, 1.2)
			local v233 = v225 + Vector3.new(1.2, 3.496, 1.2)
			local v234 = v230 - v231 / 2
			local v235 = v230 + v231 / 2
			local v236
			if v232.X <= v235.X then
				v236 = v233.X >= v234.X
			else
				v236 = false
			end
			local v237
			if v232.Y <= v235.Y then
				v237 = v233.Y >= v234.Y
			else
				v237 = false
			end
			local v238
			if v232.Z <= v235.Z then
				v238 = v233.Z >= v234.Z
			else
				v238 = false
			end
			if v236 then
				if not v237 then
					v238 = v237
				end
			else
				v238 = v236
			end
			if v238 then
				v225 = p209:resolveCollision(p210, v225, Vector3.new(2.4, 6.992, 2.4), v230, v231)
			end
		end
	end
	v218.CFrame = CFrame.new(v225)
	v212.PLAYER_VELOCITY = v220
end
function v_u_1.checkGroundedAt(_, p239, p240) -- name: checkGroundedAt
	local v241 = p239.Character
	local v242 = RaycastParams.new()
	v242.CollisionGroup = "Hitbox"
	v242.FilterDescendantsInstances = { v241 }
	v242.FilterType = Enum.RaycastFilterType.Exclude
	local v243 = {
		p240 + Vector3.new(1.1800001, 0, 1.1800001),
		p240 + Vector3.new(-1.1800001, 0, 1.1800001),
		p240 + Vector3.new(1.1800001, 0, -1.1800001),
		p240 + Vector3.new(-1.1800001, 0, -1.1800001),
		p240
	}
	for _, v244 in ipairs(v243) do
		if workspace:Raycast(v244, Vector3.new(0, -3.596, 0), v242) then
			return true
		end
	end
	return false
end
function v_u_1.checkGrounded(p245, p246) -- name: checkGrounded
	return p245:checkGroundedAt(p246, p246.Character.PlayerHitbox.Position)
end
function v_u_1.clampHorizDeltaToEdge(p247, p248, p249, p250) -- name: clampHorizDeltaToEdge
	local v251 = p247.PlayerStates[p248].PLAYER_VELOCITY
	if p250.Magnitude < 1e-6 then
		local v252 = v251.Y
		Vector3.new(0, v252, 0)
		return Vector3.new(0, 0, 0)
	elseif p247:checkGroundedAt(p248, p249 + p250) then
		return p250
	else
		local v253 = p250.X
		local v254 = Vector3.new(v253, 0, 0)
		local v255 = p250.Z
		local v256 = Vector3.new(0, 0, v255)
		local v257 = p247:checkGroundedAt(p248, p249 + v254)
		local v258 = p247:checkGroundedAt(p248, p249 + v256)
		if v257 and not v258 then
			local v259 = v251.X
			local v260 = v251.Y
			Vector3.new(v259, v260, 0)
			return v254
		elseif v258 and not v257 then
			local v261 = v251.Y
			local v262 = v251.Z
			Vector3.new(0, v261, v262)
			return v256
		elseif v257 and v258 then
			local v263 = p250.X
			local v264 = math.abs(v263)
			local v265 = p250.Z
			if math.abs(v265) <= v264 then
				local v266 = v251.X
				local v267 = v251.Y
				Vector3.new(v266, v267, 0)
				return v254
			else
				local v268 = v251.Y
				local v269 = v251.Z
				Vector3.new(0, v268, v269)
				return v256
			end
		else
			local v270 = 0
			local v271 = 1
			for _ = 1, 7 do
				local v272 = (v270 + v271) * 0.5
				if p247:checkGroundedAt(p248, p249 + p250 * v272) then
					v270 = v272
				else
					v271 = v272
				end
			end
			local v273 = p250 * v270
			local v274 = v251.X * v270
			local v275 = v251.Y
			local v276 = v251.Z * v270
			Vector3.new(v274, v275, v276)
			return v273
		end
	end
end
function v_u_1.onJumpRequest(p277, p278) -- name: onJumpRequest
	local v279 = p277.PlayerStates[p278]
	if v279 then
		local v280 = v279.canJump
		local _ = v279.jumpHoldDebounce
		local v281 = p277.JUMP_VELOCITY
		local v282 = v279.PLAYER_VELOCITY
		if v280 then
			local v283 = v282.X
			local v284 = v282.Z
			local v285 = Vector3.new(v283, v281, v284)
			if v279.sprinting and (v279.moveVector and v279.moveVector.Magnitude > 0.001) then
				local v286 = v279.moveVector.Unit * 5
				local v287 = v286.X
				local v288 = v286.Z
				v285 = v285 + Vector3.new(v287, 0, v288)
			end
			v279.PLAYER_VELOCITY = v285
		end
	end
end
function v_u_1.SimulateMovement(p289, p290, p291) -- name: SimulateMovement
	local v292 = p289.PlayerStates[p290]
	local v293 = p290.Character
	if v293 then
		local v294 = v293:FindFirstChild("PlayerHitbox")
		if v294 and v293:FindFirstChildWhichIsA("Humanoid") then
			v292.canJump = p289:checkGrounded(p290)
			if v292.jumping and v292.canJump then
				p289:onJumpRequest(p290)
			end
			local v295 = v292.moveVector or Vector3.new(0, 0, 0)
			local v296 = v292.rawInput or Vector3.new(0, 0, 0)
			local v297 = v292.crouching
			local v298 = v292.sprinting
			local v299 = v292.sprintHeld
			local v300 = p289.WALK_SPEED
			if v297 then
				v300 = p289.CROUCH_SPEED
			elseif v298 then
				v300 = p289.SPRINT_SPEED
			end
			local v301 = v296 * v300
			local v302 = v292.PLAYER_VELOCITY.Y
			if v295.Magnitude > 0 then
				if v292.canJump then
					local v303 = v292.PLAYER_VELOCITY
					local v304 = v301.X
					local v305 = v301.Z
					v292.PLAYER_VELOCITY = v303:Lerp(Vector3.new(v304, 0, v305), p289.ACCELERATION_SPEED * p291)
				else
					local v306 = v292.PLAYER_VELOCITY
					local v307 = v301.X
					local v308 = v301.Z
					v292.PLAYER_VELOCITY = v306:Lerp(Vector3.new(v307, 0, v308), p289.AIR_ACCELERATION_SPEED * p291)
				end
			else
				if not v299 then
					v292.sprinting = false
				end
				if v292.canJump then
					v292.PLAYER_VELOCITY = v292.PLAYER_VELOCITY:Lerp(Vector3.new(0, 0, 0), p289.DECELERATION_SPEED * p291)
				else
					v292.PLAYER_VELOCITY = v292.PLAYER_VELOCITY:Lerp(Vector3.new(0, 0, 0), p289.AIR_DECELERATION_SPEED * p291)
				end
			end
			if v295.Magnitude > 0 and v295.Z >= 0 then
				v292.sprinting = false
			elseif v295.Z < 0 and v299 then
				v292.sprinting = true
			end
			local v309 = v292.PLAYER_VELOCITY.X
			local v310 = v292.PLAYER_VELOCITY.Z
			v292.PLAYER_VELOCITY = Vector3.new(v309, v302, v310)
			local v311 = v292.PLAYER_VELOCITY.X
			local v312 = v292.PLAYER_VELOCITY.Z
			local v313 = Vector3.new(v311, 0, v312) * p291
			local v314 = v292.PLAYER_VELOCITY.Y * p291
			if v297 and (v292.canJump and v313) then
				if p289:checkGroundedAt(p290, v294.Position + v313) then
					if v296.Magnitude > 0.1 then
						v313 = p289:clampHorizDeltaToEdge(p290, v294.Position, v313)
					end
				elseif not p289:canStepDown(p290, v294.Position, v313) then
					if v296.Magnitude <= 0.1 then
						local v315 = v292.PLAYER_VELOCITY.Y
						v292.PLAYER_VELOCITY = Vector3.new(0, v315, 0)
						v313 = Vector3.new(0, 0, 0)
					else
						v313 = p289:clampHorizDeltaToEdge(p290, v294.Position, v313)
					end
				end
			end
			local v316 = v313 + Vector3.new(0, v314, 0)
			local v317 = p289:sweptMove(p290, v294.Position, v316)
			v292.ABSOLUTE_POSITION = v317
			local v318 = v292.PLAYER_VELOCITY.X
			local v319 = v292.PLAYER_VELOCITY.Z
			if Vector3.new(v318, 0, v319).Magnitude < 1 then
				v292.sprinting = false
			end
			local v320 = v292.PLAYER_VELOCITY.X
			local v321 = p289.TERMINAL_VELOCITY
			local v322 = v292.PLAYER_VELOCITY.Y + p289.GRAVITY * p289.GRAVITY_SCALE * p291
			local v323 = math.max(v321, v322)
			local v324 = v292.PLAYER_VELOCITY.Z
			v292.PLAYER_VELOCITY = Vector3.new(v320, v323, v324)
			if v292.lastCrouchState == true and not v297 then
				local v325 = v292.PLAYER_VELOCITY.X
				local v326 = v292.PLAYER_VELOCITY.Z
				if Vector3.new(v325, 0, v326).Magnitude < 0.5 then
					local v327 = v292.PLAYER_VELOCITY.Y
					v292.PLAYER_VELOCITY = Vector3.new(0, v327, 0)
				end
			end
			v294.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v294.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			v292.lastCrouchState = v297
			return v317
		end
	end
end
function v_u_1.normalizeXZ(_, p328) -- name: normalizeXZ
	local v329 = p328.X
	local v330 = p328.Z
	local v331 = Vector3.new(v329, 0, v330)
	local v332 = v331.Magnitude
	return v332 <= 1e-6 and Vector3.new(0, 0, 0) or v331 / v332
end
function v_u_1.TickMovement(p333, p334, p335) -- name: TickMovement
	if p333.PlayerStates[p334] then
		return p333:SimulateMovement(p334, p335)
	end
end
return v_u_1
local v_u_1 = {
	["Items"] = {
		["red_terracotta"] = {
			["id"] = "red_terracotta",
			["type"] = "block",
			["displayName"] = "Red Clay",
			["maxStack"] = 64,
			["timeToDestroy"] = 0.3
		},
		["blue_terracotta"] = {
			["id"] = "blue_terracotta",
			["type"] = "block",
			["displayName"] = "Blue Clay",
			["maxStack"] = 64,
			["timeToDestroy"] = 0.3
		},
		["sword"] = {
			["id"] = "sword",
			["type"] = "sword",
			["displayName"] = "Steel Sword",
			["maxStack"] = 1,
			["damage"] = 30
		},
		["pickaxe"] = {
			["id"] = "pickaxe",
			["type"] = "pickaxe",
			["displayName"] = "Pickaxe",
			["maxStack"] = 1
		},
		["stair"] = {
			["id"] = "stair",
			["type"] = "stair",
			["displayName"] = "stairs bruh",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 1
		},
		["golden_apple"] = {
			["id"] = "golden_apple",
			["type"] = "food",
			["displayName"] = "Heal Apple",
			["maxStack"] = 64
		},
		["bow"] = {
			["id"] = "bow",
			["type"] = "bow",
			["displayName"] = "Bow",
			["maxStack"] = 1
		},
		["white_terracotta"] = {
			["id"] = "white_terracotta",
			["type"] = "block",
			["displayName"] = "White Clay",
			["maxStack"] = 64,
			["timeToDestroy"] = 0.3
		},
		["grass"] = {
			["id"] = "grass",
			["type"] = "block",
			["displayName"] = "Grass Block",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["bricks"] = {
			["id"] = "bricks",
			["type"] = "block",
			["displayName"] = "Bricks",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["brick_stairs"] = {
			["id"] = "brick_stairs",
			["type"] = "stair",
			["displayName"] = "Brick Stairs",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["smooth_stone"] = {
			["id"] = "smooth_stone",
			["type"] = "block",
			["displayName"] = "Smooth Stone",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["stone_slab"] = {
			["id"] = "stone_slab",
			["type"] = "block",
			["displayName"] = "Stone Slab",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["stone_bricks"] = {
			["id"] = "stone_bricks",
			["type"] = "block",
			["displayName"] = "Stone Bricks",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["stone_brick_stairs"] = {
			["id"] = "stone_brick_stairs",
			["type"] = "stair",
			["displayName"] = "Stone Brick Stairs",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["leaves"] = {
			["id"] = "leaves",
			["type"] = "block",
			["displayName"] = "Leaves",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["dirt"] = {
			["id"] = "dirt",
			["type"] = "block",
			["displayName"] = "Dirt",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["sand"] = {
			["id"] = "sand",
			["type"] = "block",
			["displayName"] = "Sand",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["sandstone"] = {
			["id"] = "sandstone",
			["type"] = "block",
			["displayName"] = "Sandstone",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["smooth_sandstone"] = {
			["id"] = "smooth_sandstone",
			["type"] = "block",
			["displayName"] = "Smooth Sandstone",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["stone"] = {
			["id"] = "stone",
			["type"] = "block",
			["displayName"] = "Stone",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["blue_wool"] = {
			["id"] = "blue_wool",
			["type"] = "block",
			["displayName"] = "Blue Wool",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["red_wool"] = {
			["id"] = "red_wool",
			["type"] = "block",
			["displayName"] = "Red Wool",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["prismarine_bricks"] = {
			["id"] = "prismarine_bricks",
			["type"] = "block",
			["displayName"] = "Prismarine Bricks",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["dark_prismarine_bricks"] = {
			["id"] = "dark_prismarine_bricks",
			["type"] = "block",
			["displayName"] = "Dark Prismarine Bricks",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["prismarine"] = {
			["id"] = "prismarine",
			["type"] = "block",
			["displayName"] = "Prismarine",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["packed_ice"] = {
			["id"] = "packed_ice",
			["type"] = "block",
			["displayName"] = "Packed Ice",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["sea_lantern"] = {
			["id"] = "sea_lantern",
			["type"] = "block",
			["displayName"] = "Sea Lantern",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["acacia_log"] = {
			["id"] = "acacia_log",
			["type"] = "block",
			["displayName"] = "Acacia Log",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["quartz_pillar"] = {
			["id"] = "quartz_pillar",
			["type"] = "block",
			["displayName"] = "Quartz Pillar",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["quartz_block"] = {
			["id"] = "quartz_block",
			["type"] = "block",
			["displayName"] = "Quartz Block",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["andesite"] = {
			["id"] = "andesite",
			["type"] = "block",
			["displayName"] = "Andesite",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["polished_andesite"] = {
			["id"] = "polished_andesite",
			["type"] = "block",
			["displayName"] = "Polished Andesite",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["acacia_plank"] = {
			["id"] = "acacia_plank",
			["type"] = "block",
			["displayName"] = "Acacia Plank",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["glass"] = {
			["id"] = "glass",
			["type"] = "block",
			["displayName"] = "Glass",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["clay"] = {
			["id"] = "clay",
			["type"] = "block",
			["displayName"] = "Clay",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["arrow"] = {
			["id"] = "arrow",
			["type"] = "item",
			["displayName"] = "Arrow (Regenerates every 4s)",
			["maxStack"] = 64
		},
		["tempblock"] = {
			["id"] = "tempblock",
			["type"] = "block",
			["displayName"] = "Red Clay",
			["maxStack"] = 64,
			["timeToDestroy"] = 0.3,
			["decayTime"] = 6
		},
		["sword_strong"] = {
			["id"] = "sword_strong",
			["type"] = "sword",
			["displayName"] = "Diamond Sword",
			["maxStack"] = 1,
			["damage"] = 35
		},
		["sword_weak"] = {
			["id"] = "sword_weak",
			["type"] = "sword",
			["displayName"] = "Rock Sword",
			["maxStack"] = 1,
			["damage"] = 25
		},
		["sword_weaker"] = {
			["id"] = "sword_weaker",
			["type"] = "sword",
			["displayName"] = "Gold Sword",
			["maxStack"] = 1,
			["damage"] = 20
		},
		["sword_weakest"] = {
			["id"] = "sword_weakest",
			["type"] = "sword",
			["displayName"] = "Twig Sword",
			["maxStack"] = 1,
			["damage"] = 15
		},
		["coal_block"] = {
			["id"] = "coal_block",
			["type"] = "block",
			["displayName"] = "Coal Block",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["oak_log"] = {
			["id"] = "oak_log",
			["type"] = "block",
			["displayName"] = "Oak Log",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["oak_plank"] = {
			["id"] = "oak_plank",
			["type"] = "block",
			["displayName"] = "Oak Planks",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["birch_plank"] = {
			["id"] = "birch_plank",
			["type"] = "block",
			["displayName"] = "Birch Planks",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["coal_ore"] = {
			["id"] = "coal_ore",
			["type"] = "block",
			["displayName"] = "Coal Ore",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["gold_ore"] = {
			["id"] = "gold_ore",
			["type"] = "block",
			["displayName"] = "Gold Ore",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["iron_ore"] = {
			["id"] = "iron_ore",
			["type"] = "block",
			["displayName"] = "Iron Ore",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["diamond_ore"] = {
			["id"] = "diamond_ore",
			["type"] = "block",
			["displayName"] = "Diamond Ore",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["jukebox"] = {
			["id"] = "jukebox",
			["type"] = "block",
			["displayName"] = "Jukebox",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["obsidian_breakable"] = {
			["id"] = "obsidian_breakable",
			["type"] = "block",
			["displayName"] = "Obsidian",
			["maxStack"] = 64,
			["unbreakable"] = false,
			["timeToDestroy"] = 9.4,
			["decayTime"] = 20
		},
		["red_glass"] = {
			["id"] = "red_glass",
			["type"] = "block",
			["displayName"] = "Red Glass",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["blue_glass"] = {
			["id"] = "blue_glass",
			["type"] = "block",
			["displayName"] = "Blue Glass",
			["maxStack"] = 64,
			["unbreakable"] = true,
			["timeToDestroy"] = 0.3
		},
		["playagain"] = {
			["id"] = "playagain",
			["type"] = "interactable",
			["displayName"] = "<font color=\"#55FF55\">Play Again</font><font color=\"#AAAAAA\"> (Use)</font>",
			["maxStack"] = 64
		},
		["lobby"] = {
			["id"] = "lobby",
			["type"] = "interactable",
			["displayName"] = "<font color=\"#FF5555\">Return to Lobby</font><font color=\"#AAAAAA\"> (Use)</font>",
			["maxStack"] = 64
		}
	},
	["NumToId"] = {
		"red_terracotta",
		"blue_terracotta",
		"sword",
		"pickaxe",
		"stair",
		"golden_apple",
		"bow",
		"white_terracotta",
		"grass",
		"bricks",
		"brick_stairs",
		"smooth_stone",
		"stone_slab",
		"stone_bricks",
		"stone_brick_stairs",
		"leaves",
		"dirt",
		"sand",
		"sandstone",
		"smooth_sandstone",
		"stone",
		"blue_wool",
		"red_wool",
		"prismarine_bricks",
		"dark_prismarine_bricks",
		"prismarine",
		"packed_ice",
		"sea_lantern",
		"acacia_log",
		"quartz_pillar",
		"quartz_block",
		"andesite",
		"polished_andesite",
		"acacia_plank",
		"glass",
		"clay",
		"arrow",
		"tempblock",
		"sword_strong",
		"sword_weak",
		"sword_weaker",
		"sword_weakest",
		"coal_block",
		"oak_log",
		"oak_plank",
		"birch_plank",
		"coal_ore",
		"gold_ore",
		"iron_ore",
		"diamond_ore",
		"jukebox",
		"obsidian_breakable",
		"red_glass",
		"blue_glass",
		"playagain",
		"lobby"
	},
	["IdToNum"] = {}
}
for v2, v3 in pairs(v_u_1.NumToId) do
	v_u_1.IdToNum[v3] = v2
end
function v_u_1.get(p4) -- name: get
	-- upvalues: (copy) v_u_1
	if p4 then
		return v_u_1.Items[p4:lower()]
	else
		return nil
	end
end
function v_u_1.getByNum(p5) -- name: getByNum
	-- upvalues: (copy) v_u_1
	local v6 = v_u_1.NumToId[p5]
	if v6 then
		return v_u_1.Items[v6]
	else
		return nil
	end
end
function v_u_1.newStack(p7, p8) -- name: newStack
	-- upvalues: (copy) v_u_1
	local v9 = v_u_1.get(p7)
	return v9 and {
		["id"] = v9.id,
		["type"] = v9.type,
		["count"] = p8 or 1
	} or nil
end
function v_u_1.toNum(p10) -- name: toNum
	-- upvalues: (copy) v_u_1
	return v_u_1.IdToNum[p10]
end
function v_u_1.toId(p11) -- name: toId
	-- upvalues: (copy) v_u_1
	return v_u_1.NumToId[p11]
end
return v_u_1
local v1 = {}
local _ = workspace.CurrentCamera
local v_u_2 = game.ReplicatedStorage.Remotes:WaitForChild("GetControlScheme")
v1.ChatActive = false
v1.CursorLocked = true
v1.Preferences = {
	["ShowHitboxes"] = false,
	["FieldOfView"] = 90,
	["AutoSprint"] = false
}
v1.Keybinds = {
	["slot1"] = Enum.KeyCode.One,
	["slot2"] = Enum.KeyCode.Two,
	["slot3"] = Enum.KeyCode.Three,
	["slot4"] = Enum.KeyCode.Four,
	["slot5"] = Enum.KeyCode.Five,
	["slot6"] = Enum.KeyCode.Six,
	["slot7"] = Enum.KeyCode.Seven,
	["slot8"] = Enum.KeyCode.Eight,
	["slot9"] = Enum.KeyCode.Nine,
	["crouch"] = Enum.KeyCode.LeftShift,
	["sprint"] = Enum.KeyCode.Q,
	["switchPerspective"] = Enum.KeyCode.R
}
local v3, v4 = pcall(function()
	-- upvalues: (copy) v_u_2
	return v_u_2:InvokeServer()
end)
if v3 and type(v4) == "table" then
	local v5 = v4.Keybinds
	local v6 = v4.Preferences
	if type(v5) == "table" then
		for v7, v8 in pairs(v5) do
			if v1.Keybinds[v7] ~= nil and v8 ~= nil then
				if typeof(v8) == "EnumItem" and v8.EnumType == Enum.KeyCode then
					v1.Keybinds[v7] = v8
				elseif type(v8) == "string" and Enum.KeyCode[v8] then
					v1.Keybinds[v7] = Enum.KeyCode[v8]
				end
			end
		end
	end
	if type(v6) == "table" then
		for v9, v10 in pairs(v6) do
			if v1.Preferences[v9] ~= nil and v10 ~= nil then
				v1.Preferences[v9] = v10
			end
		end
		return v1
	end
else
	warn("Failed to get control scheme from server")
end
return v1
local v_u_1 = {}
v_u_1.__index = v_u_1
local v2 = v_u_1._anim
if not v2 then
	v2 = {
		["token"] = 0,
		["tweens"] = nil,
		["tweens"] = {}
	}
end
v_u_1._anim = v2
local v_u_3 = game.Players.LocalPlayer
require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("CharacterController"):WaitForChild("PlayerState"))
local v_u_4 = game:GetService("UserInputService")
local v_u_5 = game.ReplicatedStorage.Remotes:WaitForChild("InventoryUpdate")
local v_u_6 = require(game.ReplicatedStorage.TextureModule)
local v_u_7 = require(game.ReplicatedStorage.ItemRegistry)
local v_u_8 = game:GetService("TweenService")
v_u_1.Inventory = {}
v_u_1.SelectedSlot = 1
local v_u_9 = nil
local v_u_10 = nil
local v_u_11 = {}
function v_u_1.init() -- name: init
	-- upvalues: (copy) v_u_3, (copy) v_u_1, (ref) v_u_9, (ref) v_u_10, (copy) v_u_11, (copy) v_u_4, (copy) v_u_5
	local v_u_12 = v_u_3:WaitForChild("PlayerGui"):WaitForChild("Game"):WaitForChild("GameUI"):WaitForChild("Hotbar")
	local v13 = v_u_12:WaitForChild("Selector")
	v_u_1.Inventory = table.create(36, 0)
	v_u_1.SelectedSlot = 1
	v_u_1.Selector = v13
	v_u_1:UpdateSelector()
	if v_u_9 then
		v_u_9:Disconnect()
		v_u_9 = nil
	end
	if v_u_10 then
		v_u_10:Disconnect()
		v_u_10 = nil
	end
	for v14, v15 in ipairs(v_u_11) do
		v15:Disconnect()
		v_u_11[v14] = nil
	end
	v_u_9 = v_u_4.InputChanged:Connect(function(p16)
		-- upvalues: (ref) v_u_1
		if p16.UserInputType == Enum.UserInputType.MouseWheel then
			local v17 = p16.Position.Z
			local v18 = v_u_1.SelectedSlot or 1
			local v19
			if v17 < 0 then
				v19 = v18 % 9 + 1
			else
				local v20 = v18 - 1
				v19 = v20 == 0 and 9 or v20
			end
			v_u_1:SelectHotbarSlot(v19)
		end
	end)
	local function v24(p_u_21) -- name: cf
		-- upvalues: (copy) v_u_12, (ref) v_u_1
		local v22 = v_u_12:FindFirstChild("Slot" .. p_u_21)
		if v22 then
			return v22.TapDetection.InputBegan:Connect(function(p23)
				-- upvalues: (ref) v_u_1, (copy) p_u_21
				if p23.UserInputType == Enum.UserInputType.Touch and p23.UserInputState == Enum.UserInputState.Begin then
					v_u_1:SelectHotbarSlot(p_u_21)
				end
			end)
		end
	end
	for v25 = 1, 9 do
		local v26 = v_u_11
		table.insert(v26, v24(v25))
	end
	v_u_10 = v_u_5.OnClientEvent:Connect(function(p27, p28)
		-- upvalues: (ref) v_u_1
		if p28 == nil then
			v_u_1.Inventory = p27
			for v29 = 1, 36 do
				v_u_1:UpdateHotbarSlot(v29, true)
			end
		else
			v_u_1.Inventory[p28] = p27 or 0
			v_u_1:UpdateHotbarSlot(p28, true)
			if p28 == v_u_1.SelectedSlot then
				script.RedrawViewmodel:Fire()
			end
		end
	end)
end
function v_u_1._cancelActiveTweens(p30) -- name: _cancelActiveTweens
	for _, v_u_31 in ipairs(p30._anim.tweens) do
		pcall(function()
			-- upvalues: (copy) v_u_31
			v_u_31:Cancel()
		end)
	end
	table.clear(p30._anim.tweens)
end
function v_u_1.UpdateHotbarSlot(p32, p33, p34) -- name: UpdateHotbarSlot
	-- upvalues: (copy) v_u_3, (copy) v_u_6, (copy) v_u_1
	local v35 = p34 == nil and true or p34
	local v36 = v_u_3.PlayerGui.Game.GameUI or v_u_3:WaitForChild("PlayerGui"):WaitForChild("Game"):WaitForChild("GameUI")
	local v37 = (v36.Hotbar or v36:WaitForChild("Hotbar")):FindFirstChild("Slot" .. p33)
	if v37 then
		local v38 = p32.Inventory[p33]
		if v38 then
			if v37:FindFirstChild("ItemContent") and v35 then
				v37.ItemContent:Destroy()
			end
			if v38 == 0 then
				v37.CountText.Visible = false
				v37.CountText.MainText.Text = ""
				v37.CountText.ShadowText.Text = ""
			else
				local v39
				if v35 then
					v39 = game.ReplicatedStorage.Models.ViewportItem:Clone()
					v39.Parent = v37
					v39.Name = "ItemContent"
				else
					v39 = v37:FindFirstChild("ItemContent")
				end
				local v40 = nil
				if v38.type == "block" or v38.type == "stair" then
					if v38.type == "block" then
						v40 = game.ReplicatedStorage.Models.HotbarItems.BlockItem:Clone()
						for _, v41 in ipairs(v40:GetChildren()) do
							v41.Texture = v_u_6.block[v38.id].atlas
							v41.OffsetStudsU = v_u_6.block[v38.id][v41.Name].X / 4
							v41.OffsetStudsV = v_u_6.block[v38.id][v41.Name].Y / 4
						end
					elseif v38.type == "stair" then
						v40 = game.ReplicatedStorage.Models.HotbarItems.StairItem:Clone()
						for _, v42 in ipairs(v40.TexturePart:GetChildren()) do
							v42.Texture = v_u_6.block[v38.id].atlas
							v42.OffsetStudsU = 2 + v_u_6.block[v38.id][v42.Name].X / 4
							v42.OffsetStudsV = 2 + v_u_6.block[v38.id][v42.Name].Y / 4
						end
					end
				else
					local v43 = game.ReplicatedStorage.Models.HotbarItems.item:FindFirstChild(v38.id)
					if v43 then
						v40 = v43:Clone()
					else
						v40 = game.ReplicatedStorage.Models.HotbarItems.NoTexture:Clone()
					end
				end
				v40.Parent = v39
				if v38.count > 1 then
					local v44 = v38.count
					v37.CountText.Visible = true
					v37.CountText.MainText.Text = v44
					v37.CountText.ShadowText.Text = v44
					return
				end
				v37.CountText.Visible = false
				v37.CountText.MainText.Text = ""
				v37.CountText.ShadowText.Text = ""
				if v38.count <= 0 then
					v_u_1.Inventory[p33] = 0
					if v37:FindFirstChild("ItemContent") then
						v37.ItemContent:Destroy()
						return
					end
				end
			end
		end
	end
end
function v_u_1.UpdateSelector(p45) -- name: UpdateSelector
	-- upvalues: (copy) v_u_1
	if p45.Selector then
		local _ = p45.Selector.Parent
		local _ = p45.SelectedSlot
		p45.Selector.Position = UDim2.new(0, -2 + (v_u_1.SelectedSlot - 1) * 51.8, 0.5, 0)
	end
end
function v_u_1.SelectHotbarSlot(p_u_46, p47) -- name: SelectHotbarSlot
	-- upvalues: (copy) v_u_3, (copy) v_u_7, (copy) v_u_8
	if p47 < 1 or p47 > 9 then
		return
	else
		if p_u_46.SelectedSlot ~= p47 then
			script.SelectionChanged:Fire(p_u_46.SelectedSlot, p47)
		end
		p_u_46.SelectedSlot = p47
		p_u_46:UpdateSelector()
		game.ReplicatedStorage.Remotes:WaitForChild("SetSelectedSlot"):FireServer(p47)
		local v48 = p_u_46.Inventory[p_u_46.SelectedSlot]
		local v49 = v48 == nil and true or typeof(v48) == "number"
		local v50 = v_u_3:FindFirstChild("PlayerGui")
		if v50 then
			local v51 = v50:FindFirstChild("Game")
			if v51 then
				local v52 = v51:FindFirstChild("GameUI") and v51.GameUI:FindFirstChild("Hotbar") or v51:FindFirstChild("Hotbar")
				if v52 then
					local v_u_53 = v52:FindFirstChild("ItemNameDisplay")
					if v_u_53 and (v_u_53:FindFirstChild("Front") and v_u_53:FindFirstChild("Back")) then
						p_u_46._anim = p_u_46._anim or {
							["token"] = 0,
							["tweens"] = nil,
							["tweens"] = {}
						}
						p_u_46._anim.tweens = p_u_46._anim.tweens or {}
						local function v55() -- name: cancelTweens
							-- upvalues: (copy) p_u_46
							for _, v_u_54 in ipairs(p_u_46._anim.tweens) do
								pcall(function()
									-- upvalues: (copy) v_u_54
									v_u_54:Cancel()
								end)
							end
							table.clear(p_u_46._anim.tweens)
						end
						if not v49 then
							local v56 = p_u_46._anim
							v56.token = v56.token + 1
							v55()
							local v_u_57 = p_u_46._anim.token
							local v58 = v_u_7.Items[v48.id].displayName or v48.id
							v_u_53.Front.Text = v58
							v_u_53.Back.Text = v58:gsub("<[^>]->", "")
							v_u_53.Front.TextTransparency = 0
							v_u_53.Back.TextTransparency = 0.5
							task.spawn(function()
								-- upvalues: (copy) v_u_57, (copy) p_u_46, (ref) v_u_8, (copy) v_u_53
								local v59 = v_u_57
								task.wait(1)
								if v59 == p_u_46._anim.token then
									local v60 = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
									local v61 = v_u_8:Create(v_u_53.Front, v60, {
										["TextTransparency"] = 1
									})
									local v62 = v_u_8:Create(v_u_53.Back, v60, {
										["TextTransparency"] = 1
									})
									local v63 = p_u_46._anim.tweens
									table.insert(v63, v61)
									local v64 = p_u_46._anim.tweens
									table.insert(v64, v62)
									v61:Play()
									v62:Play()
									v61.Completed:Wait()
									if v59 == p_u_46._anim.token then
										table.clear(p_u_46._anim.tweens)
									end
								end
							end)
						end
					else
						return
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	end
end
v_u_1:SelectHotbarSlot(1)
function v_u_1.SetSlot(p65, p66, p67) -- name: SetSlot
	p65.Inventory[p66] = p67
end
function v_u_1.find(p68) -- name: find
	-- upvalues: (copy) v_u_1
	local v69 = {}
	for _, v70 in pairs(v_u_1.Inventory) do
		if typeof(v70) == "table" then
			local v71 = v70.id
			table.insert(v69, v71)
		end
	end
	return table.find(v69, p68)
end
game.ReplicatedStorage.Remotes.SetClientSlot.OnClientEvent:Connect(function(p72)
	-- upvalues: (copy) v_u_1
	if p72 then
		v_u_1:SelectHotbarSlot((math.clamp(p72, 1, 9)))
	end
end)
return v_u_1
local v_u_1 = game.Players.LocalPlayer
local v_u_2 = game.Workspace.CurrentCamera
local _ = v_u_1.PlayerGui
local v_u_3 = nil
local v_u_4 = nil
local v_u_5 = nil
local v_u_6 = v_u_1.PlayerGui:WaitForChild("Game"):WaitForChild("MobileGui")
local v_u_7 = game:GetService("RunService")
local v_u_8 = game:GetService("UserInputService")
local v_u_9 = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
local v_u_10 = require(script:WaitForChild("PlayerState"))
local v11 = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PlayerConfig"))
local v_u_12 = require(script:WaitForChild("Inventory"))
local v_u_13 = require(game.ReplicatedStorage:WaitForChild("TextureModule"))
hitRemote = game.ReplicatedStorage.Remotes.AnimateHit
damageFlashEvent = game.ReplicatedStorage.Remotes.DamageFlash
setSelectedEvent = game.ReplicatedStorage.Remotes.SetSelectedSlot
beginBlockEvent = game.ReplicatedStorage.Remotes.BeginBlocking
endBlockEvent = game.ReplicatedStorage.Remotes.EndBlocking
beginEatEvent = game.ReplicatedStorage.Remotes.StartEating
endEatEvent = game.ReplicatedStorage.Remotes.StopEating
finishedEatEvent = game.ReplicatedStorage.Remotes.FinishedEating
beginChargeEvent = game.ReplicatedStorage.Remotes.StartBowCharge
endChargeEvent = game.ReplicatedStorage.Remotes.EndBowCharge
local v_u_14 = Vector3.new(0, 0, 0)
local v_u_15 = Vector3.new(0, 0, 0)
local v_u_16 = v11.HITBOX_SIZE
local v_u_17 = v11.WALK_SPEED
local v_u_18 = v11.SPRINT_SPEED
local v_u_19 = v11.CROUCH_SPEED
local v_u_20 = v11.JUMP_VELOCITY
local v_u_21 = v11.PLAYER_REACH
local v_u_22 = v11.ACCELERATION_SPEED
local v_u_23 = v11.DECELERATION_SPEED
local v_u_24 = v11.AIR_ACCELERATION_SPEED
local v_u_25 = v11.AIR_DECELERATION_SPEED
local _ = v11.FLY_ACCELERATION_SPEED
local _ = v11.DECELERATION_SPEED
local v_u_26 = v11.GRAVITY
local v_u_27 = v11.GRAVITY_SCALE
local v_u_28 = v11.TERMINAL_VELOCITY
local v_u_29 = v_u_16 * 0.5
local v_u_30 = 5
local v_u_31 = 1 / v_u_30
local v_u_32 = OverlapParams.new()
v_u_32.FilterDescendantsInstances = { v_u_3, v_u_1.Character }
v_u_32.FilterType = Enum.RaycastFilterType.Exclude
v_u_32.CollisionGroup = "Hitbox"
local v_u_33 = true
local v_u_34 = false
local v_u_35 = false
local v_u_36 = true
local v_u_37 = false
local v_u_38 = false
local v_u_39 = false
local v_u_40 = nil
local v_u_41 = nil
local v_u_42 = 0
local v_u_43 = nil
local v_u_44 = false
local v_u_45 = false
local v_u_46 = false
local v_u_47 = nil
local v_u_48 = nil
local v_u_49 = nil
local v_u_50 = 0
local v_u_51 = 0
local v_u_52 = 0
local v_u_53 = 0
local v_u_54 = Vector3.new()
local v_u_55 = v_u_2.CFrame.LookVector
local v_u_56 = tick()
local v_u_57 = CFrame.new()
local v_u_58 = 0
local v_u_59 = CFrame.Angles(0, 0, 0)
local v_u_60 = CFrame.Angles(0, 0, 0)
local v_u_61 = CFrame.Angles(0, 0, 0)
local v_u_62 = CFrame.Angles(0, 0, 0)
local v_u_63 = CFrame.identity
local v_u_64 = CFrame.identity
local v_u_65 = CFrame.identity
local v_u_66 = CFrame.identity
local v_u_67 = nil
local v_u_68 = nil
local v_u_69 = nil
local v_u_70 = nil
local v_u_71 = nil
local v_u_72 = nil
local v_u_73 = nil
local v_u_74 = nil
local v_u_75 = nil
local v_u_76 = nil
local v_u_77 = nil
local v_u_78 = nil
CFrame.Angles(0, 0, 0)
local v_u_79 = 1
local v_u_80 = nil
local v_u_81 = 0
local v_u_82 = {
	[2] = {
		["TextureID"] = "rbxassetid://72473920099802",
		["Is4px"] = true
	},
	[3] = {
		["TextureID"] = "rbxassetid://99390011244350",
		["Is4px"] = true
	},
	[4] = {
		["TextureID"] = "rbxassetid://83425296690741",
		["Is4px"] = true
	},
	[5] = {
		["TextureID"] = "rbxassetid://120884443822905",
		["Is4px"] = true
	},
	[6] = {
		["TextureID"] = "rbxassetid://137141151005639",
		["Is4px"] = true
	},
	[7] = {
		["TextureID"] = "rbxassetid://101879187208808",
		["Is4px"] = true
	},
	[8] = {
		["TextureID"] = "rbxassetid://135957480053738",
		["Is4px"] = true
	},
	[9] = {
		["TextureID"] = "rbxassetid://79178804612157",
		["Is4px"] = false
	},
	[10] = {
		["TextureID"] = "rbxassetid://86295932616861",
		["Is4px"] = true
	},
	[11] = {
		["TextureID"] = "rbxassetid://131917722504802",
		["Is4px"] = false
	},
	[12] = {
		["TextureID"] = "rbxassetid://85331403005541",
		["Is4px"] = false
	}
}
local function v_u_90(p83) -- name: loadLocalCharacter
	-- upvalues: (ref) v_u_3, (copy) v_u_2, (ref) v_u_4, (ref) v_u_5, (ref) v_u_71, (ref) v_u_72, (ref) v_u_73, (ref) v_u_74, (ref) v_u_75, (ref) v_u_76, (ref) v_u_77, (ref) v_u_78, (ref) v_u_47, (ref) v_u_48, (ref) v_u_49, (copy) v_u_1, (copy) v_u_82
	local v84 = p83 or Vector3.new(0, 50, 0)
	if v_u_3 then
		print("character existed")
		v_u_3:Destroy()
		v_u_2.CameraType = Enum.CameraType.Fixed
		v_u_2.CameraSubject = nil
		v_u_4 = nil
		v_u_5 = nil
		v_u_71 = nil
		v_u_72 = nil
		v_u_73 = nil
		v_u_74 = nil
		v_u_75 = nil
		v_u_76 = nil
		v_u_77 = nil
		v_u_78 = nil
		v_u_47 = nil
		v_u_48 = nil
		v_u_49 = nil
	end
	local v85 = v_u_1:WaitForChild("Data"):WaitForChild("SkinTexture").Value
	local v86 = v_u_1:WaitForChild("Data"):WaitForChild("EquippedSkin").Value
	local v87
	if v86 == 1 then
		v87 = v_u_1.Data.Is4px.Value
	else
		v87 = v_u_82[v86].Is4px
	end
	v_u_3 = game.ReplicatedStorage["StarterCharacter" .. (v87 and "4x" or "3x")]:Clone()
	v_u_3.Parent = workspace
	v_u_3.Name = "LocalCharacter_" .. v_u_1.Name
	v_u_3:PivotTo(CFrame.new(v84))
	v_u_4 = v_u_3:WaitForChild("PlayerHitbox")
	v_u_5 = v_u_3:WaitForChild("Humanoid")
	for _, v88 in pairs(v_u_3:GetDescendants()) do
		if v88:IsA("ImageLabel") then
			v88.Image = v85
		end
	end
	v_u_71 = v_u_3:WaitForChild("Torso")
	v_u_72 = v_u_3:WaitForChild("Head")
	v_u_73 = v_u_3:WaitForChild("HeadTorso"):WaitForChild("Neck")
	v_u_74 = v_u_71:WaitForChild("Left Shoulder")
	v_u_75 = v_u_71:WaitForChild("Right Shoulder")
	v_u_76 = v_u_71:WaitForChild("Left Hip")
	v_u_77 = v_u_71:WaitForChild("Right Hip")
	v_u_78 = v_u_4:WaitForChild("Torso")
	v_u_47 = v_u_78.C0
	v_u_48 = v_u_76.C0
	v_u_49 = v_u_77.C0
	for _, v89 in ipairs(game.StarterPlayer.StarterCharacterScripts:GetChildren()) do
		v89:Clone().Parent = v_u_3
	end
	require(v_u_1:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():Enable(true)
	v_u_2.CameraSubject = v_u_3:WaitForChild("PlayerEyeLevel")
	v_u_2.CameraType = Enum.CameraType.Custom
end
local function v_u_115(p91) -- name: worldHalf
	local v92 = p91.Size * 0.5
	local v93 = p91.CFrame
	local v94 = v93.RightVector.X
	local v95 = math.abs(v94)
	local v96 = v93.RightVector.Y
	local v97 = math.abs(v96)
	local v98 = v93.RightVector.Z
	local v99 = math.abs(v98)
	local v100 = v93.UpVector.X
	local v101 = math.abs(v100)
	local v102 = v93.UpVector.Y
	local v103 = math.abs(v102)
	local v104 = v93.UpVector.Z
	local v105 = math.abs(v104)
	local v106 = v93.LookVector.X
	local v107 = math.abs(v106)
	local v108 = v93.LookVector.Y
	local v109 = math.abs(v108)
	local v110 = v93.LookVector.Z
	local v111 = math.abs(v110)
	local v112 = v95 * v92.X + v101 * v92.Y + v107 * v92.Z
	local v113 = v97 * v92.X + v103 * v92.Y + v109 * v92.Z
	local v114 = v99 * v92.X + v105 * v92.Y + v111 * v92.Z
	return Vector3.new(v112, v113, v114)
end
local function v_u_132(p116) -- name: findBestLandingTop
	-- upvalues: (copy) v_u_29, (copy) v_u_16, (copy) v_u_32, (ref) v_u_3
	local v117 = p116.Y - v_u_29.Y
	local v118 = p116.X
	local v119 = v117 - 0.75
	local v120 = p116.Z
	local v121 = Vector3.new(v118, v119, v120)
	local v122 = v_u_16.X - 0.02
	local v123 = math.max(0.05, v122)
	local v124 = v_u_16.Z - 0.02
	local v125 = math.max(0.05, v124)
	local v126 = Vector3.new(v123, 1.5, v125)
	local v127 = nil
	for _, v128 in ipairs(workspace:GetPartBoundsInBox(CFrame.new(v121), v126, v_u_32)) do
		local v129 = v128:IsA("BasePart") and v128.CanCollide
		if v129 then
			if v128.Name == "RenderBox" then
				v129 = false
			else
				v129 = not v128:IsDescendantOf(v_u_3)
			end
		end
		if v129 and not v128:IsDescendantOf(v_u_3) then
			local v130 = v128.Position.Y + v128.Size.Y * 0.5
			if v130 <= v117 + 0.01 and (v117 - v130 <= 1.51 and (not v127 or v127 < v130)) then
				v127 = v130
			end
		end
	end
	if not v127 then
		return nil
	end
	local v131 = v127 * 1000
	return math.round(v131) / 1000
end
local function v_u_144(p133, p134) -- name: clampLanding
	-- upvalues: (ref) v_u_81, (copy) v_u_29, (copy) v_u_132, (ref) v_u_80
	if p134 > 0 then
		v_u_81 = 0
		return p133, p134, false
	end
	local v135 = p133.Y - v_u_29.Y
	local v136 = v_u_132(p133)
	if not v136 then
		v_u_80 = nil
		v_u_81 = 0
		return p133, p134, false
	end
	if v_u_80 then
		local v137 = v136 - v_u_80
		if math.abs(v137) <= 0.002 then
			v136 = v_u_80
			local v138 = v_u_81 + 1
			v_u_81 = math.min(6, v138)
			::l8::
			local v139 = (v_u_80 or v136) + v_u_29.Y + 0.01
			if v135 <= v_u_80 + 0.03 then
				if p133.Y < v139 then
					local v140 = v139 - p133.Y
					local v141 = math.abs(v140)
					if v141 > 3 then
						print("teleported... diff is " .. v141)
					end
					local v142 = p133.X
					local v143 = p133.Z
					p133 = Vector3.new(v142, v139, v143)
					p134 = 0
				end
				return p133, p134, true
			else
				if v_u_81 >= 6 then
					v_u_80 = nil
					v_u_81 = 0
				end
				return p133, p134, false
			end
		end
	end
	v_u_80 = v136
	v_u_81 = 1
	goto l8
end
local function v_u_158(p145, p146) -- name: getCandidates
	-- upvalues: (copy) v_u_16, (copy) v_u_32
	local v147 = p145 + p146 * 0.5
	local v148 = v_u_16.X
	local v149 = p146.X
	local v150 = v148 + math.abs(v149)
	local v151 = v_u_16.Y
	local v152 = p146.Y
	local v153 = v151 + math.abs(v152)
	local v154 = v_u_16.Z
	local v155 = p146.Z
	local v156 = v154 + math.abs(v155)
	local v157 = Vector3.new(v150, v153, v156)
	return workspace:GetPartBoundsInBox(CFrame.new(v147), v157, v_u_32)
end
local function v_u_213(p159, p160, p161, p162) -- name: sweepAxis
	-- upvalues: (copy) v_u_29, (ref) v_u_3, (copy) v_u_115
	if p160 == 0 then
		return p159, 0, false, nil
	end
	local v163 = v_u_29
	local v164 = p159.X - v163.X
	local v165 = p159.Y - v163.Y
	local v166 = p159.Z - v163.Z
	local v167 = Vector3.new(v164, v165, v166)
	local v168 = p159.X + v163.X
	local v169 = p159.Y + v163.Y
	local v170 = p159.Z + v163.Z
	local v171 = Vector3.new(v168, v169, v170)
	local v172 = p160
	local v173 = false
	local v174 = nil
	for _, v175 in ipairs(p162) do
		local v176 = v175:IsA("BasePart") and v175.CanCollide
		if v176 then
			if v175.Name == "RenderBox" then
				v176 = false
			else
				v176 = not v175:IsDescendantOf(v_u_3)
			end
		end
		if v176 then
			local v177 = v_u_115(v175)
			local v178 = v175.Position - v177
			local v179 = v175.Position + v177
			if p161 == "Y" then
				local v180 = v167.X
				local v181 = v171.X
				local v182 = v178.X
				local v183
				if v180 <= v179.X then
					v183 = v182 <= v181
				else
					v183 = false
				end
				if v183 then
					local v184 = v167.Z
					local v185 = v171.Z
					local v186 = v178.Z
					local v187
					if v184 <= v179.Z then
						v187 = v186 <= v185
					else
						v187 = false
					end
					if v187 then
						if p160 > 0 then
							local v188 = v178.Y - v171.Y
							if v188 >= -0.0001 and v188 < v172 then
								v174 = v175
								v172 = v188
								v173 = true
							end
						else
							local v189 = v179.Y - v167.Y
							if v189 <= 0.0001 and v172 < v189 then
								v174 = v175
								v172 = v189
								v173 = true
							end
						end
					end
				end
			elseif p161 == "X" then
				local v190 = v167.Y
				local v191 = v171.Y
				local v192 = v178.Y
				local v193
				if v190 <= v179.Y then
					v193 = v192 <= v191
				else
					v193 = false
				end
				if v193 then
					local v194 = v167.Z
					local v195 = v171.Z
					local v196 = v178.Z
					local v197
					if v194 <= v179.Z then
						v197 = v196 <= v195
					else
						v197 = false
					end
					if v197 then
						if p160 > 0 then
							local v198 = v178.X - v171.X
							if v198 >= -0.0001 and v198 < v172 then
								v174 = v175
								v172 = v198
								v173 = true
							end
						else
							local v199 = v179.X - v167.X
							if v199 <= 0.0001 and v172 < v199 then
								v174 = v175
								v172 = v199
								v173 = true
							end
						end
					end
				end
			else
				local v200 = v167.X
				local v201 = v171.X
				local v202 = v178.X
				local v203
				if v200 <= v179.X then
					v203 = v202 <= v201
				else
					v203 = false
				end
				if v203 then
					local v204 = v167.Y
					local v205 = v171.Y
					local v206 = v178.Y
					local v207
					if v204 <= v179.Y then
						v207 = v206 <= v205
					else
						v207 = false
					end
					if v207 then
						if p160 > 0 then
							local v208 = v178.Z - v171.Z
							if v208 >= -0.0001 and v208 < v172 then
								v174 = v175
								v172 = v208
								v173 = true
							end
						else
							local v209 = v179.Z - v167.Z
							if v209 <= 0.0001 and v172 < v209 then
								v174 = v175
								v172 = v209
								v173 = true
							end
						end
					end
				end
			end
		end
	end
	if v173 then
		if v172 > 0 then
			local v210 = v172 - 0.0001
			v172 = math.max(0, v210)
		else
			local v211 = v172 + 0.0001
			v172 = math.min(0, v211)
		end
	end
	local v212
	if p161 == "Y" then
		v212 = p159 + Vector3.new(0, v172, 0)
	elseif p161 == "X" then
		v212 = p159 + Vector3.new(v172, 0, 0)
	else
		v212 = p159 + Vector3.new(0, 0, v172)
	end
	return v212, v172, v173, v174
end
local function v_u_266(p214, p215, p216, _, p217) -- name: tryStepUp
	-- upvalues: (copy) v_u_29, (ref) v_u_3, (copy) v_u_16, (copy) v_u_32, (copy) v_u_158, (copy) v_u_213, (ref) v_u_14
	if not p217 or p216 == 0 then
		return nil
	end
	local v218 = p216 > 0 and 1 or -1
	local v219 = p215 == "X" and Vector3.new(v218, 0, 0) or Vector3.new(0, 0, v218)
	local v220 = p215 == "X" and v_u_29.X or v_u_29.Z
	local v221 = p215 == "X" and Vector3.new(0, 0, 1) or Vector3.new(1, 0, 0)
	local v222 = p215 == "X" and v_u_29.Z or v_u_29.X
	local v223 = RaycastParams.new()
	v223.FilterDescendantsInstances = { v_u_3 }
	v223.FilterType = Enum.RaycastFilterType.Exclude
	v223.CollisionGroup = "Hitbox"
	local v224 = p214.Y - v_u_29.Y
	local v225 = v224 + 2 + 0.6
	local v226 = { v220 + 0.02 + 0.1, v220 + 0.02 + 0.45 }
	local v227 = { 0, -(v222 - 0.02), v222 - 0.02 }
	local v228 = {}
	for _, v229 in ipairs(v226) do
		local v230 = p214 + v219 * v229
		for _, v231 in ipairs(v227) do
			local v232 = v230 + v221 * v231
			local v233 = workspace
			local v234 = v232.X
			local v235 = v232.Z
			local v236 = v233:Raycast(Vector3.new(v234, v225, v235), Vector3.new(0, -3.1, 0), v223)
			if v236 and v236.Instance then
				local v237 = v236.Instance
				local v238 = v237:IsA("BasePart") and v237.CanCollide
				if v238 then
					if v237.Name == "RenderBox" then
						v238 = false
					else
						v238 = not v237:IsDescendantOf(v_u_3)
					end
				end
				if not v238 or v236.Normal.Y <= 0.6 then
					v236 = nil
				end
			else
				v236 = nil
			end
			if v236 then
				table.insert(v228, v236)
			end
		end
	end
	if #v228 == 0 then
		return nil
	end
	local v239 = v228[1].Position.Y
	for v240 = 2, #v228 do
		if v239 < v228[v240].Position.Y then
			v239 = v228[v240].Position.Y
		end
	end
	local v241 = 0
	for _, v242 in ipairs(v228) do
		local v243 = v242.Position.Y - v239
		if math.abs(v243) <= 1 then
			v241 = v241 + 1
		end
	end
	if v241 == 0 then
		return nil
	end
	if not v239 then
		return nil
	end
	local v244 = v239 + v_u_29.Y
	local v245 = math.clamp(p216, -0.5, 0.5)
	if p215 == "X" then
		local v246 = p214.X + v245
		local v247 = p214.Z
		v265 = Vector3.new(v246, v244, v247)
		if v265 then
			::l52::
			local v248 = workspace:GetPartBoundsInBox(CFrame.new(v265), v_u_16, v_u_32)
			for _, v249 in ipairs(v248) do
				local v250 = v249:IsA("BasePart") and v249.CanCollide
				if v250 then
					if v249.Name == "RenderBox" then
						v250 = false
					else
						v250 = not v249:IsDescendantOf(v_u_3)
					end
				end
				if v250 and not v249:IsDescendantOf(v_u_3) then
					local v251 = v249.Position.Y + v249.Size.Y * 0.5
					if v249.Position.Y - v249.Size.Y * 0.5 < v239 + 0.05 and v239 + 0.05 < v251 then
						return nil
					end
				end
			end
			local v252 = v239 - v224
			if v252 <= 0 or v252 > 2.001 then
				return nil
			end
			local v253 = v_u_158
			local v254 = v252 + 0.02
			local v255 = v253(p214, (Vector3.new(0, v254, 0)))
			local v256, v257, v258 = v_u_213(p214, v252 + 0.02, "Y", v255)
			if v258 and v257 < v252 - 0.001 then
				return nil
			end
			local v259, _, v260 = v_u_213(v256, p216, p215, (v_u_158(v256, p215 == "X" and Vector3.new(p216, 0, 0) or Vector3.new(0, 0, p216))))
			if v260 then
				return nil
			end
			local v261 = v_u_14.X
			local v262 = v_u_14.Z
			v_u_14 = Vector3.new(v261, 0, v262)
			return v259
		end
	end
	local v263 = p214.X
	local v264 = p214.Z + v245
	local v265 = Vector3.new(v263, v244, v264)
	goto l52
end
local function v_u_286(p267, p268) -- name: canStepDown
	-- upvalues: (copy) v_u_29, (copy) v_u_16, (copy) v_u_32, (ref) v_u_3
	if p268.Magnitude < 1e-6 then
		return false
	end
	local v269 = p268.X
	local v270 = p268.Z
	local v271 = p267 + Vector3.new(v269, 0, v270)
	local v272 = p267.Y - v_u_29.Y
	local v273 = v271.X
	local v274 = v272 - 1.05
	local v275 = v271.Z
	local v276 = Vector3.new(v273, v274, v275)
	local v277 = v_u_16.X - 0.05
	local v278 = math.max(0.05, v277)
	local v279 = v_u_16.Z - 0.05
	local v280 = math.max(0.05, v279)
	local v281 = Vector3.new(v278, 2.1, v280)
	local v282 = workspace:GetPartBoundsInBox(CFrame.new(v276), v281, v_u_32)
	for _, v283 in ipairs(v282) do
		if v283:IsA("BasePart") and (v283.CanCollide and not v283:IsDescendantOf(v_u_3)) then
			local v284 = v283:IsA("BasePart") and v283.CanCollide
			if v284 then
				if v283.Name == "RenderBox" then
					v284 = false
				else
					v284 = not v283:IsDescendantOf(v_u_3)
				end
			end
			if v284 then
				local v285 = v283.Position.Y + v283.Size.Y * 0.5
				if v285 < v272 - 0.05 and v272 - v285 <= 2.05 then
					return true
				end
			end
		end
	end
	return false
end
local function v_u_311(p287, p288) -- name: sweptMove
	-- upvalues: (copy) v_u_158, (ref) v_u_33, (copy) v_u_213, (ref) v_u_14, (copy) v_u_266, (copy) v_u_29
	local v289 = v_u_158(p287, p288)
	local v290 = v_u_33
	local v291, _, v292 = v_u_213(p287, p288.Y, "Y", v289)
	if v292 then
		local v293 = v_u_14.X
		local v294 = v_u_14.Z
		v_u_14 = Vector3.new(v293, 0, v294)
	end
	local v295, _, v296, v297 = v_u_213(v291, p288.X, "X", v289)
	local v298 = not v296 or v_u_266(v291, "X", p288.X, v289, v290)
	if v298 then
		v295 = v298
	else
		local v299 = false
		if v290 and v297 then
			local v300 = v297.Position.Y + v297.Size.Y * 0.5 - (v291.Y - v_u_29.Y)
			v299 = v300 > -0.05 and v300 <= 2.05 and true or v299
		end
		if not v299 then
			local v301 = v_u_14.Y
			local v302 = v_u_14.Z
			v_u_14 = Vector3.new(0, v301, v302)
		end
	end
	local v303, _, v304, v305 = v_u_213(v295, p288.Z, "Z", v289)
	if v304 then
		local v306 = v_u_266(v295, "Z", p288.Z, v289, v290)
		if v306 then
			return v306
		end
		local v307 = false
		if v290 and v305 then
			local v308 = v305.Position.Y + v305.Size.Y * 0.5 - (v295.Y - v_u_29.Y)
			v307 = v308 > -0.05 and v308 <= 2.05 and true or v307
		end
		if not v307 then
			local v309 = v_u_14.X
			local v310 = v_u_14.Y
			v_u_14 = Vector3.new(v309, v310, 0)
			return v303
		end
	end
	return v303
end
local function v_u_314(p312) -- name: setLocalCharacterVisibility
	-- upvalues: (ref) v_u_3
	for _, v313 in pairs(v_u_3:GetDescendants()) do
		if v313:IsA("SurfaceGui") then
			v313.Enabled = p312
		end
		if v313:IsA("BasePart") and (v313.Name == "Head" or (v313.Name == "Left Arm" or (v313.Name == "Left Leg" or (v313.Name == "Torso" or (v313.Name == "Right Arm" or v313.Name == "Right Leg"))))) then
			v313.LocalTransparencyModifier = ({
				["true"] = 0,
				["false"] = 1
			})[tostring(p312)]
		end
	end
end
local v_u_315 = nil
local v_u_316 = nil
local v_u_317 = nil
local v_u_318 = 0
local v_u_319 = os.clock()
local v_u_320 = os.clock()
local function v_u_361(_) -- name: animateHandHit
	-- upvalues: (ref) v_u_318, (ref) v_u_315, (ref) v_u_319, (ref) v_u_59, (ref) v_u_62, (copy) v_u_7, (copy) v_u_12, (ref) v_u_44, (ref) v_u_45, (ref) v_u_46
	v_u_318 = os.clock()
	if not v_u_315 or v_u_318 - v_u_319 >= 0.22 then
		hitRemote:FireServer()
		local v_u_321 = 0
		local v_u_322 = 0
		v_u_319 = os.clock()
		local v_u_323 = 0
		local v_u_324 = 0
		local v_u_325 = 0
		local v_u_326 = 0
		local v_u_327 = 0
		if v_u_315 then
			v_u_59 = CFrame.identity
			v_u_62 = CFrame.identity
			v_u_315:Disconnect()
			v_u_315 = nil
		end
		v_u_315 = v_u_7.RenderStepped:Connect(function()
			-- upvalues: (ref) v_u_319, (ref) v_u_321, (ref) v_u_322, (ref) v_u_323, (ref) v_u_324, (ref) v_u_325, (ref) v_u_326, (ref) v_u_327, (ref) v_u_12, (ref) v_u_44, (ref) v_u_45, (ref) v_u_46, (ref) v_u_59, (ref) v_u_62, (ref) v_u_315
			local v328 = os.clock() - v_u_319
			local v329 = v328 * 582
			local v330 = math.rad(v329)
			v_u_321 = math.sin(v330) * 90
			local v331 = v328 * 582 * 2
			local v332 = math.rad(v331) - 1.5707963267948966
			v_u_322 = math.cos(v332) * 25
			local v333 = v328 * 582 * 1
			local v334 = math.rad(v333)
			v_u_323 = math.sin(v334) * -40
			local v335 = v328 * 582 * 0.5
			local v336 = math.rad(v335)
			v_u_324 = math.cos(v336) * 60
			local v337 = v328 * 582 * 1
			local v338 = math.rad(v337)
			v_u_325 = math.sin(v338) * -10
			local v339 = v328 * 582 * 0.5
			local v340 = math.rad(v339)
			v_u_326 = math.cos(v340) * -0.45
			local v341 = v328 * 582 * 1.5
			local v342 = math.rad(v341)
			v_u_327 = math.cos(v342) * 1
			local v343 = v_u_12.Inventory[v_u_12.SelectedSlot]
			if typeof(v343) ~= "number" then
				local v344 = v328 * 582 * 0.5
				local v345 = math.rad(v344)
				v_u_324 = math.cos(v345) * -30
				local v346 = v328 * 582 * 1
				local v347 = math.rad(v346)
				v_u_325 = math.sin(v347) * 42
				if v_u_44 then
					local v348 = v328 * 582 * 0.5
					local v349 = math.rad(v348)
					v_u_326 = math.cos(v349) * -1
					local v350 = v328 * 582 * 1.5
					local v351 = math.rad(v350)
					v_u_327 = math.cos(v351) * 0.7
				elseif v_u_45 or v_u_46 then
					v_u_326 = 0
					v_u_327 = 0
				else
					local v352 = v328 * 582 * 0.5
					local v353 = math.rad(v352)
					v_u_326 = math.cos(v353) * -2
					local v354 = v328 * 582 * 1.5
					local v355 = math.rad(v354)
					v_u_327 = math.cos(v355) * 0.7
				end
			end
			local v356 = v_u_321
			local v357 = v_u_322
			v_u_59 = CFrame.new() * CFrame.Angles(math.rad(v356), 0, (math.rad(v357)))
			local v358 = v_u_323
			local v359 = v_u_324
			local v360 = v_u_325
			v_u_62 = CFrame.new(v_u_326, v_u_327, 0) * CFrame.Angles(math.rad(v358), math.rad(v359), (math.rad(v360)))
			if v328 >= 0.30927835051546393 then
				v_u_59 = CFrame.identity
				v_u_62 = CFrame.identity
				v_u_315:Disconnect()
				v_u_315 = nil
			end
		end)
	end
end
function startEatAnimation() -- name: startEatAnimation
	-- upvalues: (ref) v_u_320, (ref) v_u_316, (ref) v_u_65, (copy) v_u_7
	v_u_320 = os.clock()
	if v_u_316 then
		v_u_65 = CFrame.identity
		v_u_316:Disconnect()
		v_u_316 = nil
	end
	local v_u_362 = 0
	local v_u_363 = false
	v_u_316 = v_u_7.RenderStepped:Connect(function(_)
		-- upvalues: (ref) v_u_320, (ref) v_u_362, (ref) v_u_363, (ref) v_u_65
		local v364 = os.clock() - v_u_320
		local v365 = v364 * 4
		local v366 = math.clamp(v365, 0, 1)
		local v367 = -v366 * v366 + v366 * 2
		local v368 = v367 * -1
		local v369 = v364 - 0.27
		local v370 = math.clamp(v369, 0, 1.5)
		local v371 = v370 * 30
		local v372 = math.sin(v371)
		local v373 = v372 * 0.3
		local v374 = v367 * -0.3
		local v375 = v367 * 20
		local v376 = v367 * 70
		local v377 = v367 * 20
		if v_u_362 and (v372 < v_u_362 and not v_u_363) then
			v_u_363 = true
			game.ReplicatedStorage.Sounds.generic["eat" .. math.random(1, 3)]:Play()
		elseif v_u_362 < v372 then
			v_u_363 = false
		end
		v_u_362 = v372
		v_u_65 = CFrame.new(v368, v373 + v374, 0) * CFrame.Angles(math.rad(v375), math.rad(v376), (math.rad(v377)))
		if v370 >= 1.3 then
			endEatAnimation()
		end
	end)
end
function endEatAnimation() -- name: endEatAnimation
	-- upvalues: (ref) v_u_316, (ref) v_u_65
	if v_u_316 then
		v_u_65 = CFrame.identity
		v_u_316:Disconnect()
		v_u_316 = nil
	end
end
function startBowCharge() -- name: startBowCharge
	-- upvalues: (ref) v_u_317, (copy) v_u_7, (ref) v_u_67, (ref) v_u_66
	local v_u_378 = os.clock()
	if v_u_317 then
		v_u_317:Disconnect()
		v_u_317 = nil
	end
	v_u_317 = v_u_7.Heartbeat:Connect(function(_)
		-- upvalues: (copy) v_u_378, (ref) v_u_67, (ref) v_u_66
		local v379 = os.clock() - v_u_378
		local v380 = math.pow(v379, 2) * 0.008
		local v381 = math.clamp(v380, 0, 0.1)
		local v382 = v379 * 30
		local v383 = v381 * math.sin(v382)
		local v384 = v_u_67.ViewportBlock
		if v384:FindFirstChild("Model") then
			if v384.Model:FindFirstChild("pull_1") then
				for _, v385 in ipairs(v384.Model:GetChildren()) do
					v385.Transparency = 1
				end
				if v379 >= 1 then
					v384.Model.pull_3.Transparency = 0
				elseif v379 >= 0.75 then
					v384.Model.pull_2.Transparency = 0
				else
					v384.Model.pull_1.Transparency = 0
				end
				v_u_66 = CFrame.new(-1.3, v383 + 1.4, 1) * CFrame.Angles(-0.17453292519943295, -0.17453292519943295, 0.08726646259971647)
			end
		else
			return
		end
	end)
end
function endBowCharge() -- name: endBowCharge
	-- upvalues: (ref) v_u_317, (ref) v_u_66, (ref) v_u_67
	if v_u_317 then
		v_u_66 = CFrame.identity
		v_u_317:Disconnect()
		v_u_317 = nil
	end
	local v386 = v_u_67.ViewportBlock
	if v386:FindFirstChild("Model") then
		if v386.Model:FindFirstChild("pull_1") then
			for _, v387 in ipairs(v386.Model:GetChildren()) do
				v387.Transparency = 1
			end
			v386.Model.standby.Transparency = 0
		end
	else
		return
	end
end
hitRemote.OnClientEvent:Connect(function(p388)
	-- upvalues: (copy) v_u_1
	if p388 ~= v_u_1 then
		animateOtherHandHit(p388)
	end
end)
damageFlashEvent.OnClientEvent:Connect(function(p389)
	-- upvalues: (copy) v_u_1
	if p389 == v_u_1 then
		local v390 = v_u_1.PlayerGui.Game.GameUI.ViewportFrame
		v390.ImageColor3 = Color3.fromRGB(255, 157, 157)
		task.wait(0.15)
		v390.ImageColor3 = Color3.new(1, 1, 1)
		return
	else
		local v391 = workspace.OtherCharacters:FindFirstChild(p389.Name .. "_FakeCharacter")
		if v391 then
			local v392 = game.ReplicatedStorage.Models.DamageHighlight:Clone()
			v392.Parent = v391
			task.wait(0.35)
			v392:Destroy()
		end
	end
end)
local function v_u_399(p393) -- name: updateHeadCFrame
	-- upvalues: (ref) v_u_39, (ref) v_u_79, (copy) v_u_2, (ref) v_u_40, (ref) v_u_73
	local v394 = Vector3.new(0, 1.403, 0)
	if v_u_39 then
		v394 = v394 + Vector3.new(0, -0.8, 0)
	end
	local v395 = v_u_79 == 3 and -v_u_2.CFrame.LookVector or v_u_2.CFrame.LookVector
	local v396 = CFrame.new(v394, v394 + v395)
	local v397 = 15 * p393
	local v398 = v_u_39 and v_u_40 == false and 1 or (not v_u_39 and v_u_40 == true and 1 or v397)
	v_u_73.C0 = v_u_73.C0:Lerp(v396, v398)
end
local v_u_400 = CFrame.Angles(0, 0, 0)
local function v_u_422(p401) -- name: updateTorsoCFrame
	-- upvalues: (ref) v_u_73, (ref) v_u_78, (ref) v_u_72, (ref) v_u_14, (copy) v_u_9, (ref) v_u_79, (ref) v_u_400, (ref) v_u_39, (ref) v_u_47, (ref) v_u_40
	local _, v402, _ = v_u_73.C0:ToEulerAnglesYXZ()
	local _, v403, _ = v_u_78.C0:ToEulerAnglesYXZ()
	local v404 = v402 - v403
	if v404 > 3.141592653589793 then
		v404 = v404 - 6.283185307179586
	elseif v404 < -3.141592653589793 then
		v404 = v404 + 6.283185307179586
	end
	local v405 = v_u_72.CFrame:VectorToObjectSpace(v_u_14)
	local v406 = v405.X
	local v407 = v405.Z
	Vector3.new(v406, 0, v407)
	local v408 = v_u_9:GetMoveVector()
	local v409 = v408.X
	local v410 = v408.Z
	local v411 = Vector3.new(v409, 0, v410)
	local v412 = v411.Z > 0.7071067811865476
	local v413 = v411.Z < -0.7071067811865476
	local v414 = (v_u_79 == 3 and v411.X or v411.X) > 0.7071067811865476
	local v415 = (v_u_79 == 3 and v411.X or v411.X) < -0.7071067811865476
	local v416 = nil
	if math.abs(v404) > 0.8028514559173916 then
		local v417 = v403 + 0.5 * v404
		v416 = CFrame.Angles(0, v417, 0)
	elseif v413 and not (v414 or v415) then
		v416 = CFrame.Angles(0, v402, 0)
	elseif v412 or v415 then
		v416 = CFrame.Angles(0, v402 + 0.7853981633974483, 0)
	elseif v414 or v414 and v413 then
		v416 = CFrame.Angles(0, v402 - 0.7853981633974483, 0)
	end
	if v416 then
		v_u_400 = v416
	end
	local v418 = CFrame.new()
	if v_u_39 then
		v418 = CFrame.new(0, -0.6, 0.7) * CFrame.Angles(-0.5235987755982988, 0, 0)
	end
	local v419 = v_u_47 * v_u_400 * v418
	local v420 = 8 * p401
	local v421 = v_u_40 ~= v_u_39 and 1 or v420
	v_u_78.C0 = v_u_78.C0:Lerp(v419, v421)
end
local function v_u_430(p423) -- name: updateArmSway
	-- upvalues: (ref) v_u_58, (ref) v_u_74, (ref) v_u_75
	v_u_58 = v_u_58 + p423 * 2
	local v424 = v_u_58
	local v425 = math.sin(v424) * 0.2617993877991494 * 0.1
	local v426 = v_u_58
	local v427 = math.cos(v426) * 0.2617993877991494 * 0.2 - 0.03490658503988659
	local v428 = -v425
	local v429 = -v427
	v_u_74.C0 = CFrame.new(v_u_74.C0.Position) * CFrame.Angles(v425, 0, v427)
	v_u_75.C0 = CFrame.new(v_u_75.C0.Position) * CFrame.Angles(v428, 0, v429)
end
local function v_u_446(p431) -- name: updateArmSwingBasedOnVelocity
	-- upvalues: (ref) v_u_37, (ref) v_u_39, (ref) v_u_14, (ref) v_u_71, (ref) v_u_53, (ref) v_u_50, (ref) v_u_74, (ref) v_u_75, (ref) v_u_59, (ref) v_u_60, (ref) v_u_61, (ref) v_u_67, (ref) v_u_69, (ref) v_u_70, (ref) v_u_62, (ref) v_u_65, (ref) v_u_66, (copy) v_u_12, (ref) v_u_64
	local v432 = v_u_39 and 2 or (v_u_37 and 10.4 or 8)
	local v433 = v_u_14.X
	local v434 = v_u_14.Z
	local v435 = Vector3.new(v433, 0, v434)
	local v436 = v435.Magnitude
	local v437 = math.clamp(v436, -17.27, 17.27)
	local v438 = v_u_71.CFrame.LookVector
	local v439 = v438.X
	local v440 = v438.Z
	local v441 = Vector3.new(v439, 0, v440).Unit
	local v442 = v435.Unit:Dot(v441)
	local v443 = tick() * v432
	v_u_53 = math.sin(v443) * 0.06981317007977318 * v437
	if v442 < 0 then
		v_u_53 = -v_u_53
	end
	v_u_50 = v_u_50 + (v_u_53 - v_u_50) * 10 * p431
	v_u_74.C0 = v_u_74.C0 * CFrame.Angles(v_u_50, 0, 0)
	v_u_75.C0 = v_u_75.C0 * CFrame.Angles(-v_u_50, 0, 0) * v_u_59 * v_u_60 * v_u_61
	if v_u_67 then
		v_u_69.C0 = v_u_70 * v_u_62 * v_u_65 * v_u_66
		local v444 = v_u_12.Inventory[v_u_12.SelectedSlot]
		if typeof(v444) == "table" and (v_u_12.Inventory[v_u_12.SelectedSlot].type == "sword" and v_u_67:FindFirstChild("ViewportBlock")) then
			if not v_u_67.ViewportBlock:FindFirstChild("BasePart") then
				return
			end
			for _, v445 in ipairs(v_u_67.ViewportBlock.BasePart:GetChildren()) do
				if v445:IsA("Motor6D") then
					v445.C0 = CFrame.new(-0.1, 0, 0.2) * v_u_64
				end
			end
		end
	end
end
local function v_u_463(p447) -- name: updateLegSwingBasedOnVelocity
	-- upvalues: (ref) v_u_37, (ref) v_u_39, (ref) v_u_14, (ref) v_u_71, (ref) v_u_52, (ref) v_u_51, (ref) v_u_76, (ref) v_u_48, (ref) v_u_77, (ref) v_u_49
	local v448 = v_u_39 and 2 or (v_u_37 and 10.4 or 8)
	local v449 = v_u_37 and not v_u_39 and 0.10471975511965978 or 0.06981317007977318
	local v450 = v_u_14.X
	local v451 = v_u_14.Z
	local v452 = Vector3.new(v450, 0, v451)
	local v453 = v452.Magnitude
	local v454 = math.clamp(v453, -17.27, 17.27)
	local v455 = v_u_71.CFrame.LookVector
	local v456 = v455.X
	local v457 = v455.Z
	local v458 = Vector3.new(v456, 0, v457).Unit
	local v459 = v452.Unit:Dot(v458)
	local v460 = tick() * v448
	v_u_52 = math.sin(v460) * v449 * v454
	if v459 < 0 then
		v_u_52 = -v_u_52
	end
	local v461 = 10 * p447
	local v462 = CFrame.new() * CFrame.Angles(0, 0, 0)
	if v_u_39 then
		v462 = CFrame.new(0, 0.5, 0) * CFrame.Angles(0.5235987755982988, 0, 0)
	end
	v_u_51 = v_u_51 + (v_u_52 - v_u_51) * v461
	v_u_76.C0 = v_u_48 * CFrame.Angles(-v_u_51, 0, 0) * v462
	v_u_77.C0 = v_u_49 * CFrame.Angles(v_u_51, 0, 0) * v462
end
local function v_u_481() -- name: onJumpRequest
	-- upvalues: (ref) v_u_33, (ref) v_u_35, (ref) v_u_14, (copy) v_u_20, (ref) v_u_37, (copy) v_u_9, (copy) v_u_2, (ref) v_u_79, (ref) v_u_34
	if v_u_33 and not v_u_35 then
		local v464 = v_u_14.X
		local v465 = v_u_20
		local v466 = v_u_14.Z
		v_u_14 = Vector3.new(v464, v465, v466)
		if v_u_37 then
			local v467 = v_u_9:GetMoveVector()
			if v467.Magnitude > 0.001 then
				local v468 = v_u_2.CFrame
				local v469 = v_u_79 == 3 and -v468.LookVector or v468.LookVector
				local v470 = v469.X
				local v471 = v469.Z
				local v472 = Vector3.new(v470, 0, v471).Unit
				local v473 = v468.RightVector.X
				local v474 = v468.RightVector.Z
				local v475 = Vector3.new(v473, 0, v474).Unit
				local v476 = -v472 * v467.Z + v475 * v467.X
				if v476.Magnitude > 0.001 then
					local v477 = v476.Unit * 5
					local v478 = v_u_14
					local v479 = v477.X
					local v480 = v477.Z
					v_u_14 = v478 + Vector3.new(v479, 0, v480)
				end
			end
		end
		if v_u_34 then
			task.spawn(function()
				-- upvalues: (ref) v_u_35
				if not v_u_35 then
					v_u_35 = true
					task.wait(0.4)
					v_u_35 = false
				end
			end)
		end
	end
end
function snap4(p482) -- name: snap4
	if p482.Magnitude < 1e-6 then
		return Vector3.new(0, 0, -1)
	end
	local v483 = p482.X
	local v484 = p482.Z
	local v485 = Vector3.new(v483, 0, v484).Unit
	local v486 = {
		Vector3.new(1, 0, 0),
		Vector3.new(-1, 0, 0),
		Vector3.new(0, 0, 1),
		Vector3.new(0, 0, -1)
	}
	local v487 = v486[1]
	local v488 = -1000000000
	for _, v489 in ipairs(v486) do
		local v490 = v489:Dot(v485)
		if v488 < v490 then
			v487 = v489
			v488 = v490
		end
	end
	return v487
end
function projectOntoPlane(p491, p492) -- name: projectOntoPlane
	return p491 - p492 * p491:Dot(p492)
end
function basisOnPlane(p493) -- name: basisOnPlane
	local v494 = p493.Y
	local v495 = math.abs(v494) > 0.9 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0)
	local v496 = projectOntoPlane(v495, p493)
	if v496.Magnitude < 1e-6 then
		v496 = projectOntoPlane(Vector3.new(0, 0, 1), p493)
	end
	local v497 = v496.Unit
	return v497, p493:Cross(v497).Unit
end
function snapOnPlane(p498, p499) -- name: snapOnPlane
	local v500, v501 = basisOnPlane(p499)
	local v502 = {
		v500,
		-v500,
		v501,
		-v501
	}
	local v503 = v502[1]
	local v504 = -1000000000
	for _, v505 in ipairs(v502) do
		local v506 = v505:Dot(p498)
		if v504 < v506 then
			v503 = v505
			v504 = v506
		end
	end
	return v503
end
function computeStairCFrame(p507, p508, p509) -- name: computeStairCFrame
	local v510
	if p508.Y > 0.9 then
		v510 = snap4(p509)
		p508 = Vector3.new(0, 1, 0)
	elseif p508.Y < -0.9 then
		v510 = snap4(p509)
		p508 = Vector3.new(0, -1, 0)
	else
		local v511 = projectOntoPlane(p509, p508)
		local v512 = v511.Magnitude < 1e-6 and Vector3.new(0, 0, -1) or v511
		v510 = snapOnPlane(v512.Unit, p508)
	end
	return CFrame.lookAt(p507, p507 + v510, p508) * CFrame.Angles(0, 3.141592653589793, 0)
end
local function v_u_626() -- name: tryPlaceBlock
	-- upvalues: (ref) v_u_3, (copy) v_u_12, (ref) v_u_79, (copy) v_u_2, (copy) v_u_21, (copy) v_u_1, (ref) v_u_14, (ref) v_u_4, (copy) v_u_29, (copy) v_u_16, (copy) v_u_32, (copy) v_u_115, (ref) v_u_15, (ref) v_u_80, (ref) v_u_81, (ref) v_u_33, (copy) v_u_361, (copy) v_u_13, (ref) v_u_43
	if v_u_3 then
		local v513 = v_u_12.Inventory[v_u_12.SelectedSlot]
		if typeof(v513) == "table" then
			if v513.count <= 0 then
				return
			elseif v513.type == "block" or v513.type == "stair" then
				local v514 = v_u_3.PlayerEyeLevel.Position or v_u_3:WaitForChild("PlayerEyeLevel").Position
				local v515 = v_u_79 == 3 and -v_u_2.CFrame.LookVector or v_u_2.CFrame.LookVector
				local v516 = v_u_21
				local v517 = RaycastParams.new()
				v517.FilterType = Enum.RaycastFilterType.Exclude
				v517.FilterDescendantsInstances = { v_u_3, v_u_1.Character, workspace.OtherCharacters }
				v517.CollisionGroup = "Hitbox"
				local v518 = workspace:Raycast(v514, v515 * v516, v517)
				if v518 then
					local v519 = v518.Normal * (v518.Instance.Size / 2 + Vector3.new(2, 2, 2))
					local v520 = v518.Instance.Position + v519
					local v521 = v520.X / 4 + 0.5
					local v522 = math.floor(v521) * 4
					local v523 = v520.Y / 4 + 0.5
					local v524 = math.floor(v523) * 4
					local v525 = v520.Z / 4 + 0.5
					local v526 = math.floor(v525) * 4
					local v527 = Vector3.new(v522, v524, v526)
					CFrame.new(v527)
					local v528 = v513.type == "stair"
					local v529 = v518.Normal
					local v530 = v_u_2.CFrame.LookVector
					local function v564(p531, p532, p533, p534) -- name: aabbOverlapAmount
						local v535 = p532.X
						local v536 = p534.X
						local v537 = math.min(v535, v536)
						local v538 = p531.X
						local v539 = p533.X
						local v540 = math.max(v538, v539)
						local v541 = p532.X
						local v542 = p534.X
						local v543 = math.max(v541, v542)
						local v544 = v537 - math.min(v540, v543)
						local v545 = p532.Y
						local v546 = p534.Y
						local v547 = math.min(v545, v546)
						local v548 = p531.Y
						local v549 = p533.Y
						local v550 = math.max(v548, v549)
						local v551 = p532.Y
						local v552 = p534.Y
						local v553 = math.max(v551, v552)
						local v554 = v547 - math.min(v550, v553)
						local v555 = p532.Z
						local v556 = p534.Z
						local v557 = math.min(v555, v556)
						local v558 = p531.Z
						local v559 = p533.Z
						local v560 = math.max(v558, v559)
						local v561 = p532.Z
						local v562 = p534.Z
						local v563 = math.max(v561, v562)
						return v544, v554, v557 - math.min(v560, v563)
					end
					local function v596(p565, p566, p567, p568) -- name: getTopFaceSnapTarget
						-- upvalues: (ref) v_u_14, (ref) v_u_4, (ref) v_u_29, (ref) v_u_16, (ref) v_u_32, (ref) v_u_3, (ref) v_u_115
						local v569 = p566.X
						local v570 = p568.X
						local v571 = math.min(v569, v570)
						local v572 = p565.X
						local v573 = p567.X
						local v574 = v571 - math.max(v572, v573)
						local v575 = p566.Z
						local v576 = p568.Z
						local v577 = math.min(v575, v576)
						local v578 = p565.Z
						local v579 = p567.Z
						local v580 = v577 - math.max(v578, v579)
						if v574 <= 0.05 or v580 <= 0.05 then
							return nil
						end
						local v581 = p566.Y - p567.Y
						if p568.Y <= p566.Y + 0.05 or p567.Y < p565.Y - 0.05 then
							return nil
						end
						if v581 <= 0 or v581 > 0.35 then
							return nil
						end
						if v_u_14.Y > 2 then
							return nil
						end
						local v582 = v_u_4.Position.X
						local v583 = p566.Y + v_u_29.Y + 0.01
						local v584 = v_u_4.Position.Z
						local v585 = Vector3.new(v582, v583, v584)
						local v586 = v585 - v_u_29
						local v587 = v585 + v_u_29
						for _, v588 in ipairs(workspace:GetPartBoundsInBox(CFrame.new(v585), v_u_16, v_u_32)) do
							local v589 = v588:IsA("BasePart") and v588.CanCollide
							if v589 then
								if v588.Name == "RenderBox" then
									v589 = false
								else
									v589 = not v588:IsDescendantOf(v_u_3)
								end
							end
							if v589 then
								local v590 = v_u_115(v588)
								local v591 = v588.Position - v590
								local v592 = v588.Position + v590
								local v593
								if v586.X < v592.X - 0.0001 then
									v593 = v587.X > v591.X + 0.0001
								else
									v593 = false
								end
								local v594
								if v586.Y < v592.Y - 0.0001 then
									v594 = v587.Y > v591.Y + 0.0001
								else
									v594 = false
								end
								local v595
								if v586.Z < v592.Z - 0.0001 then
									v595 = v587.Z > v591.Z + 0.0001
								else
									v595 = false
								end
								if v593 and (v594 and v595) then
									return nil
								end
							end
						end
						return v585.Y
					end
					local function v607(p597) -- name: applyTopFaceSnap
						-- upvalues: (ref) v_u_4, (ref) v_u_29, (ref) v_u_15, (ref) v_u_14, (ref) v_u_80, (ref) v_u_81, (ref) v_u_33
						local v598 = p597 + 2
						local v599 = v_u_4.Position.X
						local v600 = v598 + v_u_29.Y + 0.01
						local v601 = v_u_4.Position.Z
						local v602 = Vector3.new(v599, v600, v601)
						v_u_4.CFrame = CFrame.new(v602)
						v_u_15 = v602
						local v603 = v_u_14.X
						local v604 = v_u_14.Y
						local v605 = math.max(0, v604)
						local v606 = v_u_14.Z
						v_u_14 = Vector3.new(v603, v605, v606)
						v_u_80 = v598
						v_u_81 = 6
						v_u_33 = true
					end
					local v608 = v527 - Vector3.new(2, 2, 2)
					local v609 = v527 + Vector3.new(2, 2, 2)
					local v610 = v_u_4.Position - v_u_4.Size / 2
					local v611 = v_u_4.Position + v_u_4.Size / 2
					local v612 = v596(v608, v609, v610, v611)
					local v613
					if v608.X < v611.X and (v609.X > v610.X and (v608.Y < v611.Y and (v609.Y > v610.Y and v608.Z < v611.Z))) then
						v613 = v609.Z > v610.Z
					else
						v613 = false
					end
					if v613 then
						local v614, v615, v616 = v564(v608, v609, v610, v611)
						local v617
						if v614 > 0.05 and v615 > 0.05 then
							v617 = v616 > 0.05
						else
							v617 = false
						end
						if v617 and not v612 then
							return
						end
					end
					local v618
					if v609.Y <= v610.Y + 0.05 or v608.Y >= v611.Y - 0.05 then
						v618 = false
					elseif v610.X < v609.X and (v611.X > v608.X and v610.Z < v609.Z) then
						v618 = v611.Z > v608.Z
					else
						v618 = false
					end
					if v618 and not v612 then
						return
					else
						local v619
						if v609.Y <= v610.Y + 0.05 or v608.Y >= v611.Y - 0.05 then
							v619 = false
						elseif v610.X < v609.X and (v611.X > v608.X and v610.Z < v609.Z) then
							v619 = v611.Z > v608.Z
						else
							v619 = false
						end
						if v619 then
							return
						else
							v_u_361()
							if v528 then
								local v620 = game.ReplicatedStorage.Models.Stair:Clone()
								v620:PivotTo(computeStairCFrame(v527, v529, v530))
								v620.Parent = workspace
								local v621 = v513.id
								for _, v622 in ipairs(v620.TexturePart:GetChildren()) do
									if v622:IsA("Texture") and (v621 and (v_u_13 and (v_u_13.block and (v_u_13.block[v621] and v_u_13.block[v621][v622.Name])))) then
										v622.Texture = v_u_13.block[v621].atlas
										v622.OffsetStudsU = 2 + v_u_13.block[v621][v622.Name].X / 4
										v622.OffsetStudsV = 2 + v_u_13.block[v621][v622.Name].Y / 4
									end
								end
								if v530.Z >= 0 and v530.X <= 0 then
									local _ = v530.Z > 0
								end
								local _ = v529.Y < -0.9
								game.ReplicatedStorage.Remotes.PlaceStairRequest:InvokeServer(v_u_2.CFrame.LookVector, v_u_3.PlayerEyeLevel.Position, v513.id)
								v620:Destroy()
								v_u_43 = v527
								return v527
							elseif v_u_43 and (v527 - v_u_43).Magnitude < 1e-6 then
								return
							else
								local v623 = game.ReplicatedStorage.Models.BlockModel:Clone() or game.ReplicatedStorage.Models:WaitForChild("BlockModel"):Clone()
								v623.Size = Vector3.new(4, 4, 4)
								v623.Position = v527
								v623.Anchored = true
								v623.CanCollide = true
								if v513.id == "glass" then
									v623.Transparency = 1
								end
								for _, v624 in ipairs(v623:GetChildren()) do
									if v624:IsA("Texture") then
										v624.Texture = v_u_13.block[v513.id].atlas
										v624.OffsetStudsU = v_u_13.block[v513.id][v624.Name].X / 4
										v624.OffsetStudsV = v_u_13.block[v513.id][v624.Name].Y / 4
									end
								end
								v623.Parent = workspace
								local v625 = game.ReplicatedStorage.Remotes.PlaceBlockRequest:InvokeServer(v515, v514, v_u_12.Inventory[v_u_12.SelectedSlot].id)
								if v625 == nil then
									v623:Destroy()
									return
								elseif typeof(v625) == "boolean" then
									v623:Destroy()
								else
									if v625.Position ~= v623.Position then
										v623.Position = v625.Position
									end
									v623:Destroy()
									v_u_43 = v527
									if typeof(v625) ~= "boolean" then
										if v625.Position ~= v623.Position then
											v623.Position = v625.Position
										end
										if v612 then
											v607(v625.Position.Y)
										end
										v623:Destroy()
										v_u_43 = v527
										return v527
									end
									v623:Destroy()
								end
							end
						end
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	else
		return
	end
end
v_u_8.InputBegan:Connect(function(p627, p628)
	-- upvalues: (copy) v_u_10, (copy) v_u_1
	if not p628 then
		if p627.KeyCode == Enum.KeyCode.LeftAlt or p627.KeyCode == Enum.KeyCode.RightAlt then
			v_u_10.CursorLocked = not v_u_10.CursorLocked
			v_u_1.PlayerGui.Game.GameUI.ModalObject.Modal = v_u_10.CursorLocked
		end
	end
end)
local v_u_629 = 0
local v_u_630 = 0
v_u_8.InputChanged:Connect(function(p631)
	-- upvalues: (ref) v_u_79, (ref) v_u_629, (ref) v_u_630
	if p631.UserInputType == Enum.UserInputType.MouseMovement or p631.UserInputType == Enum.UserInputType.Touch and v_u_79 == 3 then
		v_u_629 = v_u_629 - p631.Delta.X * 0.0125
		v_u_630 = v_u_630 - p631.Delta.Y * 0.0125
		local v632 = v_u_630
		v_u_630 = math.clamp(v632, -1.3962634015954636, 1.3962634015954636)
	end
end)
local function v_u_636() -- name: updateCamera
	-- upvalues: (ref) v_u_3, (ref) v_u_4, (ref) v_u_79, (copy) v_u_1, (ref) v_u_630, (ref) v_u_629, (copy) v_u_2, (copy) v_u_10, (copy) v_u_8
	if v_u_3 and v_u_4 then
		local _ = v_u_4.Position
		local v633 = v_u_3:FindFirstChild("PlayerEyeLevel")
		if v633 then
			local _ = v633.Position
		end
		if v_u_79 == 1 then
			v_u_1.CameraMode = Enum.CameraMode.LockFirstPerson
			v_u_1.CameraMinZoomDistance = 0
			v_u_1.CameraMaxZoomDistance = 0
			v_u_1.PlayerGui.Game.GameUI.ViewportFrame.Visible = true
		elseif v_u_79 == 2 then
			v_u_1.CameraMinZoomDistance = 16
			v_u_1.CameraMaxZoomDistance = 16
			v_u_1.CameraMinZoomDistance = 16
			v_u_1.CameraMode = Enum.CameraMode.Classic
			v_u_1.PlayerGui.Game.GameUI.ViewportFrame.Visible = false
		else
			local v634 = v_u_3:WaitForChild("PlayerEyeLevel").Position
			local v635 = v634 + CFrame.fromOrientation(v_u_630, v_u_629, 0).LookVector * 16
			v_u_2.CFrame = CFrame.lookAt(v635, v634)
			v_u_2.Focus = CFrame.new(v634)
			v_u_1.PlayerGui.Game.GameUI.ViewportFrame.Visible = false
		end
		if v_u_10.ChatActive then
			v_u_8.MouseBehavior = Enum.MouseBehavior.Default
			v_u_8.MouseIconEnabled = true
		else
			v_u_8.MouseBehavior = Enum.MouseBehavior.LockCenter
			v_u_8.MouseIconEnabled = false
		end
		if v_u_10.CursorLocked == false then
			v_u_8.MouseBehavior = Enum.MouseBehavior.Default
			v_u_8.MouseIconEnabled = true
		end
	end
end
local v_u_637 = OverlapParams.new()
v_u_637.CollisionGroup = "Hitbox"
v_u_637.FilterType = Enum.RaycastFilterType.Exclude
v_u_637.FilterDescendantsInstances = { v_u_3, v_u_1.Character }
local function v_u_648(p638) -- name: checkGroundedAt
	-- upvalues: (copy) v_u_16, (copy) v_u_637, (ref) v_u_3
	local v639 = v_u_16.Y * 0.5
	local v640 = v_u_16.X - 0.04
	local v641 = v_u_16.Z - 0.04
	local v642 = Vector3.new(v640, 0.08, v641)
	local v643 = -v639 - v642.Y * 0.5 + 0.03
	local v644 = p638 + Vector3.new(0, v643, 0)
	local v645 = workspace:GetPartBoundsInBox(CFrame.new(v644), v642, v_u_637)
	for _, v646 in ipairs(v645) do
		local v647 = v646:IsA("BasePart") and v646.CanCollide
		if v647 then
			if v646.Name == "RenderBox" then
				v647 = false
			else
				v647 = not v646:IsDescendantOf(v_u_3)
			end
		end
		if v647 then
			return true
		end
	end
	return false
end
local v_u_649 = v_u_6.MobileButtons.RightContainer.Use
v_u_649.InputBegan:Connect(function(p_u_650)
	-- upvalues: (copy) v_u_12, (copy) v_u_649, (copy) v_u_8
	if p_u_650.UserInputType == Enum.UserInputType.Touch and p_u_650.UserInputState == Enum.UserInputState.Begin then
		local v651 = v_u_12.Inventory[v_u_12.SelectedSlot]
		if typeof(v651) == "table" and v_u_12.Inventory[v_u_12.SelectedSlot].type == "interactable" then
			game.ReplicatedStorage.Remotes.InteractItem:FireServer()
			return
		end
		v_u_649.IsHeld.Value = true
		print("start held")
		startPlaceHold()
		local v_u_652 = nil
		v_u_652 = v_u_8.InputEnded:Connect(function(p653)
			-- upvalues: (copy) p_u_650, (ref) v_u_649, (ref) v_u_652
			if p653 == p_u_650 and p653.UserInputState == Enum.UserInputState.End then
				print("End held")
				v_u_649.IsHeld.Value = false
				stopPlaceHold()
				v_u_652:Disconnect()
			end
		end)
	end
end)
local v_u_654 = v_u_6.MobileButtons.RightContainer.Attack
v_u_654.InputBegan:Connect(function(p_u_655)
	-- upvalues: (copy) v_u_654, (copy) v_u_8, (copy) v_u_12, (ref) v_u_31
	if p_u_655.UserInputType == Enum.UserInputType.Touch and p_u_655.UserInputState == Enum.UserInputState.Begin then
		v_u_654.IsHeld.Value = true
		startHit()
		local v_u_656 = nil
		v_u_656 = v_u_8.InputEnded:Connect(function(p657)
			-- upvalues: (copy) p_u_655, (ref) v_u_654, (ref) v_u_656
			if p657 == p_u_655 and p657.UserInputState == Enum.UserInputState.End then
				v_u_654.IsHeld.Value = false
				v_u_656:Disconnect()
				v_u_656 = nil
			end
		end)
		task.spawn(function()
			-- upvalues: (ref) v_u_656, (ref) v_u_654, (ref) v_u_12, (ref) v_u_31
			while v_u_656 do
				if v_u_654.IsHeld.Value == true then
					local _ = v_u_12.Inventory
					if v_u_12.Inventory[v_u_12.SelectedSlot].type == "sword" then
						startHit()
					end
				end
				task.wait(v_u_31)
			end
		end)
	end
end)
function isRightMouseDown() -- name: isRightMouseDown
	-- upvalues: (copy) v_u_8, (copy) v_u_6, (ref) v_u_30, (ref) v_u_31, (copy) v_u_649
	if v_u_8.MouseEnabled then
		v_u_6.Enabled = false
		for _, v658 in ipairs(v_u_8:GetMouseButtonsPressed()) do
			if v658.UserInputType == Enum.UserInputType.MouseButton2 then
				return true
			end
		end
		return false
	end
	v_u_6.Enabled = true
	v_u_30 = 8
	v_u_31 = 1 / v_u_30
	return v_u_649.IsHeld.Value
end
function isLeftMouseDown() -- name: isLeftMouseDown
	-- upvalues: (copy) v_u_8, (copy) v_u_654
	if not v_u_8.MouseEnabled then
		return v_u_654.IsHeld.Value
	end
	for _, v659 in ipairs(v_u_8:GetMouseButtonsPressed()) do
		if v659.UserInputType == Enum.UserInputType.MouseButton1 then
			return true
		end
	end
	return false
end
function startPlaceHold() -- name: startPlaceHold
	-- upvalues: (copy) v_u_626, (ref) v_u_41, (ref) v_u_42, (copy) v_u_7, (copy) v_u_8, (copy) v_u_649, (ref) v_u_31, (copy) v_u_12
	v_u_626()
	if v_u_41 then
		v_u_41:Disconnect()
		v_u_41 = nil
	end
	v_u_42 = 0
	task.defer(function()
		-- upvalues: (ref) v_u_41, (ref) v_u_7, (ref) v_u_8, (ref) v_u_649, (ref) v_u_42, (ref) v_u_31, (ref) v_u_12, (ref) v_u_626
		if isRightMouseDown() then
			if not v_u_41 then
				v_u_41 = v_u_7.Heartbeat:Connect(function(p660)
					-- upvalues: (ref) v_u_8, (ref) v_u_649, (ref) v_u_42, (ref) v_u_31, (ref) v_u_12, (ref) v_u_626
					if isRightMouseDown() and (v_u_8.MouseEnabled or (not v_u_8.TouchEnabled or v_u_649.IsHeld.Value)) then
						v_u_42 = v_u_42 + p660
						while v_u_31 <= v_u_42 do
							v_u_42 = v_u_42 - v_u_31
							local v661 = v_u_12.Inventory[v_u_12.SelectedSlot]
							if typeof(v661) ~= "table" or (v661.type ~= "block" or (v661.count or 0) <= 0) then
								stopPlaceHold()
								return
							end
							v_u_626()
						end
					else
						stopPlaceHold()
					end
				end)
			end
		else
			return
		end
	end)
end
function stopPlaceHold() -- name: stopPlaceHold
	-- upvalues: (ref) v_u_41, (ref) v_u_42, (ref) v_u_43
	if v_u_41 then
		v_u_41:Disconnect()
		v_u_41 = nil
	end
	v_u_42 = 0
	v_u_43 = nil
end
v_u_8.JumpRequest:Connect(function()
	-- upvalues: (ref) v_u_35, (copy) v_u_481, (ref) v_u_34
	if v_u_35 then
		v_u_35 = false
	end
	v_u_481()
	v_u_34 = true
end)
if v_u_9.touchJumpController then
	local v662 = v_u_9.touchJumpController.jumpButton
	v662.MouseButton1Up:Connect(function()
		-- upvalues: (ref) v_u_34
		v_u_34 = false
	end)
	v662.MouseLeave:Connect(function()
		-- upvalues: (ref) v_u_34
		v_u_34 = false
	end)
end
local v_u_663 = v_u_6.MobileButtons.RightContainer.Sprint
v_u_663.InputBegan:Connect(function(p_u_664)
	-- upvalues: (copy) v_u_663, (ref) v_u_38, (ref) v_u_37, (copy) v_u_8
	if p_u_664.UserInputType == Enum.UserInputType.Touch and p_u_664.UserInputState == Enum.UserInputState.Begin then
		v_u_663.IsHeld.Value = true
		v_u_38 = true
		v_u_37 = true
		local v_u_665 = nil
		v_u_665 = v_u_8.InputEnded:Connect(function(p666)
			-- upvalues: (copy) p_u_664, (ref) v_u_663, (ref) v_u_38, (ref) v_u_665
			if p666 == p_u_664 and p666.UserInputState == Enum.UserInputState.End then
				v_u_663.IsHeld.Value = false
				v_u_38 = false
				v_u_665:Disconnect()
			end
		end)
	end
end)
local v_u_667 = v_u_6.MobileButtons.RightContainer.Crouch
v_u_667.InputBegan:Connect(function(p_u_668)
	-- upvalues: (copy) v_u_667, (ref) v_u_39, (copy) v_u_8
	if p_u_668.UserInputType == Enum.UserInputType.Touch and p_u_668.UserInputState == Enum.UserInputState.Begin then
		v_u_667.IsHeld.Value = true
		v_u_39 = true
		local v_u_669 = nil
		v_u_669 = v_u_8.InputEnded:Connect(function(p670)
			-- upvalues: (copy) p_u_668, (ref) v_u_667, (ref) v_u_39, (ref) v_u_669
			if p670 == p_u_668 and p670.UserInputState == Enum.UserInputState.End then
				v_u_667.IsHeld.Value = false
				v_u_39 = false
				v_u_669:Disconnect()
			end
		end)
	end
end)
v_u_6.MobileButtons.RightContainer.SwitchCamera.MouseButton1Down:Connect(function()
	print("swtich")
	switchCamera()
end)
local v_u_671 = nil
function hideMiningProgress() -- name: hideMiningProgress
	local v672 = workspace.GUI:FindFirstChild("SelectionBox")
	if v672 then
		for _, v673 in ipairs(v672:GetChildren()) do
			if v673:IsA("SurfaceGui") then
				v673.Enabled = false
			end
		end
	end
end
function showMiningProgress(p674) -- name: showMiningProgress
	local v675 = workspace.GUI:FindFirstChild("SelectionBox")
	if v675 then
		local v676 = math.clamp(p674, 0, 1) * 9
		local v677 = math.floor(v676)
		local v678 = math.clamp(v677, 0, 9)
		for _, v679 in ipairs(v675:GetChildren()) do
			if v679:IsA("SurfaceGui") then
				v679.Enabled = true
				v679.Image.ImageRectOffset = Vector2.new(v678 * 16, 0)
			end
		end
	end
end
function getMineTarget() -- name: getMineTarget
	-- upvalues: (ref) v_u_3, (ref) v_u_79, (copy) v_u_21
	local v680 = workspace.CurrentCamera
	if v_u_3 then
		local v681 = (v_u_3.PlayerEyeLevel or v_u_3:WaitForChild("PlayerEyeLevel")).Position
		local v682 = (v_u_79 == 3 and -v680.CFrame.LookVector or v680.CFrame.LookVector) * v_u_21
		local v683 = RaycastParams.new()
		v683.FilterType = Enum.RaycastFilterType.Include
		local v684 = { workspace.World }
		for _, v685 in ipairs(game.Players:GetPlayers()) do
			if v685 ~= game.Players.LocalPlayer and v685.Character then
				local v686 = v685.Character
				table.insert(v684, v686)
			end
		end
		v683.FilterDescendantsInstances = v684
		local v687 = workspace:Raycast(v681, v682, v683)
		if v687 and v687.Instance then
			local v688 = v687.Instance
			if (v688.Name == "StairPart" or v688.Name == "RenderBox") and (v688.Parent and v688.Parent.Parent == workspace.World) then
				v688 = v688.Parent
			end
			if v688 and v688.Parent == workspace.World then
				return v688
			else
				return nil
			end
		else
			return nil
		end
	else
		return nil
	end
end
function stopMining() -- name: stopMining
	-- upvalues: (ref) v_u_671
	if v_u_671 then
		v_u_671:Disconnect()
		v_u_671 = nil
	end
	game.ReplicatedStorage.Remotes.StopMining:FireServer()
	hideMiningProgress()
end
function startPickaxeMining() -- name: startPickaxeMining
	-- upvalues: (ref) v_u_671, (copy) v_u_7, (copy) v_u_12, (copy) v_u_361
	local v_u_689 = require(game.ReplicatedStorage.ItemRegistry)
	if not v_u_671 then
		local v_u_690 = nil
		local v_u_691 = 0
		local v_u_692 = 0
		local v_u_693 = false
		v_u_671 = v_u_7.RenderStepped:Connect(function()
			-- upvalues: (ref) v_u_12, (ref) v_u_690, (ref) v_u_691, (ref) v_u_692, (ref) v_u_693, (copy) v_u_689, (ref) v_u_7, (ref) v_u_361
			local v694 = v_u_12.Inventory[v_u_12.SelectedSlot]
			if isLeftMouseDown() and (typeof(v694) == "table" and v694.type == "pickaxe") then
				local v695 = getMineTarget()
				if v695 then
					local v696 = v695:GetAttribute("BlockType")
					local v697 = v_u_689.Items[v696]
					if v697 then
						if v697.unbreakable == true and not v_u_7:IsStudio() then
							v_u_690 = nil
							hideMiningProgress()
							if v_u_693 then
								game.ReplicatedStorage.Remotes.StopMining:FireServer()
								v_u_693 = false
							end
						else
							v_u_361()
							if v695 ~= v_u_690 then
								v_u_690 = v695
								v_u_691 = os.clock()
								v_u_692 = v697.timeToDestroy
								if not v_u_693 then
									game.ReplicatedStorage.Remotes.StartMining:FireServer()
									v_u_693 = true
								end
							end
							local v698 = os.clock() - v_u_691
							showMiningProgress(v698 / v_u_692)
							if v_u_692 <= v698 then
								local v699 = v_u_690
								v_u_690 = nil
								v_u_691 = 0
								v_u_692 = 0
								if v699 and v699.Parent == workspace.World then
									v699.Parent = game.ReplicatedStorage
									selectionBox()
									if game.ReplicatedStorage.Remotes.DestroyCallback:InvokeServer(v699) then
										v699:Destroy()
										return
									end
									v699.Parent = workspace.World
								end
							end
						end
					else
						v_u_690 = nil
						hideMiningProgress()
						return
					end
				else
					v_u_690 = nil
					v_u_691 = 0
					v_u_692 = 0
					hideMiningProgress()
					if v_u_693 then
						game.ReplicatedStorage.Remotes.StopMining:FireServer()
						v_u_693 = false
					end
					return
				end
			else
				stopMining()
				return
			end
		end)
	end
end
function startHit() -- name: startHit
	-- upvalues: (copy) v_u_361, (ref) v_u_3, (ref) v_u_79, (copy) v_u_21, (copy) v_u_12, (ref) v_u_44, (ref) v_u_45, (ref) v_u_46, (copy) v_u_1
	require(game.ReplicatedStorage.ItemRegistry)
	v_u_361()
	local v700 = workspace.CurrentCamera
	if v_u_3 then
		local v701 = (v_u_3.PlayerEyeLevel or v_u_3:WaitForChild("PlayerEyeLevel")).Position
		local _ = (v_u_79 == 3 and -v700.CFrame.LookVector or v700.CFrame.LookVector) * (v_u_21 - 2)
		local v702 = v_u_12.Inventory[v_u_12.SelectedSlot]
		if typeof(v702) == "table" then
			if v_u_12.Inventory[v_u_12.SelectedSlot].type == "pickaxe" then
				startPickaxeMining()
			elseif not (v_u_44 or (v_u_45 or v_u_46)) then
				local v703 = RaycastParams.new()
				local v704 = {}
				for _, _ in ipairs(game.Players:GetPlayers()) do
					if v_u_1 ~= game.Players.LocalPlayer then
						local v705 = v_u_1.Character
						table.insert(v704, v705)
					end
				end
				for _, v706 in ipairs(game.Workspace.OtherCharacters:GetChildren()) do
					if v706.Name ~= v_u_1.Name .. "_FakeCharacter" then
						table.insert(v704, v706)
					end
				end
				v703.FilterType = Enum.RaycastFilterType.Exclude
				local v707 = {}
				local v708 = v_u_3
				table.insert(v707, v708)
				for _, v709 in ipairs(game.Players:GetPlayers()) do
					local v710 = v709.Character
					table.insert(v707, v710)
				end
				v703.FilterDescendantsInstances = v707
				local v711 = workspace:Raycast(v701, (v_u_79 == 3 and -v700.CFrame.LookVector or v700.CFrame.LookVector) * v_u_21, v703)
				local v712, v713
				if v711 == nil or (v711.Instance == nil or v711.Instance.Parent.Parent ~= workspace.OtherCharacters) then
					v712 = nil
					v713 = nil
				else
					v712 = v711.Instance.Parent
					v713 = game.Players:FindFirstChild(string.gsub(v712.Name, "_FakeCharacter", ""))
					print(v713)
				end
				game.ReplicatedStorage.Remotes.HitRequest:FireServer(v701, v700.CFrame.LookVector.Unit, v712, v713)
			end
		else
			return
		end
	else
		return
	end
end
function switchCamera() -- name: switchCamera
	-- upvalues: (ref) v_u_79, (copy) v_u_2, (ref) v_u_3, (ref) v_u_629, (ref) v_u_630, (copy) v_u_636
	v_u_79 = v_u_79 % 3 + 1
	if v_u_79 == 3 then
		v_u_2.CameraType = Enum.CameraType.Scriptable
		v_u_3:WaitForChild("PlayerEyeLevel")
		local v714, v715, _ = v_u_2.CFrame:ToEulerAnglesYXZ()
		v_u_629 = v715
		v_u_630 = v714
	else
		if v_u_79 == 1 then
			local v716 = v_u_2.CFrame.Position
			local v717 = -v_u_2.CFrame.LookVector
			v_u_2.CFrame = CFrame.new(v716, v716 + v717)
		end
		v_u_2.CameraType = Enum.CameraType.Custom
	end
	checkHeld()
	v_u_636()
end
local function v721(p718, p719) -- name: inputRequest
	-- upvalues: (copy) v_u_10, (ref) v_u_38, (ref) v_u_39, (ref) v_u_44, (ref) v_u_45, (ref) v_u_46, (ref) v_u_37, (ref) v_u_56, (copy) v_u_12
	if p719 then
		return
	elseif p718.KeyCode ~= Enum.KeyCode.Space then
		if p718.KeyCode == v_u_10.Keybinds.sprint then
			v_u_38 = true
			if not (v_u_39 or (v_u_44 or (v_u_45 or v_u_46))) then
				v_u_37 = true
				return
			end
		else
			if p718.KeyCode == Enum.KeyCode.W then
				if tick() - v_u_56 < 0.3 then
					v_u_37 = true
				end
				v_u_56 = tick()
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.crouch then
				v_u_39 = true
				return
			end
			if p718.UserInputType == Enum.UserInputType.MouseButton2 then
				local v720 = v_u_12.Inventory[v_u_12.SelectedSlot]
				if typeof(v720) == "table" and v_u_12.Inventory[v_u_12.SelectedSlot].type == "interactable" then
					game.ReplicatedStorage.Remotes.InteractItem:FireServer()
				else
					startPlaceHold()
				end
			end
			if p718.UserInputType == Enum.UserInputType.MouseButton1 then
				startHit()
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.switchPerspective then
				switchCamera()
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot1 then
				v_u_12:SelectHotbarSlot(1)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot2 then
				v_u_12:SelectHotbarSlot(2)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot3 then
				v_u_12:SelectHotbarSlot(3)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot4 then
				v_u_12:SelectHotbarSlot(4)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot5 then
				v_u_12:SelectHotbarSlot(5)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot6 then
				v_u_12:SelectHotbarSlot(6)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot7 then
				v_u_12:SelectHotbarSlot(7)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot8 then
				v_u_12:SelectHotbarSlot(8)
				return
			end
			if p718.KeyCode == v_u_10.Keybinds.slot9 then
				v_u_12:SelectHotbarSlot(9)
			end
		end
	end
end
local function v723(p722, _) -- name: inputStop
	-- upvalues: (ref) v_u_34, (copy) v_u_10, (ref) v_u_38, (ref) v_u_39, (ref) v_u_37
	if p722.KeyCode == Enum.KeyCode.Space or p722.KeyCode == Enum.KeyCode.ButtonA then
		v_u_34 = false
		return
	elseif p722.KeyCode == v_u_10.Keybinds.sprint then
		v_u_38 = false
		return
	elseif p722.KeyCode == v_u_10.Keybinds.crouch then
		v_u_39 = false
		if v_u_38 then
			v_u_37 = true
		else
			v_u_37 = false
		end
	else
		if p722.UserInputType == Enum.UserInputType.MouseButton2 then
			stopPlaceHold()
		end
		return
	end
end
local v_u_724 = nil
local v_u_725 = nil
local v_u_726 = 0
local _ = CFrame.new(-0.382, -0.507, 0.703) * CFrame.Angles(-0.3434458902074442, 1.0084337885098038, -2.3355821517262916)
function selectionBox() -- name: selectionBox
	-- upvalues: (ref) v_u_3, (copy) v_u_1, (ref) v_u_79, (copy) v_u_2, (copy) v_u_21
	local v727 = RaycastParams.new()
	v727.CollisionGroup = "Hitbox"
	v727.FilterDescendantsInstances = { v_u_3, v_u_1.Character }
	v727.FilterType = Enum.RaycastFilterType.Exclude
	local v728 = (v_u_3.PlayerEyeLevel or v_u_3:WaitForChild("PlayerEyeLevel")).Position
	local v729 = (v_u_79 == 3 and -v_u_2.CFrame.LookVector or v_u_2.CFrame.LookVector) * v_u_21
	local v730 = workspace:Raycast(v728, v729, v727)
	if v730 and v730.Instance then
		if v730.Instance.Parent ~= workspace.OtherCharacters and v730.Instance.Name ~= "StairPart" then
			local v731 = workspace.GUI:FindFirstChild("SelectionBox") or game.ReplicatedStorage.Models.SelectionBox:Clone()
			v731.Parent = workspace.GUI
			v731.Position = v730.Instance.Position
			return
		end
		if v730.Instance.Parent:FindFirstChild("RenderBox") then
			local v732 = workspace.GUI:FindFirstChild("SelectionBox") or game.ReplicatedStorage.Models.SelectionBox:Clone()
			v732.Parent = workspace.GUI
			v732.Position = v730.Instance.Parent:FindFirstChild("RenderBox").Position
			return
		end
	end
	local v733 = workspace.GUI:FindFirstChild("SelectionBox")
	if v733 then
		v733:Destroy()
	end
end
local v_u_734 = 0
local v_u_735 = 0
local function v_u_748(p736) -- name: updateViewmodel
	-- upvalues: (ref) v_u_734, (ref) v_u_735, (copy) v_u_314, (copy) v_u_2, (ref) v_u_3, (ref) v_u_55, (ref) v_u_57, (ref) v_u_67, (ref) v_u_68, (ref) v_u_63, (copy) v_u_636, (copy) v_u_430, (copy) v_u_446
	v_u_734 = v_u_734 + 1
	v_u_735 = v_u_735 + p736
	v_u_314((v_u_2.CFrame.Position - v_u_3.PlayerEyeLevel.Position).Magnitude >= 1)
	local v737 = v_u_2.CFrame.LookVector
	local v738 = v737.X
	local v739 = v737.Z
	local v740 = Vector3.new(v738, 0, v739).Unit
	local v741 = v_u_55.X
	local v742 = v_u_55.Z
	local v743 = Vector3.new(v741, 0, v742).Unit
	local v744 = v740:Dot(v743)
	local v745 = math.clamp(v744, -1, 1)
	local v746 = -math.acos(v745) * (v740:Cross(v743).Y >= 0 and -1 or 1) * 2
	local v747 = math.clamp(v746, -0.5235987755982988, 0.5235987755982988)
	v_u_57 = v_u_57:Lerp(CFrame.Angles(0, v747, 0), 8 * p736)
	if v_u_67 then
		if v_u_68 then
			v_u_68:PivotTo(workspace.CurrentCamera.CFrame)
			v_u_67.FakeCamera.CFrame = v_u_68.CFrame
			v_u_67:PivotTo(v_u_67.FakeCamera.CFrame * v_u_57 * v_u_63)
			v_u_55 = v737
			v_u_636()
			selectionBox()
			v_u_430(p736)
			v_u_446(p736)
		end
	else
		return
	end
end
function checkHeld() -- name: checkHeld
	-- upvalues: (copy) v_u_12, (ref) v_u_3, (ref) v_u_60, (copy) v_u_13, (ref) v_u_79, (copy) v_u_636
	local v749 = v_u_12.Inventory[v_u_12.SelectedSlot]
	if v_u_3["Right Arm"]:FindFirstChild("Item") then
		v_u_3["Right Arm"]:FindFirstChild("Item"):Destroy()
	end
	if v_u_3["Right Arm"]:FindFirstChild("ItemWeld") then
		v_u_3["Right Arm"]:FindFirstChild("ItemWeld"):Destroy()
	end
	local v750 = { 1, 0, 0 }
	if typeof(v749) == "table" then
		v_u_60 = CFrame.Angles(0.3141592653589793, 0, 0)
		if v749.type == "block" or v749.type == "stair" then
			local v751 = game.ReplicatedStorage.Models.HeldBlock:Clone()
			v751.Name = "Item"
			v751.Parent = v_u_3["Right Arm"]
			local v752 = game.ReplicatedStorage.Models.HeldBlockWeld:Clone()
			v752.Name = "ItemWeld"
			v752.Parent = v_u_3["Right Arm"]
			v752.Part1 = v751
			v752.Part0 = v_u_3["Right Arm"]
			local v753 = v749.id
			for _, v754 in ipairs(v751:GetChildren()) do
				if v754:IsA("Texture") then
					v754.Texture = v_u_13.block[v753].atlas
					v754.OffsetStudsU = v_u_13.block[v753][v754.Name].X / 10.6666667
					v754.OffsetStudsV = v_u_13.block[v753][v754.Name].Y / 10.6666667
				end
			end
			local v755 = v_u_3["Right Arm"]:FindFirstChild("Item")
			local v756 = v750[v_u_79]
			v755.Transparency = math.abs(v756)
			for _, v757 in ipairs(v_u_3["Right Arm"]:FindFirstChild("Item"):GetChildren()) do
				v757.Transparency = v750[v_u_79]
			end
		elseif v749.type == "sword" or v749.type == "pickaxe" then
			local v758 = game.ReplicatedStorage.Models.Item:FindFirstChild(v749.id):Clone()
			v758.Name = "Item"
			v758.Parent = v_u_3["Right Arm"]
			local v759 = game.ReplicatedStorage.Models.HeldSwordWeld:Clone()
			v759.Name = "ItemWeld"
			v759.Parent = v_u_3["Right Arm"]
			v759.Part1 = v758
			v759.Part0 = v_u_3["Right Arm"]
			for _, v760 in ipairs(v758.Model:GetChildren()) do
				v760.Transparency = v750[v_u_79]
			end
		elseif v749.type == "bow" then
			local v761 = game.ReplicatedStorage.Models.Item:FindFirstChild(v749.id):Clone()
			v761.Name = "Item"
			v761.Parent = v_u_3["Right Arm"]
			local v762 = game.ReplicatedStorage.Models.HeldBowWeld:Clone()
			v762.Name = "ItemWeld"
			v762.Parent = v_u_3["Right Arm"]
			v762.Part1 = v761
			v762.Part0 = v_u_3["Right Arm"]
			for _, v763 in ipairs(v761.Model:GetChildren()) do
				v763.Transparency = 1
			end
			local v764 = v761.Model.standby
			local v765 = v750[v_u_79]
			v764.Transparency = math.abs(v765)
		elseif v749.type == "item" or (v749.type == "food" or (v749.type == "arrow" or v749.type == "interactable")) then
			local v766 = game.ReplicatedStorage.Models.Item:FindFirstChild(v749.id):Clone()
			v766.Name = "Item"
			v766.Parent = v_u_3["Right Arm"]
			local v767 = game.ReplicatedStorage.Models.HeldItemWeld:Clone()
			v767.Name = "ItemWeld"
			v767.Parent = v_u_3["Right Arm"]
			v767.Part1 = v766
			v767.Part0 = v_u_3["Right Arm"]
			for _, v768 in ipairs(v766.Model:GetChildren()) do
				v768.Transparency = v750[v_u_79]
			end
		end
	else
		v_u_60 = CFrame.Angles(0, 0, 0)
	end
	v_u_636()
end
script.Inventory.RedrawViewmodel.Event:Connect(function()
	-- upvalues: (ref) v_u_724, (ref) v_u_725, (ref) v_u_726, (copy) v_u_7, (ref) v_u_63, (copy) v_u_12, (ref) v_u_67, (copy) v_u_13
	if v_u_724 then
		v_u_724:Disconnect()
		v_u_724 = nil
	end
	v_u_725 = "down"
	v_u_726 = -2.5
	v_u_724 = v_u_7.RenderStepped:Connect(function(p769)
		-- upvalues: (ref) v_u_63, (ref) v_u_726, (ref) v_u_725, (ref) v_u_12, (ref) v_u_67, (ref) v_u_13, (ref) v_u_724
		local v770 = v_u_63.Position.Y
		local v771 = v_u_726 - v770
		local v772 = -18 * p769
		local v773 = 18 * p769
		local v774 = v770 + math.clamp(v771, v772, v773)
		v_u_63 = CFrame.new(0, v774, 0)
		local v775 = v_u_726 - v774
		if math.abs(v775) < 0.05 then
			if v_u_725 == "down" then
				v_u_725 = "up"
				v_u_726 = 0
				local _ = v_u_12.Inventory
				local v776 = v_u_12.Inventory[v_u_12.SelectedSlot]
				if typeof(v776) == "table" then
					if v776.type == "block" or v776.type == "stair" then
						local v777 = v_u_67:FindFirstChild("ViewportBlock")
						if v777 then
							v777:Destroy()
						end
						local v778 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
						if v778 then
							v778:Destroy()
						end
						for _, v779 in pairs(v_u_67["Right Arm"]:GetChildren()) do
							if v779:IsA("Texture") then
								v779.Transparency = 1
							end
						end
						local v780 = game.ReplicatedStorage.Models.ViewportBlock:Clone()
						v780.Parent = v_u_67
						for _, v781 in ipairs(v780:GetChildren()) do
							v781.Texture = v_u_13.block[v776.id].atlas
							v781.OffsetStudsU = v_u_13.block[v776.id][v781.Name].X / 8
							v781.OffsetStudsV = v_u_13.block[v776.id][v781.Name].Y / 8
						end
						local v782 = game.ReplicatedStorage.Models.ViewportBlockWeld:Clone()
						v782.Parent = v_u_67["Right Arm"]
						v782.Part0 = v782.Parent
						v782.Part1 = v780
						v782.Name = "ItemWeld"
					else
						local v783 = v_u_67:FindFirstChild("ViewportBlock")
						if v783 then
							v783:Destroy()
						end
						local v784 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
						if v784 then
							v784:Destroy()
						end
						for _, v785 in pairs(v_u_67["Right Arm"]:GetChildren()) do
							if v785:IsA("Texture") then
								v785.Transparency = 1
							end
						end
						local v786 = game.ReplicatedStorage.Models.Item:FindFirstChild(v776.id):Clone()
						v786.Parent = v_u_67
						v786.Name = "ViewportBlock"
						local v787 = game.ReplicatedStorage.Models.ItemAnchorWeld:Clone()
						v787.Parent = v_u_67["Right Arm"]
						v787.Part0 = v787.Parent
						v787.Part1 = v786
						v787.Name = "ItemWeld"
					end
				end
				for _, v788 in pairs(v_u_67["Right Arm"]:GetChildren()) do
					if v788:IsA("Texture") then
						v788.Transparency = 0
					end
				end
				local v789 = v_u_67:FindFirstChild("ViewportBlock")
				if v789 then
					v789:Destroy()
				end
				local v790 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
				if v790 then
					v790:Destroy()
					return
				end
			else
				v_u_63 = CFrame.new(0, 0, 0)
				v_u_724:Disconnect()
				v_u_724 = nil
			end
		end
	end)
	checkHeld()
end)
script.Inventory.SelectionChanged.Event:Connect(function(p791, p792)
	-- upvalues: (copy) v_u_12, (ref) v_u_724, (ref) v_u_725, (ref) v_u_726, (copy) v_u_7, (ref) v_u_63, (ref) v_u_67, (copy) v_u_13
	local v793 = v_u_12.Inventory
	local v794 = v793[p791]
	local v795 = v793[p792]
	if typeof(v794) == typeof(v795) then
		if typeof(v794) == "table" and (typeof(v795) == "table" and v794.id ~= v795.id) then
			if v_u_724 then
				v_u_724:Disconnect()
				v_u_724 = nil
			end
			v_u_725 = "down"
			v_u_726 = -2.5
			v_u_724 = v_u_7.RenderStepped:Connect(function(p796)
				-- upvalues: (ref) v_u_63, (ref) v_u_726, (ref) v_u_725, (ref) v_u_12, (ref) v_u_67, (ref) v_u_13, (ref) v_u_724
				local v797 = v_u_63.Position.Y
				local v798 = v_u_726 - v797
				local v799 = -18 * p796
				local v800 = 18 * p796
				local v801 = v797 + math.clamp(v798, v799, v800)
				v_u_63 = CFrame.new(0, v801, 0)
				local v802 = v_u_726 - v801
				if math.abs(v802) < 0.05 then
					if v_u_725 == "down" then
						v_u_725 = "up"
						v_u_726 = 0
						local _ = v_u_12.Inventory
						local v803 = v_u_12.Inventory[v_u_12.SelectedSlot]
						if typeof(v803) == "table" then
							if v803.type == "block" or v803.type == "stair" then
								local v804 = v_u_67:FindFirstChild("ViewportBlock")
								if v804 then
									v804:Destroy()
								end
								local v805 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
								if v805 then
									v805:Destroy()
								end
								for _, v806 in pairs(v_u_67["Right Arm"]:GetChildren()) do
									if v806:IsA("Texture") then
										v806.Transparency = 1
									end
								end
								local v807 = game.ReplicatedStorage.Models.ViewportBlock:Clone()
								v807.Parent = v_u_67
								for _, v808 in ipairs(v807:GetChildren()) do
									v808.Texture = v_u_13.block[v803.id].atlas
									v808.OffsetStudsU = v_u_13.block[v803.id][v808.Name].X / 8
									v808.OffsetStudsV = v_u_13.block[v803.id][v808.Name].Y / 8
								end
								local v809 = game.ReplicatedStorage.Models.ViewportBlockWeld:Clone()
								v809.Parent = v_u_67["Right Arm"]
								v809.Part0 = v809.Parent
								v809.Part1 = v807
								v809.Name = "ItemWeld"
							else
								local v810 = v_u_67:FindFirstChild("ViewportBlock")
								if v810 then
									v810:Destroy()
								end
								local v811 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
								if v811 then
									v811:Destroy()
								end
								for _, v812 in pairs(v_u_67["Right Arm"]:GetChildren()) do
									if v812:IsA("Texture") then
										v812.Transparency = 1
									end
								end
								local v813 = game.ReplicatedStorage.Models.Item:FindFirstChild(v803.id):Clone()
								v813.Parent = v_u_67
								v813.Name = "ViewportBlock"
								local v814 = game.ReplicatedStorage.Models.ItemAnchorWeld:Clone()
								v814.Parent = v_u_67["Right Arm"]
								v814.Part0 = v814.Parent
								v814.Part1 = v813
								v814.Name = "ItemWeld"
							end
						end
						for _, v815 in pairs(v_u_67["Right Arm"]:GetChildren()) do
							if v815:IsA("Texture") then
								v815.Transparency = 0
							end
						end
						local v816 = v_u_67:FindFirstChild("ViewportBlock")
						if v816 then
							v816:Destroy()
						end
						local v817 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
						if v817 then
							v817:Destroy()
							return
						end
					else
						v_u_63 = CFrame.new(0, 0, 0)
						v_u_724:Disconnect()
						v_u_724 = nil
					end
				end
			end)
			checkHeld()
		end
	else
		if v_u_724 then
			v_u_724:Disconnect()
			v_u_724 = nil
		end
		v_u_725 = "down"
		v_u_726 = -2.5
		v_u_724 = v_u_7.RenderStepped:Connect(function(p818)
			-- upvalues: (ref) v_u_63, (ref) v_u_726, (ref) v_u_725, (ref) v_u_12, (ref) v_u_67, (ref) v_u_13, (ref) v_u_724
			local v819 = v_u_63.Position.Y
			local v820 = v_u_726 - v819
			local v821 = -18 * p818
			local v822 = 18 * p818
			local v823 = v819 + math.clamp(v820, v821, v822)
			v_u_63 = CFrame.new(0, v823, 0)
			local v824 = v_u_726 - v823
			if math.abs(v824) < 0.05 then
				if v_u_725 == "down" then
					v_u_725 = "up"
					v_u_726 = 0
					local _ = v_u_12.Inventory
					local v825 = v_u_12.Inventory[v_u_12.SelectedSlot]
					if typeof(v825) == "table" then
						if v825.type == "block" or v825.type == "stair" then
							local v826 = v_u_67:FindFirstChild("ViewportBlock")
							if v826 then
								v826:Destroy()
							end
							local v827 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
							if v827 then
								v827:Destroy()
							end
							for _, v828 in pairs(v_u_67["Right Arm"]:GetChildren()) do
								if v828:IsA("Texture") then
									v828.Transparency = 1
								end
							end
							local v829 = game.ReplicatedStorage.Models.ViewportBlock:Clone()
							v829.Parent = v_u_67
							for _, v830 in ipairs(v829:GetChildren()) do
								v830.Texture = v_u_13.block[v825.id].atlas
								v830.OffsetStudsU = v_u_13.block[v825.id][v830.Name].X / 8
								v830.OffsetStudsV = v_u_13.block[v825.id][v830.Name].Y / 8
							end
							local v831 = game.ReplicatedStorage.Models.ViewportBlockWeld:Clone()
							v831.Parent = v_u_67["Right Arm"]
							v831.Part0 = v831.Parent
							v831.Part1 = v829
							v831.Name = "ItemWeld"
						else
							local v832 = v_u_67:FindFirstChild("ViewportBlock")
							if v832 then
								v832:Destroy()
							end
							local v833 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
							if v833 then
								v833:Destroy()
							end
							for _, v834 in pairs(v_u_67["Right Arm"]:GetChildren()) do
								if v834:IsA("Texture") then
									v834.Transparency = 1
								end
							end
							local v835 = game.ReplicatedStorage.Models.Item:FindFirstChild(v825.id):Clone()
							v835.Parent = v_u_67
							v835.Name = "ViewportBlock"
							local v836 = game.ReplicatedStorage.Models.ItemAnchorWeld:Clone()
							v836.Parent = v_u_67["Right Arm"]
							v836.Part0 = v836.Parent
							v836.Part1 = v835
							v836.Name = "ItemWeld"
						end
					end
					for _, v837 in pairs(v_u_67["Right Arm"]:GetChildren()) do
						if v837:IsA("Texture") then
							v837.Transparency = 0
						end
					end
					local v838 = v_u_67:FindFirstChild("ViewportBlock")
					if v838 then
						v838:Destroy()
					end
					local v839 = v_u_67["Right Arm"]:FindFirstChild("ItemWeld")
					if v839 then
						v839:Destroy()
						return
					end
				else
					v_u_63 = CFrame.new(0, 0, 0)
					v_u_724:Disconnect()
					v_u_724 = nil
				end
			end
		end)
		checkHeld()
		return
	end
end)
local function v_u_867(p840, p841) -- name: clampHorizDeltaToEdge
	-- upvalues: (ref) v_u_14, (copy) v_u_648
	if p841.Magnitude < 1e-6 then
		local v842 = v_u_14.Y
		v_u_14 = Vector3.new(0, v842, 0)
		return Vector3.new(0, 0, 0)
	elseif v_u_648(p840 + p841) then
		return p841
	else
		local v843 = p841.X
		local v844 = Vector3.new(v843, 0, 0)
		local v845 = p841.Z
		local v846 = Vector3.new(0, 0, v845)
		local v847 = v_u_648(p840 + v844)
		local v848 = v_u_648(p840 + v846)
		if v847 and not v848 then
			local v849 = v_u_14.X
			local v850 = v_u_14.Y
			v_u_14 = Vector3.new(v849, v850, 0)
			return v844
		elseif v848 and not v847 then
			local v851 = v_u_14.Y
			local v852 = v_u_14.Z
			v_u_14 = Vector3.new(0, v851, v852)
			return v846
		elseif v847 and v848 then
			local v853 = p841.X
			local v854 = math.abs(v853)
			local v855 = p841.Z
			if math.abs(v855) <= v854 then
				local v856 = v_u_14.X
				local v857 = v_u_14.Y
				v_u_14 = Vector3.new(v856, v857, 0)
				return v844
			else
				local v858 = v_u_14.Y
				local v859 = v_u_14.Z
				v_u_14 = Vector3.new(0, v858, v859)
				return v846
			end
		else
			local v860 = 0
			local v861 = 1
			for _ = 1, 7 do
				local v862 = (v860 + v861) * 0.5
				if v_u_648(p840 + p841 * v862) then
					v860 = v862
				else
					v861 = v862
				end
			end
			local v863 = p841 * v860
			local v864 = v_u_14.X * v860
			local v865 = v_u_14.Y
			local v866 = v_u_14.Z * v860
			v_u_14 = Vector3.new(v864, v865, v866)
			return v863
		end
	end
end
local v_u_868 = 0
local v_u_869 = 0
local v_u_870 = {}
local function v_u_921(p871) -- name: movement
	-- upvalues: (ref) v_u_36, (ref) v_u_868, (ref) v_u_869, (ref) v_u_33, (copy) v_u_648, (ref) v_u_4, (ref) v_u_34, (copy) v_u_481, (ref) v_u_14, (copy) v_u_28, (copy) v_u_26, (copy) v_u_27, (copy) v_u_9, (copy) v_u_2, (ref) v_u_79, (ref) v_u_39, (copy) v_u_19, (ref) v_u_37, (copy) v_u_18, (copy) v_u_17, (ref) v_u_44, (ref) v_u_45, (ref) v_u_46, (ref) v_u_3, (ref) v_u_38, (copy) v_u_10, (copy) v_u_22, (copy) v_u_24, (copy) v_u_23, (copy) v_u_25, (copy) v_u_286, (copy) v_u_867, (copy) v_u_311, (copy) v_u_144, (ref) v_u_15, (ref) v_u_40, (copy) v_u_870, (copy) v_u_1, (ref) v_u_735, (ref) v_u_734, (ref) v_u_5, (copy) v_u_12, (ref) v_u_65, (ref) v_u_66, (ref) v_u_64, (ref) v_u_61, (copy) v_u_463, (copy) v_u_399, (copy) v_u_422, (ref) v_u_54
	if not v_u_36 then
		v_u_868 = v_u_868 + p871
		v_u_869 = v_u_869 + 1
		v_u_33 = v_u_648(v_u_4.Position)
		if v_u_34 and v_u_33 then
			v_u_481()
		end
		local v872 = v_u_14.X
		local v873 = v_u_28
		local v874 = v_u_14.Y + v_u_26 * v_u_27 * p871
		local v875 = math.max(v873, v874)
		local v876 = v_u_14.Z
		v_u_14 = Vector3.new(v872, v875, v876)
		local v877 = v_u_9:GetMoveVector()
		local v878 = v_u_2.CFrame
		local v879 = v_u_79 == 3 and -v878.LookVector or v878.LookVector
		local v880 = v_u_79 == 3 and -v878.RightVector or v878.RightVector
		local v881 = v879.X
		local v882 = v879.Z
		local v883 = Vector3.new(v881, 0, v882).Unit
		local v884 = v880.X
		local v885 = v880.Z
		local v886 = Vector3.new(v884, 0, v885).Unit
		local v887 = -v883 * v877.Z + v886 * v877.X
		if v887.Magnitude > 0 then
			v887 = v887.Unit
		end
		local v888
		if v_u_39 then
			v888 = v_u_19
		elseif v_u_37 then
			v888 = v_u_18
		else
			v888 = v_u_17
		end
		if v_u_44 or (v_u_45 or v_u_46) then
			v888 = v_u_19
		end
		if v_u_3 then
			if v_u_39 then
				v_u_2.CameraSubject = nil
				v_u_3.PlayerHitbox.PlayerEyeLevel.C1 = CFrame.new(0, 0.5, 0)
				v_u_2.CameraSubject = v_u_3.PlayerEyeLevel
			else
				v_u_2.CameraSubject = nil
				v_u_3.PlayerHitbox.PlayerEyeLevel.C1 = CFrame.new(0, 0, 0)
				v_u_2.CameraSubject = v_u_3.PlayerEyeLevel
			end
		end
		local v889 = v887 * v888
		local v890 = v_u_14.Y
		if v877.Magnitude > 0 then
			if v_u_38 == true or v_u_10.Preferences.AutoSprint then
				v_u_37 = true
			end
			if v_u_33 then
				local v891 = v_u_14
				local v892 = v889.X
				local v893 = v889.Z
				v_u_14 = v891:Lerp(Vector3.new(v892, 0, v893), v_u_22 * p871)
			else
				local v894 = v_u_14
				local v895 = v889.X
				local v896 = v889.Z
				v_u_14 = v894:Lerp(Vector3.new(v895, 0, v896), v_u_24 * p871)
			end
		else
			if not v_u_38 then
				v_u_37 = false
			end
			if v_u_33 then
				v_u_14 = v_u_14:Lerp(Vector3.new(0, 0, 0), v_u_23 * p871)
			else
				v_u_14 = v_u_14:Lerp(Vector3.new(0, 0, 0), v_u_25 * p871)
			end
		end
		if v877.Magnitude > 0 and v877.Z >= 0 then
			v_u_37 = false
		elseif v877.Z < 0 and v_u_38 then
			v_u_37 = true
		end
		local v897 = v_u_14.X
		local v898 = v_u_14.Z
		v_u_14 = Vector3.new(v897, v890, v898)
		local v899 = v_u_14.X
		local v900 = v_u_14.Z
		local v901 = Vector3.new(v899, 0, v900) * p871
		local v902 = v_u_14.Y * p871
		if v_u_39 and v_u_33 then
			if v_u_648(v_u_4.Position + v901) then
				v901 = v_u_867(v_u_4.Position, v901)
			elseif not v_u_286(v_u_4.Position, v901) then
				v901 = v_u_867(v_u_4.Position, v901)
				if v887.Magnitude <= 0.1 and v901.Magnitude < 0.00001 then
					local v903 = v_u_14.Y
					v_u_14 = Vector3.new(0, v903, 0)
				end
			end
		end
		local v904 = v901 + Vector3.new(0, v902, 0)
		local v905, v906, v907 = v_u_144(v_u_311(v_u_4.Position, v904), v_u_14.Y)
		local v908 = v_u_14.X
		local v909 = v_u_14.Z
		v_u_14 = Vector3.new(v908, v906, v909)
		v_u_33 = v907
		v_u_4.CFrame = CFrame.new(v905)
		v_u_15 = v905
		local v910 = v_u_14.X
		local v911 = v_u_14.Z
		if Vector3.new(v910, 0, v911).Magnitude < 4 then
			v_u_37 = false
		end
		if v_u_40 == true and not v_u_39 then
			local v912 = v_u_14.X
			local v913 = v_u_14.Z
			if Vector3.new(v912, 0, v913).Magnitude < 0.5 then
				local v914 = v_u_14.Y
				v_u_14 = Vector3.new(0, v914, 0)
			end
		end
		v_u_4.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		v_u_4.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		if #v_u_870 ~= 0 then
			if v_u_870[1].PLAYER_VELOCITY then
				v_u_14 = v_u_870[1].PLAYER_VELOCITY
			end
			table.remove(v_u_870, 1)
		end
		local v915 = v_u_14.X
		local v916 = v_u_14.Z
		local v917 = Vector3.new(v915, 0, v916).Magnitude
		v_u_1.PlayerGui.Game.Debug.Frame.SpeedLabel.Text = string.format("%.2f", v917 / 4) .. " m/s"
		if v_u_735 >= 1 then
			v_u_1.PlayerGui.Game.Debug.FPS.Text = "FPS: " .. v_u_734
			v_u_735 = v_u_735 - 1
			v_u_734 = 0
		end
		if v_u_868 >= 1 then
			v_u_1.PlayerGui.Game.Debug.TPS.Text = "Client TPS: " .. v_u_869
			v_u_868 = v_u_868 - 1
			v_u_869 = 0
		end
		v_u_5.CameraOffset = Vector3.new(0, 0.7, 0)
		local v918 = v_u_12.Inventory[v_u_12.SelectedSlot]
		if typeof(v918) == "table" then
			if v_u_12.Inventory[v_u_12.SelectedSlot].type == "sword" then
				if v_u_45 then
					endEatEvent:FireServer()
					endEatAnimation()
				end
				if v_u_46 then
					endBowCharge()
				end
				v_u_65 = CFrame.identity
				v_u_66 = CFrame.identity
				v_u_45 = false
				v_u_46 = false
				if isRightMouseDown() then
					if not v_u_44 then
						beginBlockEvent:FireServer()
					end
					v_u_64 = CFrame.new(0, 1.5, -0.4) * CFrame.Angles(1.5707963267948966, 0.4363323129985824, -0.8726646259971648)
					v_u_61 = CFrame.Angles(0.5235987755982988, 0.3490658503988659, -0.3490658503988659)
					v_u_44 = true
					v_u_37 = false
				else
					if v_u_44 then
						endBlockEvent:FireServer()
					end
					v_u_61 = CFrame.identity
					v_u_64 = CFrame.identity
					v_u_44 = false
				end
			else
				if v_u_44 then
					endBlockEvent:FireServer()
				end
				v_u_61 = CFrame.identity
				v_u_44 = false
				if v_u_12.Inventory[v_u_12.SelectedSlot].type == "food" then
					if isRightMouseDown() then
						if not v_u_45 then
							beginEatEvent:FireServer()
							startEatAnimation()
						end
						v_u_45 = true
						v_u_37 = false
					else
						if v_u_45 then
							endEatEvent:FireServer()
							endEatAnimation()
						end
						v_u_65 = CFrame.identity
						v_u_45 = false
					end
				else
					if v_u_45 then
						endEatEvent:FireServer()
						endEatAnimation()
					end
					v_u_65 = CFrame.identity
					v_u_45 = false
					if v_u_12.Inventory[v_u_12.SelectedSlot].type == "bow" then
						if v_u_12.find("arrow") then
							if isRightMouseDown() then
								if not v_u_46 then
									startBowCharge()
									beginChargeEvent:FireServer()
								end
								v_u_46 = true
								v_u_37 = false
							else
								if v_u_46 then
									endBowCharge()
									endChargeEvent:FireServer(v_u_79 == 3 and -v_u_2.CFrame.LookVector or v_u_2.CFrame.LookVector)
								end
								v_u_66 = CFrame.identity
								v_u_46 = false
							end
						else
							if v_u_46 then
								endBowCharge()
							end
							v_u_66 = CFrame.identity
							v_u_46 = false
						end
					else
						if v_u_46 then
							endBowCharge()
						end
						v_u_66 = CFrame.identity
						v_u_46 = false
					end
				end
			end
		else
			if v_u_44 then
				endBlockEvent:FireServer()
			end
			v_u_61 = CFrame.identity
			v_u_64 = CFrame.identity
			v_u_44 = false
			if v_u_45 then
				endEatEvent:FireServer()
			end
			v_u_65 = CFrame.identity
			v_u_45 = false
			v_u_66 = CFrame.identity
			v_u_46 = false
		end
		v_u_463(p871)
		v_u_399(p871)
		v_u_422(p871)
		local v919 = 12 * p871
		local v920 = v_u_37 and not (v_u_39 or (v_u_44 or (v_u_45 or v_u_46))) and v_u_10.Preferences.FieldOfView + 10 or v_u_10.Preferences.FieldOfView
		v_u_2.FieldOfView = v_u_2.FieldOfView + v919 * (v920 - v_u_2.FieldOfView)
		v_u_54 = v877
	end
	v_u_40 = v_u_39
end
finishedEatEvent.OnClientEvent:Connect(function()
	-- upvalues: (ref) v_u_45
	game.ReplicatedStorage.Sounds.generic.burp:Play()
	if v_u_45 then
		v_u_45 = false
		endEatAnimation()
	end
end)
game.ReplicatedStorage.Remotes.LoadLocalCharacter.OnClientEvent:Connect(function(p922)
	-- upvalues: (copy) v_u_90, (copy) v_u_2, (copy) v_u_1, (ref) v_u_67, (ref) v_u_69, (ref) v_u_70, (ref) v_u_68, (copy) v_u_7, (copy) v_u_921, (copy) v_u_748, (copy) v_u_636, (copy) v_u_12
	v_u_90(p922)
	v_u_2.FieldOfView = 30
	local v923 = v_u_1.PlayerGui.Game.GameUI.ViewportFrame
	v_u_67 = game.ReplicatedStorage.Models.Viewmodel_4x:Clone()
	v_u_67.Parent = v923.WorldModel
	v_u_69 = v_u_67.FakeCamera["Right Arm"]
	v_u_70 = v_u_69.C0
	if v_u_68 then
		v_u_68:Destroy()
		v_u_68 = nil
	end
	v_u_68 = Instance.new("Camera")
	v_u_68.Parent = workspace
	v_u_68.Name = "ViewmodelCamera"
	v_u_68.FieldOfView = 70
	v923.CurrentCamera = v_u_68
	v_u_7:BindToRenderStep("Movement", 0, function(p924)
		-- upvalues: (ref) v_u_921
		v_u_921(p924)
	end)
	v_u_7:BindToRenderStep("Viewmodel", Enum.RenderPriority.Camera.Value, v_u_748)
	local v925 = v_u_1.Character or v_u_1.CharacterAdded:Wait()
	local v926 = v925:WaitForChild("PlayerEyeLevel"):WaitForChild("SelectionBox")
	local v927 = v925:WaitForChild("PlayerHitbox"):WaitForChild("SelectionBox")
	v926.Visible = false
	v927.Visible = false
	v_u_636()
	v_u_12.init()
end)
game.ReplicatedStorage.Remotes.SetAbsolutePosition.OnClientEvent:Connect(function(p928)
	-- upvalues: (ref) v_u_15
	v_u_15 = p928 or Vector3.new(0, 50, 0)
end)
game.ReplicatedStorage.Remotes.PlayLocalSound.OnClientEvent:Connect(function(p929, p930)
	game.ReplicatedStorage.Sounds[p929][p930]:Play()
end)
game.ReplicatedStorage.Remotes.CriticalParticles.OnClientEvent:Connect(function(p931)
	-- upvalues: (copy) v_u_1
	local v932 = p931 ~= v_u_1 and workspace.OtherCharacters:FindFirstChild(p931.Name .. "_FakeCharacter")
	if v932 then
		local v933 = game.ReplicatedStorage.Models:WaitForChild("CritParticle"):Clone()
		v933.Parent = v932:WaitForChild("PlayerHitbox")
		v933:Emit(30)
		task.wait(0.7)
		v933:Destroy()
	end
end)
local _ = false
v_u_14 = Vector3.new(0, 0, 0)
v_u_8.InputBegan:Connect(v721)
v_u_8.InputEnded:Connect(v723)
local v_u_934 = 0
local v_u_935 = 0
local v_u_936 = game.ReplicatedStorage.Remotes.InputUpdate
local v937 = game.ReplicatedStorage.Remotes.ClientStateUpdate
local v938 = game.ReplicatedStorage.Remotes.ServerStateUpdate
local v_u_939 = {}
local v_u_940 = {
	["mv"] = Vector3.new(0, 0, 0),
	["rawInput"] = Vector3.new(0, 0, 0),
	["jumping"] = false,
	["crouching"] = false,
	["sprintHeld"] = false,
	["sprinting"] = false
}
local v_u_941 = false
local function v_u_953() -- name: handleTick
	-- upvalues: (ref) v_u_3, (ref) v_u_935, (copy) v_u_939, (ref) v_u_15, (copy) v_u_9, (ref) v_u_14, (ref) v_u_34, (ref) v_u_39, (ref) v_u_38, (ref) v_u_37, (ref) v_u_941, (ref) v_u_79, (copy) v_u_2, (copy) v_u_936, (ref) v_u_940
	if v_u_3 then
		local v942 = {
			["tick"] = v_u_935,
			["position"] = v_u_15
		}
		v_u_939[v_u_935 % 1024] = v942
		local v943 = v_u_9:GetMoveVector()
		local v944 = workspace.CurrentCamera.CFrame
		local v945 = v944.LookVector.X
		local v946 = v944.LookVector.Z
		local v947 = Vector3.new(v945, 0, v946).Unit
		local v948 = v944.RightVector.X
		local v949 = v944.RightVector.Z
		local v950 = Vector3.new(v948, 0, v949).Unit
		local v951 = {
			["PLAYER_VELOCITY"] = v_u_14,
			["tick"] = v_u_935,
			["ABSOLUTE_POSITION"] = v_u_15,
			["rawInput"] = v943,
			["moveVector"] = -v947 * v943.Z + v950 * v943.X,
			["jumping"] = v_u_34,
			["crouching"] = v_u_39,
			["sprintHeld"] = v_u_38,
			["sprinting"] = v_u_37,
			["lastCrouchState"] = v_u_941
		}
		local v952 = v_u_79 == 3 and -v_u_2.CFrame.LookVector or v_u_2.CFrame.LookVector
		v951.neckC0 = CFrame.new(Vector3.new(0, 1.403, 0), Vector3.new(0, 1.403, 0) + v952)
		v_u_936:FireServer(v951)
		v_u_940 = v951
		v_u_941 = v_u_39
	end
end
local v_u_954 = {}
local v_u_955 = {}
local v_u_956 = {}
setSelectedEvent.OnClientEvent:Connect(function(p957, p958)
	-- upvalues: (copy) v_u_1, (copy) v_u_955, (ref) v_u_60, (copy) v_u_13
	if p957 ~= v_u_1 then
		if not v_u_955[p957.Name] then
			repeat
				task.wait()
			until v_u_955[p957.Name]
		end
		local v959 = workspace.OtherCharacters[p957.Name .. "_FakeCharacter"] or workspace.OtherCharacters:WaitForChild(p957.Name .. "_FakeCharacter")
		v959:WaitForChild("Right Arm")
		if v959["Right Arm"]:FindFirstChild("Item") then
			v959["Right Arm"]:FindFirstChild("Item"):Destroy()
		end
		if v959["Right Arm"]:FindFirstChild("ItemWeld") then
			v959["Right Arm"]:FindFirstChild("ItemWeld"):Destroy()
		end
		if typeof(p958) == "table" then
			v_u_60 = CFrame.Angles(0.3141592653589793, 0, 0)
			if p958.type == "block" or p958.type == "stair" then
				local v960 = game.ReplicatedStorage.Models.HeldBlock:Clone()
				v960.Name = "Item"
				v960.Parent = v959["Right Arm"]
				local v961 = game.ReplicatedStorage.Models.HeldBlockWeld:Clone()
				v961.Name = "ItemWeld"
				v961.Parent = v959["Right Arm"]
				v961.Part1 = v960
				v961.Part0 = v959["Right Arm"]
				local v962 = p958.id
				for _, v963 in ipairs(v960:GetChildren()) do
					if v963:IsA("Texture") then
						v963.Texture = v_u_13.block[v962].atlas
						v963.OffsetStudsU = v_u_13.block[v962][v963.Name].X / 10.6666667
						v963.OffsetStudsV = v_u_13.block[v962][v963.Name].Y / 10.6666667
					end
				end
				return
			end
			if p958.type == "sword" or p958.type == "pickaxe" then
				local v964 = game.ReplicatedStorage.Models.Item:FindFirstChild(p958.id):Clone()
				v964.Name = "Item"
				v964.Parent = v959["Right Arm"]
				local v965 = game.ReplicatedStorage.Models.HeldSwordWeld:Clone()
				v965.Name = "ItemWeld"
				v965.Parent = v959["Right Arm"]
				v965.Part1 = v964
				v965.Part0 = v959["Right Arm"]
				return
			end
			if p958.type == "bow" then
				local v966 = game.ReplicatedStorage.Models.Item:FindFirstChild(p958.id):Clone()
				v966.Name = "Item"
				v966.Parent = v959["Right Arm"]
				local v967 = game.ReplicatedStorage.Models.HeldBowWeld:Clone()
				v967.Name = "ItemWeld"
				v967.Parent = v959["Right Arm"]
				v967.Part1 = v966
				v967.Part0 = v959["Right Arm"]
				return
			end
			if p958.type == "item" or (p958.type == "food" or p958.type == "arrow") then
				local v968 = game.ReplicatedStorage.Models.Item:FindFirstChild(p958.id):Clone()
				v968.Name = "Item"
				v968.Parent = v959["Right Arm"]
				local v969 = game.ReplicatedStorage.Models.HeldItemWeld:Clone()
				v969.Name = "ItemWeld"
				v969.Parent = v959["Right Arm"]
				v969.Part1 = v968
				v969.Part0 = v959["Right Arm"]
				return
			end
		else
			v_u_955.handCFrameOffset1 = CFrame.Angles(0, 0, 0)
		end
	end
end)
function animateOtherHandHit(p970) -- name: animateOtherHandHit
	-- upvalues: (copy) v_u_955, (copy) v_u_7
	local v_u_971 = v_u_955[p970.Name]
	if v_u_971 then
		local v_u_972 = 0
		local v_u_973 = 0
		v_u_971.t = os.clock()
		if v_u_971.handAnimConnection then
			v_u_971.handCFrameOffset = CFrame.new() * CFrame.Angles(0, 0, 0)
			v_u_971.handAnimConnection:Disconnect()
			v_u_971.handAnimConnection = nil
		end
		v_u_971.handAnimConnection = v_u_7.RenderStepped:Connect(function()
			-- upvalues: (copy) v_u_971, (ref) v_u_972, (ref) v_u_973
			local v974 = os.clock() - v_u_971.t
			local v975 = v974 * 582
			local v976 = math.rad(v975)
			v_u_972 = math.sin(v976) * 90
			local v977 = v974 * 582 * 2
			local v978 = math.rad(v977) - 1.5707963267948966
			v_u_973 = math.cos(v978) * 25
			local v979 = v_u_972
			local v980 = v_u_973
			v_u_971.handCFrameOffset = CFrame.new() * CFrame.Angles(math.rad(v979), 0, (math.rad(v980)))
			if v974 >= 0.30927835051546393 then
				v_u_971.handCFrameOffset = CFrame.new() * CFrame.Angles(0, 0, 0)
				v_u_971.handAnimConnection:Disconnect()
				v_u_971.handAnimConnection = nil
			end
		end)
	end
end
local function v_u_990(p981, p982, p983) -- name: updateOtherHeadCFrame
	-- upvalues: (ref) v_u_954
	local v984 = workspace.OtherCharacters:FindFirstChild(p981.Name .. "_FakeCharacter")
	local v985 = v_u_954[p981.Name]
	if v985 then
		local v986 = v985.neckC0
		if v986 then
			if v985.crouching then
				v986 = v986 + Vector3.new(0, -0.8, 0)
			end
			local v987 = p983 and 1 or 15 * p982
			local v988 = v984:FindFirstChild("HeadTorso")
			local v989 = v988 and v988:FindFirstChild("Neck")
			if v989 then
				v989.C0 = v989.C0:Lerp(v986, v987)
			end
		end
	else
		return
	end
end
local function v_u_1019(p991, p992, p993) -- name: updateOtherTorsoCFrame
	-- upvalues: (ref) v_u_954, (copy) v_u_955, (ref) v_u_47
	local v994 = v_u_954[p991.Name]
	if v994 then
		local v995 = workspace.OtherCharacters:FindFirstChild(p991.Name .. "_FakeCharacter")
		if v995 then
			local v996 = v994.neckC0
			if v996 then
				local v997 = v995.PlayerHitbox.Torso
				if v_u_955[p991.Name].lastTorsoOrientation then
					local v998 = v_u_47 or CFrame.new(0, 0.709, 0)
					local _, v999, _ = v996:ToEulerAnglesYXZ()
					local _, v1000, _ = v997.C0:ToEulerAnglesYXZ()
					local v1001 = v999 - v1000
					if v1001 > 3.141592653589793 then
						v1001 = v1001 - 6.283185307179586
					elseif v1001 < -3.141592653589793 then
						v1001 = v1001 + 6.283185307179586
					end
					local v1002 = v994.PLAYER_VELOCITY.X
					local v1003 = v994.PLAYER_VELOCITY.Z
					local v1004 = Vector3.new(v1002, 0, v1003)
					local v1005 = v995.Head.CFrame:VectorToObjectSpace(v1004)
					local v1006 = v1005.X
					local v1007 = v1005.Z
					local v1008 = Vector3.new(v1006, 0, v1007)
					local v1009 = v1008.Z > 0.7071067811865476
					local v1010 = v1008.Z < -0.7071067811865476
					local v1011 = v1008.X > 0.7071067811865476
					local v1012 = v1008.X < -0.7071067811865476
					local v1013 = v_u_955[p991.Name].lastTorsoOrientation
					local v1014 = nil
					if math.abs(v1001) > 0.8028514559173916 then
						local v1015 = v1000 + 0.5 * v1001
						v1014 = CFrame.Angles(0, v1015, 0)
					elseif v1010 and not (v1011 or v1012) then
						v1014 = CFrame.Angles(0, v999, 0)
					elseif v1009 or v1012 then
						v1014 = CFrame.Angles(0, v999 + 0.7853981633974483, 0)
					elseif v1011 or v1011 and v1010 then
						v1014 = CFrame.Angles(0, v999 - 0.7853981633974483, 0)
					end
					if v1014 then
						v_u_955[p991.Name].lastTorsoOrientation = v1014
					else
						v1014 = v1013
					end
					local v1016 = CFrame.new()
					if v994.crouching then
						v1016 = CFrame.new(0, -0.6, 0.7) * CFrame.Angles(-0.5235987755982988, 0, 0)
					end
					local v1017 = v998 * v1014 * v1016
					local v1018 = p993 and 1 or 8 * p992
					v997.C0 = v997.C0:Lerp(v1017, v1018)
				end
			else
				return
			end
		else
			return
		end
	else
		return
	end
end
local function v_u_1034(p1020, p1021) -- name: updateOtherArmSway
	-- upvalues: (copy) v_u_955, (ref) v_u_954, (copy) v_u_1
	local v1022 = v_u_955[p1020.Name]
	if v_u_954[v_u_1.Name] then
		local v1023 = v_u_954[p1020.Name]
		if v1023 then
			if v1022 then
				if v1023.blocking == true then
					v1022.handCFrameOffset2 = CFrame.Angles(0.5235987755982988, 0.3490658503988659, -0.3490658503988659)
				else
					v1022.handCFrameOffset2 = CFrame.identity
				end
				local v1024 = workspace.OtherCharacters:FindFirstChild(p1020.Name .. "_FakeCharacter")
				if v1024 then
					local v1025 = v1024:FindFirstChild("Torso")
					if v1025 then
						local v1026 = v1025:FindFirstChild("Left Shoulder")
						local v1027 = v1025:FindFirstChild("Right Shoulder")
						if v1026 and v1027 then
							v1022.sine = v1022.sine + p1021 * 2
							local v1028 = v1022.sine
							local v1029 = math.sin(v1028) * 0.2617993877991494 * 0.1
							local v1030 = v1022.sine
							local v1031 = math.cos(v1030) * 0.2617993877991494 * 0.2 - 0.03490658503988659
							local v1032 = -v1029
							local v1033 = -v1031
							v1026.C0 = CFrame.new(v1026.C0.Position) * CFrame.Angles(v1029, 0, v1031)
							v1027.C0 = CFrame.new(v1027.C0.Position) * CFrame.Angles(v1032, 0, v1033) * v1022.handCFrameOffset * v1022.handCFrameOffset1 * v1022.handCFrameOffset2
						end
					else
						return
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	else
		return
	end
end
local function v_u_1055(p1035, p1036) -- name: updateOtherArmSwingBasedOnVelocity
	-- upvalues: (copy) v_u_955, (ref) v_u_954
	local v1037 = v_u_955[p1035.Name]
	if v1037 then
		local v1038 = v_u_954[p1035.Name]
		if v1038 then
			local v1039 = workspace.OtherCharacters:FindFirstChild(p1035.Name .. "_FakeCharacter")
			if v1039 then
				local v1040 = v1039:FindFirstChild("Torso")
				if v1040 then
					local v1041 = v1040:FindFirstChild("Left Shoulder")
					local v1042 = v1040:FindFirstChild("Right Shoulder")
					if v1041 and v1042 then
						local v1043 = v1038.sprinting and 10.4 or (v1038.crouching and 2 or 8)
						local v1044 = v1038.PLAYER_VELOCITY.X
						local v1045 = v1038.PLAYER_VELOCITY.Z
						local v1046 = Vector3.new(v1044, 0, v1045)
						local v1047 = v1046.Magnitude
						local v1048 = math.clamp(v1047, 0, 17.27)
						local v1049 = v1040.CFrame.LookVector.X
						local v1050 = v1040.CFrame.LookVector.Z
						local v1051 = Vector3.new(v1049, 0, v1050).Unit
						local v1052 = v1048 > 0 and v1046.Unit:Dot(v1051) or 0
						local v1053 = tick() * v1043
						local v1054 = math.sin(v1053) * 0.06981317007977318 * v1048
						if v1052 < 0 then
							v1054 = -v1054
						end
						v1037.currentSwingAmount = v1037.currentSwingAmount + (v1054 - v1037.currentSwingAmount) * 10 * p1036
						v1041.C0 = v1041.C0 * CFrame.Angles(v1037.currentSwingAmount, 0, 0)
						v1042.C0 = v1042.C0 * CFrame.Angles(-v1037.currentSwingAmount, 0, 0)
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	else
		return
	end
end
local function v_u_1084(p1056, p1057, p1058) -- name: updateOtherLegSwingBasedOnVelocity
	-- upvalues: (copy) v_u_955, (ref) v_u_954, (ref) v_u_48, (ref) v_u_49
	local v1059 = v_u_955[p1056.Name]
	if v1059 then
		local v1060 = v_u_954[p1056.Name]
		if v1060 then
			local v1061 = workspace.OtherCharacters:FindFirstChild(p1056.Name .. "_FakeCharacter")
			if v1061 then
				v1061.PlayerHitbox:FindFirstChild("Torso")
				local v1062 = v1061:FindFirstChild("Torso")
				if v1062 then
					local v1063 = v1062:FindFirstChild("Left Hip")
					local v1064 = v1062:FindFirstChild("Right Hip")
					if v1063 and v1064 then
						local v1065 = v1060.crouching
						local v1066 = v1060.sprinting and not v1065 and 10.4 or (v1065 and 2 or 8)
						local v1067 = v1060.sprinting and not v1065 and 0.10471975511965978 or 0.06981317007977318
						local v1068 = v1060.PLAYER_VELOCITY.X
						local v1069 = v1060.PLAYER_VELOCITY.Z
						local v1070 = Vector3.new(v1068, 0, v1069)
						local v1071 = v1070.Magnitude
						local v1072 = math.clamp(v1071, -17.27, 17.27)
						local v1073 = v1062.CFrame.LookVector
						local v1074 = v1073.X
						local v1075 = v1073.Z
						local v1076 = Vector3.new(v1074, 0, v1075).Unit
						local v1077 = v1070.Unit:Dot(v1076)
						local v1078 = tick() * v1066
						local v1079 = math.sin(v1078) * v1067 * v1072
						if v1077 < 0 then
							v1079 = -v1079
						end
						local v1080 = p1058 and 1 or 10 * p1057
						v1059.currentLegSwingAmount = v1059.currentLegSwingAmount + (v1079 - v1059.currentLegSwingAmount) * v1080
						local v1081 = CFrame.new()
						if v1065 then
							v1081 = CFrame.new(0, 0.5, 0) * CFrame.Angles(0.5235987755982988, 0, 0)
						end
						local v1082 = v_u_48 or CFrame.new(-0.468, -1.403, 0)
						local v1083 = v_u_49 or CFrame.new(0.468, -1.403, 0)
						v1063.C0 = v1082 * CFrame.Angles(-v1059.currentLegSwingAmount, 0, 0) * v1081
						v1064.C0 = v1083 * CFrame.Angles(v1059.currentLegSwingAmount, 0, 0) * v1081
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end
	else
		return
	end
end
v_u_7.Heartbeat:Connect(function(p1085)
	-- upvalues: (ref) v_u_934, (ref) v_u_935, (copy) v_u_953, (copy) v_u_1, (ref) v_u_954, (copy) v_u_956, (copy) v_u_990, (copy) v_u_1019, (copy) v_u_1034, (copy) v_u_1055, (copy) v_u_1084
	v_u_934 = v_u_934 + p1085
	while v_u_934 >= 0.05 do
		v_u_934 = v_u_934 - 0.05
		v_u_935 = v_u_935 + 1
		v_u_953()
	end
	for _, v1086 in ipairs(game.Players:GetPlayers()) do
		if v1086 ~= v_u_1 then
			local v1087 = workspace.OtherCharacters:FindFirstChild(v1086.Name .. "_FakeCharacter")
			if v1087 and v1086.Character then
				local v1088 = v1086.Character:GetPivot().Position
				local v1089 = v1087:GetPivot().Position:lerp(v1088, 0.17)
				v1087:PivotTo(CFrame.new(v1089))
				local v1090 = v_u_954[v1086.Name]
				if v1090 then
					local v1091 = v_u_956[v1086.Name]
					local v1092 = v1090.crouching
					if v1087.PlayerEyeLevel:FindFirstChild("Nameplate_Occluded") then
						v1087.PlayerEyeLevel:FindFirstChild("Nameplate_Occluded").Enabled = not v1092
					else
						buildNameDisplay(v1086)
					end
					local v1093, v1094
					if v1091 == nil or v1091 == v1092 then
						v1093 = false
						v1094 = false
					else
						v1093 = v1092
						v1094 = not v1092
					end
					v_u_956[v1086.Name] = v1092
					v_u_990(v1086, p1085, v1093 or v1094)
					v_u_1019(v1086, p1085, v1093 or v1094)
					v_u_1034(v1086, p1085)
					v_u_1055(v1086, p1085)
					v_u_1084(v1086, p1085, v1093 or v1094)
				end
			end
		end
	end
end)
v937.OnClientEvent:Connect(function(p1095)
	-- upvalues: (ref) v_u_15, (ref) v_u_3, (ref) v_u_14, (copy) v_u_870
	local v1096 = p1095.position or v_u_15
	local _ = p1095.ackClientTick
	v_u_15 = v1096
	v_u_3:PivotTo(CFrame.new(v1096))
	v_u_14 = p1095.vel
	local v1097 = v_u_870
	local v1098 = {
		["PLAYER_VELOCITY"] = v_u_14
	}
	table.insert(v1097, v1098)
end)
function getRoughTextWidth(p1099) -- name: getRoughTextWidth
	-- upvalues: (copy) v_u_1
	local v1100 = v_u_1.PlayerGui:WaitForChild("Game"):WaitForChild("GameUI"):WaitForChild("Diagnostic")
	local v1101 = v1100:WaitForChild("Content"):WaitForChild("TextFrame"):WaitForChild("TextContent")
	v1101.Text = p1099
	return v1101.TextBounds.X / v1100.AbsoluteSize.X
end
function buildNameDisplay(p1102) -- name: buildNameDisplay
	local v1103 = workspace.OtherCharacters:FindFirstChild(p1102.Name .. "_FakeCharacter")
	if v1103 then
		local v1104 = v1103.PlayerEyeLevel or v1103:WaitForChild("PlayerEyeLevel")
		local v1105 = v1104:FindFirstChild("Nameplate_Occluded") or game.ReplicatedStorage.Models:WaitForChild("Nameplate_Occluded"):Clone()
		local v1106 = v1104:FindFirstChild("Nameplate_Visible") or game.ReplicatedStorage.Models:WaitForChild("Nameplate_Visible"):Clone()
		v1105.Parent = v1104
		v1106.Parent = v1104
		for _, v1107 in ipairs(v1105.Content:GetChildren()) do
			if not v1107:IsA("UIListLayout") then
				v1107:Destroy()
			end
		end
		for _, v1108 in ipairs(v1106.Content:GetChildren()) do
			if not v1108:IsA("UIListLayout") then
				v1108:Destroy()
			end
		end
		local v1109 = game.ReplicatedStorage.Models.TextElement_Occluded:Clone()
		v1109.TextContent.Text = p1102.Name
		v1109.Name = "Nametag"
		local v1110 = game.ReplicatedStorage.Models.TextElement_Visible:Clone()
		v1110.TextContent.Text = p1102.Name
		v1110.Name = "Nametag"
		local v1111 = getRoughTextWidth(p1102.Name)
		local v1112 = {
			["OWNER"] = Color3.fromHex("FF5555"),
			["MVP+"] = Color3.fromHex("55FFFF"),
			["MVP"] = Color3.fromHex("55FFFF"),
			["VIP"] = Color3.fromHex("55FF55"),
			["None"] = Color3.fromHex("AAAAAA")
		}
		local v1113 = p1102.Data.Rank.Value or "None"
		v1109.Background.Size = UDim2.new(v1111 + 0.01, 0, 1, 0)
		v1109.TextContent.TextColor3 = v1112[v1113]
		v1110.Background.Size = UDim2.new(v1111 + 0.01, 0, 1, 0)
		v1110.TextContent.TextColor3 = v1112[v1113]
		v1109.Parent = v1105.Content
		v1110.Parent = v1106.Content
		local v1114 = p1102.HealthValue.Value / 5
		local v1115 = "\226\153\165 " .. math.ceil(v1114) or "\226\153\165 20"
		local v1116 = p1102.HealthValue.Value / 5
		local v1117 = "<font color=\"rgb(255, 66, 66)\">\226\153\165</font> " .. math.ceil(v1116)
		local v1118 = getRoughTextWidth(v1115)
		local v1119 = v1105.Content:FindFirstChild("Health") or game.ReplicatedStorage.Models.TextElement_Occluded:Clone()
		v1119.TextContent.Text = v1117
		v1119.Name = "Health"
		local v1120 = v1106.Content:FindFirstChild("Health") or game.ReplicatedStorage.Models.TextElement_Visible:Clone()
		v1120.TextContent.Text = v1117
		v1120.Name = "Health"
		v1119.Background.Size = UDim2.new(v1118 + 0.03, 0, 1, 0)
		v1120.Background.Size = UDim2.new(v1118 + 0.03, 0, 1, 0)
		v1119.Parent = v1105.Content
		v1120.Parent = v1106.Content
	end
end
function refreshNameDisplay(p1121) -- name: refreshNameDisplay
	local v1122 = workspace.OtherCharacters:FindFirstChild(p1121.Name .. "_FakeCharacter")
	if v1122 then
		local v1123 = v1122.PlayerEyeLevel or v1122:WaitForChild("PlayerEyeLevel")
		local v1124 = v1123:FindFirstChild("Nameplate_Occluded")
		if v1124 then
			local v1125 = v1123:FindFirstChild("Nameplate_Visible")
			if v1125 then
				local v1126 = getRoughTextWidth(p1121.Name)
				local v1127 = v1124:WaitForChild("Content"):WaitForChild("Nametag")
				local v1128 = v1125:WaitForChild("Content"):WaitForChild("Nametag")
				local v1129 = {
					["OWNER"] = Color3.fromHex("FF5555"),
					["MVP+"] = Color3.fromHex("55FFFF"),
					["MVP"] = Color3.fromHex("55FFFF"),
					["VIP"] = Color3.fromHex("55FF55"),
					["None"] = Color3.fromHex("AAAAAA")
				}
				local v1130 = p1121.Data.Rank.Value or "None"
				v1127.Background.Size = UDim2.new(v1126 + 0.01, 0, 1, 0)
				v1127.TextContent.TextColor3 = v1129[v1130]
				v1128.Background.Size = UDim2.new(v1126 + 0.01, 0, 1, 0)
				v1128.TextContent.TextColor3 = v1129[v1130]
				local v1131 = p1121.HealthValue.Value / 5
				local v1132 = "\226\153\165 " .. math.ceil(v1131) or "\226\153\165 20"
				local v1133 = p1121.HealthValue.Value / 5
				local v1134 = "<font color=\"rgb(255, 66, 66)\">\226\153\165</font> " .. math.ceil(v1133)
				local v1135 = getRoughTextWidth(v1132)
				local v1136 = v1124.Content:FindFirstChild("Health") or game.ReplicatedStorage.Models.TextElement_Occluded:Clone()
				v1136.TextContent.Text = v1134
				v1136.Name = "Health"
				local v1137 = v1125.Content:FindFirstChild("Health") or game.ReplicatedStorage.Models.TextElement_Visible:Clone()
				v1137.TextContent.Text = v1134
				v1137.Name = "Health"
				v1136.Background.Size = UDim2.new(v1135 + 0.03, 0, 1, 0)
				v1137.Background.Size = UDim2.new(v1135 + 0.03, 0, 1, 0)
				v1136.Parent = v1124.Content
				v1137.Parent = v1125.Content
			else
				buildNameDisplay(p1121)
			end
		else
			buildNameDisplay(p1121)
			return
		end
	else
		return
	end
end
local v_u_1138 = v_u_954
local v_u_1139 = v_u_15
local function v_u_1146(p_u_1140) -- name: createPlayer
	-- upvalues: (copy) v_u_1, (copy) v_u_82, (copy) v_u_10, (copy) v_u_955
	if p_u_1140 ~= v_u_1 then
		local v1141 = p_u_1140:WaitForChild("Data"):WaitForChild("SkinTexture").Value
		local v1142 = p_u_1140:WaitForChild("Data"):WaitForChild("EquippedSkin").Value
		local v1143
		if v1142 == 1 then
			v1143 = p_u_1140:WaitForChild("Data"):WaitForChild("Is4px").Value
		else
			v1143 = v_u_82[v1142].Is4px
		end
		local v1144 = game.ReplicatedStorage["StarterCharacter" .. (v1143 and "4x" or "3x")]:Clone()
		v1144.Parent = workspace.OtherCharacters
		v1144.Name = p_u_1140.Name .. "_FakeCharacter"
		for _, v1145 in ipairs(v1144:GetDescendants()) do
			if v1145:IsA("ImageLabel") then
				v1145.Image = v1141
			end
		end
		if not p_u_1140.Character then
			p_u_1140.CharacterAdded:Wait()
		end
		v1144:PivotTo(p_u_1140.Character:GetPivot())
		v1144.PlayerHitbox.SelectionBox.Visible = v_u_10.Preferences.ShowHitboxes
		v1144.PlayerEyeLevel.SelectionBox.Visible = v_u_10.Preferences.ShowHitboxes
		v_u_955[p_u_1140.Name] = {
			["lastTorsoOrientation"] = nil,
			["sine"] = 0,
			["currentSwingAmount"] = 0,
			["currentLegSwingAmount"] = 0,
			["targetLegSwingAmount"] = 0,
			["handAnimConnection"] = nil,
			["handCFrameOffset"] = nil,
			["handCFrameOffset1"] = nil,
			["handCFrameOffset2"] = nil,
			["t"] = nil,
			["lastTorsoOrientation"] = CFrame.Angles(0, 0, 0),
			["handCFrameOffset"] = CFrame.Angles(0, 0, 0),
			["handCFrameOffset1"] = CFrame.Angles(0, 0, 0),
			["handCFrameOffset2"] = CFrame.Angles(0, 0, 0),
			["t"] = os.clock()
		}
		buildNameDisplay(p_u_1140)
		refreshNameDisplay(p_u_1140)
		p_u_1140:WaitForChild("HealthValue"):GetPropertyChangedSignal("Value"):Connect(function()
			-- upvalues: (copy) p_u_1140
			refreshNameDisplay(p_u_1140)
		end)
	end
end
local function v1149(p1147) -- name: destroyPlayer
	-- upvalues: (copy) v_u_1, (copy) v_u_955
	if p1147 ~= v_u_1 then
		local v1148 = workspace.OtherCharacters:FindFirstChild(p1147.Name .. "_FakeCharacter")
		if v1148 then
			v1148:Destroy()
		end
		v_u_955[p1147.Name] = nil
	end
end
for _, v1150 in ipairs(game.Players:GetPlayers()) do
	v_u_1146(v1150)
end
game.ReplicatedStorage.Remotes.ApplySkinToPlayer.OnClientEvent:Connect(function(p1151)
	-- upvalues: (copy) v_u_1, (copy) v_u_955, (copy) v_u_1146, (copy) v_u_90, (ref) v_u_1139
	if p1151 == v_u_1 then
		v_u_90(v_u_1139)
		checkHeld()
	else
		if p1151 ~= v_u_1 then
			local v1152 = workspace.OtherCharacters:FindFirstChild(p1151.Name .. "_FakeCharacter")
			if v1152 then
				v1152:Destroy()
			end
			v_u_955[p1151.Name] = nil
		end
		v_u_1146(p1151)
	end
end)
game.Players.PlayerAdded:Connect(v_u_1146)
game.Players.PlayerRemoving:Connect(v1149)
v938.OnClientEvent:Connect(function(p1153)
	-- upvalues: (ref) v_u_1138
	v_u_1138 = p1153
end)
game.ReplicatedStorage.Remotes.SetCameraOrientation.OnClientEvent:Connect(function(p1154)
	-- upvalues: (copy) v_u_2
	v_u_2.CFrame = p1154
end)
