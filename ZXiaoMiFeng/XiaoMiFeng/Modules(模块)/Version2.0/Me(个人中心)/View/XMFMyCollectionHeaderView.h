//
//  XMFMyCollectionHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFMyCollectionHeaderView : UIView

@property (nonatomic, copy) void (^emptyInvalidCollectionBlock)(XMFMyCollectionHeaderView *headerView);

@end

NS_ASSUME_NONNULL_END
