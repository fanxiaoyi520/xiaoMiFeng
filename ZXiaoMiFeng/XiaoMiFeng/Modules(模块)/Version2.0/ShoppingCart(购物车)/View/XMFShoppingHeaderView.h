//
//  XMFShoppingHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/29.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellModel;

@interface XMFShoppingHeaderView : UIView


/**蜜蜂海淘-cc 购物车总model */
@property (nonatomic, strong) XMFShoppingCartCellModel *overseaModel;

/**蜜蜂国际-bc 购物车总model */
@property (nonatomic, strong) XMFShoppingCartCellModel *internationalModel;


@end

NS_ASSUME_NONNULL_END
