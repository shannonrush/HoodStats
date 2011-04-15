//
//  InfoViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/14/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "InfoViewController.h"
#import "HoodStatsAppDelegate.h"

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    locations = [[NSArray alloc]initWithArray:[self locations]];
}

# pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [locations count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSManagedObject *location = [locations objectAtIndex:section];
    NSString *header = [NSString stringWithFormat:@"%@, %@",[location valueForKey:@"city"],[location valueForKey:@"state"]];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSManagedObject *location = [locations objectAtIndex:section];
    NSSet *historyItems = [location valueForKeyPath:@"HistoryItems"];
    return [historyItems count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSManagedObject *location = [locations objectAtIndex:indexPath.section];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"label" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *historyItems = [[location valueForKeyPath:@"HistoryItems"] sortedArrayUsingDescriptors:sortDescriptors];
    NSManagedObject *item = [historyItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [item valueForKey:@"label"];
    cell.detailTextLabel.text = [item valueForKey:@"value"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark data collection

-(NSArray *)locations {
    HoodStatsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [request setEntity:entityDesc];
	[request setSortDescriptors:[NSArray arrayWithObject:dateSort]];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    [request release];
    [dateSort release];
    return objects;
}

#pragma mark navigation

-(IBAction)loadMainScreen {
    [self.parentViewController dismissModalViewControllerAnimated: YES];
}


#pragma mark memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    locations = nil;
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
