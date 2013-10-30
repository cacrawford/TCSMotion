describe 'SimpleVerticalGridLayout' do

  before do
    @layout = TCS::SimpleVerticalGridLayout.alloc.initWithCellSize(CGSizeMake(80,80))
    @view = MockCollectionView.alloc.initWithFrame(CGRectMake(0,0,500,500), collectionViewLayout:@layout)
    @layout.collectionView = @view
    @view.addSection(20)
    @layout.prepareLayout
  end

  it 'should scroll vertically' do
    @layout.scrollDirection.should == UICollectionViewScrollDirectionVertical
  end

  it 'should Layout cells in a vertical grid' do

    @layout.num_columns.should == @layout.maxColumnsWithoutScroll
    @layout.num_rows.should == (20 / @layout.maxColumnsWithoutScroll).ceil
  end

end