//
//  XMFOrdersCommentCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCommentCell;

@class XMFOrdersCommentAddImgCell;

@class XMFOrdersDetailOrderGoodsModel;


@protocol XMFOrdersCommentCellDelegate<NSObject>

@optional//选择实现的方法



/// 图片被点击
/// @param commentCell 评论cell
/// @param commentAddImgCell 图片cell
/// @param row XMFOrdersCommentCell的row
/// @param indexPath XMFOrdersCommentAddImgCell的indexpath
-(void)commentAddImgCellOnXMFOrdersCommentCellDidSelect:(XMFOrdersCommentCell *)commentCell commentAddImgCell:(XMFOrdersCommentAddImgCell *)commentAddImgCell atCommentCellRow:(NSInteger)row  atCommentAddImgCellIndexPath:(NSIndexPath *)indexPath;


/// 添加图片按钮被点击
/// @param commentCell 添加评论cell
-(void)buttonsOnXMFOrdersCommentCellDidClick:(XMFOrdersCommentCell *)commentCell;



/// 删除按钮点击
/// @param commentCell 评论cell
/// @param row 评论cell的row
/// @param indexPath 图片cell的indexpath
-(void)buttonsIncommentAddImgCellOnXMFOrdersCommentCellDidSelect:(XMFOrdersCommentCell *)commentCell  atCommentCellRow:(NSInteger)row  atCommentAddImgCellIndexPath:(NSIndexPath *)indexPath;



/// 评论内容发生了改变
/// @param cell 评论cell
/// @param row 评论cell的row
/// @param textView 评论框
-(void)textViewOnXMFOrdersCommentCellDidChange:(XMFOrdersCommentCell *)cell atCommentCellRow:(NSInteger)row textView:(UITextView *)textView;




@required//必须实现的方法

@end

@interface XMFOrdersCommentCell : UITableViewCell

//商品信息model
@property (nonatomic, strong) XMFOrdersDetailOrderGoodsModel *goodsModel;

@property (nonatomic, assign) NSInteger cellRow;

@property (nonatomic, weak) id<XMFOrdersCommentCellDelegate> delegate;

//选中的图片
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

@end

NS_ASSUME_NONNULL_END
