class SurveyController < ApplicationController
	before_action :admin_user,   only: [:new, :create, :add_question, :create_question, :display_responses]
	before_action :logged_in_user, only: [:index, :show]

	def new
		@survey = SurveySet.new
	end

	def create
		@survey = SurveySet.new(sur_params)
		if @survey.save
			flash[:success] = "Survey created!"
			redirect_to :controller => "survey", :action => "add_question", :id => @survey.id
		else
			render 'new'
		end
	end

	def show
		@questions = Que.where(SurveySet_id: params[:id])
		@survey= SurveySet.find(params[:id])	
	end

	def index
		@surveys = SurveySet.paginate(page: params[:page])
	end

	def add_question
		@survey= SurveySet.find(params[:id])
	end

	def create_question
		temp = Que.new()
		temp.category = params[:question][:category]
		temp.desc = params[:question][:desc]
		temp.a = params[:question][:a]
		temp.b = params[:question][:b]
		temp.c = params[:question][:c]
		temp.d = params[:question][:d]
		temp.SurveySet_id= params[:question][:id]
		if(params[:question][:over] == '0')
			if temp.save()
				flash[:success] = "Question added!"
				redirect_to :controller => "survey", :action => "add_question", :id => params[:question][:id]
			else
				render 'new'
			end

		elsif(params[:question][:over] == '1')
			if temp.save()
				flash[:success] = "Question added!"
				
			end
			

			redirect_to root_url
		end
	end

	def save
		params[:response].each do |value, resp|
			if(resp[:category]!="mcq_m")
				temp = Resp.new()
				temp.Que_id = resp[:id]
				temp.response = resp[:response]
				temp.User_id = resp[:user]
				puts(temp)
				temp.save()
				flash[:success] = "Survey Answered!"

			else
				temp = Resp.new()
				temp.Que_id = resp[:id]
				temp.User_id = resp[:user]
				if(resp[:response1]) 
					temp = Resp.new()
					temp.Que_id = resp[:id]
					temp.User_id = resp[:user]
					temp.response = resp[:response1]
					temp.save()
				end
				if(resp[:response2]) 
					temp = Resp.new()
					temp.Que_id = resp[:id]
					temp.User_id = resp[:user]
					temp.response = resp[:response2]
					temp.save()
				end
				if(resp[:response3]) 
					temp = Resp.new()
					temp.Que_id = resp[:id]
					temp.User_id = resp[:user]
					temp.response = resp[:response3]
					temp.save()
				end
				if(resp[:response4]) 
					temp = Resp.new()
					temp.Que_id = resp[:id]
					temp.User_id = resp[:user]
					temp.response = resp[:response4]
					temp.save()
				end
				flash[:success] = "Survey Answered!"
			end
		end
		redirect_to :controller => "static_pages", :action => "home"
	end

	def display_responses
		@responses = Resp.paginate(page: params[:page])
	end

	def edit
		@survey = SurveySet.find(params[:id])
	end

	def update
		@survey = SurveySet.find(params[:id])
		if @survey.update_attributes(sur_params)
			flash[:success] = "Survey updated"
			redirect_to 'index'
		else
			render 'edit'
		end
	end

	def destroy
		SurveySet.find(params[:id]).destroy
		flash[:success] = "Survey deleted"
		redirect_to root_url
	end

	private

	def sur_params
		params.require(:survey_set).permit(:name)
	end

	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end

	def logged_in_user
		unless logged_in?
			flash[:danger] = "Please log in."
			redirect_to login_url
		end
	end
end
