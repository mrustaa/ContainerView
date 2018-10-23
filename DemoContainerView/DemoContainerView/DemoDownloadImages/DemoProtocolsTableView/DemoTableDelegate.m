
//  Created by Rustam Motygullin on 29.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "DemoTableDelegate.h"

@implementation DemoTableDelegate

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.blockSelectIndex) self.blockSelectIndex(indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

@end
