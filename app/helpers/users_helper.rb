module UsersHelper
  def about_Money(money, owner)
    message = '';
    if owner || Settings.config.hideMoneyMode == 1
      message = t('defaults.unit.money', num:money)
    elsif Settings.config.hideMoneyMode == 2
      if money < 500
        message = t('defaults.unit.about_under')
      else
        money = (money + 500) / 1000;
        message = t('defaults.unit.about_over', num: money)
      end
    end
  end
  
  def command_select
    Settings.reload!
    tmp = []
    
    Settings.command.options.each do | key, value |
      if value.cost == 0
        cost = t('defaults.free')
      elsif value.cost < 0
        cost = t('defaults.unit.food', num:value.cost * -1)
      else
        cost = t('defaults.unit.money', num:value.cost)
      end
      tmp.push([value.name + '(' + cost + ')', key])
    end

    return tmp
  end
end
