//
//  SelectRouteViewController.h
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/24/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"

@interface SelectRouteViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property(nonatomic, strong) IBOutlet MKMapView *mapView;
@property(nonatomic, strong) CLLocationManager *locationManager;

@property CLLocationCoordinate2D selectedPoint;
@property CLLocationCoordinate2D center;

@end
