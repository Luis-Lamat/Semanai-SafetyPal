//
//  MapPin.h
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/24/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation>{
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
