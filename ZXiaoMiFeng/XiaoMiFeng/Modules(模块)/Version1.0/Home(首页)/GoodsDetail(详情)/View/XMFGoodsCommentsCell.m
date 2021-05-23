//
//  XMFGoodsCommentsCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsCommentsCell.h"
#import "XMFGoodsCommentsModel.h"
#import "XMFGoodsCommentsImageCell.h"//图片cell


//在.m文件中添加
@interface  XMFGoodsCommentsCell()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLB;


@property (weak, nonatomic) IBOutlet UILabel *contentLB;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;




@end

@implementation XMFGoodsCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerClass:[XMFGoodsCommentsImageCell class] forCellWithReuseIdentifier:NSStringFromClass([XMFGoodsCommentsImageCell class])];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.avatarImgView cornerWithRadius:self.avatarImgView.height/2.0];
    
}


-(void)setCommentsModel:(XMFGoodsCommentsModel *)commentsModel{
    
    _commentsModel = commentsModel;
    
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:commentsModel.avatar] placeholderImage:[UIImage imageNamed:@"icon_me_touxiang"]];
    
    
    if ([commentsModel.nickname nullToString]) {
        
         self.nickNameLB.text = @"***";
        
        
    }else if(commentsModel.nickname.length > 1){
        
        NSString *nickNameStr = [commentsModel.nickname stringByReplacingCharactersInRange:NSMakeRange(1, commentsModel.nickname.length - 2) withString:@"***"];
        
         self.nickNameLB.text = nickNameStr;
        
    }else{
        
        self.nickNameLB.text = [NSString stringWithFormat:@"%@***",commentsModel.nickname];
    }
   
    
    self.timeLB.text = [commentsModel.addTime substringToIndex:10];
    
    
    if (commentsModel.specifications.count > 0) {
        
        self.contentLB.text = [NSString stringWithFormat:@"%@\n商品型号:%@",commentsModel.content,commentsModel.specifications[0]];
    }else{
        
        self.contentLB.text = commentsModel.content;
    }
    
    // 没图片就高度为0
    CGFloat width = KScreenWidth - 30;
    
    if (commentsModel.picList.count==0){
        
        self.myCollectionViewHeight.constant = 0;
        
    }else{
        
        if (commentsModel.picList.count == 1){
            
            self.myCollectionViewHeight.constant = width / 1.5;
        }else{
            
            CGFloat height = ((commentsModel.picList.count - 1) / 3 + 1) * (width / 3) + (commentsModel.picList.count - 1) / 3 * 15;
            self.myCollectionViewHeight.constant = height;
        }
    }
    
    [self.myCollectionView reloadData];
    
    
}


#pragma mark - ——————— collectionView的代理方法和数据源 ————————

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.commentsModel.picList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMFGoodsCommentsImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFGoodsCommentsImageCell class]) forIndexPath:indexPath];
    
    if (self.commentsModel.picList.count > 0) {
        
        cell.imageNameStr = self.commentsModel.picList[indexPath.row];
        
        //图片点击
        cell.commentsImageViewBlock = ^(UIImageView * _Nonnull tapImageView) {
            
            [HUPhotoBrowser showFromImageView:tapImageView withURLStrings:self.commentsModel.picList atIndex:indexPath.item];
            
        };
  
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = KScreenWidth - 30 - 20;
    if (self.commentsModel.picList.count!=0)
    {
        if (self.commentsModel.picList.count == 1)
        {
            return CGSizeMake(width / 2, width / 1.5);
        }
        else
        {
            return CGSizeMake(width / 3, width / 3);
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
