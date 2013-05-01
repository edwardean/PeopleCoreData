//
//  AddPersonViewController.m
//  People
//
//  Created by Edward on 13-5-1.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "AddPersonViewController.h"
#import "People.h"
#import "AppDelegate.h"
@interface AddPersonViewController ()

@end

@implementation AddPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
	self.view.backgroundColor = [UIColor cyanColor];
    self.title  =@"New Person";
    
    CGRect textFieldRect = CGRectMake(20.0f, 20.0f, self.view.bounds.size.width - 40.0f, 31.0f);
    
    self.textFieldFirstName = [[UITextField alloc] initWithFrame:textFieldRect];
    _textFieldFirstName.placeholder = @"First Name";
    _textFieldFirstName.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldFirstName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textFieldFirstName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldFirstName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:_textFieldFirstName];
    
    textFieldRect.origin.y += 37.0f;
    self.textFieldLastName = [[UITextField alloc] initWithFrame:textFieldRect];
    _textFieldLastName.placeholder = @"Last Name";
    _textFieldLastName.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldLastName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textFieldLastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldLastName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:_textFieldLastName];
    
    textFieldRect.origin.y += 37.0f;
    self.textFieldAge = [[UITextField alloc] initWithFrame:textFieldRect];
    _textFieldAge.placeholder = @"Age";
    _textFieldAge.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldAge.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textFieldAge.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldAge.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:_textFieldAge];
    
    self.barButtonAdd = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(createNewPerson:)];
    
    [self.navigationItem setRightBarButtonItem:_barButtonAdd animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_textFieldFirstName becomeFirstResponder];
}
- (void)createNewPerson:(id)paramSender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
    
    People *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:managedObjectContext];
    
    if (newPerson != nil) {
        
        newPerson.firstName = _textFieldFirstName.text;
        newPerson.lastName = _textFieldLastName.text;
        newPerson.age = [NSNumber numberWithInteger:[_textFieldAge.text integerValue]];
        
        NSError *savingError = nil;
        
        if ([managedObjectContext save:&savingError]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Failed to save the managed object context.");
        }
    } else {
        NSLog(@"Failed to create the new person object.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
