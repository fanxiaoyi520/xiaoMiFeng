//
//  XMFOrdersCommentAddImgCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/19.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCommentAddImgCell;

@protocol XMFOrdersCommentAddImgCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ


-(void)buttonsOnXMFOrdersCommentAddImgCellDidClick:(XMFOrdersCommentAddImgCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFOrdersCommentAddImgCell : UICollectionViewCell

@property (nonatomic, weak) id<XMFOrdersCommentAddImgCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *commentImgView;

@end

NS_ASSUME_NONNULL_END
