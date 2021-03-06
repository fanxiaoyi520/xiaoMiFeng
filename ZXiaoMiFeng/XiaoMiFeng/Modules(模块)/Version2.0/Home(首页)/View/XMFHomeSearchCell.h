//
//  XMFHomeSearchCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/3.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeSearchCell;

@protocol XMFHomeSearchCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeSearchCellDidClick:(XMFHomeSearchCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeSearchCell : UICollectionViewCell

@property (nonatomic, copy) NSString *keywordStr;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<XMFHomeSearchCellDelegate> delegate;

/** ๆฏๅฆ้ไธญๆ้ฎ */
@property (nonatomic, assign) BOOL isSelectedBtn;


@end

NS_ASSUME_NONNULL_END
