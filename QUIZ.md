##Define “metaprogramming.” Where would you want to use it, and what are the downsides of using it (if any)? 

Put simply, metaprogramming is writing code that writes code. One of the things that makes ruby cool/sometimes maddening is that it allows you to modify your code at runtime, and gives you all kinds of interesting methods to do so. Here are a few things I find metaprogramming useful for: 

* DRYing up your code (e.g. attr_accessor dynamically adds reader and writer methods so you don't have to define them again and again)
* Sharing methods with a class when single inheritance just isn't flexible enough (e.g. basically anytime you use a module mix-in ever)
* Breaking encapsulation for debugging or testing purposes (e.g. I'll send a private method to an instance variable to poke around, or overwite an instance method in its metaclass to stub it out in testing)

But in general, I try to only use metaprogramming when it's absolutely necessary, because: 

* It's harder to read and debug. You can do some wild stuff if you start passing around bindings and sprinkling your code with `self` references, but this can really mess with another coder's expectations and lead to errors that are difficult to track down.  
* It compromises your encapsulation. Defining methods and directly calling variables from outside of a class seems like a great idea until you need to refactor the class.

##Give an example of a framework or a plugin that uses metaprogramming.  Please describe how this framework uses metaprogramming and what it changes.

Rails relies heavily on metaprogramming pretty much throughout the codebase. Metaprogramming gives rails much of its unique character. I love that in so many aspects of the framework you can call a simple method with an options hash and--thanks to some metaprogramming magic under the hood--quickly add some crazy new functionality to your application. 

In activerecord, for example, metaprogramming is used for callbacks, validations, and associations, among other things. So with associations, when you do this: 

    class User < ActiveRecord::Base
      has_many :followers
    end

The 'has_many' method will, after doing some other stuff, call this method: 

    def collection_reader_method(reflection, association_proxy_class)
      define_method(reflection.name) do |*params|
        force_reload = params.first unless params.empty?
        association = association_instance_get(reflection.name)

        unless association
          association = association_proxy_class.new(self, reflection)
          association_instance_set(reflection.name, association)
        end

        reflection.klass.uncached { association.reload } if force_reload

        association
      end

      ...

Here, `reflection` is an object that's been instantiatied with a 'name' attribute based on the `:followers` symbol from your code, so this method defines a 'followers' method which will return an array of Follower activerecord objects (retrieved by way of some other code and assigned here to the `association` local variable). 

In this way, has_many dynamically defines 'followers' and 20 or so other helper methods specific to the has many association you've declared. 

##In ruby you can add your own methods to standard library classes, such as String, Fixnum, Array, etc.  Is this a good idea? Explain. How do you do that? 

Monkeypatching the standard library can be handy sometimes, but it definitely messes with developer expectations and so needs to be done carefully. For example, I can add a method to String by just reopening the class and defining as I please: 

    class String
      def make_leet
        gsub('l','1').gsub('e','3').gsub('t','7').gsub('s','$')
      end
    end

If another developer doesn't know any better, they might assume this method is part of the standard library when they see it used in code, and will waste a lot of time searching out the documentation or fixing any problems the modified method creates. My rules for modifying the standard library: 

* Make sure the method belongs there. If it's not relevant to all Strings, for example, maybe I should create a SpecialString class that inherits from String. 
* Keep it simple. If it's not a totally encapsulated method with relatively simple logic, put it elsewhere. 
* Make it very clear that you've extended these classes. I typically put all extensions into a single 'extensions' file/folder, require the file near to where it's being used, and add a comment to places where and extension method is called. 

##Is it more important to write automated test suites in Ruby than, for example, in Java or C++? Explain.

Granted I haven't worked much with Java or C++, but yes, I believe so. Ruby is a dynamic language--both in the sense of having dynamic typing and enabling metaprogramming practices--and a lot of things are implicit that must be explicitly declared in other languages. These features allow for quick and flexible coding, but they also allow for bugs that you wouldn't typically see in other languages. Good testing helps you quickly catch bugs related to variable typing, for example. 

More importantly, Ruby lends itself to a particular style of programming that involves quick scripting followed by heavy refactoring. Testing is an essential counterpart to that style--it gives a focus to your quick scripting when you're answering a failing unit test, and it gives you confidence when you refactor because accidental changes to functioning will be caught by tests. 
