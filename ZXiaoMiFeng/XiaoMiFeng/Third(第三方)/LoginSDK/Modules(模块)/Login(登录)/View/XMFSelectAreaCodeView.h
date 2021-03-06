//
//  XMFSelectAreaCodeView.h
//  thirdLgoin
//
//  Created by ๐ๅฐ่่๐ on 2020/7/8.
//  Copyright ยฉ 2020 ๅฐ่่. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFAreaCodeModel;

@interface XMFSelectAreaCodeView : UIView


-(void)show;

-(void)hide;

@property (nonatomic, strong) NSArray<XMFAreaCodeModel *> *areaArr;

@property (nonatomic, copy) void (^selectedAreaBlock)(XMFAreaCodeModel *areaModel);

//viewๆพ็คบไธๅฆ
@property (nonatomic, copy) void (^areaViewStatus)(BOOL isShow);


@end

NS_ASSUME_NONNULL_END
