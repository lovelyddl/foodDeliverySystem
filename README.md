# foodDeliverySystem Website

A food delivery system web app: URL http://www.bowenfirstweb.xyz/
Testing Accounts: You can log in one of them by using user name, phone, or email as login method
User Role	User Name	User phone	User Email 	User Password
Admin	cuteduo	9999999999	cuteduo@duo.com	cuteduoduo
Customer	jingyi	4444444444	jingyi@jy.com	12345678
Deliveryman 	yuaiai	3333333333	yu@yu.com	12345678
Manager 	managerlei	7777777777	managerlei@lei.com	managerlei

Front-end Skills: ReactJS and Semantic UI

Back-end Skills: Express.JS and NodeJS 

Database: MySQL

Software architectural: Model–view–view model (MVVM) + RESTful web services


For Back-end:
The middle tie of our website builds RESTful web service: Create different API for front end to obtain and update data, such as GET, PUT, POST, and DELET.
Finished Part: 
0. We have deployed this Express.JS project and run it successfully on our cloud hosting
1. We have created SQL database and run it successfully on our cloud hosting 
2. Create the connection between Express.JS back-end with the MySQL Workbench successfully
3. Build different API to provide web services for basic GET Json data and POST requests
4. Created all users API, front-end can access different API to log in, register a new user, view its profile, and edit profile information in our database.

Waiting for development:
5. Created all restaurants API
6. Created all Cart API
7. Created all Customer orders API
8. Created all Deliverymen orders API
8. Created all restaurants managers API


For Front-end:
Finished Part: 
0.We have deployed the front-end part to our cloud hosting 
1.Landing/Home page: You can go to signup, login, and search restaurants pages
After logging, all users can see and edit their profile
2.Sign Up and Login page: Sign up by entering name, phone, email, password (confirm password). Login can choose login methods, by username and pw, by phone number and pw, and by email and pw
3.User profile page: shows user information and allows update them
4. Search Restaurants: a search box that requires the user to search restaurants by entering either name, address, zip code, and type.
5.Restaurants results page: List all restaurants that searched from keywords 

Waiting for development:
6.Restaurant details page: the menu, reviews and more info. Each food can be added to cart by selecting the quantity and click "add to cart" button, but users need to login first

7.Cart: a pop out window or a seperate page, which shows name, quantity and price of foods added. Allows add or decrease quantity and remove foods from cart, and check out

8.Check out page: A form that requires a lot info, such as address, gift or not, subscribe or not and payment info

9.My order page: shows the food the user ordered, with info about deliverymen, the restaurant, and the status. After the status is "completed", it allows the user to submit reviews about the restaurant and the deliveryman

10.Manager view page: After login, managers should see a list of undistributed orders that they manage, and managers need to assign available deliverymen to orders. In the future, managers should be able to add, edit and remove foods from restaurants they manage

11.Deliverymen view page: After login, deliverymen should see a list of orderers they are assigned to. After they delivered the food, they will update the order status to "delivered"

Those are as far as I can think of and you are welcome to modify them. We can definitely design more and support more features in the future.




