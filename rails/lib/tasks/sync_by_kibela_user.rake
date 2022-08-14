namespace :sync_by_kibela_user do
  desc "sync by kibela user"
  SYNC_USER_HASH = [
    { docbase_name: "鵜殿", kibela_name: "w-udono" },
    { docbase_name: "線", kibela_name: "sentium" },
    { docbase_name: "吉貝", kibela_name: "c_yoshikai" },
    { docbase_name: "上ノ山慎哉", kibela_name: "uenoyama" },
    { docbase_name: "ootsuka", kibela_name: "ootsuka" },
    { docbase_name: "林(Jay)", kibela_name: "i-hayashi" },
    { docbase_name: "nishitani", kibela_name: "t-nishitani" },
    { docbase_name: "わたなべ", kibela_name: "k-watanabe" },
    { docbase_name: "谷岡なつみ", kibela_name: "n-tanioka" },
    { docbase_name: "勝又礼佳", kibela_name: "a-katsumata" },
    { docbase_name: "景利", kibela_name: "kagetoshi" },
    { docbase_name: "國崎優香", kibela_name: "y-kunisaki" },
    { docbase_name: "小松義尊", kibela_name: "y-komatsu" },
    { docbase_name: "コイケ", kibela_name: "koike" },
    { docbase_name: "神山大智", kibela_name: "d-kamiyama" },
    { docbase_name: "中西佐耶香", kibela_name: "s-nakanishi" },
    { docbase_name: "宮﨑", kibela_name: "k-miyazaki" },
    { docbase_name: "山下祐輝", kibela_name: "y-yamashita"},
    { docbase_name: "しいくま", kibela_name: "k-shiikuma" },
    { docbase_name: "横岸澤", kibela_name: "t-yokogishizawa" },
    { docbase_name: "金城", kibela_name: "y-kinjo" },
    { docbase_name: "三宅哲子", kibela_name: "t-miyake_a24156aaf3" },
    { docbase_name: "合田加奈", kibela_name: "k-gouda_d12ef0b029" },
    { docbase_name: "高松宗一郎", kibela_name: "s-takamatsu" },
    { docbase_name: "吉田美紀", kibela_name: "m-yoshida" },
    { docbase_name: "内山廉太", kibela_name: "r-uchiyama" },
    { docbase_name: "高橋", kibela_name: "h-takahashi" },
    { docbase_name: "三浦紗耶加", kibela_name: "s-miura" },
    { docbase_name: "m-kikkawa", kibela_name: "dummy-user" },
    { docbase_name: "東郷早瑛", kibela_name: "dummy-user" },
    { docbase_name: "asahi", kibela_name: "dummy-user" },
    { docbase_name: "竹内章裕", kibela_name: "a-takeuchi" },
    { docbase_name: "秋本るな", kibela_name: "r-akimoto" },
    { docbase_name: "平田匠", kibela_name: "dummy-user" },
    { docbase_name: "Yano", kibela_name: "yano" },
    { docbase_name: "豊島颯太", kibela_name: "dummy-user" },
    { docbase_name: "五十川侑汰", kibela_name: "y-isogawa" },
    { docbase_name: "平口叶太", kibela_name: "k-hiraguchi" },
    { docbase_name: "清水伸枝", kibela_name: "n-shimizu" },
    { docbase_name: "原田隆司", kibela_name: "dummy-user" },
    { docbase_name: "阪本美紗", kibela_name: "m-sakamoto" },
    { docbase_name: "中村彩太", kibela_name: "a-nakamura" },
    { docbase_name: "露嵜", kibela_name: "tsuyuzaki" },
    { docbase_name: "かわのみゆう", kibela_name: "m-kawano" },
    { docbase_name: "樋浦七奈", kibela_name: "dummy-user" },
    { docbase_name: "松島祐也", kibela_name: "dummy-user" },
    { docbase_name: "星野　宮穂", kibela_name: "m-hoshino" },
    { docbase_name: "三好", kibela_name: "miyoshi" },
    { docbase_name: "加藤翔子", kibela_name: "s-kato" },
    { docbase_name: "Sho_Ito", kibela_name: "s-ito" },
    { docbase_name: "湊", kibela_name: "dummy-user" },
    { docbase_name: "梶原亘平", kibela_name: "k-kajiwara" },
    { docbase_name: "小山菜々", kibela_name: "n-koyama" },
    { docbase_name: "福田佑介", kibela_name: "y-fukuda" },
    { docbase_name: "新井裕", kibela_name: "y-arai" },
    { docbase_name: "sena", kibela_name: "dummy-user" },
    { docbase_name: "秋元友一", kibela_name: "y-akimoto" },
    { docbase_name: "大須賀", kibela_name: "k-ohsuka" },
    { docbase_name: "萩原", kibela_name: "t-hagiwara" },
    { docbase_name: "世田稜", kibela_name: "r-seda" },
    { docbase_name: "米谷源太", kibela_name: "g-yoneya" },
    { docbase_name: "西村愛莉", kibela_name: "a-nishimura" }
  ]
  failures = []
  task :execute => :environment do
    adapter = ::Kibela::Adapter.new
    responses = adapter.get_users
    responses.data.users.nodes.each do |node|
      hash = USER_HASH.select{ |hash| hash[:kibela_name] == node.account }
      if hash.present?
        # N+1許容
        user = User.find_by(docbase_name: hash[0][:docbase_name])
        user.update(kibela_id: node.id)
      end
    end
    # dummy_userを一律登録
    User.where(kibela_id: nil).update_all(kibela_id: "VXNlci82NjE")
  rescue => e
    failures << { error: "#{e.class}: #{e.message}" }
  end
end
