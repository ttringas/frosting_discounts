# http://forums.shopify.com/categories/6/posts/42926
# This is a fairly simple mechanize script to create a few hundred or so shopify discounts from a CSV of groupon codes.
# You'll want to change all of the "changeme" values to your own.
# The script expects there to be a groupon_codes.csv in the same directory.
#
# The groupons_code.csv should look like this:
# 8m7677
# 8m6749
# 8m5398
# 8m7699
# 8m8885
# 8m788
# etc.

require 'rubygems'
require 'date'
require 'mechanize'
require 'csv'

BASE_URL = 'https://frostingsva.myshopify.com/admin'
LOGIN_PATH = '/auth/login'

USER = 'tyler@tylertringas.com'
PASSWORD = 'MMl25xle'
DISCOUNT = "1"

@agent = Mechanize.new
@groupon_codes = []

def login
  page = @agent.get(BASE_URL + LOGIN_PATH)
  form = page.forms.first
  form.login = USER
  form.password = PASSWORD
  @agent.submit(page.forms.first)
end

def load_codes
  @groupon_codes = CSV.read("discount_codes.csv").flatten
end

def create_discount(page, code, discount, note)
  puts "Create discount for code: #{code}..."
  # You may want to have some error handling in case you have connection issues. Worked fine for me with 500+ codes though.
  page.form_with(:action => "#{BASE_URL}/discounts") do |f|
    f['discount[code]'] = code
    f['discount[ends_at]'] = (Date.today + 1).strftime("%Y-%-m-%d")
    # f["discount[usage_limit]"] = '1'
  
    # Set both the visible and hidden textfield to ensure the value gets sent
    discount_value_fields = f.fields_with(:id => 'discount_value')
    discount_value_fields.each do |textfield|
      textfield.value = discount
    end
  end.click_button
end

# load_codes
login

@agent.get(BASE_URL + '/marketing') do |page|
  CSV.open("discount_codes.csv", 'r') do |row|
    code = row[0]
    discount = row[1]
    note = row[2]
    create_discount(page, code, discount, note)
  end
end