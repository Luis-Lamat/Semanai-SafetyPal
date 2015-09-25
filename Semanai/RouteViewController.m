//
//  RouteViewController.m
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/24/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController ()

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // hide the police notified label
    [self.lblPoliceOnItsWay setHidden:YES];
    
    // calculate minutes
    int min = (int) ceil(self.minutes / 60);
    
    // only works for less than 59 minutes of walking
    NSString *format = (min < 10) ? @"00:0%d" : @"00:%d";
    self.lblETA.text = [NSString stringWithFormat:format, min];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * emergencyPressed:
 *
 * Method that fires when the emergency hand button is pressed
 * @param sender is the button that calls the action
 */
- (IBAction)emergencyPressed:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"¡Emergencia!"
                                message:@"Se contactará a la policia, estás seguro? (Falsas alarmas obtienen multa)."
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"Confirmar"
                         style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self notifyPolice];
                         }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancelar"
                             style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
/*
 * notifyPolice:
 *
 * Method that notifies the local police of any danger. It also creates a report
 * int the CIC platform of Monterrey, MX
 */
- (void)notifyPolice {
    [self submitCICReport]; // CIC REST API
    [self showPoliceNotifiedAlert];
    [self.lblPoliceOnItsWay setHidden:NO];
}

/*
 * showPoliceNotifiedAlert:
 *
 * Method that shows an alert that tells the user that the police has already
 * been notified of the emergency.
 */
- (void)showPoliceNotifiedAlert {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Policía en Camino"
                                message:@"La policía local ya está en camino. Se le notificó a los usuarios de los alrededores."
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
 * showShakeAlert:
 *
 * Method that shows an alert when the iPhone is shaken.
 */
- (void)showShakeAlert {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"IMPORTANTE: ¿Estás Bien?"
                                message:@"Se detectó actividad brusca, en 20 segundos se le llamará a la policia"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"¡Ayuda!"
                         style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self notifyPolice];
                         }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Estoy Bien"
                             style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
 * submitCICReport
 *
 * Method that submits via POST method the json data of the problem
 * the user is having. Defaults to a template message.
 */
- (void)submitCICReport{
    NSString *lat = [NSString stringWithFormat:@"%.5f", self.usersLocation.latitude];
    NSString *lon = [NSString stringWithFormat:@"%.5f", self.usersLocation.longitude];
    NSArray *keys = [NSArray arrayWithObjects:@"format", @"account", @"title",
                     @"content", @"first_name", @"last_name", @"lat", @"lon",
                     @"category", nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:@"json", @"nl", @"Alerta de SafetyPal",
                        @"El usuario de la aplicación no responde", @"Safety", @"Pal",
                        lat, lon, @"ACCIDENTE", nil];
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&error];
    
    // print the data to console to check if its correct
    NSString *strPostData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\nJSON Data: \n %@", strPostData);
    
    // init the URL and the request objects
    NSURL *url = [NSURL URLWithString:@"http://api.cic.mx/0/nl/reports.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:60.0];
    
    // init the session object
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    // setting the request body and headers
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    // send the data with a callback block
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"\n\nResponse: \n %@", response);
    }];
    
    // IDK what this is for...
    [postDataTask resume];
}

#pragma mark - Shake Functions

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:NO];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake ){
        // shaking has began.
    }
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake ){
        // shaking has ended
        [self showShakeAlert];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
