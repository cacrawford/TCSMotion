describe 'MenuCell' do
  tests MenuCellTestController

  it 'should initialize with defaults' do
    controller.cell.backgroundColor.should == UIColor.clearColor
    controller.cell.attributes[:indent].should == 0
    controller.cell.styles.should == TCS::Menu::default_menu_styles

    controller.cell.indent.should == TCS::Menu::default_menu_styles[:default][:indent]
    controller.cell.enabled?.should.be.true?
    controller.cell.disabled?.should.be.false?
    controller.cell.selectable?.should.be.false?
    controller.cell.parent?.should.be.false?
    controller.cell.child?.should.be.false?
    controller.cell.highlightable?.should.be.true?
  end

  it 'should accept enabled attribute' do
    controller.cell.attributes = {:enabled => false}

    controller.cell.enabled?.should.be.false?
    controller.cell.disabled?.should.be.true?
  end

  it 'should accept indent attribute' do
    controller.cell.attributes = {:indent => 10}

    controller.cell.indent.should == 10
  end

  it 'should become selectable with delegate & action attributes' do
    controller.cell.attributes = { :delegate => self, :action => :doSomething}

    controller.cell.selectable?.should.be.true?
  end

  it 'should accept parent attribute' do
    controller.cell.attributes = { :parent => true}

    controller.cell.parent?.should.be.true?
  end

  it 'should accept child attribute' do
    controller.cell.attributes = { :child => true}

    controller.cell.child?.should.be.true?
  end

  it 'should not highlight parent cell' do
    controller.cell.attributes = { :parent => true}

    controller.cell.highlightable?.should.be.false?
  end

  it 'should add new style without altering default styles' do
    styles = Hash.new
    styles[:custom] = Hash.new
    styles[:custom][:backgroundColor] = UIColor.redColor

    controller.cell.styles = styles

    [:default,:child,:parent].each do |style|
      controller.cell.styles.include?(style).should.be.true?
      controller.cell.styles[style].should == TCS::Menu::default_menu_styles[style]
    end

    controller.cell.styles.include?(:custom).should.be.true?
    controller.cell.styles[:custom].should == styles[:custom]
  end

  it 'should replace existing style without altering other styles' do
    styles = Hash.new
    styles[:normal] = Hash.new
    styles[:normal][:backgroundColor] = UIColor.redColor

    controller.cell.styles = styles

    [:default,:child,:parent].each do |style|
      controller.cell.styles.include?(style).should.be.true?
      controller.cell.styles[style].should == TCS::Menu::default_menu_styles[style]
    end

    controller.cell.styles.include?(:normal).should.be.true?
    controller.cell.styles[:normal].should == styles[:normal]
  end

  it 'should call action on designated delegate' do
    @didSomething = false
    @sentArguments = false

    self.instance_eval do
      def doSomething(arguments)
        @didSomething = true
        @sentArguments = true if arguments == 'argument'
      end
    end

    controller.cell.attributes = { :delegate => self, :action => :'doSomething:', :arguments => 'argument'}
    controller.cell.performAction
    @didSomething.should.be.true?
    @sentArguments.should.be.true?
  end

  it 'should combine default style with state style' do

    style = controller.cell.getStyle([:default])

    style[:textColor].should == TCS::Menu::default_menu_styles[:default][:normal][:textColor]
    style[:backgroundColor].should == TCS::Menu::default_menu_styles[:default][:backgroundColor]
  end

  it 'should combine default style and state style with parent style' do

    style = controller.cell.getStyle([:disabled,:parent])

    style[:textColor].should == TCS::Menu::default_menu_styles[:default][:disabled][:textColor]
    style[:backgroundColor].should == TCS::Menu::default_menu_styles[:default][:backgroundColor]
  end

  it 'should combine default style and state style with child style' do

    style = controller.cell.getStyle([:highlighted,:child])

    style[:textColor].should == TCS::Menu::default_menu_styles[:child][:textColor]
    style[:backgroundColor].should == TCS::Menu::default_menu_styles[:default][:highlighted][:backgroundColor]
  end

end
