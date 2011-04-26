//
//  InfoViewController.m
//  HoodStats
//
//  Created by Shannon Rush on 4/14/11.
//  Copyright 2011 Rush Devo. All rights reserved.
//

#import "InfoViewController.h"
#import "HoodStatsAppDelegate.h"
#import "GalleryViewController.h"

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
    NSManagedObject *sectionLocation = [locations objectAtIndex:section];
    NSString *header = [NSString stringWithFormat:@"%@, %@",[sectionLocation valueForKey:@"city"],[sectionLocation valueForKey:@"state"]];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSManagedObject *sectionLocation = [locations objectAtIndex:section];
    NSSet *historyItems = [sectionLocation valueForKeyPath:@"HistoryItems"];
    NSSet *photos = [sectionLocation valueForKey:@"Photos"];
    if ([photos count]>0) {
        return [historyItems count]+1;
    } else {
        return [historyItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSManagedObject *sectionLocation = [locations objectAtIndex:indexPath.section];
    if ([[sectionLocation valueForKey:@"HistoryItems"]count]<=[indexPath row]) {
        cell.textLabel.text = @"Photos";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Your photos taken in %@",[sectionLocation valueForKey:@"city"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"label" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [sortDescriptor release];
        NSArray *historyItems = [[sectionLocation valueForKeyPath:@"HistoryItems"] sortedArrayUsingDescriptors:sortDescriptors];
        NSManagedObject *item = [historyItems objectAtIndex:[indexPath row]];
        cell.textLabel.text = [item valueForKey:@"label"];
        cell.detailTextLabel.text = [item valueForKey:@"value"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Photos"]) {
        // load galleryView
        GalleryViewController *gallery = [[GalleryViewController alloc]initWithNibName:@"GalleryViewController" bundle:[NSBundle mainBundle]];
        gallery.selectedLocation = [locations objectAtIndex:[indexPath section]];
        [self presentModalViewController:gallery animated:YES];
        [gallery release];
    }
}

#pragma mark data collection



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
