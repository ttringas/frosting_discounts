desc "Update the discount codes"
task :update_discounts => :environment do

    DISCOUNTS = [
    {code: "8m7677", amount:  0.50, greater_than: "6"},
    {code: "8m6749", amount:  4.00, greater_than: "12"},
    {code: "8m5398", amount:  4.50, greater_than: "18"},
    {code: "8m7699", amount:  8.00, greater_than: "24"},
    {code: "8m8885", amount:  8.50, greater_than: "30"},
    {code: "8m788", amount:   12.00, greater_than: "36"},
    {code: "8m788", amount:   12.50, greater_than: "42"},
    {code: "8m788", amount:   16.00, greater_than: "48"},
    {code: "8m788", amount:   16.50, greater_than: "54"},
    {code: "8m788", amount:   20.00, greater_than: "60"}
  ]

  BASE_URL = 'https://frostingsva.myshopify.com/admin'
  LOGIN_PATH = '/auth/login'

  USER = 'tyler@tylertringas.com'
  PASSWORD = 'MMl25xle'

      Discount.destroy_all

    new_codes = []
    
    DISCOUNTS.each do |d|
      @code = (0...8).map{65.+(rand(25)).chr}.join
      @discount = Discount.new
      @discount.attributes = {
        code: @code,
        value: d[:amount],
        expiration: Date.today + 2,
        greater_than: d[:greater_than]
      }
      @discount.save
      new_codes << @discount
    end

    @agent = Mechanize.new

    @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    page = @agent.get(BASE_URL + LOGIN_PATH)
    form = page.forms.first
    form.login = USER
    form.password = PASSWORD
    @agent.submit(page.forms.first)

    @agent.get(BASE_URL + '/marketing') do |page|
      new_codes.each do |c|
        page.form_with(:action => "#{BASE_URL}/discounts") do |f|
          f["discount[code]"] = c.code
          f["discount[ends_at]"] = (Date.today + 1).strftime("%Y-%-m-%-d")
          discount_value_fields = f.fields_with(:id => 'discount_value')
          discount_value_fields.each do |textfield|
            textfield.value = c.value
          end
        end.click_button        
      end
    end

end