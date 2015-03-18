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
end
