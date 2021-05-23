//
//  XMFOrdersCommentCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersCommentCell.h"
#import "XMFOrdersCommentAddImgCell.h"
#import "XMFOrdersDetailModel.h"


//在.m文件中添加
@interface  XMFOrdersCommentCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMFOrdersCommentAddImgCellDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *goodsCoverImgView;


@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;



@property (weak, nonatomic) IBOutlet UITextView *goodsCommentTxw;


@property (weak, nonatomic) IBOutlet UIButton *addImgBtn;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;



@end

@implementation XMFOrdersCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 水平方向的间距
    _flowLayout.minimumLineSpacing = 0 ;
    
    // 垂直方向的间距
    _flowLayout.minimumInteritemSpacing = 0;
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (@available (iOS 11.0,*)) {
        
        _myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _myCollectionView.delegate = self;
    
    _myCollectionView.dataSource = self;
    
    //    _myCollectionView.pagingEnabled = YES;
    
    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersCommentAddImgCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFOrdersCommentAddImgCell class])];
    
    
    self.goodsCommentTxw.zw_placeHolder = XMFLI(@"说点什么...");
    
    self.goodsCommentTxw.delegate = self;
    
    
    //默认高度为0
    self.myCollectionViewHeight.constant = 0.f;
    
    
}

//选择的图片数组
-(void)setSelectedPhotos:(NSMutableArray<UIImage *> *)selectedPhotos{
    
    _selectedPhotos = selectedPhotos;
    
    [self.myCollectionView reloadData];
    
    //当没有选中图片的时候
    if (selectedPhotos.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
         self.myCollectionViewHeight.constant = (KScreenWidth - 30)/3.0;
        
    }
    
}


//商品信息model
-(void)setGoodsModel:(XMFOrdersDetailOrderGoodsModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    [self.goodsCoverImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = goodsModel.goodsName;
    
    
}


//页面上的按钮被点击：添加图片
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrdersCommentCellDidClick:)]) {
        
        [self.delegate buttonsOnXMFOrdersCommentCellDidClick:self];
    }
    
    
}


#pragma mark - ——————— collectionView的代理方法和数据源 ————————

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.selectedPhotos.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMFOrdersCommentAddImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFOrdersCommentAddImgCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    

    cell.commentImgView.image = self.selectedPhotos[indexPath.item];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = KScreenWidth - 30;
    
    return CGSizeMake(width / 3.0, self.myCollectionView.height);
     
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /*
    XMFOrdersCommentAddImgCell *cell = (XMFOrdersCommentAddImgCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if ([self.delegate respondsToSelector:@selector(commentAddImgCellOnXMFOrdersCommentCellDidSelect:commentAddImgCell:atCommentCellRow:atCommentAddImgCellIndexPath:)]) {
        
        [self.delegate commentAddImgCellOnXMFOrdersCommentCellDidSelect:self commentAddImgCell:cell atCommentCellRow:self.cellRow atCommentAddImgCellIndexPath:indexPath];
    }*/
    
    
}


#pragma mark - ——————— XMFOrdersCommentAddImgCell的代理方法 ————————
-(void)buttonsOnXMFOrdersCommentAddImgCellDidClick:(XMFOrdersCommentAddImgCell *)cell button:(UIButton *)button{
    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    if ([self.delegate respondsToSelector:@selector(buttonsIncommentAddImgCellOnXMFOrdersCommentCellDidSelect:atCommentCellRow:atCommentAddImgCellIndexPath:)]) {
        
        [self.delegate buttonsIncommentAddImgCellOnXMFOrdersCommentCellDidSelect:self atCommentCellRow:self.cellRow atCommentAddImgCellIndexPath:indexPath];
    }
    
    
}


#pragma mark - ——————— UITextView的代理方法 ————————

-(void)textViewDidChange:(UITextView *)textView{
    
    if ([self.delegate respondsToSelector:@selector(textViewOnXMFOrdersCommentCellDidChange:atCommentCellRow:textView:)]) {
        
        [self.delegate textViewOnXMFOrdersCommentCellDidChange:self atCommentCellRow:self.cellRow textView:textView];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}

@end
