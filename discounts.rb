require 'rubygems'
require 'date'
require 'mechanize'
BASE = 'http://frostingsva.myshopify.com/admin'
LOGIN = '/auth/login'
USER = 'tyler@tylertringas.com'
PWD = 'MMl25xle'
agent = Mechanize.new
page = agent.get(BASE+LOGIN)
form = page.forms.first
form.login = USER
form.password = PWD
agent.submit(page.forms.first)
codes = %w(COW-0 COW-1 COW-2 COW-3 COW-4 COW-5)  # make a million codes if you dare
page = agent.get(BASE+'/marketing')
form = page.forms.each {|e| e['id'] == 'new-code-form'}
form = page.forms.first
codes.each do |code|
  form["discount[code]"] = code
  form["discount[value]"] = '1'
  form["discount[starts_at]"] = Date.today.strftime('%F')
  form["discount[ends_at]"] = Date.today.+(10).strftime('%F')
  form["discount[minimum_order_amount]"] = '0.0'
  form["discount[usage_limit]"] = '1'
  form["type"] = 'percentage'
  form["commit"] = 'Create Discount'
  r = agent.submit(page.forms.first)
  pp r
end