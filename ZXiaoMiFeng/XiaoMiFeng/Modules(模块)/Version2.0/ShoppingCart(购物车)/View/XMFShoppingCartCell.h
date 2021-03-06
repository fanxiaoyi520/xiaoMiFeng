//
//  XMFShoppingCartCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/2.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellGoodsModel;

@class XMFShoppingCartCell;

@protocol XMFShoppingCartCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFShoppingCartCellDidClick:(XMFShoppingCartCell *)cell button:(UIButton *)button;


/** ่พๅฅ็ปๆ็ๆถๅไปฃ็ๆนๆณ */
-(void)textFieldOnXMFShoppingCartCellEndInput:(XMFShoppingCartCell *)cell textField:(UITextField *)textField;


@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFShoppingCartCell : UITableViewCell


/** ่ฎฐๅฝๆ็ปๅๅ็ๆฐ้*/
@property (nonatomic,assign)NSInteger  goodCout;


@property (nonatomic, weak) id<XMFShoppingCartCellDelegate> delegate;


@property (nonatomic, strong) XMFShoppingCartCellGoodsModel *validModel;


//@property (nonatomic, assign) NSInteger cellRow;

/** ้ไธญ็indexPath */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

NS_ASSUME_NONNULL_END
