//
//  CreateViewController.m
//  Group_Project
//
//  Created by White, Jordan on 6/30/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import "CreateViewController.h"
#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "SettingsTableViewController.h"
#import "InviteTableViewCell.h"

@interface CreateViewController () <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextField *groupPasswordField;

@property (strong, nonatomic) NSIndexPath *myIndex;
@property int counter;
@property (strong, nonatomic) NSMutableArray *indexPaths;
@property (weak, nonatomic) PFUser *user;

@end



@implementation CreateViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _counter = 5;
    
    //[self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView *txt in self.view.subviews) {
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

#pragma mark - Inviting users
#pragma mark TableView (developing)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //number of rows
    return _counter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"new invitee");
    
    InviteTableViewCell *invitee = [tableView dequeueReusableCellWithIdentifier:@"invitee" forIndexPath:indexPath];
    
    [invitee setDidTapButtonBlock:^(id sender) {
        _myIndex = indexPath;
        NSLog(@"%i", _myIndex.row);
    }];
    
    return invitee;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Invite";
            break;
    }
    return sectionName;
}

//for custom header
/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        [headerView setBackgroundColor:[UIColor redColor]];
         
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];

    title.text = @"Hi ther";
    [headerView addSubview:title];
    
    return headerView;
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _myIndex = indexPath;
    NSLog(@"%i", _myIndex.row);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    InviteTableViewCell *invitee = (InviteTableViewCell *)cell;
    
    //[invitee.addButton setUserInteractionEnabled:YES];
    //[invitee.addButton becomeFirstResponder];
    
    [invitee.emailField setUserInteractionEnabled:YES];
    [invitee.emailField becomeFirstResponder];
    [invitee.emailField setDelegate:self];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    InviteTableViewCell *invitee = (InviteTableViewCell *)cell;
    
    //[invitee.addButton setUserInteractionEnabled:NO];
    //[invitee.addButton resignFirstResponder];
    
    [invitee.emailField setUserInteractionEnabled:NO];
    [invitee.emailField resignFirstResponder];
}

#pragma mark Re-adjusting the keyboard
/*
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_myIndex];
    InviteTableViewCell *invitee = (InviteTableViewCell *)cell;
    
    if (!CGRectContainsPoint(aRect, invitee.emailField.frame.origin) ) {
        [self.tableView scrollRectToVisible:invitee.emailField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_myIndex];
    InviteTableViewCell *invitee = (InviteTableViewCell *)cell;
    
    invitee.emailField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_myIndex];
    InviteTableViewCell *invitee = (InviteTableViewCell *)cell;
    invitee.emailField = nil;
}
*/

#pragma mark Done button works
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Adding new cell
/*
-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"endEditing");
    _counter += 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"began");
}
 */
#pragma mark - Deleting cell
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && _counter > 1) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        _counter -= 1;
    }
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"editingStyle is UITableViewCellEditingStyleInsert");
        
    }
}*/

 
//The address book feature
- (IBAction)addContact:(id)sender {
    
    ABPeoplePickerNavigationController *contacts = [[ABPeoplePickerNavigationController alloc]init];
    contacts.peoplePickerDelegate = self;
    
    NSArray *displayedItems = @[@(kABPersonEmailProperty)];
    contacts.displayedProperties = displayedItems;
    
    //show
    [self presentViewController:contacts animated:YES completion:nil];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// The selected person and property from the people picker.
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    /*
    NSString *contactName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    NSString *propertyName = CFBridgingRelease(ABPersonCopyLocalizedPropertyName(property));
    NSString *message = [NSString stringWithFormat:@"Picked %@ for %@", propertyName, contactName];
    NSLog(@"%@", message);
     */
    
    if (property == kABPersonEmailProperty) {
        ABMultiValueRef email = ABRecordCopyValue(person, property);
        NSString *saveEmail = (__bridge NSString *)ABMultiValueCopyValueAtIndex(email, ABMultiValueGetIndexForIdentifier(email, identifier));
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_myIndex];
        InviteTableViewCell *invitee = (InviteTableViewCell *)cell;
        invitee.emailField.text = saveEmail;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
    }
}

//this doesn't do anything
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    //return YES;
    return NO;
}

#pragma mark - Activity Indicator View
- (void)customActivityIndicatorWith:(UIActivityIndicatorView *)activity {
    //creates the activity monitor
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    activity.transform = transform;
    
    [activity setCenter:CGPointMake(screenWidth/2.0, screenHeight/2.0 + 128)];
    [self.view addSubview:activity];
}

#pragma mark - Creation of the Group in Parse
- (IBAction)createGroup:(id)sender {
    //creates new group
    PFObject *group = [PFObject objectWithClassName:@"Groups"];
    group[@"groupName"] = self.groupNameField.text;
    group[@"password"] = self.groupPasswordField.text;
    [group setObject:[PFUser currentUser] forKey:@"owner"];
    
    //creates and add activity indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self customActivityIndicatorWith:spinner];
    [spinner startAnimating];
    
    //save it...
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //alert the user
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Group successfully created!" message:nil delegate:nil cancelButtonTitle:@"awesome!" otherButtonTitles:nil, nil];
            [alert show];
            
            //if saved...set the relations
            NSLog(@"now its adding the relationship");
            PFUser *currentUser = [PFUser currentUser];
            
            PFRelation *relationUG = [currentUser relationForKey:@"myGroups"];
            [relationUG addObject:group];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"group is under user");
            }];
            
            PFRelation *relationGU = [group relationForKey:@"users"];
            [relationGU addObject:currentUser];
            [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"user is under group");
            }];
            
            [self email];
            [spinner stopAnimating];
            [self.creationDelegate createGroupFinished];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (error) {
            [spinner stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Something unforeseen happened. \n Please try creating that group again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}


#pragma mark - Email
//- (IBAction)email:(id)sender {
- (void)email {
    NSLog(@"email");
    
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
    mailVC.mailComposeDelegate = self;
    
    //subject
    NSString *subject = @"please join my ";
    NSString *fullSubject = [subject stringByAppendingFormat:@"%@ group", self.groupNameField.text];
    
    //body
    NSString *body = @"";
    NSString *fullBody = [body stringByAppendingFormat:@"Hi there, <br><br>I'd like you to join my group on the app Group Project. <br><br>Group Name: %@ <br>Group Password: %@ <br><br>If you don't already have Group Project you can download it here: <a href>https://itunes.apple.com/us/app/google-search/id284815942?mt=8</a>", self.groupNameField.text, self.groupPasswordField.text];
    
    //recipients
    NSMutableArray *recipients = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        InviteTableViewCell *invitee = (InviteTableViewCell *)cell;
        
        NSString *email = invitee.emailField.text;
        [recipients addObject:email];
        NSLog(@"Time #%i", i);
    }
    
    //set up and assign
    [mailVC setSubject:fullSubject];
    [mailVC setMessageBody:fullBody isHTML:YES];
    [mailVC setToRecipients:recipients];
    
    [self presentViewController:mailVC animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)pinkButton:(id)sender {
    [self email];
}


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
