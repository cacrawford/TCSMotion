describe 'SimpleHorizontalGridLayout' do

  before do
    @layout = TCS::SimpleHorizontalGridLayout.alloc.initWithCellSize(CGSizeMake(80,80))
    @view = MockCollectionView.alloc.initWithFrame(CGRectMake(0,0,500,500), collectionViewLayout:@layout)
    @layout.collectionView = @view
    @view.addSection(20)
    @layout.prepareLayout
  end

  it 'should scroll horizontally' do
    @layout.scrollDirection.should == UICollectionViewScrollDirectionHorizontal
  end

  it 'should Layout cells in a horizontal grid' do

    @layout.num_rows.should == @layout.maxRowsWithoutScroll
    @layout.num_columns.should == (20 / @layout.maxRowsWithoutScroll).ceil
  end

end