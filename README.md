# LearningInLeeds

Resulting from a LCC Innovation Lab this is a course finder for about 300 courses by the City and run by a number of providers and dozens of venues. It offers a range of first step courses for adults, such as basic IT skills, ESOL, caring and crafts. Within the first 24 hours of launch it received over 3000 visits, in the first month, it had over 25,000 visits, with the average user spending three minutes on the site. 

It can be seen in operation at [LeedsAdultLearning.co.uk](https://leedsadultlearning.co.uk/) 

## Screenshots 

### Homepage
![Homepage](/screenshot-home.png)

### Course Detail
![Course Detail](/screenshot-course.png)

### Admin Page
![Admin page](/screenshot-admin.png)


## Features  

* Automatic imports of courses from Data Mill North (open data site)
* Full text search with support for sounds like and spelling mistakes
* Geographical, near searches
* Bus and walking directions to the start of the course from any point
* Add to calendar links for course start
* Showing courses by topics or categories
* Responsive and mobile friendly.
* Simple CMS admin UI for staff to update text pages, change records etc
* Caching of external API requests, front page and CMS pages
* Recent searches kept

## Technology

* Ruby on Rails
* Devise and Active Admin for admin UI
* Postgresql, PostGIS and pg_search for db, geo, full text stuff
* Bootstrap for front end user interface layout, CSS etc
* Transport API, Bing Transit, Mapzen for journey planning and geocoding etc



 