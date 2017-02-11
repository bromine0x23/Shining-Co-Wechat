# -*- coding: utf-8 -*-
# frozen_string_literal: true

class FortuneService

	FORTUNE_JUDGE = %w(大凶 凶 凶 凶 末吉 末吉 末吉 末吉 末吉 末吉 半吉 半吉 吉 吉 小吉 小吉 中吉 中吉 大吉 大吉 秀吉 溢出)

	def fortune(sender, time)
		level = random_service.pseudo_random(random_service.date_seed(time, 11111, 111, 1) ^ sender.sum, 11) % 102 - 1
		format(
			I18n.t('fortune.format'),
			公历日期: calender_service.format_solar(time),
			农历日期: calender_service.format_lunar(time),
			sender: sender,
			level: level,
			judge: judge(level),
		)
	end

	private

	def calender_service
		@calender_service ||= CalenderService.new
	end

	def random_service
		@random_service ||= RandomService.new
	end

	def judge(level)
		FORTUNE_JUDGE[level / 5]
	end

	def sender_hash(sender)
		sender.unpack('C*').reduce(:^)
	end
end