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

@interface CreateViewController () <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextField *groupPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *invitee1;

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
    // Do any additional setup after loading the view.
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
    
    NSString *email = nil;
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (ABMultiValueGetCount(emails) > 0) {
        email = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(emails, 0);
    } else {
        email = @"[None]";
    }
    self.invitee1.text = email;
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
/*
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue {
    
    return NO;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
     if (kABPersonEmailProperty == property) {
         ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
         NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multi, 0);
         NSLog(@"email: %@", email);
         [self dismissViewControllerAnimated:YES completion:nil];
         return NO;
     }
     //return YES;
 
    return NO;
}
 */



#pragma mark - Creation of the Group in Parse
- (IBAction)createUMGroup:(id)sender {
    
    NSLog(@"button was preseed");
    
    
    //creates new group
    PFObject *group = [PFObject objectWithClassName:@"Groups"];
    group[@"groupName"] = self.groupNameField.text;
    group[@"password"] = self.groupPasswordField.text;
    group[@"owner"] = [PFUser currentUser];
    
    //[PFUser currentUser][@"currentGroup"] = group;
    
    //save it...
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //alert the user
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Group successfully created!" message:nil delegate:nil cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
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
