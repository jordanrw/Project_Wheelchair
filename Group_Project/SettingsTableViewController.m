//
//  SettingsTableViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/26/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "LoginViewController.h"
#import "JoinViewController.h"
#import "CreateViewController.h"
#import <Parse/Parse.h> 

@interface SettingsTableViewController () <CreateGroupDelegate>

@property BOOL hasShown;
@property (nonatomic, strong) UIAlertView *confirm;

@property (nonatomic, weak) NSArray *groupsOfUser;
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation SettingsTableViewController

#pragma mark - Initial View Setup
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    [self refreshArray];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup:)];
    self.navigationItem.rightBarButtonItem = add;
    
    /*Broken implementation of a customized group title
    if ([PFUser currentUser]) {
        
        NSMutableString *name = [[PFUser currentUser] objectForKey:@"username"];
        [name appendString:@"Groups"];
        self.navigationController.title = name;
    }*/
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    [self loginOrLogout];
}

- (void)loginOrLogout {
    if (![PFUser currentUser]) {
        UIBarButtonItem *signup = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(signnnup:)];
        self.navigationItem.leftBarButtonItem = signup;
    }
    else {
        UIBarButtonItem *logout = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logggout:)];
        self.navigationItem.leftBarButtonItem = logout;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser] && !_hasShown) {
        _hasShown = YES;
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark - Signup || Loggout
- (IBAction)signnnup:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (IBAction)logggout:(id)sender {
    _confirm = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out", nil];
    [_confirm show];
}

#pragma mark UIAlertviewDelegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [_confirm firstOtherButtonIndex]) {
        [PFUser logOut];
        
        //changes it back after [logging out]
        UIBarButtonItem *signup = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(signnnup:)];
        self.navigationItem.leftBarButtonItem = signup;
    }
}


#pragma mark - Action Sheet for creating group
- (void)addGroup:(id)sender {
    if ([PFUser currentUser]) {
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Join a Group", @"Create a Group", nil];
    [action showInView:self.view];
    }
    else {
        UIAlertView *loginTo = [[UIAlertView alloc]initWithTitle:@"Joining or Creating a Group" message:@"You need to login first." delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
        [loginTo show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"Join a Group");
        JoinViewController *joinVC = (JoinViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"join"];
        [self presentViewController:joinVC animated:YES completion:nil];
    
    }
    else if (buttonIndex == 1) {
        NSLog(@"Create a Group");
        CreateViewController *createVC = (CreateViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"create"];
        createVC.creationDelegate = self;
        [self presentViewController:createVC animated:YES completion:nil];
        
    }
}

#pragma mark - Refresh array
- (void)refreshArray {
    
    PFRelation *relation = [[PFUser currentUser]relationForKey:@"myGroups"];
    PFQuery *queryOfRelation = [relation query];
    self.groupsOfUser = [queryOfRelation findObjects];
    
    
    NSMutableArray *titles = [[NSMutableArray alloc]init];
    for (PFObject *object in self.groupsOfUser) {
        NSString *name = [object objectForKey:@"groupName"];
        [titles addObject:name];
    }
    NSLog(@"all the titles%@", titles);
    self.titles = titles;
    NSLog(@"the property %@", self.titles);
    
    //[NSNotificationCenter defaultCenter] postNotificationName:<#(NSString *)#> object:<#(id)#>];
    //[NSNotificationCenter defaultCenter] addObserver:<#(id)#> selector:<#(SEL)#> name:<#(NSString *)#> object:<#(id)#>
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    //PFQuery *groupQuery = [PFQuery queryWithClassName:@"Todo"];
    //groupQuery
    //this query pulls in the number of groups associated
    
    return [self.groupsOfUser count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"UITableViewCell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    //cell.backgroundColor = [UIColor redColor];
   
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"leave group";
}

#pragma mark - Create Group (Custom Delegate methods)

- (void)createGroupCancelled {
    
}

- (void)createGroupFinished {
    [self refreshArray];
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

#pragma mark- Others

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
