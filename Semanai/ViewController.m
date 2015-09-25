//
//  ViewController.m
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/22/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import "ViewController.h"
#import "SelectRouteViewController.h"
#import "RouteViewController.h"
#import <QuartzCore/QuartzCore.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()

@end

@implementation ViewController

@synthesize mapView = _mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // round and hide the start route button
    self.btnStartRoute.layer.cornerRadius = 10;
    self.btnStartRoute.clipsToBounds = YES;
    [self.btnStartRoute setHidden:YES];
    
    // setting the map type to standard
    self.mapType = 0;
    
    // showing the user's location
    [_mapView setShowsUserLocation:YES];
    [_mapView setDelegate:self];
    
    // centers on user location
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"%f", self.mapView.userLocation.coordinate.longitude);
    [self paintMapType];
    // [self.view addSubview:mapView];
    // [self setMapLocationWithLat:25.6509241 lon:-100.2890669]; // Tec Adsress
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * setMapLocationWithLat:lon:
 *
 * Centers map on a given latitude and longitude
 * @param "lat" and "lon" which are the coordinates in double type.
 */
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

/*
 * addPinOnCenter
 *
 * Method to add a pin on a specified center location
 * @param a CLLocationCoordinate2D called center
 */
- (void)addPinOnCenter:(CLLocationCoordinate2D)center
                 title:(NSString *)title subtitile:(NSString *)subtitle {
    MapPin *ann = [[MapPin alloc] init];
    ann.title = title;
    ann.subtitle = subtitle;
    ann.coordinate = center;
    [_mapView addAnnotation:ann];
}

/*
 * paintMapType
 *
 * Method that paints the map type according to the self.mapType property
 * set in the viewDidLoad method. 0 = std, 1 = hybrid;
 */
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

/*
 * mapView:didUpdateUserLocation:
 *
 * Delegate that gets called every time the user location is updated
 * @params aMapView that is the MKMapView and a MKUserLocation called aUserLocation
 */
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.03;
    span.longitudeDelta = 0.03;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
    NSLog(@"%f", self.mapView.userLocation.coordinate.longitude);
}

/*
 * drawPathFrom
 *
 * Draw a path between two CLLocationsCoordinate2D's
 * @params loc1 and loc2 are the CLL..2D's
 */
- (void)drawPathFrom:(CLLocationCoordinate2D) loc1 to:(CLLocationCoordinate2D) loc2 {
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:loc1
                                               addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:loc2
                                                    addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // NSLog(@"response = %@",response);
        NSArray *arrRoutes = [response routes];
        
        // setting the route estimated time of arrival
        self.routeETA = [[arrRoutes firstObject] expectedTravelTime];
        NSLog(@"Route ETA: %f", [[arrRoutes firstObject] expectedTravelTime]);
        
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            [self.mapView addOverlay:line]; // this fires the methos below
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
            NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    }];
}

/*
 * mapView:viewForOverlay:
 *
 * Delegate that gets called when we want to draw a path with the "addOverlay" method
 * @params mapView that is the MKMapView and a MKPolyline called overlay
 */
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 15;
        return aView;
    }
    return nil;
}

/*
 * locationManager:didFailWithError
 *
 * Method that gets called if a locationManager gets an error due
 * to WiFi problems or other reasons. Prints the error in console.
 */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

/*
 * startRoutePressed:
 *
 * Method that gets called if the btnStartRoute button is pressed.
 * @param "sender" is the button itself.
 */
- (IBAction)startRoutePressed:(id)sender {
    
}

// ignore this method for now
- (IBAction)locPressed:(id)sender{}


#pragma mark - Navigation

/*
 * prepareForSegue
 *
 * Method that gets called if view will segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[SelectRouteViewController class]]) {
        SelectRouteViewController *vwDestination = [segue destinationViewController];
        vwDestination.center = self.mapView.userLocation.coordinate;
    }
    else if ([segue.destinationViewController isKindOfClass:[RouteViewController class]]) {
        RouteViewController *vwDestination = [segue destinationViewController];
        vwDestination.minutes = self.routeETA;
    }
}


/*
 * unwindSelectRoute
 *
 * Method that gets called when you exit the route selection
 */
- (IBAction)unwindSelectRoute:(UIStoryboardSegue *)segue {
    if (self.selectedDestination.longitude != 0.0) {
        [self addPinOnCenter:self.selectedDestination title:@"Destino" subtitile:@""];
        [self drawPathFrom:self.mapView.userLocation.coordinate to:self.selectedDestination];
        [self.btnStartRoute setHidden:NO];
    }
}

/*
 * unwindMenu
 *
 * Method that gets called when you exit the menu. Does nothing.
 */
- (IBAction)unwindMenu:(UIStoryboardSegue *)segue {
    
}


@end
