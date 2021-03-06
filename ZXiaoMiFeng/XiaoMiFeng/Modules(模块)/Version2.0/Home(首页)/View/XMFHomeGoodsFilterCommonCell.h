//
//  XMFHomeGoodsFilterCommonCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/5.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsFilterSonModel;

@class XMFHomeGoodsFilterCommonCell;

@protocol XMFHomeGoodsFilterCommonCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeGoodsFilterCommonCellDidClick:(XMFHomeGoodsFilterCommonCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeGoodsFilterCommonCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *standardBtn;

@property (nonatomic, weak) id<XMFHomeGoodsFilterCommonCellDelegate> delegate;

@property (nonatomic, strong) XMFHomeGoodsFilterSonModel *sonModel;


@end

NS_ASSUME_NONNULL_END
