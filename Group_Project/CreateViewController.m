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
#import "SettingsTableViewController.h"

@interface CreateViewController () <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextField *groupPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *invitee1;

@property (weak, nonatomic) PFUser *user;

@end

@implementation CreateViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
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
- (IBAction)contacts:(id)sender {

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
        
        self.invitee1.text = saveEmail;
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
    
    [activity setCenter:CGPointMake(screenWidth/2.0, screenHeight/2.0 - 20)];
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
            
            
            //this works for saving a pointer, but the group isn't working only random PFObjects
            PFObject *obj = [PFObject objectWithClassName:@"String"];
            [obj save];
            [[PFUser currentUser] setObject:obj forKey:@"test"];
            [[PFUser currentUser]save];
            
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
