describe 'MenuData' do

  it 'should add menu items in order' do
    menu = TCS::Menu::MenuBuilder.new(self) do
      add(TCS::Menu::ActionMenuItem.new('Action1').withAction(:leftArrowSelected))
      add(TCS::Menu::ActionMenuItem.new('Action2').withAction(:rightArrowSelected))
      add(TCS::Menu::ExpandableMenuItem.new('SubMenu1')) do
        add(TCS::Menu::ActionMenuItem.new('SubMenuAction1'))
        add(TCS::Menu::ActionMenuItem.new('SubMenuAction2'))
      end
      add(TCS::Menu::ActionMenuItem.new('Last Menu Item'))
    end

    menuData = menu.build

    menuData.at(0)[:text].should == 'Action1'
    menuData.at(0)[:action].should == :leftArrowSelected
    menuData.at(1)[:text].should == 'Action2'
    menuData.at(1)[:action].should == :rightArrowSelected
    menuData.at(2)[:text].should == 'SubMenu1'
    menuData.at(2)[:parent].should.be.true?
    menuData.at(3)[:text].should == 'SubMenuAction1'
    menuData.at(3)[:child].should.be.true?
    menuData.at(4)[:text].should == 'SubMenuAction2'
    menuData.at(4)[:child].should.be.true?
    menuData.at(5)[:text].should == 'Last Menu Item'
    menuData.at(5)[:child].should.be.false?
  end

  it 'should add multiple levels of submenus' do
    menu = TCS::Menu::MenuBuilder.new(self) do

      add(TCS::Menu::ExpandableMenuItem.new('Level 0')) do
        add(TCS::Menu::ExpandableMenuItem.new('Level 1')) do
          add(TCS::Menu::ExpandableMenuItem.new('Level 2')) do
            add(TCS::Menu::ExpandableMenuItem.new('Level 3')) do
              add(TCS::Menu::ActionMenuItem.new('Clickable item level 3'))
            end
            add(TCS::Menu::ActionMenuItem.new('Clickable item level 2'))
          end
          add(TCS::Menu::ActionMenuItem.new('Clickable item level 1'))
        end
        add(TCS::Menu::ActionMenuItem.new('Clickable item level 0'))
      end
      add(TCS::Menu::ActionMenuItem.new('Clickable item root'))
    end

    menuData = menu.build


    menuData.at(0)[:text].should == 'Level 0'
    menuData.at(0)[:parent].should.be.true?
    menuData.at(0)[:child].should.be.false?
    menuData.at(1)[:text].should == 'Level 1'
    menuData.at(1)[:parent].should.be.true?
    menuData.at(1)[:child].should.be.true?
    menuData.at(2)[:text].should == 'Level 2'
    menuData.at(2)[:parent].should.be.true?
    menuData.at(2)[:child].should.be.true?
    menuData.at(3)[:text].should == 'Level 3'
    menuData.at(3)[:parent].should.be.true?
    menuData.at(3)[:child].should.be.true?
    menuData.at(4)[:text].should == 'Clickable item level 3'
    menuData.at(4)[:parent].should.be.false?
    menuData.at(4)[:child].should.be.true?
    menuData.at(5)[:text].should == 'Clickable item level 2'
    menuData.at(5)[:parent].should.be.false?
    menuData.at(5)[:child].should.be.true?
    menuData.at(6)[:text].should == 'Clickable item level 1'
    menuData.at(6)[:parent].should.be.false?
    menuData.at(6)[:child].should.be.true?
    menuData.at(7)[:text].should == 'Clickable item level 0'
    menuData.at(7)[:parent].should.be.false?
    menuData.at(7)[:child].should.be.true?
    menuData.at(8)[:text].should == 'Clickable item root'
    menuData.at(8)[:parent].should.be.false?
    menuData.at(8)[:child].should.be.false?

  end
end