//
//  MenuViewController.m
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/23/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *vwDestination = [segue destinationViewController];
    vwDestination.mapType = (int)[self.sgtMapType selectedSegmentIndex];
}

@end
