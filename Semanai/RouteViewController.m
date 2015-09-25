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

- (void)notifyPolice {
    // add CIC REST API
    [self showPoliceNotifiedAlert];
    [self.lblPoliceOnItsWay setHidden:NO];
}

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
