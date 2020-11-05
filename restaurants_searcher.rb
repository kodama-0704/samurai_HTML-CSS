require 'net/http'
require 'json'
require "csv"

# 初期設定
KEYID = ENV['GRNB_ACCESS_KEY']
HIT_PER_PAGE = 100
PREF = "PREF13"
FREEWORD_CONDITION = 1
FREEWORD = "渋谷駅"
PARAMS = {"keyid": KEYID, "hit_per_page":HIT_PER_PAGE, "pref":PREF, "freeword_condition":FREEWORD_CONDITION, "freeword":FREEWORD}

def write_data_to_csv(params)

    restaurants = [["名称","住所","営業日","電話番号"]]
    uri = URI.parse("https://api.gnavi.co.jp/RestSearchAPI/v3/")
    uri.query = URI.encode_www_form(PARAMS)  

    json_res = Net::HTTP.get uri
    
    # JSON.load(response)
    response = JSON.load(json_res)
    
    if response.has_key?("error") then
        puts "エラーが発生しました！"
    end
    for restaurant in response["rest"] do
        rest_info = [restaurant["name"], restaurant["address"], restaurant["opentime"], restaurant["tel"]]
        puts rest_info
        restaurants.append(rest_info)
    end
    
    CSV.open("restaurants_list.csv", "w") do |csv|
        restaurants.each do |rest_info|
            csv << rest_info
        end
    end
    return puts restaurants
end

write_data_to_csv(PARAMS)