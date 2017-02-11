# -*- coding: utf-8 -*-
# frozen_string_literal: true

class ApplicationController < ActionController::API

	class << self
		include ActionController::WechatResponder
	end

	include ActionController::Cookies

	# 设置区域
	def set_locale
		I18n.locale = user_locale
		cookies[:locale] = params[:locale] if params[:locale]
	rescue I18n::InvalidLocale
		I18n.locale = I18n.default_locale
	end
	before_action :set_locale

	private

	def user_locale
		params[:locale] || cookies[:locale] || http_head_locale || I18n.default_locale
	end

	def http_head_locale
		http_accept_language.language_region_compatible_from(I18n.available_locales)
	end
end
