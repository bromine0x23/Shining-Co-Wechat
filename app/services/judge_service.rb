# -*- coding: utf-8 -*-
# frozen_string_literal: true

class JudgeService
	# @param [String] sender
	# @param [String] subject 主语
	# @param [String] predicate 谓语
	# @param [String] negative 否定词
	# @param [String] object 宾语
	# @param [Time] time
	def judge(sender, subject, predicate, negative, object, time = Time.now)
		if subject.blank? || subject == '我'
			subject = '你'
			subject_sum = sender.sum
		else
			subject_sum = subject.sum
		end
		if random_service.pseudo_random(random_service.date_seed(time), (subject_sum ^ predicate.sum ^ object.sum), 11113).odd?
			format(I18n.t('judge.positive'), 主语: subject, 谓语: predicate, 宾语: object)
		else
			format(I18n.t('judge.negative'), 主语: subject, 谓语: predicate, 宾语: object, 否定词: negative)
		end
	end

	private

	def random_service
		@random_service ||= RandomService.new
	end
end