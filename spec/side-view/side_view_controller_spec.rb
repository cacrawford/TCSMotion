describe 'SideViewController - common' do
  tests LeftSideViewTestController

  it 'should hide view by default' do
    controller.sideViewClosed?.should.be.true?
    controller.opened?.should.be.false?
  end

  it 'should show side view when called' do
    controller.showSideView
    controller.sideViewOpened?.should.be.true?
    controller.opened?.should.be.true?
  end

  it 'should hide side view when called' do
    controller.showSideView
    controller.sideViewOpened?.should.be.true?
    wait 0.5 do
      controller.hideSideView
      controller.sideViewOpened?.should.be.false?
    end
  end

  it 'should immediately show on opened=true' do
    controller.opened = true
    controller.sideViewOpened?.should.be.true?
    controller.opened?.should.be.true?
  end

  it 'should immediately hide on opened=false' do
    controller.showSideView
    wait 0.5 do
      controller.opened = false
      controller.sideViewOpened?.should.be.false?
      controller.opened?.should.be.false?
    end
  end

end

describe 'SideViewController - left' do
  tests LeftSideViewTestController

  it 'should display to left' do
    controller.verify_on_left?.should.be.true?
  end

  it 'should open from left' do
    controller.showSideView
    wait 0.5 do
      controller.verify_main_to_left?.should.be.true?
    end
  end
end

describe 'SideViewController - right' do
  tests RightSideViewTestController

  it 'should display to right' do
    controller.verify_on_right?.should.be.true?
  end

  it 'should open from right' do
    controller.showSideView
    wait 0.5 do
      controller.verify_main_to_right?.should.be.true?
    end
  end
end

describe 'SideViewController - top' do
  tests TopSideViewTestController

  it 'should display on top' do
    controller.verify_on_top?.should.be.true?
  end

  it 'should open from top' do
    controller.showSideView
    wait 0.5 do
      controller.verify_main_to_top?.should.be.true?
    end
  end
end

describe 'SideViewController - bottom' do
  tests BottomSideViewTestController

  it 'should display on bottom' do
    controller.verify_on_bottom?.should.be.true?
  end

  it 'should open from bottom' do
    controller.showSideView
    wait 0.5 do
      controller.verify_main_to_bottom?.should.be.true?
    end
  end
end

