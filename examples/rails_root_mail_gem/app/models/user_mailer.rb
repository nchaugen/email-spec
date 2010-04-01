require "mail"

class UserMailer
  default_url_options = {:host => 'example.com'}
  
  Mail.defaults do 
      delivery_method :test
  end
  
  def self.deliver_signup(email, name, confirm_account_url)
    Mail.deliver do
      to      email
      from    "admin@example.com"
      subject "Account confirmation"
      date    Time.now
      body    UserMailer.render(
        {:file => 'user_mailer/signup', :content_type => :text}, 
        {:name => name, :confirm_account_url => confirm_account_url}
      )
    end    
  end

  def self.deliver_newsletter(email, name)
    Mail.deliver do
      to      email
      from    "admin@example.com"
      subject "Newsletter sent"
      date    Time.now
      body    UserMailer.render({:file => 'user_mailer/newsletter', :content_type => :text}, {:name => name})
    end    
  end

  def self.deliver_attachments(email, name)
    Mail.deliver do
      to        email
      from      "admin@example.com"
      subject   "Attachments test"
      date      Time.now
      body      UserMailer.render({:file => 'user_mailer/attachments', :content_type => :text}, {:name => name})
      add_file  File.join RAILS_ROOT, 'attachments', 'image.png'
      add_file  File.join RAILS_ROOT, 'attachments', 'document.pdf'
    end    
  end

private

  def self.render(options, assigns)
    controller = ActionController::Base.new
    controller.response = ActionController::Response.new
    viewer = ActionView::Base.new(Rails::Configuration.new.view_path, assigns, controller)
    viewer.template_format = :text
    viewer.render(options)
  end

end
