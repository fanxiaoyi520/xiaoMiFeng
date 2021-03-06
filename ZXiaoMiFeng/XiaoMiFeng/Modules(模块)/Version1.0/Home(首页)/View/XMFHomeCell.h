//
//  XMFHomeCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/16.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeCell;

@class XMFGoodsListModel;

@protocol XMFHomeCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeCellDidClick:(XMFHomeCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeCell : UITableViewCell

@property (nonatomic, weak) id<XMFHomeCellDelegate> delegate;

@property (nonatomic, strong) XMFGoodsListModel *model;

@end

NS_ASSUME_NONNULL_END
