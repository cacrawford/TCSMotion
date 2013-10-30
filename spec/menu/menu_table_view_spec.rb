describe 'MenuTableView' do
  tests MenuTableViewTestController

  before do

    @menuItem1Selected = false
    @menuItem2Selected = false
    @subMenuItem1Selected = false
    @subMenuItem2Selected = false

    self.instance_eval do
      def menuItem1(arguments)
        @menuItem1Selected = true
      end

      def menuItem2(arguments)
        @menuItem2Selected = true
      end

      def subMenuItem1(arguments)
        @subMenuItem1Selected = true
      end

      def subMenuItem2(arguments)
        @subMenuItem2Selected = true
      end
    end

    @menuItems = TCS::Menu::MenuBuilder.new(self) do
      self.add(TCS::Menu::ActionMenuItem.new('menuItem1').withAction(:'menuItem1:'))
      self.add(TCS::Menu::ActionMenuItem.new('menuItem2').withAction(:'menuItem2:'))
      self.add(TCS::Menu::ExpandableMenuItem.new('expandableMenu1')) do
        self.add(TCS::Menu::ActionMenuItem.new('subMenuItem1').withAction(:'subMenuItem1:'))
      end
      self.add(TCS::Menu::ExpandableMenuItem.new('expandableMenu2').withOpened) do
        self.add(TCS::Menu::ActionMenuItem.new('subMenuItem2').withAction(:'subMenuItem2:'))
      end

    end

    controller.menu.setMenuItemAttributes(@menuItems.build)
    controller.menu.reloadData
  end

  it 'should apply table style' do
    controller.menu.defineStyle(:table, {:backgroundColor => UIColor.redColor, :separatorColor => UIColor.purpleColor})

    controller.menu.backgroundColor.should == UIColor.redColor
    controller.menu.separatorColor.should == UIColor.purpleColor
  end

  it 'should call both cell\'s target and selection target when cell selected' do

    @actionCalled = false

    self.instance_eval do
      def itemSelected
        @actionCalled = true
      end
    end

    controller.menu.setTargetWhenSelected(self, :itemSelected)
    controller.menu.selectMenuItem('menuItem1')

    @menuItem1Selected.should.be.true?
    @actionCalled.should.be.true?
  end

  it 'should clear all cells' do
    controller.menu.numMenuItems.should == @menuItems.build.size
    controller.menu.clearCells
    controller.menu.numMenuItems.should == 0
  end

  it 'should create expandable cell closed by default' do
    controller.menu.isMenuItemVisible?('subMenuItem1').should.be.false?
  end

  it 'should expand expandable cell when selected' do
    controller.menu.selectMenuItem('expandableMenu1')
    controller.menu.isMenuItemVisible?('subMenuItem1').should.be.true?
  end

  it 'should create expandable cell as opened when indicated' do
    controller.menu.isMenuItemVisible?('subMenuItem2').should.be.true?
  end

  it 'should close expandable cell when selected' do
    controller.menu.selectMenuItem('expandableMenu2')
    controller.menu.isMenuItemVisible?('subMenuItem2').should.be.false?
  end



end