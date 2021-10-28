require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(:first => 'Candice')
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    #Customer.find_by_sql("select * from customers where email like '%@%'")
    Customer.where( [ " email like ?", '%@%'] )
  end

  def self.with_dot_org_email
    Customer.where( [ " email like ?", '%.org'] )
  end

  def self.with_invalid_email
    Customer.where( [ " email is not ? and email not like ?",nil,'%@%'] )
  end

  def self.with_blank_email
    Customer.where(:email => nil)
  end

  def self.born_before_1980
    Customer.where( ["birthdate < ?",'1980-01-01'])
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where( ["email like ? and birthdate < ?",'%@%','1980-01-01'])
  end

  def self.last_names_starting_with_b
    Customer.where( ["last like ? ",'B%']).order("birthdate")
  end

  def self.twenty_youngest
    Customer.order("birthdate desc").limit(20)
  end

  def self.update_gussie_murray_birthdate
    Customer.where("first" => 'Gussie').update_all("birthdate":'2004-02-08')
    #Customer.update("birthdate" => Time.parse("8 February 2004"),)
  end

  def self.change_all_invalid_emails_to_blank
    c = Customer.where( [ " email is not ? and email not like ?",nil,'%@%'] )
    c.update_all("email" => nil)
  end

  def self.delete_meggie_herman
    c = Customer.where(:first => 'Meggie', :last => 'Herman')
    c.delete_all()
  end

  def self.delete_everyone_born_before_1978
    c = Customer.where(["birthdate < ?",'1978-01-01'])
    c.delete_all()
  end
  # etc. - see README.md for more details
end
