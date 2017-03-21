
//
//  LZAMapSearchManager.m
//  MapDemo01
//
//  Created by goldeneye on 2017/3/20.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "LZAMapSearchManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapSearchKit/AMapSearchKit.h>

static LZAMapSearchManager * manager = nil;
static AMapSearchAPI * mapSearch   = nil;

@interface LZAMapSearchManager()<AMapSearchDelegate>


@property(nonatomic,copy)void (^GeocodeAddressSuccess)(CGFloat latitude , CGFloat longitude);

@property(nonatomic,copy)void (^GeocodeAddressFinished)(NSString *address);

@end

@implementation LZAMapSearchManager

+ (LZAMapSearchManager *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LZAMapSearchManager alloc]init];
        mapSearch =  [[AMapSearchAPI alloc] init];
        
    });
    
    return manager;
}

/**
 *  地理编码：经纬度坐标—>地名
 *
 *  @param latitude    经度
 *  @param longitude   纬度
 *  @param success     成功回掉
 *  @param failure     失败回掉
 */
- (void)geocodeAddressWithLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude withSuccess:(void (^)(NSString * address))success failure:(void(^)())failure{
    
    mapSearch.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeo.requireExtension = YES;
    
    [mapSearch AMapReGoecodeSearch:regeo];
    
    self.GeocodeAddressFinished = success;
    
}
/**
 *  地理编码：地名 —>经纬度坐标
 *
 *  @param addressString   地名
 *  @param success     成功回掉
 *  @param failure     失败回掉
 */
- (void)geocodeAddressWithAddressString:(NSString *)addressString  withSuccess:(void (^)(CGFloat latitude,CGFloat longitude))success failure:(void(^)())failure{
    
    
    mapSearch.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = addressString;
    [mapSearch AMapGeocodeSearch:geo];
    self.GeocodeAddressSuccess = success;
    
}
/**
 * @brief 地理编码查询回调函数
 * @param request  发起的请求，具体字段参考 AMapGeocodeSearchRequest 。
 * @param response 响应结果，具体字段参考 AMapGeocodeSearchResponse 。
 */
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    
    
    if (response.geocodes.count == 0)
    {
        return;
    }else{
        
        AMapGeocode * code = response.geocodes[0];
        
        if (self.GeocodeAddressSuccess) {
            self.GeocodeAddressSuccess(code.location.latitude,code.location.longitude);
        }
        
    
        NSLog(@"formattedAddress===%@",code.formattedAddress);
        //        for (AMapGeocode * code in response.geocodes) {
        //            NSLog(@"code.formattedAddress===%@",code.formattedAddress);
        NSLog(@"code.location.latitude-====%lf code.location.longitude===%lf ",code.location.latitude,code.location.longitude);
        //
        //        }
        
    }
    
    
    
    
    NSLog(@"response.geocodes=========%@",response.geocodes);
    
    //解析response获取地理信息，具体解析见 Demo
}

/**
 * @brief 逆地理编码查询回调函数
 * @param request  发起的请求，具体字段参考 AMapReGeocodeSearchRequest 。
 * @param response 响应结果，具体字段参考 AMapReGeocodeSearchResponse 。
 */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
  

    
    if (response.regeocode != nil)
    {
        
        if (self.GeocodeAddressFinished) {
            self.GeocodeAddressFinished(response.regeocode.formattedAddress);
            
        }
    
    
    }else{
    
    }
}



@end
