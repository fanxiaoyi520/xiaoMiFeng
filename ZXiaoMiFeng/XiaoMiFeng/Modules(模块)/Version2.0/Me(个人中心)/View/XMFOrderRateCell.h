//
//  XMFGoodsCommentCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListGoodsListModel,XMFOrderRateCell,YYStarView;


@protocol XMFOrderRateCellDelegate<NSObject>

@optional//选择实现的方法

/// 添加图片按钮被点击
/// @param rateCell 添加评论cell
-(void)buttonsOnXMFOrderRateCellDidClick:(XMFOrderRateCell *)rateCell;



/// 删除按钮点击
/// @param rateCell 评论cell
/// @param row 评论cell的row
/// @param indexPath 图片cell的indexpath
-(void)buttonsIncommentAddImgCellOnXMFOrderRateCellDidSelect:(XMFOrderRateCell *)rateCell  atRateCellRow:(NSInteger)row  atCommentAddImgCellIndexPath:(NSIndexPath *)indexPath;



/// 评论内容发生了改变
/// @param rateCell 评论cell
/// @param row 评论cell的row
/// @param textView 评论框
-(void)textViewOnXMFOrderRateCellDidChange:(XMFOrderRateCell *)rateCell atRateCellRow:(NSInteger)row textView:(UITextView *)textView;



//星星数量发生了改变
-(void)starViewOnXMFOrderRateCellDidClick:(XMFOrderRateCell *)rateCell atRateCellRow:(NSInteger)row starView:(YYStarView *)starView;



@required//必须实现的方法

@end



@interface XMFOrderRateCell : UITableViewCell

/** 商品列表model */
@property (nonatomic, strong) XMFMyOrdersListGoodsListModel *goodsListModel;


@property (nonatomic, weak) id<XMFOrderRateCellDelegate> delegate;


@property (nonatomic, assign) NSInteger cellRow;

//选中的图片
//@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

@end

NS_ASSUME_NONNULL_END
