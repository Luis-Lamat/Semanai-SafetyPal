//
//  ViewController.m
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/22/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import "ViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapType = 0;
    
    [_mapView setShowsUserLocation:YES];
    [_mapView setDelegate:self];
    
    NSLog(@"%@",_mapView.userLocation.location);
    
    // centers on user location
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    [self paintMapType];
    // [self.view addSubview:mapView];
    // [self setMapLocationWithLat:25.6509241 lon:-100.2890669];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMapLocationWithLat:(double)lat lon:(double)lon {
    
    // setting map center
    MKCoordinateRegion region = { {0.0, 0.0}, {0.0, 0.0} };
    region.center.latitude = lat;
    region.center.longitude = lon;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [_mapView setRegion:region animated:YES];
    
    [self addPinOnCenter:region.center title:@"Ejemplo" subtitile:@"Simple"];
}

- (void)addPinOnCenter:(CLLocationCoordinate2D)center
                 title:(NSString *)title subtitile:(NSString *)subtitle {
    MapPin *ann = [[MapPin alloc] init];
    ann.title = title;
    ann.subtitle = subtitle;
    ann.coordinate = center;
    [_mapView addAnnotation:ann];
}

- (void)paintMapType {
    switch (self.mapType) {
        case 0:
            _mapView.mapType = MKMapTypeStandard;
            break;
            
        case 1:
            _mapView.mapType = MKMapTypeHybrid;
            break;
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (IBAction)unwindMenu:(UIStoryboardSegue *)segue {
    
}

- (IBAction)locPressed:(id)sender {
    
}

@end
