#### SoFi Project
##### Demo:

![SoFi Demo](https://github.com/rainmaker490/SoFi/blob/master/SoFiDemo.gif)


##### Design:
* ImgurRequestable:
  * This is a Service protocol. Any class that conforms to this protocol can define custom parameters around populating a request (i.e. request headers, url parameters, etc).

* ImgurSearchResult:
  * This is the response object (from the provided API).
  * One enhancement to this Model that I would suggest is to have this object conform to the Decodable protocol. If you were to peek in the ImgurSearchFactory class, I manually parse the response and map it to ImgurSearchResult (this can be done much easily with the use of the Decodable protocol).

* ImgurSearchFactory:
  * This is the model object that is responsible for making API calls, pagination, and performing the search queries. I have also implemented an extremely light weight cache (String:Data dictionary).
  * If you were to take a look at the successCompletionBlock (part of conforming to the ImgurRequestable protocol), you will notice that I am filtering out non “jpg” and “png” types. 

* ImgurCollectionViewCell:
  * CollectionViewCell that has an ImageView and a Title

* ImgurSearchView:
  * Search View that contains a Search Bar and a CollectionView

* ImgurSearchViewController:
  * The biggest challenge here was to ensure that if we are in the process of fetching Image data on a background thread, but the cell is no longer on the screen and possible reused, you do not need to update the cell with the Image (just cache it instead).
  * 250 ms debounce -> The timer object helps us with the debounce. 

* ImgurDetailViewController:
  * This is a detailViewController.
  * I would suggest that this View Controller be embedded in a Scroll View Controller so that the aspect ratio of the image is honored and the Image is scrollable.

* Other Comments / Logic behind decisions:
  * I decided to use a non-storyboard approach because I wanted to show my understanding of constraints and how they work.
  * Suggested Enhancements: Write a custom SearchBar (in terms of UI).
  * The DetailVC's Image doesn't have the correct Aspect Ratio, this needs to be corrected.
  * Observation: Not all Search Results contain a "Title". Most do contain a "Detail"
