# -*- coding: utf-8 -*-
# frozen_string_literal: true

class RandomService
	def pseudo_random(seed, index = 11, mod = 11117)
		index.times.reduce(seed) { |x, _i| x * x % mod }
	end

	def date_seed(date, year_rank = 10000, month_rank = 100, day_rank = 1)
		date.year * year_rank + date.month * month_rank + date.day * day_rank
	end
end