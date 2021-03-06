//
//  XMFGoodsCommentCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/12.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFOrderRateCell.h"
#import "YYStarView.h"
#import "XMFOrdersCommentAddImgCell.h"
#import "XMFMyOrdersListModel.h"//æçè®¢ååè¡¨model


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFOrderRateCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMFOrdersCommentAddImgCellDelegate,UITextViewDelegate,XMFOrdersCommentAddImgCellDelegate>

/** ååå¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** åååç§° */
@property (weak, nonatomic) IBOutlet UILabel *goodNameLB;

/** ææçèæ¯view */
@property (weak, nonatomic) IBOutlet UIView *starBgView;

/** ç»¼åè¯åçèæ¯view */
@property (weak, nonatomic) IBOutlet UIView *starContentBgView;

/** ç»¼åè¯åçèæ¯viewé«åº¦ */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starContentBgViewHeight;


/** ææview */
@property (nonatomic, strong) YYStarView *starView;

/** è¯ä»·åå®¹ */
@property (weak, nonatomic) IBOutlet UITextView *contentTxw;

/** æ·»å  */
@property (weak, nonatomic) IBOutlet UIButton *addImgBtn;

/** æçå¾ç */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;



/** å­æ° */
@property (weak, nonatomic) IBOutlet UILabel *wordsCountLB;



@end


@implementation XMFOrderRateCell

//xibåæ§è¡è¿ä¸ªåå§åæ¹æ³
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
    
    
    // æ°´å¹³æ¹åçé´è·
    _flowLayout.minimumLineSpacing = 0 ;
    
    // åç´æ¹åçé´è·
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
    
    
    //é»è®¤é«åº¦ä¸º0
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
        make.center.mas_equalTo(0);//æ éè®¾ç½®å¤§å°sizeï¼åªéè®¾ç½®ä½ç½®å³å¯
//        make.top.mas_equalTo(9);
        make.left.mas_offset(0);
    }];
    self.starView = starView;
    
       //è®¾ç½®åæ°
//        starView.starScore = 2;
    self.starView.starSize = CGSizeMake(30, 30);
    self.starView.starSpacing = 15;
    self.starView.starCount = 5;
    self.starView.starBrightImageName = @"icon_comment_star_y";
    self.starView.starDarkImageName = @"icon_comment_star_n";
    
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.goodsPicImgView cornerWithRadius:5.f];
    
    
}



//é¡µé¢ä¸çæé®è¢«ç¹å»:æ·»å å¾ç
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrderRateCellDidClick:)]) {
        
        [self.delegate buttonsOnXMFOrderRateCellDidClick:self];
    }
    
}

/*
//éæ©çå¾çæ°ç»
-(void)setSelectedPhotos:(NSMutableArray<UIImage *> *)selectedPhotos{
    
    _selectedPhotos = selectedPhotos;
    
    [self.myCollectionView reloadData];
    
    //å½æ²¡æéä¸­å¾ççæ¶å
    if (selectedPhotos.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
         self.myCollectionViewHeight.constant = (KScreenWidth - 30)/4.0;
        
    }
    
}*/


-(void)setGoodsListModel:(XMFMyOrdersListGoodsListModel *)goodsListModel{
    
    
    _goodsListModel = goodsListModel;
    
    
    
    
    
    //å¾ç
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //åååç§°
    self.goodNameLB.text = goodsListModel.goodsName;
    
    
    //ç»¼åè¯åèæ¯view
    if (goodsListModel.rateType == addComment) {
       
        //è¿½å è¯ä»·
        self.starContentBgView.hidden = YES;
        
        self.starContentBgViewHeight.constant = 0.f;
        
        self.contentTxw.zw_placeHolder = XMFLI(@"äº²ï¼æä»ä¹éè¦è¿½å è¯ä»·çä¹ï¼");
        
    }else if (goodsListModel.rateType == soonComment){
        
        self.contentTxw.zw_placeHolder = XMFLI(@"äº²ï¼æ¨å¯¹è¿ä¸ªååæ»¡æåï¼æ¨çè¯ä»·ä¼å¸®å©æä»¬éæ©æ´å¥½çååå¦~");
        
    }
    
    
    //ææ
    self.starView.starScore = goodsListModel.star;
    

    //è¯è®ºåå®¹
    
    self.contentTxw.text = goodsListModel.content;
    
   
    //å­æ°
    self.wordsCountLB.text = [NSString stringWithFormat:@"%zd/70", goodsListModel.wordsCountNum];
    
    
    //å½æ²¡æéä¸­å¾ççæ¶å
    if (goodsListModel.selectedPhotos.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
        self.myCollectionViewHeight.constant = (KScreenWidth - 30)/4.0;
        
    }
    
    [self.myCollectionView reloadData];

}

#pragma mark - âââââââ collectionViewçä»£çæ¹æ³åæ°æ®æº ââââââââ

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


#pragma mark - âââââââ XMFOrdersCommentAddImgCellçä»£çæ¹æ³ ââââââââ
-(void)buttonsOnXMFOrdersCommentAddImgCellDidClick:(XMFOrdersCommentAddImgCell *)cell button:(UIButton *)button{
    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    if ([self.delegate respondsToSelector:@selector(buttonsIncommentAddImgCellOnXMFOrderRateCellDidSelect:atRateCellRow:atCommentAddImgCellIndexPath:)]) {
        
        [self.delegate buttonsIncommentAddImgCellOnXMFOrderRateCellDidSelect:self atRateCellRow:self.cellRow atCommentAddImgCellIndexPath:indexPath];
    }
    
    
}




#pragma mark - âââââââ UITextViewçä»£çæ¹æ³ ââââââââ

-(void)textViewDidChange:(UITextView *)textView{
    
    //å®æ¶ç»è®¡å­æ°
    if (textView.text.length <= 70) {
        
        self.wordsCountLB.text = [NSString stringWithFormat:@"%zd/70", textView.text.length];
        
        
    }else{
        
        textView.text = [textView.text substringToIndex:70];
        
        [textView resignFirstResponder];
        
        [MBProgressHUD showError:XMFLI(@"æå¤è¾å¥70ä¸ªå­") toView:kAppWindow];
        
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
