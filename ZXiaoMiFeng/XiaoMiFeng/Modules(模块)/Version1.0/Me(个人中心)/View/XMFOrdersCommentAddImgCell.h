//
//  XMFOrdersCommentAddImgCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCommentAddImgCell;

@protocol XMFOrdersCommentAddImgCellDelegate<NSObject>

@optional//选择实现的方法


-(void)buttonsOnXMFOrdersCommentAddImgCellDidClick:(XMFOrdersCommentAddImgCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFOrdersCommentAddImgCell : UICollectionViewCell

@property (nonatomic, weak) id<XMFOrdersCommentAddImgCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *commentImgView;

@end

NS_ASSUME_NONNULL_END
