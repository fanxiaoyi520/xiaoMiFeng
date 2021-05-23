//
//  XMFGoodsDeletedPageView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/12/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDeletedPageView.h"
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFHomeAllGoodsCell.h"//首页推荐cell
#import "XMFHomeGoodsCellModel.h"//商品cell的model


//在.m文件中添加
@interface  XMFGoodsDeletedPageView()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout,XMFHomeAllGoodsCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


//布局
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;

@end


@implementation XMFGoodsDeletedPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    

    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //    self.flowLayout.headerHeight = 15;
    //    self.flowLayout.footerHeight = 10;
    self.flowLayout.minimumColumnSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.columnCount = 2;
    
    self.myCollectionView.collectionViewLayout = self.flowLayout;
    
    self.myCollectionView.backgroundColor = UIColorFromRGB(0xF3F3F5);
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeAllGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class])];
    
    self.myCollectionView.scrollEnabled = NO;
    
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {


    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsDeletedPageViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFGoodsDeletedPageViewDidClick:self button:sender];
    }

}




//显示在整个界面上

-(void)showOnView:(UIView *)view{
    
    
    CATransition *applicationLoadViewIn =[CATransition animation];
    
    [applicationLoadViewIn setDuration:0.5];
    
    [applicationLoadViewIn setType:kCATransitionFade];
    
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    //you view need to replace
    
    [[view layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    
    self.frame = view.frame;
    
    [view addSubview:self];
    
    
    /*
    [UIView animateWithDuration:0.5 animations:^{
        


    } completion:^(BOOL finished) {
        

        self.frame = view.frame;
        [view addSubview:self];
        
    }];
     */
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self removeFromSuperview];

        
    } completion:^(BOOL finished) {
        
        
    }];
    
}


-(void)setDataSourceArr:(NSMutableArray<XMFHomeGoodsCellModel *> *)dataSourceArr{

    _dataSourceArr = dataSourceArr;
    
    self.myCollectionViewHeight.constant = ceilf(dataSourceArr.count/2)*(1.44 *(KScreenW /2.0) + 10);
    
    [self.myCollectionView reloadData];
    
}


#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFHomeAllGoodsCell *allGoodsCell = (XMFHomeAllGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class]) forIndexPath:indexPath];
    
    allGoodsCell.recommendModel = self.dataSourceArr[indexPath.item];
    
    allGoodsCell.cellItem = indexPath.item;
    
    allGoodsCell.delegate = self;
    
    
    return allGoodsCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
    
    
    XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
    
    if ([self.delegate respondsToSelector:@selector(cellOnXMFGoodsDeletedPageViewDidSelected:model:)]) {
        
        [self.delegate cellOnXMFGoodsDeletedPageViewDidSelected:self model:model];
    }
    
}

#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((KScreenW - 30)/2.0, 1.44 *(KScreenW /2.0));

    
}

#pragma mark - ——————— XMFHomeAllGoodsCell的代理方法 ————————
-(void)buttonsOnXMFHomeAllGoodsCellDidClick:(XMFHomeAllGoodsCell *)cell button:(UIButton *)button{
    
    //点击加入购物车
    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];
    
   
    if ([self.delegate respondsToSelector:@selector(addBtnOnCellDidClick:cell:button:indexPath:)]) {
        
        [self.delegate addBtnOnCellDidClick:self cell:cell button:button indexPath:selectedIndexPath];
    }
    
    
}

#pragma mark - ——————— 懒加载 ————————
-(CHTCollectionViewWaterfallLayout *)flowLayout{
    
    if (_flowLayout == nil) {
        
        _flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    }
    return _flowLayout;
    
}





@end
