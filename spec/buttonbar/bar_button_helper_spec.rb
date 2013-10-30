class BBH
  include TCS::BarButtonHelper

end
describe 'BarButtonHelper' do

  before do
    TCS::BarButtonHelper::buttonStyle = UIBarButtonItemStylePlain

    @helper = BBH.new
  end

  it 'should create flexible space' do
    button = @helper.flexibleSpace

    button.should.not.be.nil?
    button.style.should == 0
  end

  it 'should create fixed space' do
    button = @helper.fixedSpace(20)

    button.should.not.be.nil?
    button.style.should == 0
    button.width.should == 20
  end

  it 'should create menu button' do
    button = @helper.menuButton(self, :test)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create menu button with non-default style' do
    button = @helper.menuButton(self, :test, UIBarButtonItemStylePlain)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create custom menu button with flat style' do
    button = @helper.menuButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleFlat)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemFlat).should.be.true?
    button.style.should == 0
    button.target.should.not == self
    button.action.should.not == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create custom menu button with sticky style' do
    button = @helper.menuButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleSticky)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemSticky).should.be.true?
    button.style.should == 0
    button.target.should == self
    button.action.should == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create back button' do
    button = @helper.backButton(self, :test)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create back button with non-default style' do
    button = @helper.backButton(self, :test, UIBarButtonItemStylePlain)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create custom back button with flat style' do
    button = @helper.backButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleFlat)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemFlat).should.be.true?
    button.style.should == 0
    button.target.should.not == self
    button.action.should.not == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create custom back button with sticky style' do
    button = @helper.backButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleSticky)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemSticky).should.be.true?
    button.style.should == 0
    button.target.should == self
    button.action.should == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create left arrow button' do
    button = @helper.leftArrowButton(self, :test)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create left arrow button with non-default style' do
    button = @helper.leftArrowButton(self, :test, UIBarButtonItemStylePlain)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create custom left arrow button with flat style' do
    button = @helper.leftArrowButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleFlat)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemFlat).should.be.true?
    button.style.should == 0
    button.target.should.not == self
    button.action.should.not == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create custom left arrow button with sticky style' do
    button = @helper.leftArrowButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleSticky)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemSticky).should.be.true?
    button.style.should == 0
    button.target.should == self
    button.action.should == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create right arrow button' do
    button = @helper.rightArrowButton(self, :test)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create right arrow button with non-default style' do
    button = @helper.rightArrowButton(self, :test, UIBarButtonItemStylePlain)

    button.should.not.be.nil?
    button.style.should == UIBarButtonItemStylePlain
    button.target.should == self
    button.action.should == :test
    button.customView.should.be.nil?
  end

  it 'should create custom right arrow button with flat style' do
    button = @helper.rightArrowButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleFlat)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemFlat).should.be.true?
    button.style.should == 0
    button.target.should.not == self
    button.action.should.not == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create custom right arrow button with sticky style' do
    button = @helper.rightArrowButton(self, :test, TCS::BarButtonHelper::UIBarButtonItemStyleSticky)

    button.should.not.be.nil?
    button.is_a?(TCS::UIBarButtonItemSticky).should.be.true?
    button.style.should == 0
    button.target.should == self
    button.action.should == :test
    button.customView.should.not.be.nil?
    button.customView.is_a?(UIButton).should.be.true?
  end

  it 'should create title button' do
    button = @helper.titleButton('title', self, :test)

    button.should.not.be.nil?
    button.style.should == 0
    button.target.should == self
    button.action.should == :test
    button.title.should == 'title'
    button.customView.should.be.nil?
  end

  it 'should create title space' do
    button = @helper.titleSpace('Title')

    button.should.not.be.nil?
    button.style.should == 0
    button.customView.should.not.be.nil?
    button.customView.is_a?(UILabel).should.be.true?
    button.customView.text.should == 'Title'
  end

end