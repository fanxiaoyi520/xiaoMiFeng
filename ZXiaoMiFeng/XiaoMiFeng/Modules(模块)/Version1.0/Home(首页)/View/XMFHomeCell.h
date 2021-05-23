//
//  XMFHomeCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/16.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeCell;

@class XMFGoodsListModel;

@protocol XMFHomeCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeCellDidClick:(XMFHomeCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFHomeCell : UITableViewCell

@property (nonatomic, weak) id<XMFHomeCellDelegate> delegate;

@property (nonatomic, strong) XMFGoodsListModel *model;

@end

NS_ASSUME_NONNULL_END
