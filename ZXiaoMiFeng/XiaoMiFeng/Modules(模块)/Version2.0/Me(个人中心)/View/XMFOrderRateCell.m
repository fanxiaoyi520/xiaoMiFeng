//
//  XMFGoodsCommentCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderRateCell.h"
#import "YYStarView.h"
#import "XMFOrdersCommentAddImgCell.h"
#import "XMFMyOrdersListModel.h"//我的订单列表model


//在.m文件中添加
@interface  XMFOrderRateCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMFOrdersCommentAddImgCellDelegate,UITextViewDelegate,XMFOrdersCommentAddImgCellDelegate>

/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodNameLB;

/** 星星的背景view */
@property (weak, nonatomic) IBOutlet UIView *starBgView;

/** 综合评分的背景view */
@property (weak, nonatomic) IBOutlet UIView *starContentBgView;

/** 综合评分的背景view高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starContentBgViewHeight;


/** 星星view */
@property (nonatomic, strong) YYStarView *starView;

/** 评价内容 */
@property (weak, nonatomic) IBOutlet UITextView *contentTxw;

/** 添加 */
@property (weak, nonatomic) IBOutlet UIButton *addImgBtn;

/** 我的图片 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;



/** 字数 */
@property (weak, nonatomic) IBOutlet UILabel *wordsCountLB;



@end


@implementation XMFOrderRateCell

//xib先执行这个初始化方法
-(instancetype)initWithCoder:(NSCoder *)coder{
    
    self = [super initWithCoder:coder];
    
    if (self) {
        
        
    }
    
    return self;
}

-(void)setupUI{
    
    
    
}


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
    
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    
    
    
    self.contentTxw.delegate = self;
    
    
    //默认高度为0
    self.myCollectionViewHeight.constant = 0.f;
    
    kWeakSelf(self)
    
    YYStarView *starView = [YYStarView new];
    
    starView.starClick = ^ {
        
        //        NSInteger starNum = weakself.starView.starScore;
        
        if ([weakself.delegate respondsToSelector:@selector(starViewOnXMFOrderRateCellDidClick:atRateCellRow:starView:)]) {
            
            [weakself.delegate starViewOnXMFOrderRateCellDidClick:weakself atRateCellRow:weakself.cellRow starView:weakself.starView];
        }
        
        
    };
    
    
    [self.starBgView addSubview:starView];
    
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);//无需设置大小size，只需设置位置即可
//        make.top.mas_equalTo(9);
        make.left.mas_offset(0);
    }];
    self.starView = starView;
    
       //设置参数
//        starView.starScore = 2;
    self.starView.starSize = CGSizeMake(30, 30);
    self.starView.starSpacing = 15;
    self.starView.starCount = 5;
    self.starView.starBrightImageName = @"icon_comment_star_y";
    self.starView.starDarkImageName = @"icon_comment_star_n";
    
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //以下三行代码防止图片变形
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.goodsPicImgView cornerWithRadius:5.f];
    
    
}



//页面上的按钮被点击:添加图片
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrderRateCellDidClick:)]) {
        
        [self.delegate buttonsOnXMFOrderRateCellDidClick:self];
    }
    
}

/*
//选择的图片数组
-(void)setSelectedPhotos:(NSMutableArray<UIImage *> *)selectedPhotos{
    
    _selectedPhotos = selectedPhotos;
    
    [self.myCollectionView reloadData];
    
    //当没有选中图片的时候
    if (selectedPhotos.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
         self.myCollectionViewHeight.constant = (KScreenWidth - 30)/4.0;
        
    }
    
}*/


-(void)setGoodsListModel:(XMFMyOrdersListGoodsListModel *)goodsListModel{
    
    
    _goodsListModel = goodsListModel;
    
    
    
    
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodNameLB.text = goodsListModel.goodsName;
    
    
    //综合评分背景view
    if (goodsListModel.rateType == addComment) {
       
        //追加评价
        self.starContentBgView.hidden = YES;
        
        self.starContentBgViewHeight.constant = 0.f;
        
        self.contentTxw.zw_placeHolder = XMFLI(@"亲，有什么需要追加评价的么？");
        
    }else if (goodsListModel.rateType == soonComment){
        
        self.contentTxw.zw_placeHolder = XMFLI(@"亲，您对这个商品满意吗？您的评价会帮助我们选择更好的商品哦~");
        
    }
    
    
    //星星
    self.starView.starScore = goodsListModel.star;
    

    //评论内容
    
    self.contentTxw.text = goodsListModel.content;
    
   
    //字数
    self.wordsCountLB.text = [NSString stringWithFormat:@"%zd/70", goodsListModel.wordsCountNum];
    
    
    //当没有选中图片的时候
    if (goodsListModel.selectedPhotos.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
        self.myCollectionViewHeight.constant = (KScreenWidth - 30)/4.0;
        
    }
    
    [self.myCollectionView reloadData];

}

#pragma mark - ——————— collectionView的代理方法和数据源 ————————

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.goodsListModel.selectedPhotos.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMFOrdersCommentAddImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFOrdersCommentAddImgCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    

    cell.commentImgView.image = self.goodsListModel.selectedPhotos[indexPath.item];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = KScreenWidth - 30;
    
    return CGSizeMake(width / 4.0, self.myCollectionView.height);
     
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
    
    if ([self.delegate respondsToSelector:@selector(buttonsIncommentAddImgCellOnXMFOrderRateCellDidSelect:atRateCellRow:atCommentAddImgCellIndexPath:)]) {
        
        [self.delegate buttonsIncommentAddImgCellOnXMFOrderRateCellDidSelect:self atRateCellRow:self.cellRow atCommentAddImgCellIndexPath:indexPath];
    }
    
    
}




#pragma mark - ——————— UITextView的代理方法 ————————

-(void)textViewDidChange:(UITextView *)textView{
    
    //实时统计字数
    if (textView.text.length <= 70) {
        
        self.wordsCountLB.text = [NSString stringWithFormat:@"%zd/70", textView.text.length];
        
        
    }else{
        
        textView.text = [textView.text substringToIndex:70];
        
        [textView resignFirstResponder];
        
        [MBProgressHUD showError:XMFLI(@"最多输入70个字") toView:kAppWindow];
        
        return;
    }
    
    
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
    
    if ([self.delegate respondsToSelector:@selector(textViewOnXMFOrderRateCellDidChange:atRateCellRow:textView:)]) {
           
           [self.delegate textViewOnXMFOrderRateCellDidChange:self atRateCellRow:self.cellRow textView:textView];
       }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
