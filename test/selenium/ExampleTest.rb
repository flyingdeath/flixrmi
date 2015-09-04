#!/usr/bin/env ruby
#
# Sample Test:Unit based test case using the selenium-client API
#

require 'test_helper'
require "rubygems"
gem "selenium-client"
#require "selenium/client"
require "selenium"
require "test/unit"

class NewTest < Test::Unit::TestCase
  def setup
    @verification_errors = []
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox", "http://localhost:3000", 10000);
      @selenium.start
    end
    @selenium.set_context("test_new")
  end

  def teardown
    @selenium.stop unless $selenium
    assert_equal [], @verification_errors
  end

  def test_new
  
    @selenium.open "/"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "login", "briansspiegel@gmail.com"
    @selenium.type "password", "Dingqw01"
    @selenium.click "css=input[type=image]"
    @selenium.wait_for_page_to_load "30000"


   # begin
   #   assert @selenium.is_text_present("Please confirm the link to your account below.")
   # rescue Test::Unit::AssertionFailedError
   #   @verification_errors << $!
   # end
   # @selenium.click "css=input[type=image]"
   # @selenium.wait_for_page_to_load "30000"
    begin
      assert @selenium.is_text_present("This page is provided by Netflix to authorize third-party")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    assert !60.times{ break if (@selenium.is_text_present("Resources") rescue false); sleep 1 }
    @selenium.wait_for_page_to_load "60000"
    assert !60.times{ break if ("NetFlix RMI" == @selenium.get_title rescue false); sleep 1 }
    assert_equal "NetFlix RMI", @selenium.get_title
    begin
      assert @selenium.is_text_present("Resources")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
    
    @selenium.click "treeViewItem0Main_Menu_173"
    assert !60.times{ break if (@selenium.is_text_present("5 Against the House") rescue false); sleep 1 }
    begin
      assert @selenium.is_text_present("5 Against the House")
    rescue Test::Unit::AssertionFailedError
      @verification_errors << $!
    end
  end
end