//
//  XMFAddressManager.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAddressManager.h"
#import "BRAddressModel.h"


#define addressInfoKey  @"addressInfo"

//在.m文件中添加
@interface  XMFAddressManager()

@property(nonatomic,strong) YYCache *addressCache;//YYCache对象

@property(nonatomic,strong) NSMutableDictionary *addressInfoDict;//地址信息字典



@end

@implementation XMFAddressManager

//重写init方法
-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.addressCache = [[YYCache alloc]initWithName:@"app.addressInfo"];
    }
    
    return self;
}

#pragma mark - 单例 - 创建管理对象
+(instancetype)shareManager{
    static XMFAddressManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[XMFAddressManager alloc]init];
    });
    
    return instance;
    
}


#pragma mark - ——————— 存储地址信息 ————————

-(void)updateAddressInfo:(id)addressInfo{
    
    [self.addressCache setObject:addressInfo forKey:addressInfoKey];
}


#pragma mark - ——————— 清除地址信息 ————————

-(void)removeAddressInfo{
    
    [self.addressCache removeObjectForKey:addressInfoKey];
}

#pragma mark - 是否存在用户信息
-(BOOL)isContainsAddressInfo{
    
    //判断缓存是否存在
    if ([self.addressCache containsObjectForKey:addressInfoKey]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
    
}

#pragma mark - ——————— 获取省级名称 ————————
-(NSString *)getProvinceName:(NSString *)provinceCode{
    
    NSString *provinceNameStr = @"";
    
    for (BRProvinceModel *provinceModel in self.addressModel.provincelist) {
        
        //省级code相同
        if ([provinceModel.code isEqualToString:provinceCode]) {
            
            provinceNameStr = provinceModel.name;
            
            return provinceNameStr;
            
        }
        
        
    }
    
     return provinceNameStr;
    
}

#pragma mark - ——————— 获取城市名称 ————————
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


#pragma mark - ——————— 获取区级名称 ————————

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


#pragma mark - ——————— 假懒加载 ————————
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
            
            
            //解析省
            
            NSMutableArray *brProvinceModelArr = [[NSMutableArray alloc]init];
            
            for (XMFBRProvinceModel *provinceModel in model.provincelist) {
                
                
                BRProvinceModel *brProvinceModel = [[BRProvinceModel alloc]init];
                
                brProvinceModel.code = provinceModel.code;
                
                brProvinceModel.name = provinceModel.name;
                
                brProvinceModel.index = provinceModel.index;
                
                
                //解析市
                
                NSMutableArray *brCityModelArr = [[NSMutableArray alloc]init];
                
                for (XMFBRCityModel *cityModel in provinceModel.citylist) {
                    
                    
                    BRCityModel *brCityModel = [[BRCityModel alloc]init];
                    
                    brCityModel.code = cityModel.code;
                    
                    brCityModel.name = cityModel.name;
                    
                    brCityModel.index = cityModel.index;
                    
                    
                    //解析地区
                    
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
            
            //解析省
            
            NSMutableArray *brProvinceModelArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary *provinceDic in dataArr) {
                
                
                BRProvinceModel *brProvinceModel = [[BRProvinceModel alloc]init];
                
                brProvinceModel.code = [NSString stringWithFormat:@"%@",provinceDic[@"code"]];
                
                brProvinceModel.name = [NSString stringWithFormat:@"%@",provinceDic[@"name"]];
                
                brProvinceModel.index = [provinceDic[@"id"] integerValue];
                
                
                //解析市
                
                NSMutableArray *brCityModelArr = [[NSMutableArray alloc]init];
                
                NSArray *cityArr = provinceDic[@"childs"];
                
                for (NSDictionary *cityDic in cityArr) {
                    
                    
                    BRCityModel *brCityModel = [[BRCityModel alloc]init];
                    
                    brCityModel.code = [NSString stringWithFormat:@"%@",cityDic[@"code"]];
                    
                    brCityModel.name = [NSString stringWithFormat:@"%@",cityDic[@"name"]];
                    
                    brCityModel.index = [cityDic[@"index"] integerValue];
                    
                    
                    //解析地区
                    
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
