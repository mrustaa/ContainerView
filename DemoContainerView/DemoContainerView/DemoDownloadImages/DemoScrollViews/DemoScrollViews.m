//
//  DemoScrollViews.m
//  DemoContainerView
//
//  Created by Рустам Мотыгуллин on 26/11/2018.
//  Copyright © 2018 mrusta. All rights reserved.
//

#import "DemoScrollViews.h"
#import "ContainerDefines.h"
#import "DemoCollectionCell.h"

@implementation DemoScrollViews

+ (UITableView *)createTableViewWithProtocols:(id)protocols {
    UITableView *
    table = [[UITableView alloc] initWithFrame:FRAME_SCROLLVIEW style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.showsVerticalScrollIndicator = NO;
    table.backgroundColor = CLR_COLOR;
    table.delegate   = protocols;
    table.dataSource = protocols;
    return table;
}


+ (UICollectionView *)createCollectionViewWithProtocols:(id)protocols {
    UICollectionView *
    collection = [[UICollectionView alloc]initWithFrame:FRAME_SCROLLVIEW collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    [collection registerClass:[DemoCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
    collection.backgroundColor = CLR_COLOR;
    collection.delegate   = protocols;
    collection.dataSource = protocols;
    return collection;
}

+ (UITextView *)createTextViewWithProtocols:(id)protocols {
    
    UITextView * textView = [[UITextView alloc]initWithFrame:FRAME_SCROLLVIEW];
    textView.delegate = protocols;
    textView.returnKeyType = UIReturnKeyDone;
    textView.backgroundColor = CLR_COLOR;
    //textView.textColor = (self.containerStyle == ContainerStyleDark) ?WHITE_COLOR :BLACK_COLOR;
    textView.font = FONT_S(15);
    textView.text = @"This example demonstrates a block quote. Because some introductory phrases will lead\
    naturally into the block quote,\
    you might choose to begin the block quote with a lowercase letter. In this and the later\
    examples we use “Lorem ipsum” text to ensure that each block quotation contains 40 words or\
    more. Lorem ipsum dolor sit amet, consectetur adipiscing elit. (Organa, 2013, p. 234)\
    Example 2\
    This example also demonstrates a block quote. Some introductory sentences end abruptly in a\
    colon or a period:\
    In those cases, you are more likely to capitalize the beginning word of the block quotation.\
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisi mi, pharetra sit amet mi vitae,\
    commodo accumsan dui. Donec non scelerisque quam. Pellentesque ut est sed neque.\
    (Calrissian, 2013, para. 3)\
    Example 3\
    This is another example of a block quotation. Sometimes, the author(s) being cited will be\
    included in the introduction. In that case, according to Skywalker and Solo,\
    because the author names are in the introduction of this quote, the parentheses that follow it\
    will include only the year and the page number. Lorem ipsum dolor sit amet, consectetur\
    adipiscing elit. Sed nisi mi, pharetra sit amet mi vitae, commodo accumsan dui. Donec non\
    scelerisque quam. Pellentesque ut est sed neque. (2013, p. 103)\
    Copyright © 2013 by the American Psychological Association. This content may be reproduced for classroom or teaching purposes\
    provided that credit is given to the American Psychological Association. For any other use, please contact the APA Permissions Office.\
    Example 4\
    In this example, we have added our own emphasis. This needs to be indicated parenthetically,\
    so the reader knows that the italics were not in the original text. Amidala (2009) dabbled in hyperbole,\
    saying,\
    Random Explosions 2: Revenge of the Dialogue is the worst movie in the history of time\
    [emphasis added]. . . . it’s [sic] promise of dialogue is a misnomer of explosive proportions. Lorem ipsum\
    dolor sit amet, consectetur adipiscing elit. Sed nisi mi, pharetra sit amet mi vitae. (p. 13)\
    This paragraph appears flush left because it is a continuation of the paragraph we began above the block\
    quote. Note that we also added “[sic]” within the block quotation to indicate that a misspelling was in\
    the original text, and we’ve included ellipses (with four periods) because we have omitted a sentence\
    from the quotation (see pp. 172–173 of the Publication Manual of the American Psychological\
    Association).\
    Example 5\
    This example is similar to the previous one, except that we have continued the quotation to\
    include text from a second paragraph. Amidala (2009) dabbled in hyperbole, saying,\
    Random Explosions 2: Revenge of the Dialogue is the worst movie in the history of time\
    [emphasis added]. . . . it’s [sic] promise of dialogue is a misnomer of explosive proportions.\
    On the other hand, Delightful Banter on Windswept Mountainside is a film to be\
    cherished for all time. Filmmakers hoping to top this film should abandon hope. (p. 13)\
    This paragraph begins with an indent because we do not intend it to continue the paragraph\
    that we started above the block quote. Note that we also added “[sic]” within the block quotation to\
    indicate that a misspelling was in the original text, and we’ve included ellipses (with four periods)\
    because we have omitted a sentence from this quotation (see pp. 172–173 of the Manual).";
    
    return textView;
}

@end
