//
//  RouteViewController.h
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/24/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteViewController : UIViewController

// outlets / values
@property (weak, nonatomic) IBOutlet UILabel *lblETA;
@property (weak, nonatomic) IBOutlet UILabel *lblPoliceOnItsWay;
@property double minutes;

// actions
- (IBAction)emergencyPressed:(id)sender;


@end
