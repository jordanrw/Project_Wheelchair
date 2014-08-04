//
//  ToDoListTableViewController.m
//  to_do
//
//  Created by White, Jordan on 6/14/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "ToDoListTableViewController.h"

@interface ToDoListTableViewController ()

@property EditTableViewCell *currentCell;

@end


@implementation ToDoListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    NSLog(@"list view loaded");
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setDelegate:self];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
        //TODO - why is this line saying VT Hacks, and hard coded in there?
        [query whereKey:@"groupName" equalTo:@"VT Hacks"];
        [query includeKey:@"todos"];  //this is the golden line
        NSLog(@"This prints out the query%@", query);
        self.todoArray = [query findObjects];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.todoArray = [[objects objectAtIndex:0]objectForKey:@"todos"];
            NSLog(@"The array of todos:%@", self.todoArray);
            NSLog(@"The real number :%lu", (unsigned long)[self.todoArray count]);
            
            [self.tableView reloadData];
        }];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (![PFUser currentUser]) {
        return 3;
    }
    
    NSLog(@"The number of rows is this :%lu", (unsigned long)[self.todoArray count]);
    return [self.todoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"tableView:cellForRowAtIndexPath:");
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell" forIndexPath:indexPath];
    
    if (![PFUser currentUser]) {
        cell.customLabel.text = @"join group";
        return cell;
    }
    
    PFObject *todo = self.todoArray[indexPath.row];
    NSLog(@"todo item %@", todo);
    
    cell.customLabel.text = [todo objectForKey:@"text"];
    
    /*
    if (indexPath.row <= [self.todoArray count]-1) {
        static NSString *cellIdentifier = @"EditTableViewCell";
        EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.customLabel.backgroundColor = [UIColor clearColor];

        PFObject *todo = self.todoArray[indexPath.row];
        [cell setUpCell:cell withToDo:todo];
        
        return cell;
    }
    else {
        NSLog(@"else index path is greater and this has run");
        
        static NSString *cellIdentifier = @"addCell";
        EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
     */
    return cell;
}

#pragma mark - Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:didSelectRowAtIndexPath:");
    
    //casting the TableViewCell as a EditTableViewCell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.currentCell = (EditTableViewCell *)cell;

    //update property
    self.indexOfCurrentCell = indexPath;
    
    //set delegates
    [self.currentCell startEditingWithDelegate:self];
    [self.currentCell.editField setDelegate:self];
    
     /* The stuff for resigning keyboard when you go to another textfield
     if (self.currentCell != nil) {
        
         [self.currentCell endEditingForCellAt:indexPath];
         [self.currentCell.editField resignFirstResponder];
        
         [self.tableView reloadData];
     }*/
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
   
    [self.currentCell endEditingForTodo:[self.todoArray objectAtIndex:_indexOfCurrentCell.row] At:_indexOfCurrentCell];
    [textField resignFirstResponder];
    
    [self.tableView reloadData];
    return YES;
}


- (void)dismissAKeyboard {
    [self.currentCell.editField resignFirstResponder];
}

#pragma mark - important, and just commented out for now, to hopefully get it running
/*
#pragma mark - Deleting
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *todos = [[ToDoList defaultToDoList]publicToDos];
        ToDoItem *todo = [todos objectAtIndex:indexPath.row];
        
        [[ToDoList defaultToDoList]removeToDo:todo];
        
        //Also remove that row from the tableview with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"remove";
}

#pragma mark - Editing the Table
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ([[[ToDoList defaultToDoList]publicToDos]count] - 1)) {
        return  NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [[ToDoList defaultToDoList]moveToDoAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.row == ([[[ToDoList defaultToDoList]publicToDos]count] - 1)) {
        return sourceIndexPath;
    }
    else if (proposedDestinationIndexPath.row == ([[[ToDoList defaultToDoList]publicToDos]count] - 1)) {
        return sourceIndexPath;
    }
    else {
        return proposedDestinationIndexPath;
    }
}

*/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
