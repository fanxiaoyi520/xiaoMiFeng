//
//  XMFAddressListCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFAddressListModel;

@class XMFAddressListCell;

@protocol XMFAddressListCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFAddressListCellDidClick:(XMFAddressListCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFAddressListCell : UITableViewCell


@property (nonatomic, strong) XMFAddressListModel *model;

@property (nonatomic, weak) id<XMFAddressListCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
