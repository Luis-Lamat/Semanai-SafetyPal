//
//  ViewController.h
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/22/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "MapPin.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    MKMapView *mapView;
}

// outlets / values
@property (weak, nonatomic) IBOutlet UIButton *btnStartRoute;
@property(strong, nonatomic) IBOutlet MKMapView *mapView;
@property(strong, nonatomic) CLLocationManager *locationManager;

@property int mapType;
@property NSTimeInterval routeETA;
@property CLLocationCoordinate2D selectedDestination;

// actions
- (IBAction)locPressed:(id)sender;
- (IBAction)startRoutePressed:(id)sender;


@end