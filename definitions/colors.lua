local c = function(t)
	return setmetatable(t, {__call = function(self, a) return self[1], self[2], self[3], a end})
end

colors = {
	black = c{0, 0, 0},
	white = c{1, 1, 1},
	gray_mid = c{.5,.5,.5},
	pink29 = c{29/32, 1/2, 29/32},
	automata = {
		yellow = c{1, 1, 91/128, 1},
		green = c{91/128, 1, 91/128, 1},
		blue = c{91/128, 91/128, 1, 1},
		red = c{1, 91/128, 91/128, 1},
		off = c{.5, .5, .5, 1},
	},
	area = {
		on = {61/64, 61/64, 61/64, 1},
		off = {1/8, 1/8, 1/8, 1},
	},
	enemy = {
		hit_red = {15/16, 91/128, 91/128, 1}
	}
}