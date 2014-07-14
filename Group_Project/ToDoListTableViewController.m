//
//  ToDoListTableViewController.m
//  to_do
//
//  Created by White, Jordan on 6/14/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "AddToDoViewController.h"
#import "ToDoList.h"
#import "ToDoItem.h"


@interface ToDoListTableViewController ()

@property EditTableViewCell *currentCell;

@end


@implementation ToDoListTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
    //pulls in the sourceViewController
    AddToDoViewController *source = [segue sourceViewController];
    //pulls in the toDoItem of the vc
    ToDoItem *item = source.toDoItem;
    
    if (item != nil) {
        [[ToDoList defaultToDoList]createBlank];
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setDelegate:self];
    
    [[ToDoList defaultToDoList] createBlank];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"numberOfSectionsInTableView:");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"tableView: numberOfRowsInSection:");
    // Return the number of rows in the section.
    
    return [[[ToDoList defaultToDoList]publicToDos]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView:cellForRowAtIndexPath:");
    
    static NSString *cellIdentifier = @"EditTableViewCell";
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    NSArray *todoList = [[ToDoList defaultToDoList]publicToDos];
    ToDoItem *todo = todoList[indexPath.row];
    [cell setUpCell:cell withToDo:todo];
    
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
   
    [self.currentCell endEditingForCellAt:_indexOfCurrentCell];
    [textField resignFirstResponder];
    
    [self.tableView reloadData];
    return YES;
}


- (void)dismissAKeyboard {
    [self.currentCell.editField resignFirstResponder];
}

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

@end
