require "sinatra/base"
require "omniauth"
require "omniauth-salesforce"
require "force"
class MyApp < Sinatra::Base
	# before /^(?!\/(auth.*))/ do
	#        redirect '/authenticate' unless session[:instance_url]
	# end
	helpers do
		def client
			@client ||= Force.new  instance_url: 	session['instance_url'],
									oauth_token:    session['token'],
									refresh_token:  session['refresh_token'],
									client_id:      ENV['SALESFORCE_SANDBOX_KEY'],
									client_secret:  ENV['SALESFORCE_SANDBOX_SECRET']
		end
	end
    configure do
      enable :logging
      enable :sessions
      set :show_exceptions, false
      set :session_secret, ENV['SECRET']
 	end
	use OmniAuth::Builder do
		provider :salesforce, 
	         ENV['SALESFORCE_KEY'], 
	         ENV['SALESFORCE_SECRET']
		provider OmniAuth::Strategies::SalesforceSandbox, 
	         ENV['SALESFORCE_SANDBOX_KEY'], 
	         ENV['SALESFORCE_SANDBOX_SECRET']
		provider OmniAuth::Strategies::SalesforcePreRelease, 
	         ENV['SALESFORCE_PRERELEASE_KEY'], 
	         ENV['SALESFORCE_PRERELEASE_SECRET']
		provider OmniAuth::Strategies::DatabaseDotCom, 
	         ENV['DATABASE_DOT_COM_KEY'], 
	         ENV['DATABASE_DOT_COM_SECRET']
	end
	# error Force::UnauthorizedError do
 #    	redirect "/auth/salesforcesandbox"
	# end 
	# error do
 #    	"There was an error.  Perhaps you need to re-authenticate to /
	# 	authenticate ?  Here are the details: " + env['sinatra.error'].name
	# end
	get '/authenticate' do
	    redirect "/auth/salesforcesandbox"
	end
	get '/auth/salesforcesandbox/callback' do
	  	# logger.info "#{env["omniauth.auth"]["extra"]["display_name"]} 
	  	# authenticated"
		# env["omniauth.auth"]["extra"]["display_name"]
		omniauth = env["omniauth.auth"]
	    # @user = omniauth['uid']
		credentials = env["omniauth.auth"]["credentials"]
	    session['token'] = credentials["token"]
	    session['refresh_token'] = credentials["refresh_token"]
	    session['instance_url'] = credentials["instance_url"]
	    redirect '/'
	end 
	get '/auth/failure' do
		params[:message]
	end
	get '/unauthenticate' do
    	session.clear
    	'Goodbye - you are now logged out. <a href="/authenticate">Login</a>' 
	end
 	get '/' do
       	if session['token']
			# omniauth = env["omniauth.auth"]["extra"]
	    	# @user = omniauth['first_name']
	    	@user = 'Miles Ulrich'
	       	@accounts= client.query("select Id, Name from Account LIMIT 10")
	       	@cases= client.query("select Id, CaseNumber, Subject from Case LIMIT 5")
	       	erb :home
	    else
	    	erb :login 
	    	#redirect('/authenticate')
    	end
	end

 	get '/cases' do
       	@cases= client.query("select Id, CaseNumber, Subject, Status, Priority, CreatedDate, Site_URL_Acct__c, Primary_Contact__c, Last_Public_Comment_Date__c from Case LIMIT 20")
       	erb :cases
	end

    get '/hello' do
       'Hello World'
	end
    run! if app_file == $0
	end
