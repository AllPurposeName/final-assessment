== README

# Final Scores

####I completed this project with the following scores out of 4:

Satisfatory Progress 3
Ruby Syntax and Style 3
Rails Style and API 3
Testing 3.5
User Interface 3

## Project Iterations

### Iteration 1: Account Creation / Sign In

As a new user, when I first access the site, I should be prompted
to log in with GitHub. (None of our features are for non-authenticated
users, so a global login requirement is ok)

#####current_user render style

The first time I do this (initial account creation), I should be
taken to a second "User Information" screen, and prompted to enter
the following information:

#####after_create callback to setup User Information

* Preferred languages -- List of Checkboxes (check all that you're interested in).
  see below for a [sample list](#available-programming-languages)

##### Many to Many relationship between users and languages

* About Me -- Text Box -- Enter a short description, maximum 500
  characters. For this information, prompt users to describe what
  they're looking for in a pair, their coding interests, etc.

#####figure out 500 chr max Table column description

After submitting this information, I should be taken to the application
root, which should display a "Dashboard" / "Matches" Screen.
For the moment this will be empty.

__Note:__ To help you with testing/seeding your application,
a sample list of user account data is included. See [below](#sample-user-accounts) for more info.

### Iteration 2: Match Suggestion

When viewing the Dashboard, I should see a shiny button inviting me
to "Find Pairs". Clicking this should take me to a new screen,
where I will be shown potential pairs, and invited to match with them
or not.

For this iteration, let's not worry about how we're recommending
matches. Simply show profile information about the first
other user __whom I have not already been matched with__.

When suggesting a match, the application should display:

* User's github name
* User's github profile pic
* User's list of desired languages
* User's description

Below the other user's information, I should have 2 options:

* Approve match
* Reject match

If I Approve a match (button on the right):

* Information should be stored on the server indicating that I am
  interested in pairing with that user.
* That user should disappear and I should be shown another user account.
* That user should not appear in my recommendations again.

If I Reject a match (button on the left):

* Information should be stored on the server indicating that I am NOT
  interested in pairing with that user.
* That user should disappear and I should be shown another user account.
* That user should not appear in my recommendations again.

### Iteration 3: Better Match Suggestion

Our current setup is getting somewhere, but a match isn't that useful
until both users have approved it. Let's improve our match
recommendation algorithm to help facilitate this.

When generating potential matches:

__If there are any "pending" matches from other users to me__, then I
should be shown those users first, followed by other users where no
match information exists (as in iteration 2).

__Otherwise,__ I should be shown new user accounts in order, just as in
iteration 2.

In other words, users who have always Accepted a match with me
should be moved to the front of my recommendation "queue".

To help illustrate this, let's run through an example scenario:

* User A logs in and is shown User B's account
* User A approves the recommendation of User B
* User A is then shown User C/D/E...'s accounts
* User B logs in and is shown User A's account first, since there
  is a pending match between these 2, to which User B has not yet responded.
* User B responds to the match by approving/rejecting
* User B is then shown remaining User accounts C/D/E etc

__Note__ that there is no difference in the Interface between an initial
("blind") recommendation and a pending match (One where the other party
has already clicked, "Approve"). This information is (so
far) not visible to the user.

__Also Note__ that so far we don't need to do anything with the match
information we are collecting. For now just focus on getting the
recommendation-display portion wired up.

### Iteration 4: Completing Matches

So what happens when 2 users both approve a match? Well we need
to...match them somehow.

__Step 1 -- indicating match completion:__

As a user (User A) browsing recommendations,

when I approve a user (User B)

and that user has previously also approved a match with me

then I should see a message indicating "Congrats User A, you and User B
are a good match!"

__Step 2 -- recording completed matches:__

As a user (User A) browsing recommendations,

when I approve a user (User B)

and that user has previously also approved a match with me

and I navigate to my Dashboard, I should see a list of completed
matches, indicating that I (User A) was matched with (User B).

### Next Steps -- Iterations 5+ (Optional)

__Congratulations! You have finished the required portion of the assignment!__

_If_ you finish iterations 1-4 and ~~are looking for additional punishment~~
want to add additional functionality to the application, consider the following extensions:

#### Match Suggestion Enhancement

We're collecting preferred language
information from our users, but not currently acting on it. Let's
enhance our recommendation algorithm to take this information into
account:

As a user, when browsing potential matches, I should only see
recommended matches with whom I share at least 1 common preferred
language.


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
