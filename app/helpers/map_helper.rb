module MapHelper
  def land_string (l, lv, x, y, mode, common_string = "")
    Settings.reload!
    
    landform = Settings.const.landform

    case
      when l == landform.sea
        if lv == 1
          # 浅瀬
          image = 'land14.gif'
          alt   = '海（浅瀬）'
        else
          # 海
          image = 'land0.gif'
          alt   = '海'
        end
      when l == landform.waste
        # 荒地
        # 着弾点
        image = lv == 1? 'land13.gif': 'land1.gif'
        alt   = '荒地'
      when l == landform.plains
      	# 平地
      	image = 'land2.gif'
      	alt   = '平地'        
      when l == landform.forest
        # 森
      	# 観光者の場合は木の本数隠す
      	image = 'land6.gif'
      	alt   = "森" << mode == 1? t("defaults.unit.tree", num: lv): ""
      when l == landform.town
    		# 町
    		if lv < 30 
    			num  = 3
    			name = '村'
    		elsif lv < 100
    			num  = 4
    			name = '町'
    		else
    			num  = 5
    			name = '都市'
    		end
    
    		image = "land#{num}.gif"
    		alt   = t("defaults.unit.people", num: lv)
    		alt   = "#{name}(#{alt})"
      when l == landform.farm
      	# 農場
      	image = 'land7.gif'
      	alt   = t("defaults.unit.people", num: lv + '0')
      	alt   = "農場(#{alt}規模)"
      when l == landform.factory
      	# 工場
      	image = 'land8.gif'
      	alt   = t("defaults.unit.people", num: lv + '0')
      	alt   = "工場(#{alt}規模)"
      when l == landform.base
    		if mode == 0
    			# 観光者の場合は森のふり
    			image = 'land6.gif'
    			alt   = '森'
    	  else 
    			# ミサイル基地
    			level = exp_to_level(l, lv)
    			image = 'land9.gif'
    			alt   = "ミサイル基地 (レベル #{level}/経験値 #{lv})"
    		end
      when l == landform.sbase
    		# 海底基地
    		if mode == 0
    			# 観光者の場合は海のふり
    			image = 'land0.gif'
    			alt = '海'
    		else 
    			level = exp_to_level(l, lv)
    			image = 'land12.gif'
    		  alt   = "海底基地 (レベル #{level}/経験値 #{lv})"
    		end
      when l == landform.defence
		    # 防衛施設
    		image = 'land10.gif'
    		alt   = '防衛施設'
      when l == landform.haribote
    		# ハリボテ
  			# 観光者の場合は防衛施設のふり
    		image = 'land10.gif'
  			alt   = mode == 0? '防衛施設': 'ハリボテ'
      when l == landform.oil
    		# 海底油田
    		image = 'land16.gif'
    		alt   = '海底油田'
      when l == landform.mountain
    		# 山
    		if lv > 0
    			image = 'land15.gif'
        	alt   = t("defaults.unit.people", num: lv + '0')
    			alt   = "山(採掘場#{alt}規模)"
    		else
    			image = 'land11.gif'
    			alt   = '山'
  			end
      when l == landform.monument
    		# 記念碑
    		image = Settings.monument.image[lv]
    		alt   = Settings.monument.name[lv]
      when l == landform.monster
    		# 怪獣
    		kind, name, hp = monster_spec(lv)
    		special = Settings.monster.special[kind]
    		image   = Settings.monster.image[kind]
    
    		# 硬化中?
    		if ((special == 3) && ((islandTurn % 2) == 1)) ||
    		   ((special == 4) && ((islandTurn % 2) == 0))
    			# 硬化中
    			image = Settings.monster.image2[kind]
    		end
    		
    		alt = "怪獣#{name}(体力#{hp})"        
    end
    
    img = image_tag(image, size: '32x32', alt: alt)
    
    return mode == 1? "<a href=\"javascript:void(0)\" onclick=\"ps(#{x},#{y})\">#{img}</a>": img
  end
  
  def exp_to_level (kind, expire)
    if kind == Settings.const.landform.base
    	# ミサイル基地
    	Settings.maxim.baseLevel.to_i.downto(1) do | i |
  	    if expire >= Settings.maxim.baseLevelUp[(i-2)]
      		return i
  	    end
    	  return 1
    	end
    else
    	# 海底基地
    	Settings.maxim.sBaseLevel.to_i.downto(1) do | i |
  	    if expire >= Settings.maxim.sBaseLevelUp[(i-2)]
      		return i
        end
  	    return 1
  	  end
    end
  end
  
  def monster_spec(lv)
    # 種類
    kind = lv / 10

    # 名前
    name = Settings.monster.name[kind];

    # 体力
    hp = lv - kind * 10;
    
    return [kind, name, hp];
  end
end