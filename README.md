# Cinema app - v1.0

# Current Design
## Main Views
- MovieListViewController
  - to show a list of movie
  - pull to refresh
  - when user about scroll to the end of list, automatically request more
  - empty view
  - prevent multiple click on a cell
- MovieViewController 
  - to show a single movie for more detail
  - booking button
## Model
- Movie
  - parsing data from server into a movie object, including from list and detail api
  - prepare related data for UI
## Managers
- APIManager 
  - handle API call related function (movie list and movie detail for now)
- MovieManager 
  - maintain a movie pool
  - handle data may duplicate from list API issue
  - give caller movie id list from API
## Other Design
- DebugUtil 
  - handle console print log
  - will be able to push logs to other 3rd party tracking services, like Fabric
-  ImageUtil 
  - to convert image path from movie data into real url
- Collection, String, UIView extensions
  - some handy functions
- Secrets 
  - for manage those secrets like API keys of all other services (ex: Google map…)
- Multi-language support
  - currently support English an Chinese Traditional
   
## 3rd party library
- RxSwift - for some UI flow and data flow control
- RxAlamofire - for API request, network cache
- SDWebImage - for web image download
# Future work
- state machine for view controller (empty, loading, normal)
- give user a date picker to select start day of movie list
- store movie into core data as offline cache, or for other operate
- build a navigate system or mechanism when screen flow get complex

