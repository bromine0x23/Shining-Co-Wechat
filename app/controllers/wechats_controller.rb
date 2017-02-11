# -*- coding: utf-8 -*-
# frozen_string_literal: true

class WechatsController < ApplicationController
	# For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#rails-responder-controller-dsl
	wechat_responder

	on :text do |request, _content|
		request.reply.text I18n.t('ai.default')
	end

	on :event, with: 'subscribe' do |request|
		request.reply.text I18n.t('message.welcome')
	end

	on :text, with: /help|帮助/ do |request|
		request.reply.text I18n.t('message.help')
	end

	on :event, with: 'fortune' do |request|
		fortune(request)
	end

	on :text, with: '我的运势' do |request|
		fortune(request)
	end

	on :text, with: /\A(?<option0>\S+)还是(?<option1>\S+?)(?:[啦呢啊阿!?！？]*)\Z/ do |request, option0, option1|
		select(request, option0, option1)
	end

	on :text, with: /\A(?<subject>\S*?)(?<predicate>\S+)(?<negative>[不没])\k<predicate>(?<object>\S*?)(?:[啦呢啊阿!?！？]*)\Z/ do |request, subject, predicate, negative, object|
		judge(request, subject, predicate, negative, object)
	end

	private

	def fortune(request)
		time = Time.at(request[:CreateTime].to_i)
		sender = request[:FromUserName]
		# sender = wechat.user(request[:FromUserName])['nickname']
		request.reply.text fortune_service.fortune(sender, time)
	end

	def select(option0, option1)
		time = Time.at(request[:CreateTime].to_i)
		request.reply.text select_service.select(option0, option1, time)
	end

	def judge(request, subject, predicate, negative, object)
		time = Time.at(request[:CreateTime].to_i)
		sender = request[:FromUserName]
		request.reply.text judge_service.judge(sender, subject, predicate, negative, object, time)
	end

	def fortune_service
		@fortune_service ||= FortuneService.new
	end

	def select_service
		@select_service ||= SelectService.new
	end

	def judge_service
		@judge_service ||= JudgeService.new
	end

end
