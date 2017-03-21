//
//  LZCLGeocoderManager.m
//  MapDemo01
//
//  Created by goldeneye on 2017/3/20.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "LZCLGeocoderManager.h"
#import <CoreLocation/CoreLocation.h>


static LZCLGeocoderManager * manager = nil;
static CLGeocoder * geocoder   = nil;


@implementation LZCLGeocoderManager



+ (LZCLGeocoderManager *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LZCLGeocoderManager alloc]init];
        geocoder = [[CLGeocoder alloc]init];
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
    
    CLLocation * newLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        NSLog(@"--array--%d---error--%@ placemarks = %@",(int)placemarks.count,error,placemarks);
        if (error != nil ||  placemarks.count == 0) {
            if (failure) {
                failure(error);
            }
        }else{
            if (placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                NSLog(@"place===%@ address = %@",[placemark locality],[placemark addressDictionary]);
                NSString *city = placemark.administrativeArea;
                NSLog(@"位于:%@",city);
                NSLog(@"%@",placemark.addressDictionary[@"Name"]);
                
                if (success) {
                    success(placemark.addressDictionary[@"Name"]);
                }
            }
        }
    }];
}
/**
 *  地理编码：地名 —>经纬度坐标
 *
 *  @param addressString   地名
 *  @param success     成功回掉
 *  @param failure     失败回掉
 */
- (void)geocodeAddressWithAddressString:(NSString *)addressString  withSuccess:(void (^)(CGFloat latitude,CGFloat longitude))success failure:(void(^)())failure{
    NSLog(@"error=========addressString=%@",addressString);
    
    
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray* placemarks, NSError* error){
    
        NSLog(@"geocoder error =====%@ 我进来了我进来了",error);
        if (!error) {
            if (placemarks.count>0) {
                for (CLPlacemark* aPlacemark in placemarks)
                {
                    NSLog(@"place--%@", [aPlacemark locality]);
                    NSLog(@"lat--%f--lon--%f",aPlacemark.location.coordinate.latitude,aPlacemark.location.coordinate.longitude);
                    if (success) {
                        success(aPlacemark.location.coordinate.latitude,aPlacemark.location.coordinate.longitude);
                    }
                    
                   // return ;
                }
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }
        else{
            if (failure) {
                failure(error);
            }
            NSLog(@"error--%@",[error localizedDescription]);
        }
    }];
    
}

- (void)test{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"重庆市渝北区机场立交桥" completionHandler:^(NSArray* placemarks, NSError* error){
        if (!error) {
            
            for (CLPlacemark* aPlacemark in placemarks)
            {
                NSLog(@"place--%@", [aPlacemark locality]);
                NSLog(@"lat--%f--lon--%f",aPlacemark.location.coordinate.latitude,aPlacemark.location.coordinate.longitude);
            }
        }
        else{
            
            NSLog(@"error--%@",[error localizedDescription]);
        }
    }];
    
}

@end
