//
//  XMFMyDeliveryAddressCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyDeliveryAddressModel,XMFMyDeliveryAddressCell;

@protocol XMFMyDeliveryAddressCellDelegate<NSObject>

@optional//选择实现的方法


-(void)buttonsOnXMFMyDeliveryAddressCellDidClick:(XMFMyDeliveryAddressCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFMyDeliveryAddressCell : UITableViewCell

@property (nonatomic, strong) XMFMyDeliveryAddressModel *addressModel;

@property (nonatomic, weak) id<XMFMyDeliveryAddressCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
