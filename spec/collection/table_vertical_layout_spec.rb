describe 'TableVerticalLayout' do

  before do
    @layout = TCS::TableVerticalLayout.alloc.initWithHeight(10)
    @view = MockCollectionView.alloc.initWithFrame(CGRectMake(0,0,500,500), collectionViewLayout:@layout)
    @layout.collectionView = @view
    @view.addSection(10)
    @layout.prepareLayout
  end

  it 'should scroll vertically' do
    @layout.scrollDirection.should == UICollectionViewScrollDirectionVertical
  end

  it 'should layout cells in a vertical line' do
    xTest = false
    yTest = false

    origins = @layout.getCellXOrigins
    origins.each_with_index do |x, index|
      unless index == origins.size-1
        xTest = x >= origins.at(index+1)
        break unless xTest
      end
    end

    origins = @layout.getCellYOrigins
    origins.each_with_index do |y, index|
      unless index == origins.size-1
        yTest = (y == origins.at(index+1) - @layout.origin_to_origin_height)
        break unless yTest
      end
    end

    xTest.should.be.true?
    yTest.should.be.true?
  end

  it 'should make cell width to content width' do
    expected_width = 500 - TCS::TableVerticalLayout::WIDTH_ADJUSTMENT
    origins = @layout.getCellWidths
    origins.each do |width|
      width.should == expected_width
    end
  end

end