//
//  XMFShoppingSplitOrdersCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/27.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingSplitOrdersModel,XMFShoppingSplitOrdersCell;

@protocol XMFShoppingSplitOrdersCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFShoppingSplitOrdersCellDidClick:(XMFShoppingSplitOrdersCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFShoppingSplitOrdersCell : UITableViewCell

/** 拆分订单的数据model */
@property (nonatomic, strong) XMFShoppingSplitOrdersModel *splitOrdersModel;


@property (nonatomic, weak) id<XMFShoppingSplitOrdersCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
