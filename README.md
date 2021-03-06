Takeaway Challenge
==================
```
                            _________
              r==           |       |
           _  //            |  M.A. |   ))))
          |_)//(''''':      |       |
            //  \_____:_____.-------D     )))))
           //   | ===  |   /        \
       .:'//.   \ \=|   \ /  .:'':./    )))))
      :' // ':   \ \ ''..'--:'-.. ':
      '. '' .'    \:.....:--'.-'' .'
       ':..:'                ':..:'

 ```

Approach
-------

A description of the weekend task is below. The app was designed using strict TDD
and the red-green-refactor process. 

A large refactor took place when it became clear that a separate `Order` class would be advisable to break out
functionality from the `Takeaway` class. 

The `twilio-ruby` gem was used to interface with the Twilio text messaging service. The biggest challenge 
with this was how to approach it with strict TDD in mind. In the end, with an eye on the principles set out in 
Sandi Metz's POODR, I settled for creating a double for the `SendSMS` class and checking it received the appropriate
commands from the `Takeaway` class. The `SendSMS` class is something of a black box for my tests as a result.

The optional placing of orders by text was not implemented due to time constraints. 

All `RSpec` tests pass and test coverage is 100% for original classes. Overall project coverage is 98% due to lack
of coverage for the `SendSMS` class.

Instructions for use
-----

For SMS order confirmation, create a file named `.env` file in the root project folder. Set the following variables:
``` 
TWILIO_ACCOUNT_SID = ''
TWILIO_AUTH_TOKEN = ''
TWILIO_FROM_NUMBER = ''
TWILIO_TO_NUMBER = ''
```
according to your Twilio account setup. 

The Takeaway is initialised as follows, and will pull in all its dependencies (such as menu, order manager, printer
etc.) by default. Any can be overridden by injection into the `Takeaway` class using a hash key to indicate the
function.

```
2.5.0 :004 > require './lib/takeaway'
 => true
2.5.0 :005 > naz = Takeaway.new
 => #<Takeaway:0x00007fdc392b7240 @menu=#<Menu:0x00007fdc392b71f0 @list={:korma=>4, :jalfrezi=>6, :pilau=>2, :naan=>2.5}>, @messenger=#<SendSms:0x00007fdc392b71a0 @client=#<Twilio::REST::Client:0x00007fdc392b7128 @username=nil, @password=nil, @region=nil, @account_sid=nil, @auth_token=nil, @auth=[nil, nil], @http_client=#<Twilio::HTTP::Client:0x00007fdc392b7100 @proxy_addr=nil, @proxy_port=nil, @proxy_user=nil, @proxy_pass=nil, @ssl_ca_file=nil, @timeout=nil, @adapter=:net_http>, @accounts=nil, @api=nil, @authy=nil, @autopilot=nil, @chat=nil, @fax=nil, @ip_messaging=nil, @lookups=nil, @monitor=nil, @notify=nil, @preview=nil, @pricing=nil, @proxy=nil, @taskrouter=nil, @trunking=nil, @video=nil, @messaging=nil, @wireless=nil, @sync=nil, @studio=nil, @verify=nil, @voice=nil, @insights=nil>>, @order=#<Order:0x00007fdc392b7038 @menu=#<Menu:0x00007fdc392b71f0 @list={:korma=>4, :jalfrezi=>6, :pilau=>2, :naan=>2.5}>, @basket={:korma=>{:quantity=>0, :price=>4}, :jalfrezi=>{:quantity=>0, :price=>6}, :pilau=>{:quantity=>0, :price=>2}, :naan=>{:quantity=>0, :price=>2.5}}>>
``` 

A customer can see the menu items as follows:
```
2.5.0 :006 > naz.menu
 => {:korma=>4, :jalfrezi=>6, :pilau=>2, :naan=>2.5}
```

Place orders, with optional quantities:
``` 
2.5.0 :009 > naz.take_order('jalfrezi')
 => 1
2.5.0 :010 > naz.take_order('jalfrezi',2)
 => 3
```
View their current order and running total:
``` 
2.5.0 :013 > naz.print_basket
 => "jalfrezi x 3 (£18.00)\nThe total is £18.00"
```
Halt the checkout if the amount is unexpected:
``` 
2.5.0 :014 > naz.checkout(5)
Traceback (most recent call last):
        3: from /Users/colin/.rvm/rubies/ruby-2.5.0/bin/irb:11:in `<main>'
        2: from (irb):14
        1: from /Users/colin/Documents/Workshops/Week2/takeaway-challenge/lib/takeaway.rb:28:in `checkout'
RuntimeError (Halting Order: Unexpected Total)
```
And receive a confirmation message on a successful order (including by text):
``` 
2.5.0 :006 > naz.checkout(18)
 => "Thank you! Your order was placed and will be delivered before 08:58"
```

Instructions
-------

* Challenge time: rest of the day and weekend, until Monday 9am
* Feel free to use google, your notes, books, etc. but work on your own
* If you refer to the solution of another coach or student, please put a link to that in your README
* If you have a partial solution, **still check in a partial solution**
* You must submit a pull request to this repo with your code by 9am Monday morning

Task
-----

* Fork this repo
* Run the command 'bundle' in the project directory to ensure you have all the gems
* Write a Takeaway program with the following user stories:

```
As a customer
So that I can check if I want to order something
I would like to see a list of dishes with prices

As a customer
So that I can order the meal I want
I would like to be able to select some number of several available dishes

As a customer
So that I can verify that my order is correct
I would like to check that the total I have been given matches the sum of the various dishes in my order

As a customer
So that I am reassured that my order will be delivered on time
I would like to receive a text such as "Thank you! Your order was placed and will be delivered before 18:52" after I have ordered
```

* Hints on functionality to implement:
  * Ensure you have a list of dishes with prices
  * Place the order by giving the list of dishes, their quantities and a number that should be the exact total. If the sum is not correct the method should raise an error, otherwise the customer is sent a text saying that the order was placed successfully and that it will be delivered 1 hour from now, e.g. "Thank you! Your order was placed and will be delivered before 18:52".
  * The text sending functionality should be implemented using Twilio API. You'll need to register for it. It’s free.
  * Use the twilio-ruby gem to access the API
  * Use the Gemfile to manage your gems
  * Make sure that your Takeaway is thoroughly tested and that you use mocks and/or stubs, as necessary to not to send texts when your tests are run
  * However, if your Takeaway is loaded into IRB and the order is placed, the text should actually be sent
  * Note that you can only send texts in the same country as you have your account. I.e. if you have a UK account you can only send to UK numbers.

* Advanced! (have a go if you're feeling adventurous):
  * Implement the ability to place orders via text message.

* A free account on Twilio will only allow you to send texts to "verified" numbers. Use your mobile phone number, don't worry about the customer's mobile phone.

* **WARNING** think twice before you push your mobile number or any private details to a public space like Github. Now is a great time to think about security and how you can keep your private information secret. You might want to explore environment variables.

* Finally submit a pull request before Monday at 9am with your solution or partial solution.  However much or little amount of code you wrote please please please submit a pull request before Monday at 9am


In code review we'll be hoping to see:

* All tests passing
* High [Test coverage](https://github.com/makersacademy/course/blob/master/pills/test_coverage.md) (>95% is good)
* The code is elegant: every class has a clear responsibility, methods are short etc.

Reviewers will potentially be using this [code review rubric](docs/review.md).  Referring to this rubric in advance will make the challenge somewhat easier.  You should be the judge of how much challenge you want this weekend.

Notes on Test Coverage
------------------

You can see your [test coverage](https://github.com/makersacademy/course/blob/master/pills/test_coverage.md) when you run your tests.
