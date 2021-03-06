//
//  XMFShoppingSplitOrdersCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2021/1/27.
//  Copyright ยฉ 2021 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingSplitOrdersModel,XMFShoppingSplitOrdersCell;

@protocol XMFShoppingSplitOrdersCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFShoppingSplitOrdersCellDidClick:(XMFShoppingSplitOrdersCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFShoppingSplitOrdersCell : UITableViewCell

/** ๆๅ่ฎขๅ็ๆฐๆฎmodel */
@property (nonatomic, strong) XMFShoppingSplitOrdersModel *splitOrdersModel;


@property (nonatomic, weak) id<XMFShoppingSplitOrdersCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
