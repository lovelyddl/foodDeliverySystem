# foodDeliverySystem

A food delivery system app

Front-end: ReactJS and Semantic UI

Back-end: ExpressJS and NodeJS 

Database: MySQL

Our goal is to deploy it on a real server but at least we can build a localhost version first

For back-end:

1. Download the repository and understand our SQL structure, make any changes if necessary
2. Try to connect your app on your server to our MySQL database. If not, start from connecting our db to localhost using ExpressJS and NodeJS. There should be a lot of youtube videoes doing that.


For Front-end:

1.Landing/Home page: a search box that requires the user to search restaurants by entering either name or address

maybe even zipcode or restaurant type(we don't include them in our db now but possiblely we can add them)

2.Sign Up and Login page: Sign up by entering name, phone, email, password(confirm password). Login can choose login methods, by username and pw, by phone number and pw, and by email and pw

3.Restaurants results page: List all restaurants that searched from keywords that users enter

4.Restaurant details page: the menu, reviews and more info. Each food can be added to cart by selecting the quantity and click "add to cart" button, but users need to login first

5.Cart: a pop out window or a seperate page, which shows name, quantity and price of foods added. Allows add or decrease quantity and remove foods from cart, and check out

6.Check out page: A form that requires a lot info, such as address, gift or not, subscribe or not and payment info

7.My order page: shows the food the user ordered, with info about deliverymen, the restaurant, and the status. After the status is "completed", it allows the user to submit reviews about the restaurant and the deliveryman

8.User profile page: shows user information and allows update them

9.Manager view page: After login, managers should see a list of undistributed orders that they manage, and managers need to assign available deliverymen to orders. In the future, managers should be able to add, edit and remove foods from restaurants they manage

10.Deliverymen view page: After login, deliverymen should see a list of orderers they are assigned to. After they delivered the food, they will update the order status to "delivered"


Those are as far as I can think of and you are wecome to modify them. We can definitely design more and support more features in the future.




