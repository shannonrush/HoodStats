//
//  InfoViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/14/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    locations = [self locations];
}

# pragma mark UITableViewDelegate

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[self.visitDetailView.selectedVisitobjectForKey:@"device_details"] count];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    staticNSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCellalloc] initWithStyle:UITableViewCellStyleDefaultreuseIdentifier:CellIdentifier] autorelease];
//    }
//    NSDictionary *device = [[self.visitDetailView.selectedVisitobjectForKey:@"device_details"] objectAtIndex:[indexPath row]];
//    if ([[NSStringstringWithFormat:@"%@",[device valueForKey:@"inventory_id"]]length] > 0) {
//        cell.textLabel.text = [[device objectForKey:@"inventory"]valueForKey:@"identifier"];
//    } else {
//        cell.textLabel.text= [[deviceobjectForKey:@"old_inventory"]valueForKey:@"identifier"];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [selfselectedRowOrButton:indexPath];
//}

#pragma mark data collection

-(NSArray *)locations {
    
}


#pragma mark memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}



@end
