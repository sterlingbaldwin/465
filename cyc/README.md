#[Chico Youth Court](http://www.chicoyouthcourt.org)

This project is an infrastructure page for the new youth court being set up in chico.

The main capabilities are as follows:

* Users of several types, admin, volunteer, and user
* Admins are the adults working for the CYC as organizers.
* Volunteers can be either adult volunteers or minors, the two requiring different forms. Volunteers need to have several
different things tracked about them, like what forms they've filled out and if they're adults if they've passed the police background check.
* Regular users are the kids going through the court.

# User information tracking
* User profiles contain all the metadata about volunteers and youths. A user can edit information about themselves, but only non-privelged data.
* Admins can access user and volunteer profiles, as well as change all information about them.

# Admin profiles
* Every administrator has a public profile, which is displayed to regular users. All users have the ability to upload user profile pictures.

# Blog
* The CYC asked that they have a simple bloging platform. Regular users are only able to see a list of all posts, but admin users are presented with a prompt to create new, edit, or delete old blog posts.

# AJAX
* **All** interactions on the site are communicated back the the server through ajax requests. When a user clicks the blog menu item, it doesnt load a new blog page, but instead requests the data through ajax and populates the page asynchronously. New blog posts dont cause a page reload, but instead send the blog data back to the server where its store in the db, and new blog data is sent back to the client where its populated in the browser (again, with no reloads).

* All profile updates go through ajax requests. Updating user data does not require a page load, and happens dynamically with no reloads.

* The only action that causes a page reload is uploading a user pic, because I couldnt get the input tag to happen asynchronously.


# TODO
* update logout, also update logo updating process so emma can do this

* fix volunteer_info link so it doesnt break things

* for the blog, add imbedded images

* add button to calendar for uploading an image of the schedule

* Add admin name to the top of profile text

* change link type on profile update so that it doesnt change page position -> javascript:void(0) not href(#)

* when updating a users profile information as admin its not saving properly

* look into email@chicoyouthcourt.org

* donate? remove link until its working

* fix home link to point home

* when displaying the user list under memebers, I think its only displaying "user" user_type, fix this so that all "volunteer" and "offender"


#wishlist

* Letsencrypt free https
