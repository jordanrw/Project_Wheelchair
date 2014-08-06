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
#import "GroupTableViewCell.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h> 

@interface SettingsTableViewController () <CreateGroupDelegate, RefreshArrayDelegate, JoinGroupDelegate>

@property BOOL hasShown;
@property (nonatomic, strong) UIAlertView *confirm;

@property (nonatomic, strong) NSMutableArray *groupsOfUser;      //PFObjects
@property (nonatomic, strong) NSMutableArray *titles;           //Strings
@property (nonatomic) NSIndexPath *selected;

@property (nonatomic, strong) UIView *splashView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation SettingsTableViewController

#pragma mark - Initial View Setup
- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.navigationItem.title = @"My Groups";
    
    //sets bar buttons
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup:)];
    self.navigationItem.rightBarButtonItem = add;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser]) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        [_hud setLabelText:@"Loading your groups"];
    }
    
    [self loginOrLogout];
    [self refreshArray];
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
        loginVC.refreshDelegate = self;
    }
}


#pragma mark - Signup || Loggout
- (IBAction)signnnup:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
    loginVC.refreshDelegate = self;
}

- (IBAction)logggout:(id)sender {
    _confirm = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log out", nil];
    [_confirm show];
}


#pragma mark UIAlertviewDelegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [_confirm firstOtherButtonIndex]) {
        [PFUser logOut];
        [self refreshArray];
        self.groupsOfUser = nil;
        [self.tableView reloadData];
        
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
        UIAlertView *loginTo = [[UIAlertView alloc]initWithTitle:@"Login" message:@"to join or create groups" delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
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


#pragma mark - Refresh array (get data)
- (void)refreshArray {
    
    PFRelation *relation = [[PFUser currentUser]relationForKey:@"myGroups"];
    PFQuery *queryOfRelation = [relation query];
    [queryOfRelation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            self.groupsOfUser = [[NSMutableArray alloc]initWithArray:objects];
            [_hud hide:YES];
            [self.tableView reloadData];
            [_splashView removeFromSuperview];
        }
        if ([objects count] == 0) {
            NSLog(@"0");
            _splashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.tableView.bounds.size.height)];
            _splashView.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height)/2, [UIScreen mainScreen].bounds.size.width, 20);
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:17.0];
            label.text = @"hit that + to join or create a group";
            
            [_splashView addSubview:label];
            [self.view.superview addSubview:_splashView];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.groupsOfUser count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"new UITableViewCell created");
    
    GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //TODO - change this to just pulling the title from the Parse object
    PFObject *object = [self.groupsOfUser objectAtIndex:indexPath.row];
    NSString *name = [object objectForKey:@"groupName"];
    cell.groupNameLabel.text = name;
    
    return cell;
}

#pragma mark - Selecting data
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    GroupTableViewCell *tissue = (GroupTableViewCell *)cell;
    
    tissue.checkmarkImage.hidden = NO;
    tissue.selected = YES;
    _selected = indexPath;
    
    //saving it to the backend
    //#save data sending by waiting until leaving the view, however loading then has problems
    if (_selected != nil){
        [[PFUser currentUser] setObject:[self.groupsOfUser objectAtIndex:_selected.row] forKey:@"current"];
        //TOConsider - adding a loading screen to switching groups to make it feel more permanent
        [[PFUser currentUser] save];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![_selected isEqual:indexPath]) {
        [tableView cellForRowAtIndexPath:_selected].selected = NO;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:_selected];
        GroupTableViewCell *tissue = (GroupTableViewCell *)cell;
        tissue.checkmarkImage.hidden = YES;
    }
    return indexPath;
}

#pragma mark Editing tableview
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
        
        PFObject *group = [_groupsOfUser objectAtIndex:indexPath.row];
//#upgrade if current user of group is the owner and is trying to leave, don't allow him, but tell him that since he is the owner he cannot leave the group,
        //he has to delete it
        
        
        //removes relation from the user's groups
        PFRelation *relationUG = [[PFUser currentUser] relationForKey:@"myGroups"];
        [relationUG removeObject:group];
        [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"user no longer has group");
            }
        }];
        
        //removes relation from group's users
        PFRelation *relationGU = [group relationForKey:@"users"];
        [relationGU removeObject:[PFUser currentUser]];
        [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"group no longer has user");
                
//#mbbugs
                [_groupsOfUser removeObject:group];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
        
        
        /*
        [_groupsOfUser removeObject:object];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                //then refresh array
//                [self refreshArray];
//                
//                //then reload data
//                [self.tableView reloadData];
//                
//                //visuals
//            }
//        }];
 */
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"leave group";
}

#pragma mark - Create Group (Custom Delegate methods)


- (void)createGroupFinished {
    [self refreshArray];
}

#pragma mark - Join Group (custom delegate methods)
- (void)joinedGroup {
    [self refreshArray];
    NSLog(@"asked to refresh table");
}

#pragma mark - Refresh Delegate
- (void)refresh {
    [self refreshArray];
    NSLog(@"asked to refresh table");
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

#pragma mark - Leaving the view

/*I changed it from updating here to updating on the tap so the rest of the app would work correctly
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"Goodbye");
    
    if (_selected != nil){
        [[PFUser currentUser] setObject:[self.groupsOfUser objectAtIndex:_selected.row] forKey:@"current"];
        [[PFUser currentUser] save];
    }
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
