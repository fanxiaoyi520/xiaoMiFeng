//
//  XMFHomeGoodsSortView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/8.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsSortView,XMFHomeGoodsSortCell;

@protocol XMFHomeGoodsSortViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)cellOnXMFHomeGoodsSortViewDidSelected:(XMFHomeGoodsSortView *)sortView selectedDic:(NSMutableDictionary *)selectedTagDic seletedTitle:(NSString *)titleStr;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeGoodsSortView : UIView

-(void)showWithFrame:(CGRect)frame;

-(void)hide;

@property (nonatomic, weak) id<XMFHomeGoodsSortViewDelegate> delegate;

/** ๅผนๆกๆพ็คบไธ้่ */
@property (nonatomic, copy) void (^GoodsSortViewIsShowBlock)(BOOL isShow);


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

NS_ASSUME_NONNULL_END
