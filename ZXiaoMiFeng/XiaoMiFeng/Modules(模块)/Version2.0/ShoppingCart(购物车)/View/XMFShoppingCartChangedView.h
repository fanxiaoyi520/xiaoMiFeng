//
//  XMFShoppingCartChangedView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellGoodsModel;

@interface XMFShoppingCartChangedView : UIView

-(void)show;

-(void)hide;


@property (nonatomic, copy) void (^sureBtnBlock)(void);

/**  */
@property (nonatomic, strong) NSMutableArray<XMFShoppingCartCellGoodsModel *> *dataSourceArr;


@end

NS_ASSUME_NONNULL_END
