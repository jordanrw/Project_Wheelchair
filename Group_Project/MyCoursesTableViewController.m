//
//  MyCoursesTableViewController.m
//  Group_Project
//
//  Created by White, Jordan on 7/30/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "MyCoursesTableViewController.h"
#import "Course.h"

@interface MyCoursesTableViewController ()

@end

@implementation MyCoursesTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self download];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getting newly added courses
- (void)sendBackCourse:(Course *)aCourse {
    
}

- (void)sendBackPFCourse:(PFObject *)aCourse {
    [self upload:aCourse];
    
    
}


#pragma mark - download  & uploading data
- (void)download {

}

- (void)upload:(PFObject*)newCourse {
    
    [newCourse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            PFUser *user = [PFUser currentUser];
            PFRelation *relationship = [user relationForKey:@"myCourses"];
            [relationship addObject:newCourse];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"successfully uploaded to server");
                    [self.myCourses addObject:newCourse];
                    [self.tableView reloadData];
                }
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"unable to reach server to save course \n please check your internet connection." delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
    }];
    
}



#pragma mark - Basic VC stuff
- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addCourse:(id)sender {
    
    UINavigationController *addCourseVC = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"addC"];
    
    //just get to the subview to access it properly
    AddCourseViewController *vc = [addCourseVC.childViewControllers objectAtIndex:0];
    vc.delegate = self;
    [self presentViewController:addCourseVC animated:YES completion:nil];
    
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"number: %lu", (unsigned long)[self.myCourses count]);
    return [self.myCourses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"course" forIndexPath:indexPath];
    PFObject *course = [self.myCourses objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@", [course objectForKey:@"title"]];
    NSString *subtitle = [ NSString stringWithFormat:@"%@ %@ (CRN: %@)", [course objectForKey:@"course"], [course objectForKey:@"num"], [course objectForKey:@"CRN"] ];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO - implement a way to remove yourself from that class, and it removes it on parse
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"delete");
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"remove";
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
