require File.dirname(__FILE__) + '/../test_helper'

class PaypalExpressTest < Test::Unit::TestCase
  include ActiveMerchant::Billing
  
  def setup
    Base.gateway_mode = :test
    
    cert = File.read(File.join(File.dirname(__FILE__), 'certificate.pem'))
    
    @gateway = PaypalGateway.new(
      :login     => 'login',
      :password  => 'password',
      :subject => 'third_party_account',
      :pem => '' #cert
     )

     @options = {
       :order_id => '230000',
       :email => 'buyer@jadedpallet.com',
       :address => { :name => 'Fred Brooks',
                     :address1 => '1234 Penny Lane',
                     :city => 'Jonsetown',
                     :state => 'NC',
                     :country => 'US',
                     :zip => '23456'
                   } ,
       :description => 'Stuff that you purchased, yo!',
       :ip => '10.0.0.1',
       :return_url => 'http://example.com/return',
       :cancel_return_url => 'http://example.com/cancel'
     }
  end
  
  def test_set_express_authorization
    @options.update(
      :return_url => 'http://example.com',
      :cancel_return_url => 'http://example.com',
      :email => 'Buyer1@paypal.com'
    )
    response = @gateway.setup_authorization(Money.new(500), @options)
    assert response.success?
    assert response.test?
    assert !response.params['token'].blank?
  end
  
  def test_set_express_purchase
    @options.update(
      :return_url => 'http://example.com',
      :cancel_return_url => 'http://example.com',
      :email => 'Buyer1@paypal.com'
    )
    response = @gateway.setup_purchase(Money.new(500), @options)
    assert response.success?
    assert response.test?
    assert !response.params['token'].blank?
  end
end 
