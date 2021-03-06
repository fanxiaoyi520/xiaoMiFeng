//
//  XMFAddressManager.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/7.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFAddressManager.h"
#import "BRAddressModel.h"


#define addressInfoKey  @"addressInfo"

//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFAddressManager()

@property(nonatomic,strong) YYCache *addressCache;//YYCacheå¯¹è±¡

@property(nonatomic,strong) NSMutableDictionary *addressInfoDict;//å°åä¿¡æ¯å­å¸



@end

@implementation XMFAddressManager

//éåinitæ¹æ³
-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.addressCache = [[YYCache alloc]initWithName:@"app.addressInfo"];
    }
    
    return self;
}

#pragma mark - åä¾ - åå»ºç®¡çå¯¹è±¡
+(instancetype)shareManager{
    static XMFAddressManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[XMFAddressManager alloc]init];
    });
    
    return instance;
    
}


#pragma mark - âââââââ å­å¨å°åä¿¡æ¯ ââââââââ

-(void)updateAddressInfo:(id)addressInfo{
    
    [self.addressCache setObject:addressInfo forKey:addressInfoKey];
}


#pragma mark - âââââââ æ¸é¤å°åä¿¡æ¯ ââââââââ

-(void)removeAddressInfo{
    
    [self.addressCache removeObjectForKey:addressInfoKey];
}

#pragma mark - æ¯å¦å­å¨ç¨æ·ä¿¡æ¯
-(BOOL)isContainsAddressInfo{
    
    //å¤æ­ç¼å­æ¯å¦å­å¨
    if ([self.addressCache containsObjectForKey:addressInfoKey]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    
}

#pragma mark - âââââââ è·åççº§åç§° ââââââââ
-(NSString *)getProvinceName:(NSString *)provinceCode{
    
    NSString *provinceNameStr = @"";
    
    for (BRProvinceModel *provinceModel in self.addressModel.provincelist) {
        
        //ççº§codeç¸å
        if ([provinceModel.code isEqualToString:provinceCode]) {
            
            provinceNameStr = provinceModel.name;
            
            return provinceNameStr;
            
        }
        
        
    }
    
     return provinceNameStr;
    
}

#pragma mark - âââââââ è·ååå¸åç§° ââââââââ
-(NSString *)getCityName:(NSString *)cityCode{
    
    NSString *cityNameStr = @"";
    
    for (BRProvinceModel *provinceModel in self.addressModel.provincelist) {
        
        for (BRCityModel *cityModel in provinceModel.citylist) {
            
            if ([cityModel.code isEqualToString:cityCode]) {
                
                cityNameStr = cityModel.name;
                
                return cityNameStr;
            }
            
            
        }
        
    }

    return cityNameStr;
}


#pragma mark - âââââââ è·ååºçº§åç§° ââââââââ

-(NSString *)getAreaName:(NSString *)areaCode{
    
    NSString *areaNameStr = @"";
    
    
    for (BRProvinceModel *provinceModel in self.addressModel.provincelist) {
           
           for (BRCityModel *cityModel in provinceModel.citylist) {
               
               
               for (BRAreaModel *areaModel in cityModel.arealist) {
                   
                   if ([areaModel.code  isEqualToString:areaCode]) {
                       
                       areaNameStr = areaModel.name;
                       
                       return areaNameStr;
                   }
                   
               }
               
               
               
           }
           
       }
    
    return areaNameStr;
}


#pragma mark - âââââââ åæå è½½ ââââââââ
-(NSMutableDictionary *)addressInfoDict{
    
   if (!_addressInfoDict) {
    

        id value = [self.addressCache objectForKey:addressInfoKey];
        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)value];
        return userInfoDict;
    }
    return _addressInfoDict;
    
}

-(BRAddressModel *)addressModel{
    
    if (!_addressModel) {
        if (self.addressInfoDict) {
            
            BRAddressModel *model = [BRAddressModel yy_modelWithDictionary:self.addressInfoDict];
        
            
            return model;
            
        }
    }
    
    return _addressModel;
    
}

/*
-(XMFBRAddressModel *)addressModel{
    
    if (!_addressModel) {
        if (self.addressInfoDict) {
            
            XMFBRAddressModel *model = [XMFBRAddressModel yy_modelWithDictionary:self.addressInfoDict];
            
            
            //è§£æç
            
            NSMutableArray *brProvinceModelArr = [[NSMutableArray alloc]init];
            
            for (XMFBRProvinceModel *provinceModel in model.provincelist) {
                
                
                BRProvinceModel *brProvinceModel = [[BRProvinceModel alloc]init];
                
                brProvinceModel.code = provinceModel.code;
                
                brProvinceModel.name = provinceModel.name;
                
                brProvinceModel.index = provinceModel.index;
                
                
                //è§£æå¸
                
                NSMutableArray *brCityModelArr = [[NSMutableArray alloc]init];
                
                for (XMFBRCityModel *cityModel in provinceModel.citylist) {
                    
                    
                    BRCityModel *brCityModel = [[BRCityModel alloc]init];
                    
                    brCityModel.code = cityModel.code;
                    
                    brCityModel.name = cityModel.name;
                    
                    brCityModel.index = cityModel.index;
                    
                    
                    //è§£æå°åº
                    
                    NSMutableArray *brAreaModelArr = [[NSMutableArray alloc]init];
                    
                    for (XMFBRAreaModel *areaModel in cityModel.arealist) {
                        
                        BRAreaModel *brAreaModel = [[BRAreaModel alloc]init];
                        
                        brAreaModel.code = areaModel.code;
                        
                        brAreaModel.name = areaModel.name;
                        
                        brAreaModel.index = areaModel.index;
                        
                        
                        [brAreaModelArr addObject:brAreaModel];
                        
                    }
                    
                    brCityModel.arealist = brAreaModelArr;
                    
                    
                }
                
                brProvinceModel.citylist = brCityModelArr;
                
                
               [brProvinceModelArr addObject:brProvinceModel];
            }
            
              
            model.brProvincelist = brProvinceModelArr;
            
            
            
            return model;
            
        }
    }
    
    return _addressModel;
}*/



/*
-(XMFBRAddressModel *)addressModel{
    
    if (!_addressModel) {
        if (self.addressInfoDict) {
            
            XMFBRAddressModel *addressModel = [[XMFBRAddressModel alloc]init];
            
            NSArray *dataArr = self.addressInfoDict[@"data"];
            
            //è§£æç
            
            NSMutableArray *brProvinceModelArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary *provinceDic in dataArr) {
                
                
                BRProvinceModel *brProvinceModel = [[BRProvinceModel alloc]init];
                
                brProvinceModel.code = [NSString stringWithFormat:@"%@",provinceDic[@"code"]];
                
                brProvinceModel.name = [NSString stringWithFormat:@"%@",provinceDic[@"name"]];
                
                brProvinceModel.index = [provinceDic[@"id"] integerValue];
                
                
                //è§£æå¸
                
                NSMutableArray *brCityModelArr = [[NSMutableArray alloc]init];
                
                NSArray *cityArr = provinceDic[@"childs"];
                
                for (NSDictionary *cityDic in cityArr) {
                    
                    
                    BRCityModel *brCityModel = [[BRCityModel alloc]init];
                    
                    brCityModel.code = [NSString stringWithFormat:@"%@",cityDic[@"code"]];
                    
                    brCityModel.name = [NSString stringWithFormat:@"%@",cityDic[@"name"]];
                    
                    brCityModel.index = [cityDic[@"index"] integerValue];
                    
                    
                    //è§£æå°åº
                    
                    NSMutableArray *brAreaModelArr = [[NSMutableArray alloc]init];
                    
                    NSArray *areaArr = cityDic[@"childs"];
                    
                    for (NSDictionary *areaDic in areaArr) {
                        
                        BRAreaModel *brAreaModel = [[BRAreaModel alloc]init];
                        
                        brAreaModel.code = [NSString stringWithFormat:@"%@",areaDic[@"code"]];
                        
                        brAreaModel.name = [NSString stringWithFormat:@"%@",areaDic[@"name"]];
                        
                        brAreaModel.index = [areaDic[@"index"] integerValue];
                        
                        
                        [brAreaModelArr addObject:brAreaModel];
                        
                    }
                    
                    brCityModel.arealist = brAreaModelArr;
                    
                    
                }
                
                brProvinceModel.citylist = brCityModelArr;
                
                
               [brProvinceModelArr addObject:brProvinceModel];
            }
            
              
            addressModel.brProvincelist = brProvinceModelArr;
            
            
            return addressModel;
            
        }
    }
    
    return _addressModel;
}*/



@end
