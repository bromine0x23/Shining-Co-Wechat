# -*- coding: utf-8 -*-
# frozen_string_literal: true

require 'ostruct'

class CalenderService

	CHINESE_DIGIT = '〇一二三四五六七八九'

	CHINESE_WEEK = '日一二三四五六'

	CELESTIAL_STEM  = '甲乙丙丁戊己庚辛壬癸' # 天干

	EARTHLY_BRANCH = '子丑寅卯辰巳午未申酉戌亥' # 地支

	ZODIAC = '鼠牛虎兔龙蛇马羊猴鸡狗猪' # 生肖

	LUNAR_CALENDER_MONTH = %w(正月 二月 三月 四月 五月 六月 七月 八月 九月 十月 冬月 腊月)

	LUNAR_CALENDER_DAY = %w(〇 初一 初二 初三 初四 初五 初六 初七 初八 初九 初十 十一 十二 十三 十四 十五 十六 十七 十八 十九 二十 廿一 廿二 廿三 廿四 廿五 廿六 廿七 廿八 廿九 三十)

	DAY_ACCUMULATION = [0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334].freeze

	MONTH_SIZES = [
		0x00A4B, 0x5164B, 0x006A5, 0x006D4, 0x415B5,
		0x002B6, 0x00957, 0x2092F, 0x00497, 0x60C96,
		0x00D4A, 0x00EA5, 0x50DA9, 0x005AD, 0x002B6,
		0x3126E, 0x0092E, 0x7192D, 0x00C95, 0x00D4A,
		0x61B4A, 0x00B55, 0x0056A, 0x4155B, 0x0025D,
		0x0092D, 0x2192B, 0x00A95, 0x71695, 0x006CA,
		0x00B55, 0x50AB5, 0x004DA, 0x00A5B, 0x30A57,
		0x0052B, 0x8152A, 0x00E95, 0x006AA, 0x615AA,
		0x00AB5, 0x004B6, 0x414AE, 0x00A57, 0x00526,
		0x31D26, 0x00D95, 0x70B55, 0x0056A, 0x0096D,
		0x5095D, 0x004AD, 0x00A4D, 0x41A4D, 0x00D25,
		0x81AA5, 0x00B54, 0x00B6A, 0x612DA, 0x0095B,
		0x0049B, 0x41497, 0x00A4B, 0xA164B, 0x006A5,
		0x006D4, 0x615B4, 0x00AB6, 0x00957, 0x5092F,
		0x00497, 0x0064B, 0x30D4A, 0x00EA5, 0x80D65,
		0x005AC, 0x00AB6, 0x5126D, 0x0092E, 0x00C96,
		0x41A95, 0x00D4A, 0x00DA5, 0x20B55, 0x0056A,
		0x7155B, 0x0025D, 0x0092D, 0x5192B, 0x00A95,
		0x00B4A, 0x416AA, 0x00AD5, 0x90AB5, 0x004BA,
		0x00A5B, 0x60A57, 0x0052B, 0x00A93, 0x40E95
	].freeze

	def format_solar(time)
		format(
			I18n.t('calender.solar'),
			year: time.year,
			month: time.month,
			day: time.day,
			week: time.wday,
			年: format_chinese_number(time.year),
			月: format_chinese_number(time.month),
			日: format_chinese_number(time.day),
			周: CHINESE_WEEK[time.wday],
		)
	end

	def format_lunar(time)
		year, month, day = time.year, time.month, time.day
		total_day = (year - 1921) * 365 + (year - 1921) / 4 + DAY_ACCUMULATION[month] + day - 38 + (year % 4 == 0 && month > 1 ? 1 : 0)

		y, m, t = 0, 0, 0
		while y < 100
			t = m = ((month_size = MONTH_SIZES[y]) < 0x00FFF ? 12 : 13)
			total_day -= 29 + month_size[t -= 1] while t > 0 and total_day > 0
			break unless total_day > 0
			y += 1
		end
		total_day += 29 + MONTH_SIZES[y][t] if total_day <= 0

		year, month, day  = 1921 + y, m - t, total_day

		if t == 12
			door = MONTH_SIZES[y] / 0x10000 + 1
			if month == door
				month = 1 - month
			elsif month > door
				month -= 1
			end
		end

		format(
			I18n.t('calender.lunar'),
			天干: CELESTIAL_STEM[(year-4) % CELESTIAL_STEM.size],
			地支: EARTHLY_BRANCH[(year-4) % EARTHLY_BRANCH.size],
			生肖: ZODIAC[(year-4) % ZODIAC.size],
			月: month < 1 ? "闰#{LUNAR_CALENDER_MONTH[-month-1]}" : LUNAR_CALENDER_MONTH[month-1],
			日: LUNAR_CALENDER_DAY[day],
		)
	end

	private

	def format_chinese_number(number)
		result = String.new
		while number > 0
			digit = CHINESE_DIGIT[number % CHINESE_DIGIT.size]
			result.prepend(digit)
			number /= 10
		end
		result
	end
end