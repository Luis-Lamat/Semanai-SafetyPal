//
//  ContactsViewController.h
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/25/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
