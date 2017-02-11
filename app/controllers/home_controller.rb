# -*- coding: utf-8 -*-
# frozen_string_literal: true

class HomeController < ApplicationController
	def index
		render plain: 'welcome'
	end
end
