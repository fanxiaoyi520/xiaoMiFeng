//
//  XMFSearchViewModel.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/26.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFSearchViewModel.h"

@implementation XMFSearchViewModel


/*! ๅณ้ฎ่ฏๆ็ดข */
//- (void)netWorkForsearch:(NSString *)str searchBlock:(searchBlock)searchBlock{
//    NSString *title = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSString *listurl = ๆฅๅฃ
//    AFHTTPSessionManager *manager = [AFManager shareManager];
//    NSDictionary *dic = @{@"Type":@"0",
//                          @"pageSize":@"12",
//                          @"title":title,
//                          @"curPage":@"1"};
//    [manager POST:listurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
//        NSArray *array1 = result[@"Data"];
//        if ([result[@"Res"] integerValue]==0) {
//            searchBlock(1,array1);
//        }else{
//            searchBlock(0,@[@""]);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@",error);
//        searchBlock(0,@[@""]);
//    }];
//
//}


/*! ไฟๅญๅๅฒๆ็ดข */
- (void)saveHistory :(NSString *)text{
    NSString *historyPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"history.plist"];
    NSMutableArray *array  = [NSMutableArray arrayWithContentsOfFile:historyPath];
    if (!array) {
        array = [NSMutableArray array];
    }
    if ([array containsObject:text]) {
        return;
    }else{
        [array insertObject:text atIndex:0];
    }
    [array writeToFile:historyPath atomically:YES];
}
/*! ่ทๅๅๅฒๆ็ดข */
- (NSArray *)readHistory{
    NSString *historyPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"history.plist"];
    NSArray *array  = [NSArray arrayWithContentsOfFile:historyPath];
    return array;
}
/*! ๅ?้คๅๅฒๆ็ดข */
- (void)deleteHistory:(NSString *)text{
    NSString *historyPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"history.plist"];
    NSMutableArray *array  = [NSMutableArray arrayWithContentsOfFile:historyPath];
    if (text.length>0) {
        [array removeObject:text];
    }else{
        [array removeAllObjects];
    }
    [array writeToFile:historyPath atomically:YES];
}

/*! ๅๅฒๆ็ดข้ซๅบฆ */
- (NSInteger)rowForCollection :(NSArray *)array{
    CGFloat width = 0;
    NSInteger row = 1;
    /*! 55ไธบcell้ขๅคๅฎฝๅบฆ +5็่พน่ท */
    for (NSString *str in array) {
        CGSize size = [str boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14.f]} context:nil].size;
        width = width +size.width+55;
        NSLog(@"width = %f",width);
        /*! ๅ5 ๆถๅ?ไธบๆๅไธไธชitemไธ้่ฆ + 5็่พน่ท */
        if ((width-5)/(KScreenWidth)>1) {
            row = row+1;
            width =size.width+55 ;
        }
    }
//    return row>4?4:row;
    return row;
}




@end
