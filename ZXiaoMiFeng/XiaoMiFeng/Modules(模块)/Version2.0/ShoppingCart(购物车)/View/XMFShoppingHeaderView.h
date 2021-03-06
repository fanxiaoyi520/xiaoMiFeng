//
//  XMFShoppingHeaderView.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2021/1/29.
//  Copyright Β© 2021 πε°θθπ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellModel;

@interface XMFShoppingHeaderView : UIView


/**θθζ΅·ζ·-cc θ΄­η©θ½¦ζ»model */
@property (nonatomic, strong) XMFShoppingCartCellModel *overseaModel;

/**θθε½ι-bc θ΄­η©θ½¦ζ»model */
@property (nonatomic, strong) XMFShoppingCartCellModel *internationalModel;


@end

NS_ASSUME_NONNULL_END
