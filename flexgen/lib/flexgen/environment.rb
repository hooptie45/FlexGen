require 'flexgen/model_builder'
require 'metamodel/as'

include ASMetaModel

## This is where it all comes together...
# Using this custom DSL you are able to specify your Application's functionality. 
# Since the generated code uses the RobotLegs framework, I've designed the DSL in terms
# of the RobotLegs design principals. It is very loose coupled, which was one of my primary 
# goals, my other primary goal was to never have to write another line of Actionscript. 

## The Pitch
# Writing a sophisticated Flex application is painful, especially when you're dealing with
# the Views and the Controller. You basically had to do 10 times more work in order to produce
# clean View code. And time after time I was disappointed with the code I was writing; it's like MXML 
# almost begs you to stuff your application logic into the Views. This is a result of poor design on
# Adobe's part. Object's defined in MXML are private, therefore you cannot access them from anywhere
# but the view code itself, which leads Actionscript polluting the view. The solution is a code-behind 
# for your views. But you have to manually define all of the Objects you plan on using in your view 
# in order for it to work. Pointless isn't it? Until now there was no good solution to this problem; 
# except code snippets. If you can say what you mean in 50 lines of code, why does it take 1000 lines
# of code to actually to do what you said? It's all cruft. 

## The Solution
# Say what you mean, then let the program do all the dirty work. Kind of like a rails generator with 
# a brain. The code below is not just a specification, it is actually executable code. Using MetaModels to 
# describe the building blocks of your system you are able to generate code that reacts to the 
# other code in your environment. For example, notice that the Form section says nothing about the 
# attributes of the model it is responsible for; yet it still generates the appropriate View. 

## The Spec
# The root element is the Application, or 'app'. The App can contain many Actors. Actors 
# react to signals, and they can also broadcast signals. Signals trigger commands. And Commands
# do the actual work. This allows for a very loose coupled design, keeping all your real business 
# logic away from the plumping. Almost too simple...

## Why?
# Because this beats writing pointless code all day long. I despise such languages, but for 
# once I didn't have any other option; either code in Actonscript, or abandon the platform.
# When will companies learn? But it was a nice challenge, and it made me thankful that I'm 
# a bartender; and not a Java programmer. 

### => Shaun Hannah

def auto_build
  FlexGen::ModelBuilder.build(ASMetaModel) do
    
    
    app "App", :base => "com.test" do
      # Models
      actor "Customer" do
        attribute "first_name", :view_type => "String"
        attribute "last_name", :view_type => "String"

        sig "New"
        sig "Destroy"
      end      
      actor "Order" do
        attribute "price", :view_type => "String"
        attribute "quantity", :view_type => "String"        
        sig "New"
        sig "Destroy"
      end
      
      # App Signals
      sig "Init" do
        val "testing"
      end

      # Commands
      cmd "CreateCustomer",   :triggers => ["Customer.New", "Order.New"]
      cmd "LoadCustomers",    :triggers => ["App.Init"]
      cmd "DestroyCustomer",  :triggers => ["Customer.Destroy"]
      cmd "NewOrder",         :triggers => ["Order.New"]
      
      # Views
      view "CustomerView" do
        form :watchers => [ "Customer.New", "Customer.Destroy"] do
          button "CreateCustomer", :triggers => ["Customer.New"]
          button "DestroyCustomer", :triggers => ["Customer.Destroy"]
        end
      end
      
      view "OrderView" do
        form :watchers => ["Order.New", "Order.Destroy"] do
          button "CreateOrder", :triggers => ["Order.New"]
          button "DestroyCustomer", :triggers => ["Order.Destroy"]
        end
      end
    end
  end
end

MODEL = auto_build