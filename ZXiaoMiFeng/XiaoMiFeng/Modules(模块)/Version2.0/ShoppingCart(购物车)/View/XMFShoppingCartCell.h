//
//  XMFShoppingCartCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellGoodsModel;

@class XMFShoppingCartCell;

@protocol XMFShoppingCartCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFShoppingCartCellDidClick:(XMFShoppingCartCell *)cell button:(UIButton *)button;


/** 输入结束的时候代理方法 */
-(void)textFieldOnXMFShoppingCartCellEndInput:(XMFShoppingCartCell *)cell textField:(UITextField *)textField;


@required//必须实现的方法

@end

@interface XMFShoppingCartCell : UITableViewCell


/** 记录最终商品的数量*/
@property (nonatomic,assign)NSInteger  goodCout;


@property (nonatomic, weak) id<XMFShoppingCartCellDelegate> delegate;


@property (nonatomic, strong) XMFShoppingCartCellGoodsModel *validModel;


//@property (nonatomic, assign) NSInteger cellRow;

/** 选中的indexPath */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

NS_ASSUME_NONNULL_END
