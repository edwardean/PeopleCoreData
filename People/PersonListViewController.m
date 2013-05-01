//
//  PersonListViewController.m
//  People
//
//  Created by Edward on 13-5-1.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "PersonListViewController.h"
#import "AddPersonViewController.h"
#import "AppDelegate.h"
#import "People.h"

@interface PersonListViewController ()

@end

@implementation PersonListViewController

- (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
    
    return managedObjectContext;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        /* Create the fetch request first */
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        /* Here is the entity whose contents we want to read */
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"People" inManagedObjectContext:[self managedObjectContext]];

    NSSortDescriptor *ageSort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];

    NSSortDescriptor *firstNameSort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];

    NSSortDescriptor *lastNameSort = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];

    NSArray *sortArray = @[ageSort,firstNameSort,lastNameSort];

    fetchRequest.sortDescriptors = sortArray;

    /* Tell the request that we want to read  the contents of the People entity */
    [fetchRequest setEntity:entity];

    self.personsFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];

    self.personsFRC.delegate = self;
    NSError *fetchingError = nil;
    if ([self.personsFRC performFetch:&fetchingError]) {
        NSLog(@"Successfully fetched.");
    } else {
        NSLog(@"Failed to fetch.");
    }
  }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = @"Persons";
    
    self.tableViewPersons = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableViewPersons.delegate = self;
    
    self.tableViewPersons.dataSource = self;
    
    [[self view] addSubview:_tableViewPersons];
    
    self.barButtonAddPerson = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPerson:)];
    
    [self.navigationItem setLeftBarButtonItem:[self editButtonItem] animated:NO];
    
    [self.navigationItem setRightBarButtonItem:_barButtonAddPerson animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewPerson:(id)paramSender {
    AddPersonViewController *controller = [[AddPersonViewController alloc] initWithNibName:nil bundle:nil];
    
    [[self navigationController] pushViewController:controller animated:YES];
}
#pragma mark -
#pragma mark UITableViewDelegate
- (void)setEditing:(BOOL)paramEditing animated:(BOOL)paramAnimated {
    [super setEditing:paramEditing animated:paramAnimated];
    
    if (paramEditing) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    } else {
        [self.navigationItem setRightBarButtonItem:self.barButtonAddPerson animated:YES];
    }
    
    [_tableViewPersons setEditing:paramEditing animated:paramAnimated];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    People *peopleToDelegate = [self.personsFRC objectAtIndexPath:indexPath];
    
    /* Very important: we need to make sure we are not reloading the tableView while deleting the managed object */
    self.personsFRC.delegate = nil;
    
    [[self managedObjectContext] deleteObject:peopleToDelegate];
    
    if ([peopleToDelegate isDeleted]) {
        NSError *savingError = nil;
        if ([[self managedObjectContext] save:&savingError]) {
            NSError *fetchingError = nil;
            if ([self.personsFRC performFetch:&fetchingError]) {
                NSLog(@"Successfully fetched.");
                
                NSArray *rowsToDelete = @[indexPath];
                [_tableViewPersons deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                NSLog(@"Failed to fetch with error:%@",fetchingError);
            }
        } else {
            NSLog(@"Failed to save the context eoth error:%@",savingError);
        }
    }
    
    self.personsFRC.delegate = self;
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.personsFRC.sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *CellID = @"LiHang";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    People *people = [self.personsFRC objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [people.firstName stringByAppendingFormat:@" %@",people.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[people.age unsignedIntegerValue]];
    
    return cell;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableViewPersons reloadData];
}
@end
