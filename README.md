# instaham
simple app blah blah

A few things:

- I had to go re-learn some core data.  I was never an expert, but I've made comments where I think it could get better.
- I never really learned auto-layout via the Xcode GUI, and mostly relied on stuff like PureLayout to simplify things, so that could definitely be better as well.
- I watched a talk about writing unit tests against UI code, but that was a few years ago.  Needless to say, there's not a ton of unit tests since it's mostly UI.

One other thing of note:

This may not work the way you might expect.  Instagram changed their policies some time back, this is the new policy:

`The public_content scope is required for media that does not belong to the owner of the access_token.`

This goes for comments, images, etc.  So unless you comment on your own posts, you may not see them.  This had me pulling out my hair for most of the day today until I realized it was happening :(. To get around this, I'd need to submit my app to Instagram for review.

Thanks for reading!


Brandon
