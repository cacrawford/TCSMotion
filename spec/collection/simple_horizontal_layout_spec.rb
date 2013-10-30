describe 'SimpleHorizontalLayout' do

  before do
    @layout = TCS::SimpleHorizontalLayout.alloc.initWithCellSize(CGSizeMake(10,10))
    @view = MockCollectionView.alloc.initWithFrame(CGRectMake(0,0,500,500), collectionViewLayout:@layout)
    @layout.collectionView = @view
    @view.addSection(10)
  end

  it 'should scroll horizontally' do
    @layout.scrollDirection.should == UICollectionViewScrollDirectionHorizontal
  end

  it 'should Layout cells in a horizontal line' do
    @layout.prepareLayout

    xTest = false
    yTest = false

    origins = @layout.getCellXOrigins
    origins.each_with_index do |x, index|
      unless index == origins.size-1
        xTest = (x == origins.at(index+1) - @layout.origin_to_origin_width)
        break unless xTest
      end
    end

    origins = @layout.getCellYOrigins
    origins.each_with_index do |y, index|
      unless index == origins.size-1
        yTest = y >= origins.at(index+1)
        break unless yTest
      end
    end

    xTest.should.be.true?
    yTest.should.be.true?
  end

end