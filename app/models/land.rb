class Land < ActiveRecord::Base
  belongs_to :user
  has_many :message_bord

  scope :add_select_field, ->(*fields) {
    scope = current_scope || relation
    scope = scope.select(Arel.star) if scope.select_values.blank?
    scope.select(*fields)
  }
 
  default_scope { 
    add_select_field('(SELECT count(*) FROM lands as L2 WHERE L2.money < lands.money) + 1 as rank')
  } 

  before_save {
    self.land       = land.to_s
    self.land_value = land_value.to_s
    self.prize      = prize.to_s
  }
  
  after_find {
    require 'json'
    
    self.land       = JSON.parse(self.land) unless self.land.empty?
    self.land_value = JSON.parse(self.land_value) unless self.land_value.empty?
    self.prize      = JSON.parse(self.prize) unless self.prize.empty?
  }

  after_initialize {
    # 設定の読み込み
    Settings.reload!

    @islandSize = Settings.config.islandSize
    @landform   = Settings.const.landform

    if self.land == nil
      make_new_iland
      estimate
    end
  }
  
  def estimate
    
    kind, val, self.people, self.area, self.farm, self.factory, self.mountain = nil, nil, 0, 0, 0, 0, 0
    area_form = [@landform.sea, @landform.sbase, @landform.oil]
    
    @islandSize.to_i.times do | x |
      @islandSize.to_i.times do | y |
        kind = self.land[x][y]
        val  = self.land_value[x][y]
        
        if !area_form.include?(kind) 
          self.area += 1
          
          case
            when kind == @landform.town
              self.people += val
            when kind == @landform.farm
              self.farm += val
            when kind == @landform.factory
              self.factory += val
            when kind == @landform.mountain
              self.mountain += val
            else
          end
        end
      end
    end
  end

  private

    def make_new_iland
  
      @center = @islandSize / 2 - 1
  
      @ax     = [0, 1, 1, 1, 0,-1, 0, 1, 2, 2, 2, 1, 0,-1,-1,-2,-1,-1, 0]
      @ay     = [0,-1, 0, 1, 1, 0,-1,-2,-1, 0, 1, 2, 2, 2, 1, 0,-1,-2,-2]
      
      form = []
    
      # 海に初期化
      init_land
      # 中央の4*4に荒地を配置
      create_waste
      # 8*8範囲内に陸地を増殖
      add_waste
      # 森を作る
      form.push(@landform.forest)
      crete_parts(form, 4)
      # 町を作る
      form.push(@landform.town)
      crete_parts(form, 2)
      # 山を作る
      form.push(@landform.mountain)
      crete_parts(form, 1, 0)
      # 基地を作る
      form.push(@landform.base)
      crete_parts(form, 1, 0)
  
      self.land       = @land
      self.land_value = @land_value
    end
    
    def count_around(x, y, kind, range) 
      count = 0;
      (0..range).each do | i |
  
        sx = x + @ax[i]
        sy = y + @ay[i]
        if (sy % 2) == 0 && (y % 2) == 1
          sx += 1
        end
  
        if (sx < 0 || sx >= @islandSize || 
           sy < 0 || sy >= @islandSize)
          # 範囲外の場合
          if kind == landform.sea
            # 海なら加算
            count += 1
          end
        else
          # 範囲内の場合
          if (@land[sx][sy] == kind)
            count += 1
          end
        end 
      end
      return count
    end
    
    # 海に初期化
    def init_land
      @land       = Array.new(@islandSize){ Array.new(@islandSize, @landform.sea) }
      @land_value = Array.new(@islandSize){ Array.new(@islandSize, @landform.sea) }
    end
  
    # 中央の4*4に荒地を配置
    def create_waste
      boxes = ((@center-1)..(@center+2)).to_a
      boxes.each do | x |
        boxes.each do | y |
          @land[x][y] = @landform.waste
        end
      end
    end
    
    # 8*8範囲内に陸地を増殖
    def add_waste
      x, y = 0, 0

      120.times do 
        # ランダム座標
      	x = rand(8) + @center - 3
      	y = rand(8) + @center - 3
  
        if (count_around(x, y, @landform.sea, 7) != 7)
          # 周りに陸地がある場合、浅瀬にする
          # 浅瀬は荒地にする
          # 荒地は平地にする
          if (@land[x][y] == @landform.waste) 
            @land[x][y]       = @landform.plains
            @land_value[x][y] = 0
          end
        else
          if (@land_value[x][y] == 1)
            @land[x][y]       = @landform.waste
            @land_value[x][y] = 0
          else
            @land_value[x][y] = 1
    		  end
    		end
      end
    end
  
    # パーツを作る
    def crete_parts(form, num, val = 5) 
      count = 0
      while count < num
        x = rand(4) + @center - 1
        y = rand(4) + @center - 1
        
        unless form.include?(@land[x][y])
          @land[x][y]       = form.last
          @land_value[x][y] = val
          count += 1
        end
      end
    end
end
