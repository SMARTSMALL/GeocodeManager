//
//  LZCLGeocoderManager.h
//  MapDemo01
//
//  Created by goldeneye on 2017/3/20.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define GeocoderManager [LZCLGeocoderManager shareManager]

@interface LZCLGeocoderManager : NSObject
/**  单利模式 **/
+ (LZCLGeocoderManager *)shareManager;
/**
 *  地理编码：经纬度坐标—>地名
 *
 *  @param latitude    经度
 *  @param longitude   纬度
 *  @param success     成功回掉
 *  @param failure     失败回掉
 */
- (void)geocodeAddressWithLatitude:(CGFloat)latitude withLongitude:(CGFloat)longitude withSuccess:(void (^)(NSString * address))success failure:(void(^)())failure;
/**
 *  地理编码：地名 —>经纬度坐标
 *
 *  @param addressString   地名
 *  @param success     成功回掉
 *  @param failure     失败回掉
 */
- (void)geocodeAddressWithAddressString:(NSString *)addressString  withSuccess:(void (^)(CGFloat latitude,CGFloat longitude))success failure:(void(^)())failure;

@end
