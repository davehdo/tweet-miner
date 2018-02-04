class ExchangeRate < ApplicationRecord
  def parsed
    self.full_json.present? ? JSON.parse(self.full_json) : nil
  end
  
  def price_of( symbol )
    self.parsed and self.parsed["rates"] and self.parsed["rates"][symbol] ? (1.0 / self.parsed["rates"][symbol].to_f ): nil
  end
  
  
  def self.recent( relative_to=Time.now, expires_in=10.minutes )
    # TODO: index exchangerate by created_at
    latest = where("created_at <= ? AND created_at >= ?", relative_to, relative_to - expires_in).order("created_at desc").limit(1).first
    if latest 
      puts "there is a recent exchange rate"
      latest
    else
      nil
    end
  end
  
  # this is used by rake task to fetch quotes but not more than needed
  def self.recent_or_fetch
    # refetch if 10 minutes old
    recent( Time.now, 10.minutes) || fetch_and_store
  end
  
  
  def self.recent_price_of( symbol, relative_to=Time.now, expires_in=10.minutes )
    if symbol.present?
      p = recent( relative_to, expires_in )
      q = p ? p.price_of( symbol ) : nil
      q ? q.round(3) : nil
    else
      nil
    end
  end
  
  
  def self.fetch_and_store
    puts "fetching exchange rates"
    
    
    require 'net/http'

    # uri = URI.parse("https://api.twitter.com/1/statuses/user_timeline.json")
    uri = URI.parse('https://min-api.cryptocompare.com/data/price')
    args = {fsym: "USD", tsyms: "BTC,ETH,BCH,XRP,TRX,LTC,EOS,WTC,XLM,OMG,DASH,BNB,XMR,NEO,VEN,ETC,ZEC,HSR,IOT,ICX,ADA,XEM", extraParams: "cryptocurrency-tracking"}
    uri.query = URI.encode_www_form(args)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    # {"BTC":0.00008681,"ETH":0.0009005,"EUR":0.8}
    puts response.body
    
    parsed = JSON.parse( response.body )
    
        #
    # ["COINBASE_API_PASSWORD", "COINBASE_API_KEY"].each do |e|
    #   raise "Env variable #{e} not defined" if ENV[e].blank?
    # end
    #
    # require 'coinbase/wallet'
    # client = Coinbase::Wallet::Client.new(api_key: ENV["COINBASE_API_KEY"], api_secret: ENV["COINBASE_API_PASSWORD"])
     # , api_secret: <api secret>
     # By default, each API key or app is rate limited at 10,000 requests per hour. 
     # format looks like this:
     
     # {"currency"=>"USD", "rates"=>{"AED"=>"3.67", "AFN"=>"69.50", "ALL"=>"107.45", "AMD"=>"480.25", "ANG"=>"1.78", "AOA"=>"184.38", "ARS"=>"19.55", "AUD"=>"1.23", "AWG"=>"1.79", "AZN"=>"1.69", "BAM"=>"1.57", "BBD"=>"2.00", "BCH"=>"0.00061490", "BDT"=>"83.28", "BGN"=>"1.57", "BHD"=>"0.377", "BIF"=>"1771", "BMD"=>"1.00", "BND"=>"1.31", "BOB"=>"6.91", "BRL"=>"3.15", "BSD"=>"1.00", "BTC"=>"0.00008800", "BTN"=>"63.52", "BWP"=>"9.55", "BYN"=>"1.97", "BYR"=>"19718", "BZD"=>"2.01", "CAD"=>"1.23", "CDF"=>"1595.00", "CHF"=>"0.93", "CLF"=>"0.0228", "CLP"=>"603", "CNH"=>"6.33", "CNY"=>"6.32", "COP"=>"2814.00", "CRC"=>"568.54", "CUC"=>"1.00", "CVE"=>"89.10", "CZK"=>"20.34", "DJF"=>"178", "DKK"=>"5.99", "DOP"=>"48.48", "DZD"=>"113.50", "EEK"=>"14.61", "EGP"=>"17.68", "ERN"=>"15.26", "ETB"=>"27.56", "ETH"=>"0.00092065", "EUR"=>"0.80", "FJD"=>"2.01", "FKP"=>"0.71", "GBP"=>"0.71", "GEL"=>"2.53", "GGP"=>"0.71", "GHS"=>"4.54", "GIP"=>"0.71", "GMD"=>"48.67", "GNF"=>"9000", "GTQ"=>"7.35", "GYD"=>"207.55", "HKD"=>"7.82", "HNL"=>"23.58", "HRK"=>"5.97", "HTG"=>"64.10", "HUF"=>"249", "IDR"=>"13359.80", "ILS"=>"3.39", "IMP"=>"0.71", "INR"=>"63.60", "IQD"=>"1183.000", "ISK"=>"100", "JEP"=>"0.71", "JMD"=>"124.47", "JOD"=>"0.710", "JPY"=>"109", "KES"=>"102.32", "KGS"=>"68.79", "KHR"=>"4017.50", "KMF"=>"396", "KRW"=>"1065", "KWD"=>"0.300", "KYD"=>"0.83", "KZT"=>"321.24", "LAK"=>"8310.00", "LBP"=>"1511.00", "LKR"=>"153.71", "LRD"=>"128.02", "LSL"=>"11.86", "LTC"=>"0.00556282", "LTL"=>"3.22", "LVL"=>"0.66", "LYD"=>"1.325", "MAD"=>"9.14", "MDL"=>"16.72", "MGA"=>"3205.0", "MKD"=>"49.57", "MMK"=>"1332.30", "MNT"=>"2419.67", "MOP"=>"8.05", "MRO"=>"355.3", "MTL"=>"0.68", "MUR"=>"32.31", "MVR"=>"15.40", "MWK"=>"725.82", "MXN"=>"18.48", "MYR"=>"3.87", "MZN"=>"59.00", "NAD"=>"11.86", "NGN"=>"360.00", "NIO"=>"31.06", "NOK"=>"7.69", "NPR"=>"101.64", "NZD"=>"1.36", "OMR"=>"0.385", "PAB"=>"1.00", "PEN"=>"3.21", "PGK"=>"3.21", "PHP"=>"50.98", "PKR"=>"110.55", "PLN"=>"3.32", "PYG"=>"5665", "QAR"=>"3.64", "RON"=>"3.76", "RSD"=>"95.49", "RUB"=>"56.24", "RWF"=>"846", "SAR"=>"3.75", "SBD"=>"7.75", "SCR"=>"13.78", "SEK"=>"7.87", "SGD"=>"1.31", "SHP"=>"0.71", "SLL"=>"7663.97", "SOS"=>"582.50", "SRD"=>"7.47", "SSP"=>"130.26", "STD"=>"20049.04", "SVC"=>"8.75", "SZL"=>"11.86", "THB"=>"31.32", "TJS"=>"8.82", "TMT"=>"3.51", "TND"=>"2.401", "TOP"=>"2.24", "TRY"=>"3.75", "TTD"=>"6.73", "TWD"=>"29.13", "TZS"=>"2251.45", "UAH"=>"28.93", "UGX"=>"3632", "USD"=>"1.00", "UYU"=>"28.31", "UZS"=>"8165.00", "VEF"=>"10.48", "VND"=>"22710", "VUV"=>"105", "WST"=>"2.51", "XAF"=>"528", "XAG"=>"0", "XAU"=>"0", "XCD"=>"2.70", "XDR"=>"1", "XOF"=>"528", "XPD"=>"0", "XPF"=>"96", "XPT"=>"0", "YER"=>"250.30", "ZAR"=>"11.86", "ZMK"=>"5253.08", "ZMW"=>"9.70", "ZWL"=>"322.36"}}
     

     
     
     # a = create( full_json: client.exchange_rates.to_json)
     a = create( full_json: {"currency"=>"USD", "rates"=> parsed}.to_json)
     puts "  success"
     a
  end
  
end
