//
//  ContactsViewController.m
//  Semanai
//
//  Created by Luis Alberto Lamadrid on 9/25/15.
//  Copyright © 2015 Luis Alberto Lamadrid. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@property (nonatomic, strong) NSMutableArray *contacts;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.contacts = [[NSMutableArray alloc]
                     initWithObjects:@"Mara Culebro", @"Gustavo García",
                     @"Andrés Peña", @"Jorge Ragal", @"Luis Lamadrid", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Items

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.contacts objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *label = cell.textLabel.text;
    NSString *firstLetter = [label substringToIndex:2];
    if ([firstLetter isEqualToString:@"👉"]) {
        cell.textLabel.text = [label substringFromIndex:3];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @"👉", label];
    }
    cell.backgroundColor = [UIColor whiteColor];
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
