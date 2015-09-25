//
//  SelectRouteViewController.m
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/24/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import "SelectRouteViewController.h"
#import "ViewController.h"

@interface SelectRouteViewController ()

@property BOOL centeredOnce;

@end

@implementation SelectRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // adds tap recognizer to mapView
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tapRecognizer];

    // setting the map toggle
    self.centeredOnce = NO;
    
    // showing the user's location
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setDelegate:self];
    
    double lat = self.center.latitude;
    double lon = self.center.longitude;

    // failsafe for when center fails and is {0.0, 0.0}
    lat = (lat == 0.0) ? 25.6509241 : lat;
    lon = (lon == 0.0) ? -100.2890669 : lon;
    
    [self setMapLocationWithLat:lat lon:lon];
    
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
    [self.mapView setRegion:region animated:YES];
    
    [self addPinOnCenter:region.center title:@"Destino" subtitile:@""];
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
    [self.mapView addAnnotation:ann];
}

/*
 * mapView:didUpdateUserLocation:
 *
 * Delegate that gets called every time the user location is updated
 * @params aMapView that is the MKMapView and a MKUserLocation called aUserLocation
 */
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    
    // only animate once
    if (!self.centeredOnce) {
        
        // dont enter here again
        self.centeredOnce = YES;
        
        // pan to users location
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;

        region.span = span;
        region.center = location;
        [aMapView setRegion:region animated:YES];
    }
    
    NSLog(@"%f", self.mapView.userLocation.coordinate.longitude);
}

-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    
    pin.coordinate = tapPoint;
    
    [self.mapView addAnnotation:pin];
    self.selectedPoint = tapPoint;
}

#pragma mark - Navigation


/*
 * prepareForSegue
 *
 * Method that gets called if view will segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.selectedPoint.longitude != 0.0) {
        ViewController *vwMain = [segue destinationViewController];
        vwMain.selectedDestination = self.selectedPoint;
    }
}

@end
