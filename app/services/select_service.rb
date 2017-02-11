# -*- coding: utf-8 -*-
# frozen_string_literal: true

class SelectService

	# @param [String] option0 选项一
	# @param [String] option1 选项二
	def select(option0, option1, time = Time.now)
		if option0.upcase == option1.upcase
			I18n.t('select.same')
		else
			option0_sum, option1_sum = option0.sum, option1.sum
			seed = random_service.date_seed(time)
			sample, index =
				if option0_sum < option1_sum
					[[option0, option1], option1_sum - option0_sum]
				else
					[[option1, option0], option0_sum - option1_sum]
				end
			sample[random_service.pseudo_random(seed, index, 11113) & 1]
		end
	end

	private

	def random_service
		@random_service ||= RandomService.new
	end
end