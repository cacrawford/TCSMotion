
class MenuTableViewTestController < UIViewController

  attr_reader :menu

  def init
    super.tap do
      @menu = TCS::Menu::MenuTableView.alloc.initWithFrame(CGRectMake(0, 0, 200, 800))
      @menu.delegate = self
      self.view.addSubview(@menu)
    end
  end

end