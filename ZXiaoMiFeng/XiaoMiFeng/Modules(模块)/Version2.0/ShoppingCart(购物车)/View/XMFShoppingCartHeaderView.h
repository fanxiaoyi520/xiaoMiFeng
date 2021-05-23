//
//  XMFShoppingCartHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartHeaderView,XMFShoppingCartCellModel,XMFShoppingCartCellGoodsInfoModel;

@protocol XMFShoppingCartHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFShoppingCartHeaderViewDidClick:(XMFShoppingCartHeaderView *)headerView button:(UIButton *)button;

@required//必须实现的方法

@end



@interface XMFShoppingCartHeaderView : UIView

/** 选择按钮 */
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;



/** 仓库 */
@property (weak, nonatomic) IBOutlet UILabel *warehouseLB;



/** 展开和收起切换按钮 */
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;



@property (nonatomic, weak) id<XMFShoppingCartHeaderViewDelegate> delegate;


/** 选中的indexPath */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;


/** 购物车总model */
@property (nonatomic, strong) XMFShoppingCartCellModel *cartModel;

/** 购物车一组商品的model */
@property (nonatomic, strong) XMFShoppingCartCellGoodsInfoModel *goodsInfoModel;


@end

NS_ASSUME_NONNULL_END
