//
//  MyTableController.m
//  ParseStarterProject
//
//  Created by James Yu on 12/29/11.
//

#import "MyTableController.h"
#import "DisplayTableViewCell.h"


@interface MyTableController ()

@property (nonatomic, weak) PFObject *currentGroup;
@property (nonatomic, strong) NSString *textHolder;
@property (nonatomic, strong) DisplayTableViewCell *currentCell;
@property (nonatomic, strong) DisplayTableViewCell *lastCell;
@property (nonatomic, weak) NSIndexPath *currentPath;
@property (nonatomic, weak) NSIndexPath *lastPath;

@end



@implementation MyTableController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Todo";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // The title for this table in the Navigation Controller.
        self.title = @"Todos";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
        //
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    //_currentGroup = [PFObject objectWithClassName:@"Groups"];
    self.currentGroup = [[PFUser currentUser]objectForKey:@"current"];
    
    [self loadObjects];
    NSLog(@"objecsts %@", self.objects);
    //[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    
    //Basic and works pulls in every single todo
    //PFQuery *query = [PFQuery queryWithClassName:@"Todo"];
    
    //IT ACTUALLY WORKS :D
    PFObject *currentGroup = [[PFUser currentUser] objectForKey:@"current"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Todo"];
    [query whereKey:@"group" equalTo:currentGroup];
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    [query whereKey:@"groupName" equalTo:@"VT Hacks"];
    [query includeKey:@"todos"];
    [query findObjectsInBackgroundWithBlock:<#^(NSArray *objects, NSError *error)block#>]
    */
    
    /*#2 option of getting the data
    PFQuery *query = [PFQuery queryWithClassName:@"Groups"];
    [query whereKey:@"groupName" equalTo:@"VT Hacks"];
    [query includeKey:@"todos"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.todoArray = objects;
        NSLog(@"%@", self.todoArray);
    }];
     */

    /*Not sure, trying it out
    PFQuery *query = [PFQuery queryWithClassName:@"Todo"];
    [query includeKey:@"group"];
    NSLog(@"%@", query);
    NSLog(@"This is the query%@", query);
    [query whereKey:@"group" equalTo:self.currentGroup];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@", objects);
    }];*/
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
 
    //you can change which column it sorts with
    [query orderByDescending:@"createdAt"];
 
    return query;
}



 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the first key in the object. 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 
    static NSString *CellIdentifier = @"displayCell";
    DisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    /*if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }*/
 
    // Configure the cell
    cell.customLabel.text = [object objectForKey:@"text"];
    if ([[object valueForKey:@"complete"]isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.checkImage.hidden = NO;
        NSLog(@"image code runs");
    }
    
    //check mark selector
    cell.checkButton.tag = indexPath.row;
    [cell.checkButton addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath { 
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row + 1) <= [self.objects count]) {
        return YES;
    }
    else {
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView reloadRowsAtIndexPaths: [tableView indexPathsForVisibleRows] withRowAnimation: UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        PFObject *object = [self.objects objectAtIndex: indexPath.row];
        [object deleteInBackgroundWithBlock: ^ (BOOL succeeded, NSError * error){
            [self loadObjects];
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Adding a todo
- (IBAction)add:(id)sender {
    
    NSLog(@"add");
    PFObject *currentGroup = [[PFUser currentUser]objectForKey:@"current"];
    
    //new todo
    PFObject *new = [PFObject objectWithClassName:@"Todo"];
    [new setObject:@"new todo" forKey:@"text"];
    [new setObject:@NO forKey:@"complete"];
    [new setObject:currentGroup forKey:@"group"];
    [new save];
    
    [self loadObjects];
    
    //[currentGroup addObject:new forKey:@"todos"];
}


#pragma mark - Editing Todos  (Table view delegate)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected a row at %i", indexPath.row);
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    _lastPath = _currentPath;
    _lastCell = _currentCell;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DisplayTableViewCell *todoCell = (DisplayTableViewCell *)cell;
    self.currentCell = todoCell;
    self.currentPath = indexPath;
  
    //starts the editing
    [todoCell startEditingCell];
    [todoCell.customField setDelegate:self];
}

/*
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (!_lastCell) {
        return YES;
    }
    NSLog(@"should End the Editing");
    [self updateTodoInParseWithCell:_lastCell andIndexPath:_lastPath];
    return YES;
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"should Return");
    [textField resignFirstResponder];
    
    [self updateTodoInParseWithCell:self.currentCell andIndexPath:_currentPath];
    return YES;
}

-(void)updateTodoInParseWithCell:(DisplayTableViewCell *)cell andIndexPath:(NSIndexPath *)path {
    
    [cell endEditingCell];
    
    PFObject *object =  [self.objects objectAtIndex:path.row];
    [object setObject:cell.customLabel.text forKey:@"text"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"the todo is now saved");
    }];
    
}


#pragma mark - checking off an item
- (void)check:(UIButton*)sender {
    NSLog(@"the check was tapped at index:%ld", (long)sender.tag);
    
    //gets the cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    DisplayTableViewCell *display = (DisplayTableViewCell *)cell;
    //gets the object
    PFObject *object = [self.objects objectAtIndex:sender.tag];
    
    //if yes
    if ([[object valueForKey:@"complete"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        //set to no
        display.checkImage.hidden = !display.checkImage.hidden;
        object[@"complete"] = @NO;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"success");
            }
        }];
        
    }
    
    //if no
    else {
        //set to yes
        display.checkImage.hidden = !display.checkImage.hidden;
        object[@"complete"] = @YES;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"success");
            }
        }];
    }
}



@end
